package Log::Stash::Output::STDOUT;
use Moose;
use namespace::autoclean;

with 'Log::Stash::Role::Output';

sub consume {
    my $self = shift;
    print $self->encode(shift()) . "\n";
}

1;

