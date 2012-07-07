package Message::Passing::DSL::Factory;
use Moose;
use String::RewritePrefix;
use Message::Passing::Output::STDERR;
use namespace::clean -except => 'meta';

sub expand_class_name {
    my ($self, $type, $name) = @_;
    String::RewritePrefix->rewrite({
        '' => 'Message::Passing::' . $type . '::',
        '+' => ''
    }, $name);
}

has registry => (
    isa => 'HashRef',
    default => sub { {} },
    traits => ['Hash'],
    handles => {
        registry_get => 'get',
        registry_has => 'get',
        registry_set => 'set',
        registry => 'elements',
    },
    lazy => 1,
    clearer => 'clear_registry',
);

sub set_error {
    my ($self, %opts) = @_;
    my $class = delete $opts{class}
        || confess("Class name needed");
    $class = $self->expand_class_name('Output', $class);
    Class::MOP::load_class($class);
    $self->_set_error($class->new(%opts));
}

has error => (
    is => 'ro',
    writer => '_set_error',
    default => sub {
        Message::Passing::Output::STDERR->new;
    }
);

sub make {
    my ($self, %opts) = @_;
    my $class = delete $opts{class}
        || confess("Class name needed");
    my $name = delete $opts{name};
    my $type = delete $opts{type};
    confess("We already have a thing named $name")
        if $self->registry_has($name);
    my $output_to = $opts{output_to};
    if ($output_to && !blessed($output_to)) {
        # We have to deal with the ARRAY case here for Filter::T
        if (ref($output_to) eq 'ARRAY') {
            my @out;
            foreach my $name_or_thing (@$output_to) {
                if (blessed($name_or_thing)) {
                    push(@out, $name_or_thing);
                }
                else {
                    my $thing = $self->registry_get($name_or_thing)
                        || confess("Do not have a component named '$name_or_thing'");
                    push(@out, $thing);
                }
            }
            $opts{output_to} = \@out;
        }
        else {
            my $proper_output_to = $self->registry_get($output_to)
                || confess("Do not have a component named '$output_to'");
            $opts{output_to} = $proper_output_to;
        }
    }
    if (!exists($opts{error})) {
        $opts{error} = $self->error;
    }
    $class = $self->expand_class_name($type, $class);
    Class::MOP::load_class($class);
    my $out = $class->new(%opts);
    $self->registry_set($name, $out);
    return $out;
}


1;

=head1 NAME

Message::Passing::DSL::Factory - Build a set of chains using symbolic names

=head1 DESCRIPTION

No user serviceable parts inside. See L<Message::Passing::DSL>.

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored its development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Message::Passing>.

=cut

