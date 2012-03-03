package Log::Stash::Role::Filter;
use Moose::Role;
use namespace::autoclean;

with 'Log::Stash::Role::Input';
with 'Log::Stash::Role::Output';

sub consume {
    my ($self, $message) = @_;
    $self->output_to->consume($self->filter($message));
}

requires 'filter';

1;

=head1 NAME

Log::Stash::Mixin::Filter

=head1 DESCRIPTION

Both a producer and a consumer of messages, probably mungeing them in between

=head1 REQUIRED METHODS

All the methods from L<Log::Stash::Mixin::Consumer> and
L<Log::Stash::Mixin::Producer> are required, in addition to:

=head2 filter

Called to filter the message. Returns the mangled message.

=head1 SEE ALSO

L<Log::Stash>

=head1 AUTHOR

Tomas (t0m) Doran <bobtfish@bobtfish.net>

=head1 SPONSORSHIP

This module exists due to the wonderful people at
L<Suretec Systems|http://www.suretecsystems.com/> who sponsored it's
development.

=head1 COPYRIGHT

Copyright Suretec Systems 2012.

Logstash (upon which many ideas for this project is based, but
which we do not reuse any code from) is copyright 2010 Jorden Sissel.

=head1 LICENSE

XX - TODO

=cu

