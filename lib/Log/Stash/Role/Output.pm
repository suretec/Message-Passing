package Log::Stash::Role::Output;
use Moose::Role;
use JSON qw/ to_json /;
use Scalar::Util qw/ blessed /;
use namespace::autoclean;

sub encode {
    my ($self, $message) = @_;
    $message = $message->pack if blessed($message) && $message->can('pack');
    to_json( $message, { utf8  => 1 } )
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

=cut


