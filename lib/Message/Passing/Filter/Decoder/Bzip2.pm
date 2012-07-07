package Message::Passing::Filter::Decoder::Bzip2;
use Moo;
use Compress::Bzip2;
use namespace::clean -except => 'meta';

with 'Message::Passing::Role::Filter';

sub filter {
    my ($self, $message) = @_;
    Compress::Bzip2::memBunzip($message);
}


1;

