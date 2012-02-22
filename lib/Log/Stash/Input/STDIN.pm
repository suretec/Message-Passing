package Log::Stash::Input::STDIN;
use Moose;
use AnyEvent;
use Try::Tiny;
use namespace::autoclean;

with 'Log::Stash::Mixin::Input';

sub BUILD {
    my $self = shift;
    my $r; $r = AnyEvent->io(fh => \*STDIN, poll => 'r', cb => sub {
        chomp (my $input = <STDIN>);
        my $data = try { $self->decode($input) }
            catch { warn $_ };
        return unless $data;
        $self->output_to->consume($data);
        $r;
    });
}

1;

