package Message::Passing::Exception;
use Moo::Role;
use namespace::clean -except => 'meta';

sub as_hash {
    { %{ $_[0] }, class => ref($_[0]) }
}

sub pack {
    $_[0]->as_hash;
}

1;

