package Message::Passing::Role::HasHostnameAndPort;
use Moose::Role;
use namespace::autoclean;

requires '_default_port';

has hostname => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has port => (
    is => 'ro',
    isa => 'Int',
    builder => '_default_port',
);

1;

