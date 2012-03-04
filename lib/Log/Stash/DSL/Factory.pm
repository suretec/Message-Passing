package Log::Stash::DSL::Factory;
use Moose;
use String::RewritePrefix;
use namespace::autoclean;

sub expand_class_name {
    my ($self, $type, $name) = @_;
    String::RewritePrefix->rewrite({
        '' => 'Log::Stash::' . $type . '::',
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

sub make {
    my ($self, %opts) = @_;
    my $class = delete $opts{class}
        || confess("Class name needed");
    my $name = delete $opts{__name};
    my $type = delete $opts{__type};
    confess("We already have a thing named $name")
        if $self->registry_has($name);
    my $output_to = $opts{output_to};
    if ($output_to && !ref($output_to)) {
        my $proper_output_to = $self->registry_get($output_to)
            || confess("Do not have a component named '$output_to'");
        $opts{output_to} = $proper_output_to;
    }
    $class = $self->expand_class_name($type, $class);
    Class::MOP::load_class($class);
    my $out = $class->new(%opts);
    $self->registry_set($name, $out);
    return $out;
}

__PACKAGE__->meta->make_immutable;
1;


