package Log::Stash::Role::Output;
use Moose::Role;
use JSON qw/ to_json /;
use namespace::autoclean;

sub encode { to_json( $_[1], { utf8  => 1 } ) }

requires 'consume';

1;

=head1 NAME

Log::Stash::Mixin::Consumer - Consumers messages

=head1 DESCRIPTION

This is a role for classes which consumer messages (e.g. a Log::Stash output)

=head1 REQUIRED METHODS

=head2 consume

Consume a message

=HEAD1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash> for details.

=cut

