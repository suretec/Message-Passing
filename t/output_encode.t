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

use Log::Stash::Output::Test;

my $test = Log::Stash::Output::Test->new();
my $packed = $test->encode(bless {}, 'Message');

is $packed, '{"foo":"bar"}';

done_testing;

