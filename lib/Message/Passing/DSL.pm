package Message::Passing::DSL;

use Moose ();
use Moose::Exporter;
use Message::Passing::DSL::Factory;
use Carp qw/ confess /;
use Scalar::Util qw/weaken/;
use AnyEvent;
use Moose::Util qw/ does_role /;

Moose::Exporter->setup_import_methods(
    as_is     => [qw/ run_log_server log_chain input filter output decoder encoder /],
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
    local $FACTORY = Message::Passing::DSL::Factory->new;
    $code->();
    my %items = $FACTORY->registry;
    $FACTORY->clear_registry;
    weaken($items{$_}) for
        grep { does_role($items{$_}, 'Message::Passing::Role::Output') }
        keys %items;
    foreach my $name (keys %items) {
        next if $items{$name};
        warn "Unused output or filter $name in chain\n";
    }
    return [
        grep { !does_role($_, 'Message::Passing::Role::Output') }
        grep { does_role($_, 'Message::Passing::Role::Input') }
        values %items
    ];
}

sub input {
     my ($name, %opts) = @_;
    _check_factory();
    $FACTORY->make(
        %opts,
        name => $name,
        type => 'Input',
    );
}

sub filter {
     my ($name, %opts) = @_;
    _check_factory();
    $FACTORY->make(
        %opts,
        name => $name,
        type => 'Filter',
    );
}

sub output {
    my ($name, %opts) = @_;
    _check_factory();
    $FACTORY->make(
        %opts,
        name => $name,
        type => 'Output',
    );
}

sub decoder {
     my ($name, %opts) = @_;
    _check_factory();
    $FACTORY->make(
        %opts,
        name => $name,
        type => 'Filter::Decoder',
    );
}

sub encoder {
     my ($name, %opts) = @_;
    _check_factory();
    $FACTORY->make(
        %opts,
        name => $name,
        type => 'Filter::Encoder',
    );
}

sub run_log_server {
    my $chain = shift;
    AnyEvent->condvar->recv;
}

1;

=head1 NAME

Message::Passing::DSL - An easy way to make chains of Message::Passing components.

=head1 SYNOPSIS

    package mylogcollectorscript;
    use Message::Passing::DSL;

    with 'MooseX::GetOpt',
        'Message::Passing::Role::Script';

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

    __PACKAGE__->start unless caller;
    1;

=head1 DESCRIPTION

This module provides a simple to use helper system for writing
scripts which implement a L<Message::Passing> server, like
the built in message-pass script.

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

Class names will be assumed to prefixed with 'Log::Stash::Output::',
unless you prefix the class with + e.g. C<< +My::Own::Output::Class >>

=head3 encoder

Constructs a named encoder within a chain.

    log_chain {
        encoder fooenc => ( output_to => 'out', class => 'JSON' );
        ....
    };

Class names will be assumed to prefixed with 'Log::Stash::Filter::Encoder::',
unless you prefix the class with + e.g. C<< +My::Own::Encoder::Class >>

=head3 filter

Constructs a named filter (which can act as both an output and an input)
within a chain.

    log_chain {
        ...
        filter bar => ( output_to => 'fooenc', class => 'Null' );
        ...
    };

Class names will be assumed to prefixed with 'Log::Stash::Filter::',
unless you prefix the class with + e.g. C<< +My::Own::Filter::Class >>

=head3 decoder

Constructs a named decoder within a chain.

    log_chain {
        decoder zmq_decode => ( output_to => 'filter', class => 'JSON' );
        ....
    };

Class names will be assumed to prefixed with 'Log::Stash::Filter::Decoder::',
unless you prefix the class with + e.g. C<< +My::Own::Encoder::Class >>


=head3 input

The last thing in a chain - produces data which gets consumed.

    log_chain {
        ...
        input zmq => ( output_to => 'zmq_decode', class => 'ZeroMQ', bind => '...' );
        ....
    }

Class names will be assumed to prefixed with 'Log::Stash::Output::',
unless you prefix the class with + e.g. C<< +My::Own::Output::Class >>

=head3 run_log_server

This enters the event loop and causes log events to be consumed and
processed.

Can be passed a log_chain to run, although this is entirely optional
(as all log chains which are still in scope will run when the event
loop is entered).

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored its development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Message::Passing>.

=cut

1;

