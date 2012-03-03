use strict;
use warnings;
use Test::More;

use_ok 'Log::Stash';

my $i = Log::Stash->new(
    input => 'STDIN',
    input_options => '{"foo":"bar"}',
    filter_options => '{"baz":"quux"}',
    output => 'STDOUT',
    output_options => '{"x":"m"}',
);

is_deeply {$i->input_options}, {"foo" => "bar"};
is_deeply {$i->filter_options}, {"baz" => "quux"};
is_deeply {$i->output_options}, {"x" => "m"};

done_testing;

