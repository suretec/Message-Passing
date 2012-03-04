package Log::Stash::DSL;

use Moose ();
use Moose::Exporter;
use Log::Stash::DSL::Factory;
use Carp qw/ confess /;
use Scalar::Util qw/weaken/;
use AnyEvent;

Moose::Exporter->setup_import_methods(
    as_is     => [qw/ run chain input filter output /],
    also      => 'Moose',
);

our $FACTORY;
sub _check_factory {
    confess("Not inside a chain { block!!") unless $FACTORY;
}

our ($self, $class) = ('', '');
sub chain (&) {
    my $code = shift;
    my ($caller, undef, undef) = caller();
    if ($class ne $caller) {
        $class = $caller;
        if ($class->can('new_with_options')) {
            $self = $class->new_with_options;
        }
        elsif ($class->can('new')) {
            $self = $class->new;
        }
        else {
            $self = $class;
        }
    }
    if ($FACTORY) {
        confess("Cannot chain witin a chain");
    }
    my $self;
    if ($caller->can('new_with_options')) {
        $caller->new_with_options;
    }
    local $FACTORY = Log::Stash::DSL::Factory->new;
    my $ret = $self->$code();
    my %items = $FACTORY->registry;
    $FACTORY->clear_registry;
    weaken($items{$_}) for keys %items;
    foreach my $name (keys %items) {
        next if $items{$name};
        warn "Unused output or filter $name in chain\n";
    }
    return $ret;
}

sub input {
     my ($name, %opts) = @_;
    _check_factory();
    $FACTORY->make(
        %opts,
        __name => $name,
        __type => 'Input',
    );
}

sub filter {
     my ($name, %opts) = @_;
    _check_factory();
    $FACTORY->make(
        %opts,
        __name => $name,
        __type => 'Filter',
    );
}

sub output {
    my ($name, %opts) = @_;
    _check_factory();
    $FACTORY->make(
        %opts,
        __name => $name,
        __type => 'Output',
    );
}

sub run {
    undef $self;
    my $chain = shift;
    AnyEvent->condvar->recv;
}

1;

=head1 NAME

Log::Stash::DSL

