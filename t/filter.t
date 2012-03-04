use strict;
use warnings;
use Test::More;
use Try::Tiny;

use Log::Stash::Filter::Null;
use Log::Stash::Output::Test;
use Log::Stash::Filter::All;
use Log::Stash::Filter::T;

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

is $test->message_count, 1;
is_deeply [$test->messages], ['message'];
is $called, 1;

try { $test->clear_messages }
    catch { fail "Could not clear messages: $_" };

is $test->message_count, 0;
is_deeply [$test->messages], [];

$ob = try {
    $test = Log::Stash::Output::Test->new(
            on_consume_cb => sub { $called++ }
    );
    Log::Stash::Filter::All->new(output_to => $test)
}
catch { fail "Failed to construct $_" };
ok $test;

try { $ob->consume('message') }
    catch { fail "Failed to consume message: $_" };

is $test->message_count, 0;

$called = 0;
my $called2 = 0;

my $test2;
$ob = try {
    $test = Log::Stash::Output::Test->new(
            on_consume_cb => sub { $called++ }
    );
    $test2 = Log::Stash::Output::Test->new(
            on_consume_cb => sub { $called2++ }
    );
    Log::Stash::Filter::T->new(output_to => [$test, $test2])
}
catch { fail "Failed to construct $_" };
ok $test;

try { $ob->consume('message') }
    catch { fail "Failed to consume message: $_" };

is $test->message_count, 1;
is_deeply [$test->messages], ['message'];
is $called, 1;

is $test2->message_count, 1;
is_deeply [$test2->messages], ['message'];
is $called2, 1;

done_testing;

