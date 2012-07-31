package Message::Passing::Input::FileTail;
use Moo;
use MooX::Types::MooseLike::Base qw/ Str Int /;
use AnyEvent;
use Scalar::Util qw/ weaken /;
use namespace::clean -except => 'meta';

with 'Message::Passing::Role::Input';

has filename => (
    is => 'ro',
    isa => Str,
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
    weaken($self);
    die("Cannot open filename '" . $self->filename . "'") unless -r $self->filename;
    my $child_pid = open(my $r, "-|", "tail", "-F", $self->filename)
       || die "can't fork: $!";
    AnyEvent->io(
        fh => $r,
        poll => "r",
        cb => sub {
            my $input = scalar <$r>;
            $self->output_to->consume($input);
        },
    );
}

sub BUILD {
    my $self = shift;
    $self->_tail_handle;
}


1;

=head1 NAME

Message::Passing::Input::FileTail - File tailing input

=head1 SYNOPSIS

    message-pass --input FileTail --input_options '{"filename": "/var/log/foo.log"} --output STDOUT
    {"foo":"bar"}

=head1 DESCRIPTION

=head1 METHODS

=head2 filename

The filename of the file to tail.

=head2 tailer_pid

The PID of the C<< tail -F >> being run.

=head1 SEE ALSO

L<Message::Passing>

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored its development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Message::Passing>.

=cut

