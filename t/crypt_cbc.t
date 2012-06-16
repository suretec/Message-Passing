use strict;
use warnings;
use Test::More;
use Try::Tiny;
use Message::Passing::Input::Null;
use Message::Passing::Output::Test;

plan skip_all => "No Crypt::CBC or no Crypt::Blowfish"
    unless try {
        require Message::Passing::Filter::Decoder::Crypt::CBC;
        require Crypt::Blowfish;
};

use_ok 'Message::Passing::Filter::Decoder::Crypt::CBC';
use_ok 'Message::Passing::Filter::Encoder::Crypt::CBC';

my $cbct = Message::Passing::Output::Test->new;
my $cbc = Message::Passing::Input::Null->new(
    output_to => Message::Passing::Filter::Encoder::Crypt::CBC->new(
        encryption_cipher => 'Blowfish',
        encryption_key => 'test',
        output_to => Message::Passing::Filter::Decoder::Crypt::CBC->new(
            output_to => $cbct,
            encryption_cipher => 'Blowfish',
            encryption_key => 'test',
        ),
    ),
);

$cbc->output_to->consume('test');
is $cbct->message_count, 1;
is_deeply [$cbct->messages], ['test'];

done_testing;

