package Log::Stash::Role::ConnectionManager;
use Moose::Role;
use Scalar::Util qw/ blessed weaken /;
use namespace::autoclean;

requires '_build_connection';

sub BUILD {
    my $self = shift;
    $self->connection;
}

has connected => (
    is => 'ro',
    isa => 'Bool',
    default => sub { 0 },
    writer => '_set_connected',
);

has connection => (
    is => 'ro',
    lazy => 1,
    builder => '_build_connection',
    clearer => '_clear_connection'
);

has connect_subscribers => (
    isa => 'ArrayRef',
    is => 'ro',
    default => sub { [] },
    writer => '_set_connect_subscribers',
);

sub __clean_subs {
    my $self = shift;
    my $subs = [ grep { defined $_ } @{$self->connect_subscribers} ];
    $self->_set_connect_subscribers($subs);
}

sub subscribe_to_connect {
    my ($self, $subscriber) = @_;
    confess "Subscriber '$subscriber' is not blessed" unless blessed $subscriber;
    confess "Subscriber '$subscriber' does not have a ->connected method" unless $subscriber->can('connected');
    $self->__clean_subs;
    my $subs = $self->connect_subscribers;
    push(@$subs, $subscriber);
    weaken(@{$subs}[-1]);
    if ($self->connected) {
        warn "Already connected";
        $subscriber->connect($self->connection);
    }
}

after _set_connected => sub {
    my ($self, $connected) = @_;
    $self->__clean_subs;
    my $method = $connected ? 'connected' : 'disconnected';
    foreach my $sub (@{$self->connect_subscribers}) {
        $sub->$method($self->connection) if $sub->can($method);
    }
    $self->_clear_connection unless $connected;
};

1;
