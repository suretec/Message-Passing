use strict;
use warnings;
use Test::More;

use Log::Stash::DSL;

my $c = log_chain {
        output test => (
            class => 'Test',
        );
        filter t => (
            class => 'T',
            output_to => ['test'],
        );
        filter null => (
            class => 'Null',
            output_to => 't',
        );
        input stdin => (
            class => 'STDIN',
            output_to => 'null',
        );
};
isa_ok $c, 'Log::Stash::Input::STDIN';
isa_ok $c->output_to, 'Log::Stash::Filter::Null';
isa_ok $c->output_to->output_to, 'Log::Stash::Filter::T';
isa_ok $c->output_to->output_to->output_to->[0], 'Log::Stash::Output::Test';
$c->output_to->consume({foo => 'bar'});
my $test = $c->output_to->output_to->output_to->[0];
is $test->message_count, 1;
is_deeply [$test->messages], [{foo => 'bar'}];

$c = log_chain {
            output logcollector_central => (
                class => 'STDOUT',
            );
            input null_in => (
                class => 'Null',
                output_to => 'logcollector_central',
            );
            input test_in => (
                class => 'STDIN',
                output_to => 'logcollector_central',
            );
        };

done_testing;

