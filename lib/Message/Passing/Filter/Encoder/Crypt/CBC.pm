package Message::Passing::Filter::Encoder::Crypt::CBC;
use Moo;
use Compress::Zlib;
use namespace::clean -except => 'meta';

with qw/
    Message::Passing::Role::Filter
    Message::Passing::Role::Crypt::CBC
/;

sub filter {
    my ($self, $message) = @_;
    $self->cbc->encrypt($message);
}


1;

