package Log::Stash::Filter::All;
use Moose;
use namespace::autoclean;

with 'Log::Stash::Role::Filter';

sub filter {
    return;
}

__PACKAGE__->meta->make_immutable;
1;

