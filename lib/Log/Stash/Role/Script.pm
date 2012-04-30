package Log::Stash::Role::Script;
use Moose::Role;
use Getopt::Long qw(:config pass_through);
use POSIX qw(setuid setgid);
use Moose::Util::TypeConstraints;
use namespace::autoclean;

requires 'build_chain';

has daemonize => (
    is => 'ro',
    isa => 'Bool',
    default => 0,
);

sub deamonize_if_needed {
    my ($self) = @_;
    my $fh;
    if ($self->_has_pid_file) {
        open($fh, '>', $self->pid_file)
            or confess("Could not open pid file '". $self->pid_file . "': $?");
    }
    if ($self->daemonize) {
        fork && exit;
        POSIX::setsid();
        fork && exit;
        chdir '/';
        umask 0;
    }
    if ($fh) {
        print $fh $$ . "\n";
        close($fh);
    }
}

sub change_uid_if_needed {
    my $self = shift;
    my ($uid, $gid);
    if ($self->_has_user) {
        my $user = $self->user;
        $uid = getpwnam($user) ||
            die("User '$user' does not exist, cannot become that user!\n");
        (undef, undef, undef, $gid ) = getpwuid($uid);
    }
    if ($gid) {
        setgid($gid) || die("Could not setgid to '$gid' are you root? : $!\n");
    }
    if ($uid) {
        setuid($uid) || die("Could not setuid to '$uid' are you root? : $!\n");
    }
}

foreach my $name (qw/ user pid_file /) {
    has $name => (
        isa => 'Str',
        is => 'ro',
        predicate => "_has_$name",
    );
}

has io_priority => (
    isa => enum([qw[ none be rt idle ]]),
    is => 'ro',
    predicate => "_has_io_priority",
);

sub set_io_priority_if_needed {
    my $self = shift;
    return unless $self->_has_io_priority;
    require Linux::IO_Prio;
    my $sym = do {
        no strict 'refs';
        &{"Linux::IO_Prio::IOPRIO_CLASS_" . uc($self->io_priority)}();
    };
    Linux::IO_Prio::ioprio_set(Linux::IO_Prio::IOPRIO_WHO_PROCESS(), $$,
        Linux::IO_Prio::IOPRIO_PRIO_VALUE($sym, 0)
    );
}

sub start {
    my $class = shift;
    my $instance = $class->new_with_options(@_);
    $instance->set_io_priority_if_needed;
    $instance->change_uid_if_needed;
    $instance->deamonize_if_needed;
    run_log_server $instance->build_chain;
}

1;

=head1 NAME

Log::Stash:Role::Script - Handy role for scripts.

=head1 AUTHOR

Tomas (t0m) Doran <bobtfish@bobtfish.net>

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored it's development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 COPYRIGHT

Copyright Suretec Systems Ltd. 2012.

Logstash (upon which many ideas for this project is based, but
which we do not reuse any code from) is copyright 2010 Jorden Sissel.

=head1 LICENSE

GNU Affero General Public License, Version 3

If you feel this is too restrictive to be able to use this software,
please talk to us as we'd be willing to consider re-licensing under
less restrictive terms.

=cut

1;

