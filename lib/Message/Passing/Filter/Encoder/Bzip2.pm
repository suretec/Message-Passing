package Message::Passing::Filter::Encoder::Bzip2;
use Moose;
use Compress::Bzip2;
use namespace::autoclean;

with 'Message::Passing::Role::Filter';

sub filter {
    my ($self, $message) = @_;
    Compress::Bzip2::memBzip($message);
}

__PACKAGE__->meta->make_immutable;
1;

