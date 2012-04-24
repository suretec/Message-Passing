package Log::Stash::Role::Output;
use Moose::Role;
use JSON qw/ to_json /;
use Scalar::Util qw/ blessed /;
use namespace::autoclean;

has pretty => (
    isa => 'Bool',
    default => 0,
    is => 'ro',
);

sub encode {
    my ($self, $message) = @_;
    $message = $message->pack if blessed($message) && $message->can('pack');
    to_json( $message, { utf8  => 1, $self->pretty ? (pretty => 1) : () } )
}

requires 'consume';

1;

=head1 NAME

Log::Stash::Role::Output - Consumes messages

=head1 DESCRIPTION

This is a role for classes which consumer messages (e.g. a Log::Stash output)

=head1 REQUIRED METHODS

=head2 consume

Consume a message

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

