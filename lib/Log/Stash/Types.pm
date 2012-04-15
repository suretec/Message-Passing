package Log::Stash::Types;
use MooseX::Types ();
use Moose::Util::TypeConstraints;

role_type $_ for map { "Log::Stash::Role::$_" }
    qw/
        Input
        Filter
        Output
    /;

coerce 'Log::Stash::Role::Output',
    from 'HashRef',
    via {
        my %stuff = %$_;
        my $class = delete($stuff{class});
        Class::MOP::load_class($class);
        $class->new(%stuff);
    };

1;

