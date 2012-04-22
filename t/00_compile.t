use strict;
use warnings;

use Test::More;

use_ok('Log::Stash');
use_ok('Log::Stash::Output::STDOUT');
use_ok('Log::Stash::Input::STDIN');
use_ok('Log::Stash::Input::FileTail');
use_ok('Log::Stash::Output::Null');
use_ok('Log::Stash::Output::Callback');
use_ok('Log::Stash::Output::Test');
use_ok('Log::Stash::Output::File');
use_ok('Log::Stash::Filter::Null');
use_ok('Log::Stash::Filter::All');
use_ok('Log::Stash::Filter::Delay');

done_testing;

