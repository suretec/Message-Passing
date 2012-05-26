use strict;
use warnings;
use Test::More;

use_ok 'Message::Passing';

my $i = Message::Passing->new(
    input => 'STDIN',
    input_options => '{"foo":"bar"}',
    filter_options => '{"baz":"quux"}',
    output => 'Test',
    output_options => '{"x":"m"}',
);

is_deeply {$i->input_options}, {"foo" => "bar"};
is_deeply {$i->filter_options}, {"baz" => "quux"};
is_deeply {$i->output_options}, {"x" => "m"};

my $chain = $i->build_chain;
my $output = $chain->[0]->output_to;
$output->consume({ foo => "bar" });

is_deeply [$output->output_to->messages], [{ foo => "bar" }];

done_testing;

