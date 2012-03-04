package Log::Stash::Filter::Key;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

with 'Log::Stash::Role::Filter';

has key => (
    isa => 'Str',
    is => 'ro',
    required => 1,
);

has match => (
    isa => 'Str',
    is => 'ro',
    required => 1,
);

has match_type => (
    is => 'ro',
    isa => enum(['regex', 'eq']),
    default => 'eq',
);

has _re => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $match = $self->match;
        if ($self->match_type eq 'regex') {
            return qr/$match/;
        }
        else {
            return qr/^\Q$match\E$/;
        }
    },
);

sub filter {
    my ($self, $message) = @_;
    my $re = $self->_re;
    my @key_parts = split /\./, $self->key;
    my $m = $message;
    do {
        my $part = shift(@key_parts);
        $m = (ref($m) eq 'HASH' && exists($m->{$part})) ? $m->{$part} : undef;
    } while ($m && scalar(@key_parts));
    return unless $m && !ref($m) && $m =~ /$re/;
    return $message;
}

__PACKAGE__->meta->make_immutable;
1;

