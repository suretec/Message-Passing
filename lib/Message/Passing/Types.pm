package Message::Passing::Types;
use strict;
use warnings;
use MooX::Types::MooseLike::Base qw/ :all /;
use Scalar::Util qw/ blessed /;
use JSON ();
use Try::Tiny qw/ try /;
use Module::Runtime qw/ require_module /;
use namespace::clean -except => 'meta';

use base qw(Exporter);
our @EXPORT_OK = ();
my $defs = [
    {
        name => 'Output_Type',
        test => sub { blessed($_[0]) && $_[0]->can('consume') },
        coerce => sub {
            my $val = shift;
            if (ref($val) eq 'HASH') {
                my %stuff = %$val;
                my $class = delete($stuff{class});
                require_module($class);
                $val = $class->new(%stuff);
            }
            $val;
        },
    },
    {
        name => 'Input_Type',
        test => sub { blessed($_[0]) && $_[0]->can('output_to') },
        message => sub { "$_[0] cannot ->output_to!" }
    },
    {
        name => 'Filter_Type',
        test => sub { blessed($_[0]) && $_[0]->can('output_to') && $_[0]->can('consume')},
        message => sub { "$_[0] cannot ->output_to or cannot ->consume!" }
    },
    {
        name => 'Hash_from_JSON',
        test => sub { ref($_[0]) eq 'HASH' },
        coerce => sub {
            my $str = shift;
            try {
                JSON->new->relaxed->decode($str)
            };
        },
    },
];
MooX::Types::MooseLike::register_types($defs, __PACKAGE__);

1;
