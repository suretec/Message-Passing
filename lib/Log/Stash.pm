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

with 'MooseX::Getopt';

our $VERSION = '0.001';
$VERSION = eval $VERSION;

my %things = (
    Input  => 1,
    Filter => 0,
    Output => 1,
);

foreach my $name (keys %things ) {
    my $class = subtype LoadableClass, where { 1 };
    coerce $class,
        from NonEmptySimpleStr,
        via {
            to_LoadableClass(String::RewritePrefix->rewrite({
                '' => 'Log::Stash::' . $name . '::',
                '+' => ''
            }, $_));
        };

    has lc($name) => (
        isa => $class,
        is => 'ro',
        required => $things{$name},
        coerce => 1,
    );

    has lc($name) . '_instance' => (
        is => 'ro',
        lazy => 1,
        does => "Log::Stash::Role::$name",
        builder => '_build_' . lc($name) . '_instance',
    );
}

has '+filter' => (
    default => 'Null',
);

sub _build_input_instance {
    my $self = shift;
    $self->input->new($self->input_options, output_to => $self->filter_instance);
}

sub _build_filter_instance {
    my $self = shift;
    $self->filter->new($self->filter_options, output_to => $self->output_instance);
}

sub _build_output_instance {
    my $self = shift;
    $self->output->new($self->output_options);
}

sub start {
    my $self = shift;
    $self->input_instance;
}

my $json_type = subtype
  as "HashRef";

coerce $json_type,
  from NonEmptySimpleStr,
  via { try { JSON::XS->new->relaxed->decode($_) } };

foreach my $name (map { lc($_) . "_options"  } keys %things) {
    has $name => (
        isa => $json_type,
        traits    => ['Hash'],
        default => sub { {} },
        handles => {
            lc($name) => 'elements',
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

A lightweight but interoperable interoperable subset of logstash
L<http://logstash.net>

This implementation is currently a sketch, and as such should be considered
pre alpha and subject to change at any point.

=head2 BASIC PREMIS

You have data for discrete events, represented by a hash (and
serialized as JSON).

This could be a text log line, an audit record of an API
event, a metric emitted from your application that you wish
to aggregate and process - anything that can be a simple hash really..

You want to be able to shove these events over the network easily,
and aggregate them / munge them / split them into worker queues.

This module is designed as a simple framework for writing components
that let you do all of these things, in a simple and pluggable manor.

For a practical example, You generate events from a source (e.g.
ZeroMQ output of logs and performance metrics from your Catalyst FCGI
or Starman workers) and run one script that will give you a centralised
application log file, or push the logs into L<ElasticSearch>.

There are a growing set of pre-written components you can plug together
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

Ouputs send data to somewhere, i.e. they consume messages.

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

XX - TODO

=cut


