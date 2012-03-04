package Log::Stash::Filter::All;
use Moose;
use namespace::autoclean;

with 'Log::Stash::Role::Filter';

sub filter {
    return;
}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Log::Stash::Filter::All - Filter all messages out.

=head1 DESCRIPTION

This filter just removes all messages, not passing any through.

You would normally never want to use this, but it can be useful for
testing occasionally.

=head1 METHODS

=head2 filter

Universally returns undef

=head1 SPONSORSHIP

This module exists due to the wonderful people at
L<Suretec Systems|http://www.suretecsystems.com/> who sponsored it's
development.

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash>.

=cut

1;
