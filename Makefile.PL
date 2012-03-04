use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/Log/Stash.pm';

requires 'Moose';
requires 'namespace::autoclean';
requires 'AnyEvent';
requires 'MooseX::Types::Common';
requires 'MooseX::Types::LoadableClass';
requires 'String::RewritePrefix';
requires 'JSON';
requires 'JSON::XS';
requires 'MooseX::Getopt';
requires 'Try::Tiny';
requires 'Task::Weaken';

WriteAll;

