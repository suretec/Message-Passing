package Log::Stash::Types;
use MooseX::Types ();
use Moose::Util::TypeConstraints;
use JSON::XS ();
use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;
use MooseX::Getopt;
use Try::Tiny;
use namespace::autoclean;

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

subtype 'Log::Stash::Types::FromJSON',
    as "HashRef";

coerce 'Log::Stash::Types::FromJSON',
  from NonEmptySimpleStr,
  via { try { JSON::XS->new->relaxed->decode($_) } };

MooseX::Getopt::OptionTypeMap->add_option_type_to_map(
    'Log::Stash::Types::FromJSON' => '=s'
);

1;

