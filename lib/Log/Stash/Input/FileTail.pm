package Log::Stash::Input::FileTail;
use Moose;
use AnyEvent;
use Try::Tiny;
use namespace::autoclean;

with 'Log::Stash::Role::Input';

has filename => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has _tail_handle => (
    is => 'ro',
    lazy => 1,
    builder => '_build_tail_handle',
);

has tailer_pid => (
    init_arg => undef,
    is => 'ro',
    writer => '_set_tailer_pid',
);

sub _build_tail_handle {
    my $self = shift;
    my $r;
    my $child_pid = open($r, "-|", "tail", "-F", $self->filename)
       // die "can't fork: $!";
    AnyEvent->io (
        fh => $r,
        poll => "r",
        cb => sub {
            my $data = parse_from_line(scalar <$r>)
                or return;
            $self->on_read->($data);
        },
    );
}

sub BUILD {
    my $self = shift;
    $self->_tail_handle;
}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Log::Stash::Input::FileTail - File tailing input

=head1 SYNOPSIS

    logstash --input FileTail --input_options '{"filename": "/var/log/foo.log"} --output STDOUT
    {"foo": "bar"}
    {"foo":"bar"}

=head1 DESCRIPTION

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

