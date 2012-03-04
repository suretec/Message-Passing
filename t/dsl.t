use strict;
use warnings;
use Test::More;

use Log::Stash::DSL;

my $c = log_chain {
        output test => (
            class => 'Test',
        );
        filter null => (
            class => 'Null',
            output_to => 'test',
        );
        input stdin => (
            class => 'STDIN',
            output_to => 'null',
        );
};
isa_ok $c, 'Log::Stash::Input::STDIN';
isa_ok $c->output_to, 'Log::Stash::Filter::Null';
isa_ok $c->output_to->output_to, 'Log::Stash::Output::Test';
$c->output_to->consume({foo => 'bar'});
my $test = $c->output_to->output_to;
is $test->message_count, 1;
is_deeply [$test->messages], [{foo => 'bar'}];

done_testing;

