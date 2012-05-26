use strict;
use warnings;
use Test::More;
use Try::Tiny;

{
    package Message;
    use strict;
    use warnings;

    sub pack { { foo => "bar" } }
}

use Message::Passing::Output::Test;

my $test = Message::Passing::Output::Test->new();
my $packed = $test->encode(bless {}, 'Message');

is $packed, '{"foo":"bar"}';

done_testing;

