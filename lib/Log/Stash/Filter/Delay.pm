package Log::Stash::Filter::Delay;
use Moose;
use AnyEvent;
use Scalar::Util qw/ weaken /;
use namespace::autoclean;

with qw/
    Log::Stash::Role::Input
    Log::Stash::Role::Output
/;

has delay_for => (
    isa => 'Num',
    is => 'ro',
    required => 1,
);

sub consume {
    my ($self, $message) = @_;
    weaken($self);
    my $t; $t = AnyEvent->timer(
        after => $self->delay_for,
        cb => sub {
            undef $t;
            $self->output_to->consume($message);
        },
    );
}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Log::Stash::Filter::Null - Filter no messages out.

=head1 DESCRIPTION

This filter does nothing, passing all incoming messages through with no changes.

You would normally never want to use this, but it can be useful for
testing occasionally.

=head1 METHODS

=head2 filter

Returns the message passed to it.

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

