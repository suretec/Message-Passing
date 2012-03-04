use strict;
use warnings;
use Test::More;

use_ok 'Log::Stash';

my $i = Log::Stash->new(
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
$chain->output_to->consume({ foo => "bar" });

is_deeply [$chain->output_to->output_to->messages], [{ foo => "bar" }];

done_testing;

