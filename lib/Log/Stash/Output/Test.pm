package Log::Stash::Output::Test;
use Moose;
use namespace::autoclean;

has messages => (
    isa => 'ArrayRef',
    default => sub { [] },
    traits => ['Array'],
    handles => {
        consume => 'push',
        message_count => 'count',
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

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored it's development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash>.

=cut

1;

