package Log::Stash::Role::Input;
use Moose::Role;
use JSON qw/ from_json /;
use Log::Stash::Types;
use namespace::autoclean;

sub decode { from_json( $_[1], { utf8  => 1 } ) }

has output_to => (
    isa => 'Log::Stash::Types::Output',
    is => 'ro',
    required => 1,
    coerce => 1,
);

1;

=head1 NAME

Log::Stash::Role::Input

=head1 DESCRIPTION

Produces messages.

=head1 ATTRIBUTES

=head2 output_to

Required, must perform the L<Log::Stash::Role::Output> role.

=head1 METHODS

=head2 decode

JSON decodes a message supplied as a parameter.

=head1 SEE ALSO

=over

=item L<Log::Stash>

=item L<Log::Stash::Manual::Concepts>

=back

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored it's development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash>.

=cut

1;

