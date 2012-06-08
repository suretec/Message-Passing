package Message::Passing::Filter::Encoder::Null;
use Moose;
use namespace::autoclean;

with 'Message::Passing::Role::Filter';

sub filter { $_[1] }

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Message::Passing::Filter::Enccoder::Null

=head1 DESCRIPTION

Does no Encoding

=head1 ATTRIBUTES

=head1 METHODS

=head2 filter

Returns message it's passed, verbatim

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

