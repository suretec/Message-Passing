package Message::Passing::Role::HasUsernameAndPassword;
use Moose::Role;
use namespace::autoclean;

has [qw/ username password /] => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

1;

