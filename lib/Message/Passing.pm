package Message::Passing;
use Moose;
use Getopt::Long qw(:config pass_through);
use namespace::autoclean;
use 5.8.4;

use Message::Passing::DSL;

with
    'MooseX::Getopt',
    'Message::Passing::Role::CLIComponent' => { name => 'input' },
    'Message::Passing::Role::CLIComponent' => { name => 'output' },
    'Message::Passing::Role::CLIComponent' => { name => 'filter', default => 'Null' },
    'Message::Passing::Role::Script';

our $VERSION = '0.003';
$VERSION = eval $VERSION;

sub build_chain {
    my $self = shift;
        log_chain {
            output out => (
                $self->output_options,
                class => $self->output,
            );
            filter filter => (
                $self->filter_options,
                class => $self->filter,
                output_to => 'out',
            );
            input in => (
                $self->input_options,
                class => $self->input,
                output_to => 'filter',
            );
        };
}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Message::Passing - a simple way of doing messaging.

=head1 SYNOPSIS

    message-passing --input STDIN --output STDOUT
    {"foo": "bar"}
    {"foo":"bar"}

=head1 DESCRIPTION

This implementation is currently a prototype, and as such should be considered
alpha and subject to change at any point.

A library for building high performance, loosely coupled and reliable/reseliant applications,
structured as small services which communicate over the network by passing messages.

=head2 BASIC PREMISE

You have data for discrete events, represented by a hash (and
serialized as JSON).

This could be a text log line, an audit record of an API
event, a metric emitted from your application that you wish
to aggregate and process - anything that can be a simple hash really..

You want to be able to shove these events over the network easily,
and aggregate them / filter and rewrite them / split them into worker queues.

This module is designed as a simple framework for writing components
that let you do all of these things, in a simple and easily extensible
manor.

For a practical example, You generate events from a source (e.g.
L<ZeroMQ> output of logs and performance metrics from your L<Catalyst> FCGI
or L<Starman> workers) and run one script that will give you a central
application log file, or push the logs into L<ElasticSearch>.

There are a growing set of components you can plug together
to make your solution.

Getting started is really easy - you can just use the C<message-passing>
command installed by the distribution. If you have a common config
that you want to repeat, or you want to write your own server
which does something more flexible than the normal script allows,
then see L<Message::Passing::DSL>.

To dive straight in, see the documentation for the command line utility
L<message-passing>, and see the examples in L<Message::Passing::Manual::Cookbook>.

For more about how the system works, see L<Message::Passing::Manual::Concepts>.

=head1 COMPONENTS

Below is a non-exhaustive list of components available.

=head2 INPUTS

Inputs receive data from a source (usually a network protocol).

They are responsible for decoding the data into a hash before passing
it onto the next stage.

Inputs include:

=over

=item L<Message::Passing::Input::STDIN>

=item L<Message::Passing::Input::ZeroMQ>

=item L<Message::Passing::Input::Test>

=back

You can easily write your own input, just use L<AnyEvent>, and
consume L<Message::Passing::Role::Input>.

=head2 FILTER

Filters can transform a message in any way.

Examples include:

=over

=item L<Message::Passing::Filter::Null> - Returns the input unchanged.

=item L<Message::Passing::Filter::All> - Stops any messages it receives from being passed to the output. I.e. literally filters all input out.

=item L<Message::Passing::Filter::T> - Splits the incoming message to multiple outputs.

=back

You can easily write your own filter, just consume
L<Message::Passing::Role::Filter>.

Note that filters can be chained, and a filter can return undef to
stop a message being passed to the output.

=head2 OUTPUTS

Outputs send data to somewhere, i.e. they consume messages.

=over

=item L<Message::Passing::Output::STDOUT>

=item L<Message::Passing::Output::AMQP> - COMING SOON (L<https://github.com/suretec/Message-Passing-AMQP>)

=item L<Message::Passing::Output::ZeroMQ>

=item L<Message::Passing::Output::WebHooks>

=item L<Message::Passing::Output::ElasticSearch> - COMING SOON (L<https://github.com/suretec/Message-Passing-Output-ElasticSearch>)

=item L<Message::Passing::Output::Test>

=back

=head1 SEE ALSO

=over

=item L<Log::Message::Structured> - For creating your log messages.

=item L<Log::Dispatch::Message::Passing> - use Message::Passing outputs from L<Log::Dispatch>.

=back

=head1 THIS MODULE

This is a simple L<MooseX::Getopt> script, with one input, one filter
and one output.

=head2 METHODS

=head3 build_chain

Builds and returns the configured chain of input => filter => output

=head3 start

Class method to call the run_log_server function with the results of
having constructed an instance of this class, parsed command line options
and constructed a chain.

This is the entry point for the script.

=head1 AUTHOR

Tomas (t0m) Doran <bobtfish@bobtfish.net>

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored it's development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 COPYRIGHT

Copyright Suretec Systems Ltd. 2012.

Logstash (upon which many ideas for this project is based, but
which we do not reuse any code from) is copyright 2010 Jorden Sissel.

=head1 LICENSE

GNU Affero General Public License, Version 3

If you feel this is too restrictive to be able to use this software,
please talk to us as we'd be willing to consider re-licensing under
less restrictive terms.

=cut

1;

