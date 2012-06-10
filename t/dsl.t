use strict;
use warnings;
use Test::More;

use Message::Passing::DSL;

my $c = message_chain {
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
isa_ok $c->[0], 'Message::Passing::Input::STDIN';
isa_ok $c->[0]->output_to, 'Message::Passing::Filter::Null';
isa_ok $c->[0]->output_to->output_to, 'Message::Passing::Filter::T';
isa_ok $c->[0]->output_to->output_to->output_to->[0], 'Message::Passing::Output::Test';
$c->[0]->output_to->consume({foo => 'bar'});
my $test = $c->[0]->output_to->output_to->output_to->[0];
is $test->message_count, 1;
is_deeply [$test->messages], [{foo => 'bar'}];

$c = message_chain {
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

is ref($c), 'ARRAY';
is scalar(@$c), 2;
isa_ok $c->[0], 'Message::Passing::Input::Null';
isa_ok $c->[1], 'Message::Passing::Input::STDIN';
isa_ok $c->[0]->output_to, 'Message::Passing::Output::STDOUT';
isa_ok $c->[1]->output_to, 'Message::Passing::Output::STDOUT';
is $c->[0]->output_to, $c->[1]->output_to;

done_testing;

