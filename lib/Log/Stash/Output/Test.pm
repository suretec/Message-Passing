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

with 'Log::Stash::Mixin::Output';

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Log::Stash::Output::Test - Output for use in unit tests

=head1 SYNOPSIS

    You only want this if you're writing tests...
    See the current tests for examples..

=cut

