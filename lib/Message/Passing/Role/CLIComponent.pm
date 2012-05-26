package Message::Passing::Role::CLIComponent;
use MooseX::Role::Parameterized;
use Moose::Util::TypeConstraints;
use Message::Passing::Types;
use namespace::autoclean;

parameter name => (
    isa      => 'Str',
    required => 1,
);

parameter default => (
    isa => 'Str',
    predicate => 'has_default',
);

role {
    my $p = shift;

    my $name = $p->name;
    my $has_default = $p->has_default;
    my $default = $has_default ? $p->default : undef;

    has $name => (
        isa => 'Str',
        is => 'ro',
        required => $has_default ? 0 : 1,
        $has_default ? ( default => $default ) : (),
    );

    has "${name}_options" => (
        isa => "Message::Passing::Types::FromJSON",
        traits    => ['Hash'],
        default => sub { {} },
        handles => {
            "${name}_options" => 'elements',
        },
        coerce => 1,
    );
};

