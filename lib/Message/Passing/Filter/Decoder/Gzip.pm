package Message::Passing::Filter::Decoder::Gzip;
use Moose;
use Compress::Zlib;
use namespace::autoclean;

with 'Message::Passing::Role::Filter';

sub filter {
    my ($self, $message) = @_;
    Compress::Zlib::memGunzip($message);
}

__PACKAGE__->meta->make_immutable;
1;

