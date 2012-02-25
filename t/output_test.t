use strict;
use warnings;
use Test::More;
use Try::Tiny;

use Log::Stash::Output::Test;

my $test = try { Log::Stash::Output::Test->new }
    catch { fail "Failed to construct $_" };
ok $test;

try { $test->consume('message') }
    catch { fail "Failed to consume message: $_" };

is $test->messages_count, 1;
is_deeply [$test->messages], ['message'];

try { $test->clear_messages }
    catch { fail "Could not clear messages: $_" };

is $test->messages_count, 0;
is_deeply [$test->messages], [];


done_testing;

