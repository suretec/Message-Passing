package Message::Passing::Filter::Decoder::Bzip2;
use Moose;
use Compress::Bzip2;
use namespace::autoclean;

with 'Message::Passing::Role::Filter';

sub filter {
    my ($self, $message) = @_;
    Compress::Bzip2::memBunzip($message);
}

__PACKAGE__->meta->make_immutable;
1;

