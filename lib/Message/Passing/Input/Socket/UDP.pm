package Message::Passing::Input::Socket::UDP;
use Moo;
use AnyEvent;
use AnyEvent::Handle::UDP;
use Scalar::Util qw/ weaken /;
use namespace::clean -except => 'meta';

with qw/
    Message::Passing::Role::Input
    Message::Passing::Role::HasHostnameAndPort
    Message::Passing::Role::HasErrorChain
/;

has '+hostname' => (
    default => sub { 'localhost' },
);

has '+port' => (
    required => 1,
);

sub _default_port { die "You must supply a port #" }

has handle => (
    is => 'ro',
    builder => '_build_handle',
    lazy => 1,
);

sub BUILD {
    my $self = shift;
    $self->handle;
}

sub _send_data {
    my ($self, $data, $from_addr) = @_;
    $self->output_to->consume($data);
}

sub _build_handle {
    my $self = shift;
    weaken($self);
    AnyEvent::Handle::UDP->new(
        bind => [ $self->hostname, $self->port ],
        on_recv => sub {
            my ($data, $h, $from_addr) = @_;
            # The output can optionally drop from addr.
            warn "SEND $data";
            $self->_send_data($data, $from_addr);
        },
        on_error => sub {
            my ($h, $fatal, $msg) = @_;
            $self->error->consume($msg);
        },
    );
}

1;

