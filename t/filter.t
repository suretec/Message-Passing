use strict;
use warnings;
use Test::More;
use Try::Tiny;

use Log::Stash::Filter::Null;
use Log::Stash::Output::Test;

my $called = 0;

my $test;
my $ob = try {
    $test = Log::Stash::Output::Test->new(
            on_consume_cb => sub { $called++ }
    );
    Log::Stash::Filter::Null->new(output_to => $test)
}
catch { fail "Failed to construct $_" };
ok $test;

try { $ob->consume('message') }
    catch { fail "Failed to consume message: $_" };

is $test->messages_count, 1;
is_deeply [$test->messages], ['message'];
is $called, 1;

try { $test->clear_messages }
    catch { fail "Could not clear messages: $_" };

is $test->messages_count, 0;
is_deeply [$test->messages], [];

done_testing;

