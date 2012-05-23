use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok('Log::Stash::Role::HasAConnection');
}

{
    package TestConnectionManager;
    use Moose;
    use namespace::clean -except => 'meta';

    our @THINGS;
    sub subscribe_to_connect {
        my ($self, $thing) = @_;
        push(@THINGS, $thing);
    }

}
{
    package TestWithConnection;
    use Moose;
    use namespace::clean -except => 'meta';

    with 'Log::Stash::Role::HasAConnection';

    sub connected {} # Callback API

    sub _build_connection_manager { TestConnectionManager->new }

}

my $i = TestWithConnection->new;
ok $i;
is scalar(@TestConnectionManager::THINGS), 1;
is $TestConnectionManager::THINGS[0], $i;

done_testing;

