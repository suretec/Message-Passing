package Message::Passing::Filter::Decoder::Crypt::CBC;
use Moose;
use Compress::Zlib;
use namespace::autoclean;

with qw/
    Message::Passing::Role::Filter
    Message::Passing::Role::Crypt::CBC
/;

sub filter {
    my ($self, $message) = @_;
    $self->cbc->decrypt($message);
}

__PACKAGE__->meta->make_immutable;
1;

