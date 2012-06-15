package Message::Passing::Filter::Encoder::Gzip;
use Moose;
use Compress::Zlib;
use namespace::autoclean;

with 'Message::Passing::Role::Filter';

sub filter {
    my ($self, $message) = @_;
    Compress::Zlib::memGzip($message);
}

__PACKAGE__->meta->make_immutable;
1;

