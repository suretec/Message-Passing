use strict;
use warnings;
use inc::Module::Install;
use Module::Install::AuthorRequires;
use Module::Install::AuthorTests;
use Module::Install::Authority;

all_from 'lib/Message/Passing.pm';

license 'AGPL_3';
authority('GHENRY');
resources(
    repository => "git://github.com/suretec/Message-Passing.git",
);

requires 'Moose';
requires 'namespace::autoclean';
requires 'AnyEvent';
requires 'MooseX::ConfigFromFile';
requires 'Config::Any';
requires 'MooseX::Types';
requires 'MooseX::Types::Common';
requires 'MooseX::Types::LoadableClass';
requires 'String::RewritePrefix';
requires 'JSON' => '2.0';
requires 'MooseX::Getopt';
requires 'Try::Tiny';
requires 'Task::Weaken';

install_script 'script/message-pass';

author_requires(
    'Test::Pod' => '1.14',
    'Test::NoTabs' => '0',
    'Test::Pod::Coverage' => '1.04',
    'Pod::Coverage' => '0.19',
    'Pod::Coverage::TrustPod' => '0',
    'Test::Spelling' => '0',
    'Compress::Zlib' => '0',
    'Compress::Bzip2' => '0',
);

author_tests 't/author';

if ($Module::Install::AUTHOR) {
    system("pod2text lib/Message/Passing.pm > README")
        and die $!;
}

WriteAll;

