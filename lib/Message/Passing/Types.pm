package Message::Passing::Types;
use MooseX::Types ();
use Moose::Util::TypeConstraints;
use JSON ();
use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;
use MooseX::Getopt;
use Try::Tiny;
use namespace::autoclean;

role_type 'Message::Passing::Types::Input', { role => 'Message::Passing::Role::Input' };
role_type 'Message::Passing::Types::Output', { role => 'Message::Passing::Role::Output' };
role_type 'Message::Passing::Types::Filter', { role => 'Message::Passing::Role::Filter' };

coerce 'Message::Passing::Types::Output',
    from 'HashRef',
    via {
        my %stuff = %$_;
        my $class = delete($stuff{class});
        Class::MOP::load_class($class);
        $class->new(%stuff);
    };

subtype 'Message::Passing::Types::FromJSON',
    as "HashRef";

coerce 'Message::Passing::Types::FromJSON',
  from NonEmptySimpleStr,
  via { try { JSON->new->relaxed->decode($_) } };

MooseX::Getopt::OptionTypeMap->add_option_type_to_map(
    'Message::Passing::Types::FromJSON' => '=s'
);

1;

