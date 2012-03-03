package Log::Stash::Filter::T;
use Moose;
use MooseX::Types::Moose qw/ ArrayRef /;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

with 'Log::Stash::Role::Input';
with 'Log::Stash::Role::Output';

has '+output_to' => (
    isa => ArrayRef[role_type('Log::Stash::Role::Output')],
    is => 'ro',
    required => 1,
);

sub consume {
    my ($self, $message) = @_;
    foreach my $output_to (@{ $self->output_to }) {
        $output_to->consume($message);
    }
}

__PACKAGE__->meta->make_immutable;
1;

