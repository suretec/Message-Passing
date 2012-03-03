package Log::Stash::Filter::Null;
use Moose;
use namespace::autoclean;

with 'Log::Stash::Role::Filter';

sub filter {
    my ($self, $message) = @_;
    $message;
}

__PACKAGE__->meta->make_immutable;
1;

