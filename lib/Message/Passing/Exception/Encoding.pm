package Message::Passing::Exception::Encoding;
use Moo;
use Data::Dumper ();
use MooX::Types::MooseLike::Base qw/ Str /;
use namespace::clean -except => 'meta';

with 'Message::Passing::Exception';

has exception => (
    is => 'ro',
    required => 1,
);

has stringified_data => (
    is => 'ro',
    isa => Str,
    coerce => sub {
        Data::Dumper::Dumper($_[0]);
    },
);

1;

