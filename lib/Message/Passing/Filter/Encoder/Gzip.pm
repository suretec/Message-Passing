package Message::Passing::Filter::Encoder::Gzip;
use Moo;
use Compress::Zlib;
use namespace::clean -except => 'meta';

with 'Message::Passing::Role::Filter';

sub filter {
    my ($self, $message) = @_;
    Compress::Zlib::memGzip($message);
}


1;

