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

All the methods from L<Log::Stash::Mixin::Consumer> and
L<Log::Stash::Mixin::Producer> are required, in addition to:

=head2 filter

Called to filter the message. Returns the mangled message.

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

