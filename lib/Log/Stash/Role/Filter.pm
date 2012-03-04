package Log::Stash::Role::Filter;
use Moose::Role;
use namespace::autoclean;

with 'Log::Stash::Role::Input';
with 'Log::Stash::Role::Output';

sub consume {
    my ($self, $message) = @_;
    my $new = $self->filter($message);
    return unless $new;
    $self->output_to->consume($new);
}

requires 'filter';

1;

=head1 NAME

Log::Stash::Mixin::Filter

=head1 DESCRIPTION

Both a producer and a consumer of messages, able to filter out messages based upon their contents,
or permute the structure of messages.

=head1 REQUIRED METHODS

=head2 filter

Called to filter the message. Returns the mangled message.

Note if you return undef then the message is not propagated further up the chain, which may be used
for filtering out unwanted messages.

=head1 REQUIRED ATTRIBUTES

=head2 output_to

From L<Log::Stash::Role::Input>.

=head1 METHODS

=head2 consume

Consumers a message, calling the filter method provided by the user with the message.

In the case where the filter returns a message, outputs the message to the next step in the chain.

=head1 SEE ALSO

L<Log::Stash>

=head1 SPONSORSHIP

This module exists due to the wonderful people at
L<Suretec Systems|http://www.suretecsystems.com/> who sponsored it's
development.

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash>.

=cut

1;

