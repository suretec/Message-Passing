use strict;
use warnings;
use inc::Module::Install;
use Module::Install::AuthorRequires;
use Module::Install::AuthorTests;
use Module::Install::Authority;

all_from 'lib/Log/Stash.pm';

license 'AGPL_3';
authority 'GHENRY';

requires 'Moose';
requires 'namespace::autoclean';
requires 'AnyEvent';
requires 'MooseX::Types::Common';
requires 'MooseX::Types::LoadableClass';
requires 'String::RewritePrefix';
requires 'JSON' => '2.0';
requires 'MooseX::Getopt';
requires 'Try::Tiny';
requires 'Task::Weaken';

install_script 'script/logstash';

author_requires 'Test::Pod' => '1.14';
author_requires 'Test::NoTabs';
author_requires 'Test::Pod::Coverage' => '1.04';
author_requires 'Pod::Coverage' => '0.19';
author_requires 'Pod::Coverage::TrustPod';
author_requires 'Test::Spelling';

author_tests 't/author';

if ($Module::Install::AUTHOR) {
    system("pod2text lib/Log/Stash.pm > README")
        and die $!;
}

WriteAll;

