package Message::Passing::Role::HasTimeoutAndReconnectAfter;
use Moo::Role;
use MooX::Types::MooseLike::Base qw/ Num /;
use namespace::clean -except => 'meta';

has timeout => (
    isa => Num,
    is => 'ro',
    default => sub { 30 },
);

has reconnect_after => (
    isa => Num,
    is => 'ro',
    default => sub { 2 },
);

1;

