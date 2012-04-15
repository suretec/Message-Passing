use strict;
use warnings;
use Test::More 0.88;

use Log::Stash::Input::STDIN;

my $i = Log::Stash::Input::STDIN->new(
    output_to => {
        class => 'Log::Stash::Output::Test',
    },
);

ok $i;
isa_ok($i->output_to, 'Log::Stash::Output::Test');

done_testing;

