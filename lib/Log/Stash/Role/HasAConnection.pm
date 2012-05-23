package Log::Stash::Role::HasAConnection;
use Moose::Role;
use namespace::autoclean;

requires '_build_connection_manager', 'connected';

has connection_manager => (
    is => 'ro',
    lazy => 1,
    #isa => ->can('subscribe_to_connect')
    builder => '_build_connection_manager',
);

sub BUILD {}
after BUILD => sub {
    my $self = shift;
    $self->connection_manager->subscribe_to_connect($self);
};

1;

=head1 NAME

Log::Stash::Role::HasAConnection - Role for components which have a connection

=head1 DESCRIPTION

Provides a standard ->connection_manager attribute for inputs or outputs which need to
make a network connection before they can send or receive messages.

The connection manager object is assumed to have the C<< ->subscribe_to_connect >> method
(from L<Log::Stash::Role::Connection>).

=head1 REQUIRED METHODS

=head2 _build_connection

Will be called at BUILD (i.e. object construction) time, should return
a connection manager object (i.e. an object that C<< ->subscribe_to_connect >>
can be called on).

=head2 connected ($client)

Called by the connection manager when a connection is made.

Usually used to do things like subscribe to queues..

=head1 OPTIONAL METHODS

=head2 disconnected ($client)

The client recieved an error or otherwise disconnected.

=head1 ATTRIBUTES

=head2 connection_manager

=head1 WRAPPED METHODS

=head2 BUILD

Is wrapped to build the connection manager object.

=cut
