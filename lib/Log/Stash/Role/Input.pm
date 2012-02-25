package Log::Stash::Role::Input;
use Moose::Role;
use JSON qw/ from_json /;
use namespace::autoclean;

sub decode { from_json( $_[1], { utf8  => 1 } ) }

has output_to => (
    is => 'ro',
    required => 1,
);

1;

=head1 NAME

Log::Stash::Role::Input

=head1 DESCRIPTION

Produces messages.

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
