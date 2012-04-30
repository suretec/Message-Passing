package Log::Stash::Input::Null;
use Moose;
use AnyEvent;
use Try::Tiny;
use namespace::autoclean;

with 'Log::Stash::Role::Input';

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Log::Stash::Input::Null - Null input

=head1 SYNOPSIS

    logstash --input Null --output STDOUT

=head1 DESCRIPTION

Does nothing (for testing).

=head1 SEE ALSO

L<Log::Stash>

=head1 AUTHOR

Tomas (t0m) Doran <bobtfish@bobtfish.net>

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored it's development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 COPYRIGHT

Copyright Suretec Systems 2012.

Logstash (upon which many ideas for this project is based, but
which we do not reuse any code from) is copyright 2010 Jorden Sissel.

=head1 LICENSE

XX - TODO

=cut
