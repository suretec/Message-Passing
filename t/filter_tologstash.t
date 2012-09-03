use strict;
use warnings;
use Test::More;

use_ok 'Message::Passing::Filter::ToLogStash';
use_ok 'Message::Passing::Output::Test';

my @data = (
    [ 'Simple empty hash', {}, { '@fields' => {}, '@tags' => [] } ],
);

foreach my $datum (@data) {
    my ($name, $input, $exp) = @$datum;
    my $out = Message::Passing::Output::Test->new;
    my $in = Message::Passing::Filter::ToLogStash->new(
        output_to => $out,
    );
    $in->consume($input);
    my ($output) = $out->messages;
    is_deeply $output, $exp, $name;
}

done_testing;

