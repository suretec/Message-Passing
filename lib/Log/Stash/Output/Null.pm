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

head1 NAME

Log::Stash::Input::STDIN - STDIN input

=head1 SYNOPSIS

    logstash --input STDIN --output Null
    {"foo": "bar"}

    # Note noting is printed...

=head1 DESCRIPTION

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

