use strict;
use warnings;
use Test::More;
use Try::Tiny;

use Log::Stash::Filter::Null;
use Log::Stash::Output::Test;
use Log::Stash::Filter::All;
use Log::Stash::Filter::T;
use Log::Stash::Filter::Key;
use Log::Stash::Filter::Delay;

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

$ob = try {
    $test = Log::Stash::Output::Test->new(
            on_consume_cb => sub { $called++ }
    );
    Log::Stash::Filter::Key->new(
        output_to => $test,
        key => 'foo',
        match => 'bar',
    );
}
catch { fail "Failed to construct $_" };
ok $test;

try { $ob->consume({foo => 'bar', baz => 'quux'}) }
    catch { fail "Failed to consume message: $_" };
try { $ob->consume({foo => 'blam', baz => 'quux'}) }
    catch { fail "Failed to consume message: $_" };

is_deeply [$test->messages], [{foo => 'bar', baz => 'quux'}];

$ob = try {
    $test = Log::Stash::Output::Test->new(
            on_consume_cb => sub { $called++ }
    );
    Log::Stash::Filter::Key->new(
        output_to => $test,
        key => 'foo.inner.inner',
        match => 'bar',
    );
}
catch { fail "Failed to construct $_" };
ok $test;

try { $ob->consume({foo => 'bar', baz => 'quux'}) }
    catch { fail "Failed to consume message: $_" };
try { $ob->consume({foo => { inner => 'blam' }, baz => 'quux'}) }
    catch { fail "Failed to consume message: $_" };
try { $ob->consume({foo => { inner => { inner => 'blam' } }, baz => 'quux'}) }
    catch { fail "Failed to consume message: $_" };
try { $ob->consume({foo => { inner => { inner => 'bar' } }, baz => 'quux'}) }
    catch { fail "Failed to consume message: $_" };

is_deeply [$test->messages], [{foo => { inner => { inner => 'bar' } }, baz => 'quux'}];

$ob = try {
    $test = Log::Stash::Output::Test->new();
    Log::Stash::Filter::Delay->new(
        delay_for => 0.1,
        output_to => $test,
    );
}
catch { fail "Failed to construct $_" };
ok $test;

$ob->consume({});
is_deeply [$test->messages], [];
my $cv = AnyEvent->condvar;
my $idle; $idle = AnyEvent->idle(cb => sub {
    $cv->send;
    undef $idle;
});
$cv->recv;
is_deeply [$test->messages], [];
$cv = AnyEvent->condvar;
my $timer; $timer = AnyEvent->timer(
    after => 0.2,
    cb => sub {
        $cv->send;
        undef $timer;
    },
);
$cv->recv;
is_deeply [$test->messages], [{}];

done_testing;

