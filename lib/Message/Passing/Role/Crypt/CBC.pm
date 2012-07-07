package Message::Passing::Role::Crypt::CBC;
use Moo::Role;
use MooX::Types::MooseLike::Base qw/ Str /;
use Crypt::CBC;
use namespace::clean -except => 'meta';

foreach my $name (qw/
    encryption_key
    encryption_cipher
/) {
    has $name => (
        isa => Str,
        is => 'ro',
        required => 1,
    );
}

# NOTE - We need a new CBC object per message, otherwise if we _EVER_ drop
#        messages then we totally screw ourselves!
sub cbc {
    my $self = shift;
    Crypt::CBC->new(
        -key    => $self->encryption_key,
        -cipher => $self->encryption_cipher,
    );
}

1;

