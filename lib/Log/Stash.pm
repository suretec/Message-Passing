package Log::Stash;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;
use MooseX::Types::LoadableClass qw/ LoadableClass /;
use String::RewritePrefix;
use AnyEvent;
use JSON::XS;
use Try::Tiny;
use namespace::autoclean;
use 5.8.4;

use Log::Stash::DSL;

with 'MooseX::Getopt';

our $VERSION = '0.001';
$VERSION = eval $VERSION;

my %things = (
    input  => 1,
    filter => 0,
    output => 1,
);

foreach my $name (keys %things ) {
    has $name => (
        isa => 'Str',
        is => 'ro',
        required => $things{$name},
    );
}

has '+filter' => (
    default => 'Null',
);

sub build_chain {
    my $self = shift;
        log_chain {
            output out => (
                $self->output_options,
                class => $self->output,
            );
            filter fil => (
                $self->filter_options,
                class => $self->filter,
                output_to => 'out',
            );
            input in => (
                $self->input_options,
                class => $self->input,
                output_to => 'fil',
            );
        };
}

sub start { run_log_server __PACKAGE__->new_with_options->build_chain }

my $json_type = subtype
  as "HashRef";

coerce $json_type,
  from NonEmptySimpleStr,
  via { try { JSON::XS->new->relaxed->decode($_) } };

MooseX::Getopt::OptionTypeMap->add_option_type_to_map(
    $json_type => '=s'
);

foreach my $name (map { "${_}_options"  } keys %things) {
    has $name => (
        isa => $json_type,
        traits    => ['Hash'],
        default => sub { {} },
        handles => {
            $name => 'elements',
        },
        coerce => 1,
    );
}

1;

=head1 NAME

Log::Stash - a perl subset of Logstash <http://logstash.net>

=head1 SYNOPSIS

    logstash --input STDIN --output STDOUT
    {"foo": "bar"}
    {"foo":"bar"}

=head1 DESCRIPTION

A lightweight but inter-operable subset of logstash
L<http://logstash.net>

This implementation is currently a prototype, and as such should be considered
alpha and subject to change at any point.

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
ZeroMQ output of logs and performance metrics from your Catalyst FCGI
or Starman workers) and run one script that will give you a central
application log file, or push the logs into L<ElasticSearch>.

There are a growing set of components you can plug together
to make your logging solution.

Getting started is really easy - you can just use the C<logstash>
command installed by the distribution. If you have a common config
that you want to repeat, or you want to write your own server
which does something more flexible than the normal script allows,
then see L<Log::Stash::DSL>.

=head1 COMPONENTS

Below is a non-exhaustive list of components available.

=head2 INPUTS

Inputs receive data from a source (usually a network protocol).

They are responsible for decoding the data into a hash before passing
it onto the next stage.

Inputs include:

=over

=item L<Log::Stash::Input::STDIN>

=item L<Log::Stash::Input::ZeroMQ>

=item L<Log::Stash::Input::Test>

=back

You can easily write your own input, just use L<AnyEvent>, and
consume L<Log::Stash::Role::Input>.

=head2 FILTER

Filters can transform a message in any way.

Examples include:

=over

=item L<Log::Stash::Filter::Null> - Returns the input unchanged.

=item L<Log::Stash::Filter::All> - Stops any messages it receives from being passed to the output. I.e. literally filters all input out.

=item L<Log::Stash::Filter::T> - Splits the incoming message to multiple outputs.

=back

You can easily write your own filter, just consume
L<Log::Stash::Role::Filter>.

Note that filters can be chained, and a filter can return undef to
stop a message being passed to the output.

=head2 OUTPUTS

Outputs send data to somewhere, i.e. they consume messages.

=over

=item L<Log::Stash::Output::STDOUT>

=item L<Log::Stash::Output::AMQP>

=item L<Log::Stash::Output::ZeroMQ>

=item L<Log::Stash::Output::WebHooks>

=item L<Log::Stash::Output::ElasticSearch>

=item L<Log::Stash::Output::Test>

=back

=head1 SEE ALSO

=over

=item L<Log::Message::Structured> - For creating your log messages.

=item L<Log::Dispatch::Log::Stash> - use Log::Stash outputs from L<Log::Dispatch>.

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

This is the entry point for the logstash script.

=head1 AUTHOR

Tomas (t0m) Doran <bobtfish@bobtfish.net>

=head1 SPONSORSHIP

This module exists due to the wonderful people at
L<Suretec Systems|http://www.suretecsystems.com/> who sponsored it's
development.

=head1 COPYRIGHT

Copyright Suretec Systems 2012.

Logstash (upon which many ideas for this project is based, but
which we do not reuse any code from) is copyright 2010 Jorden Sissel.

=head1 LICENSE

GNU Affero General Public License, Version 3

If you feel this is too restrictive to be able to use this software,
please talk to us as we'd be willing to consider re-licensing under
less restrictive terms.

=cut

1;

