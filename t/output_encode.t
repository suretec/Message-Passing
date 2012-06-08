use strict;
use warnings;
use Test::More;
use Try::Tiny;

{
    package Message;
    use strict;
    use warnings;

    sub pack { { foo => "bar" } }
}

use Message::Passing::Output::Test;
use Message::Passing::Filter::Encoder::JSON;

my $packed;
my $test = Message::Passing::Output::Test->new(cb => sub { $packed = shift });
my $encoder = Message::Passing::Filter::Encoder::JSON->new(output_to => $test);

$encoder->consume(bless {}, 'Message');

is $packed, '{"foo":"bar"}';

done_testing;

