package Message::Passing::Filter::Encoder::Crypt::CBC;
use Moose;
use Compress::Zlib;
use namespace::autoclean;

with qw/
    Message::Passing::Role::Filter
    Message::Passing::Role::Crypt::CBC
/;

sub filter {
    my ($self, $message) = @_;
    $self->cbc->encrypt($message);
}

__PACKAGE__->meta->make_immutable;
1;

