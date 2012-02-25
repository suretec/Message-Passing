package Log::Stash::Output::Test;
use Moose;
use namespace::autoclean;

has messages => (
    isa => 'ArrayRef',
    default => sub { [] },
    traits => ['Array'],
    handles => {
        consume => 'push',
        messages_count => 'count',
        messages => 'elements',
    },
    clearer => 'clear_messages',
    lazy => 1,
);

has on_consume_cb => (
    isa => 'CodeRef',
    is => 'ro',
    predicate => '_has_on_consume_cb',
);

after consume => sub {
    my ($self, $msg) = @_;
    $self->on_consume_cb->($msg)
        if $self->_has_on_consume_cb;
};

with 'Log::Stash::Role::Output';

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Log::Stash::Output::Test - Output for use in unit tests

=head1 SYNOPSIS

    You only want this if you're writing tests...
    See the current tests for examples..

=head1 SEE ALSO

L<Log::Stash>

=head1 AUTHOR

Tomas (t0m) Doran <bobtfish@bobtfish.net>

=head1 SPONSORSHIP

This module exists due to the wonderful people at
L<Suretec Systems|http://www.suretecsystems.com/> who sponsored it's
development.

=head1 COPYRIGHT

Copyright Suretec Systems 2012.

Logstash (upon which many ideas for this project is based, but
which we do not reuse any code from) is copyright 2010 Jorden Sissel.

=head1 LICENSE

XX - TODO

=cut

