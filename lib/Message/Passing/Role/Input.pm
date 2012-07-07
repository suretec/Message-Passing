package Message::Passing::Role::Input;
use Moo::Role;
use JSON qw/ from_json /;
#use Message::Passing::Types qw/
#    Output_Type
#/;
use namespace::clean -except => 'meta';

has output_to => (
#    isa => Output_Type,
    is => 'ro',
    required => 1,
#    coerce => 1,
);

1;

=head1 NAME

Message::Passing::Role::Input

=head1 DESCRIPTION

Produces messages.

=head1 ATTRIBUTES

=head2 output_to

Required, must perform the L<Message::Passing::Role::Output> role.

=head1 SEE ALSO

=over

=item L<Message::Passing>

=item L<Message::Passing::Manual::Concepts>

=back

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored its development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Message::Passing>.

=cut

1;

