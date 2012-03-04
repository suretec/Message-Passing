package Log::Stash::Output::Null;
use Moose;
use namespace::autoclean;

with 'Log::Stash::Role::Output';

sub consume {}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Log::Stash::Output::Null - /dev/null for logstash messages

=head1 SYNOPSIS

    logstash --input STDIN --output Null
    {"foo": "bar"}

    # Note noting is printed...

=head1 DESCRIPTION

Throws away all messages passed to it.

=head1 METHODS

=head2 consume

Takes a message and discards it silently.

=head1 SEE ALSO

L<Log::Stash>

=head1 SPONSORSHIP

This module exists due to the wonderful people at
L<Suretec Systems|http://www.suretecsystems.com/> who sponsored it's
development.

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash>.

=cut

