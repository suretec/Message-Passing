package Message::Passing::Output::Test;
use Moose;
use namespace::autoclean;

extends 'Message::Passing::Output::Callback';

has '+cb' => (
    default => sub { sub {} },
);

has messages => (
    isa => 'ArrayRef',
    default => sub { [] },
    traits => ['Array'],
    handles => {
        consume_test => 'push',
        message_count => 'count',
        messages => 'elements',
    },
    clearer => 'clear_messages',
    lazy => 1,
);

after consume => sub {
    shift()->consume_test(@_);
};

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Message::Passing::Output::Test - Output for use in unit tests

=head1 SYNOPSIS

    You only want this if you're writing tests...
    See the current tests for examples..

=head1 SEE ALSO

L<Message::Passing>

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored its development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Message::Passing>.

=cut

1;

