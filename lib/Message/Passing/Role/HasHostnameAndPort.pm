package Message::Passing::Role::HasHostnameAndPort;
use Moo::Role;
use MooX::Types::MooseLike::Base qw/ Str Int /;
use namespace::clean -except => 'meta';

requires '_default_port';

has hostname => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has port => (
    is => 'ro',
    isa => Int,
    builder => '_default_port',
);

1;

