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
                class => 'ZeroMQ',
                connect => "tcp://127.0.0.1:5223",
            );
            output webhook_distributor => (
                class => 'ZeroMQ',
                connect => "tcp://127.0.0.1:5227",
            );
            filter webhook_distributor_filter => (
                class => 'All', # FIXME
                output_to => 'webhook_distributor',
            );
            output esl_incoming_fanout => (
                class => 'ZeroMQ',
                connect => "tcp://127.0.0.1:5225",
            );
            filter esl_incoming_fanout_filter => (
                class => 'All', # FIXME
                output_to => 'esl_incoming_fanout',
            );
            filter t => (
                class => 'T',
                output_to => [qw/
                    logcollector_central
                    webhook_distributor_filter
                    esl_incoming_fanout_filter
                /],
            );
            input zmq_in => (
                class => 'ZeroMQ',
                socket_bind => 'tcp://127.0.0.1:5222',
                output_to => 't',
            );
            input syslog_in => (
                class => 'Syslog',
                output_to => 't',
            );
        };

done_testing;

