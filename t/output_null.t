use strict;
use warnings;
use Test::More;
use Try::Tiny;

use Log::Stash::Output::Null;

my $test = try { Log::Stash::Output::Null->new() }
    catch { fail "Failed to construct $_" };
ok $test;

try { $test->consume('message') }
    catch { fail "Failed to consume message: $_" };

done_testing;

