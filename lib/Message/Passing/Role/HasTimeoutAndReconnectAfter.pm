package Message::Passing::Role::HasTimeoutAndReconnectAfter;
use Moose::Role;
use namespace::autoclean;

has timeout => (
    isa => 'Num',
    is => 'ro',
    default => sub { 30 },
);

has reconnect_after => (
    isa => 'Num',
    is => 'ro',
    default => sub { 2 },
);

1;

