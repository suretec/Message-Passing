package Log::Stash::Role::Filter;
use Moose::Role;
use namespace::autoclean;

with 'Log::Stash::Role::Input';
with 'Log::Stash::Role::Output';

requires 'filter';

1;

=head1 NAME

Log::Stash::Mixin::Filter

=head1 DESCRIPTION

Both a producer and a consumer of messages, probably mungeing them in between

=head1 REQUIRED METHODS

All the methods from L<Log::Stash::Mixin::Consumer> and
L<Log::Stash::Mixin::Producer> are required, in addition to:

=head2 filter

Called to filter the message. Returns the mangled message.

=HEAD1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash> for details.

=cut

