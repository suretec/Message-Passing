package Log::Stash::DSL;

use Moose ();
use Moose::Exporter;
use Log::Stash::DSL::Factory;
use Carp qw/ confess /;
use Scalar::Util qw/weaken/;
use AnyEvent;

Moose::Exporter->setup_import_methods(
    as_is     => [qw/ run_log_server log_chain input filter output /],
    also      => 'Moose',
);

our $FACTORY;
sub _check_factory {
    confess("Not inside a chain { block!!") unless $FACTORY;
}

sub log_chain (&) {
    my $code = shift;
    if ($FACTORY) {
        confess("Cannot chain within a chain");
    }
    local $FACTORY = Log::Stash::DSL::Factory->new;
    my $ret = $code->();
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

sub run_log_server {
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

    sub build_chain {
        my $self = shift;
        log_chain {
            output console => (
                class => 'STDOUT',
            );
            input zmq => (
                class => 'ZeroMQ',
                output_to => 'console',
                socket_bind => $self->socket_bind,
            );
        };
    }

    sub start { run_log_server __PACKAGE__->new_with_options->build_chain }
    __PACKAGE__->start unless caller;

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

=head2 FUNCTIONS

=head3 log_chain

Constructs a log chain (i.e. a series of log objects feeding into each
other), warns about any unused parts of the chain, and returns the
chain head (i.e. the input class).

Maintains a registry / factory for the log classes, which is used to
allow the resolving of symbolic names in the output_to key to function.

See example in the SYNOPSIS, and details on the other functions below.

=head3 output

Constructs a named output within a chain.

    log_chain {
        output foo => ( class => 'STDOUT' );
        ....
    };

=head3 filter

Constructs a named filter (which can act as both an output and an input)
within a chain.

    log_chain {
        ...
        filter bar => ( output_to => 'stdout', class => 'Null' );
        ...
    };

=head3 input

The last thing in a chain - produces data which gets consumed.

    log_chain {
        ...
        input zmq => ( output_to => 'bar', class => 'ZeroMQ', bind => '...' );
        ....
    }

=head3 run_log_server

This enters the event loop and causes log events to be consumed and
processed.

Can be passed a log_chain to run, although this is entirely optional
(as all log chains which are still in scope will run when the event
loop is entered).

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored it's development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash>.

=cut

1;

