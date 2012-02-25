package Log::Stash::Output::STDOUT;
use Moose;
use namespace::autoclean;

with 'Log::Stash::Role::Output';

sub consume {
    my $self = shift;
    print $self->encode(shift()) . "\n";
}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Log::Stash::Output::STDOUT - STDOUT output

=head1 SYNOPSIS

    logstash --input STDIN --output STDOUT
    {"foo": "bar"}
    {"foo":"bar"}

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


