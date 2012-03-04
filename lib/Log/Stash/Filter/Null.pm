package Log::Stash::Filter::Null;
use Moose;
use namespace::autoclean;

with 'Log::Stash::Role::Filter';

sub filter {
    my ($self, $message) = @_;
    $message;
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

returns the message passed to it.

=head1 SPONSORSHIP

This module exists due to the wonderful people at
L<Suretec Systems|http://www.suretecsystems.com/> who sponsored it's
development.

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash>.

=cut

1;

