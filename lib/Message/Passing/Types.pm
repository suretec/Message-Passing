package Message::Passing::Types;
use MooseX::Types ();
use Moose::Util::TypeConstraints;
use JSON ();
use MooseX::Types::Moose qw/ Str HashRef /;
use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;
use MooseX::Getopt;
use Try::Tiny;
use namespace::autoclean;

use MooseX::Types -declare => [qw{
    Output_Type
    Input_Type
    Filter_Type
    Codec_Type
    Hash_from_JSON
    JSON_from_Hash
}];

role_type Input_Type, { role => 'Message::Passing::Role::Input' };
role_type Output_Type, { role => 'Message::Passing::Role::Output' };
role_type Filter_Type, { role => 'Message::Passing::Role::Filter' };

coerce Output_Type,
    from HashRef,
    via {
        my %stuff = %$_;
        my $class = delete($stuff{class});
        Class::MOP::load_class($class);
        $class->new(%stuff);
    };

subtype Hash_from_JSON,
    as HashRef;

coerce Hash_from_JSON,
  from NonEmptySimpleStr,
  via { try { JSON->new->relaxed->decode($_) } };

MooseX::Getopt::OptionTypeMap->add_option_type_to_map(
    Hash_from_JSON, '=s'
);

1;
