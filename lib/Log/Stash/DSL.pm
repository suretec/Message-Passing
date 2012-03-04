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

Log::Stash::DSL - An easy way to make chains of logstash objects.

=head1 SYNOPSIS

    package mylogcollectorscript;
    use Log::Stash::DSL;

    with 'MooseX::GetOpt';

    has socket_bind => (
        is => 'ro',
        isa => 'Str',
        default => 'tcp://*:5558',
    );

    run chain {
        my $self = shift;
        output console => (
            class => 'STDOUT',
        );
        input zmq => (
            class => 'ZeroMQ',
            output_to => 'console',
            socket_bind => $self->socket_bind,
        );
    };

=head1 DESCRIPTION

This module provides a simple to use helper system for writing
scripts which implement a L<Log::Stash> server, like
the built in logstash script.

Your script can just be a script, however if it's a class with a
C<< ->new >> method, then the new method will be called, or
if you're a L<MooseX::Getopt> user (i.e. you implement a new_with_optons
method), then this will be called.

You are expected to define one or more chains, and then call the run
function.

=cut

