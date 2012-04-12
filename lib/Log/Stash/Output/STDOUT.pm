package Log::Stash::Output::STDOUT;
use Moose;
use namespace::autoclean;

with 'Log::Stash::Role::Output';

sub consume {
    my $self = shift;
    local $|=1;
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

Output messages to STDOUT

=head1 METHODS

=head2 consume

Consumes a message by JSON encoding it and printing it, followed by \n

=head1 SEE ALSO

L<Log::Stash>

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored it's development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash>.

=cut

