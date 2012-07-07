package Message::Passing::Role::HasUsernameAndPassword;
use Moo::Role;
use MooX::Types::MooseLike::Base qw/ Str /;
use namespace::clean -except => 'meta';

foreach my $name (qw/ username password /) {
    has $name  => (
        is => 'ro',
        isa => Str,
        required => 1,
    );
}

1;

