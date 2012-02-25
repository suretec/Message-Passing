package Log::Stash::Output::Null;
use Moose;
use namespace::autoclean;

with 'Log::Stash::Role::Output';

sub consume {}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Log::Stash::Output::Null - /dev/null for logstash messages

=head1 DESCRIPTION

Throws away all messages passed to it.

=cut

