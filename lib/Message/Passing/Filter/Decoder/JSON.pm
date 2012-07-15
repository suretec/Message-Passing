package Message::Passing::Filter::Decoder::JSON;
use Moo;
use JSON qw/ from_json /;
use namespace::clean -except => 'meta';

with 'Message::Passing::Role::Filter';

sub filter { ref($_[1]) ? $_[1] : from_json( $_[1], { utf8  => 1 } ) }


1;

=head1 NAME

Message::Passing::Role::Filter::Decoder::JSON

=head1 DESCRIPTION

Decodes string messages from JSON into data structures.

=head1 ATTRIBUTES

=head1 METHODS

=head2 filter

JSON decodes a message supplied as a parameter.

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

