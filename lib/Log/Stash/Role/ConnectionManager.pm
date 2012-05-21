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

=head1 NAME

Log::Stash::Role::ConnectionManager - A simple manager for inputs and outputs that need to make network connections.

=head1 DESCRIPTION

This role is for components which make network connections, and need to handle the connection not starting,
timeouts, disconnects etc.

It provides a simple abstraction for multiple other classes to be able to use the same connection manager, and
a notifies

=head1 REQUIRED METHODS

=head2 _build_connection

Build and return the underlieing connection, start the connection process and return it.

Your connection should use the API as documented below to achieve notification of connect and disconnect events.

=head1 API FOR CONNECTIONS

=head2 _set_connected (1)

Notify clients that the connection is now ready for use.

=head2 _set_connected (0)

Notify clients that the connection is no longer ready for use.

Will cause the connection to be terminated and retried.

=head1 API FOR CLIENTS

To use a connection manager, you should register yourself like this:

    $manager->subscribe_to_connect($self);

The manager will call C<< $self->connected($connection) >> and C<< $self->disconnected() >> when appropriate.

If the manager is already connected when you subscribe, it will immediately call back into your
C<< connected >> method, if it is not already connected then this will happen at a later point
once the connection is established.

See L<Log::Stash::Role::HasAConnection> for a role to help with dealing with a connection manager.

=cut
