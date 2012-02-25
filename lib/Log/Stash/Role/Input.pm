package Log::Stash::Role::Input;
use Moose::Role;
use JSON qw/ from_json /;
use namespace::autoclean;

sub decode { from_json( $_[1], { utf8  => 1 } ) }

has output_to => (
    is => 'ro',
    required => 1,
);

1;

=head1 NAME

Log::Stash::Mixin::Producer

=head1 DESCRIPTION

Produces messages.

=head1 REQUIRED METHODS

=head2 produce

=HEAD1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash> for details.

=cut

