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

=head1 NAME

Log::Stash::Filter::T - Send a message stream to multiple outputs.

=head1 DESCRIPTION

This filter is used to duplicate a message stream to two or more outputs.

All messages are duplicated to all output streams, so you may want to follow
this with L<Log::Stash::Filter::Key> to one or more of those streams.

=head1 ATTRIBUTES

=head2 output_to

Just like a normal L<Log::Stash::Role::Input> class, except takes an array of outputs.

=head1 METHODS

=head2 consume

Sends the consumed message to all output_to instances.

=head1 SPONSORSHIP

This module exists due to the wonderful people at
L<Suretec Systems|http://www.suretecsystems.com/> who sponsored it's
development.

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash>.

=cut

1;

