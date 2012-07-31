package Message::Passing::Role::HasErrorChain;
use Moo::Role;
use Message::Passing::Output::STDERR;
use namespace::clean -except => 'meta';

has error => (
    is => 'ro',
    default => sub {
        Message::Passing::Output::STDERR->new;
    },
);

1;

=head1 NAME

Message::Passing::Role::HasErrorChain - A role for components which can report errors

=head1 SYNOPSIS

    # Note this is an example package, and does not really exist!
    package Message::Passing::Output::ErrorAllMessages;
    use Moo;
    use namespace::clean -except => 'meta';

    with qw/
        Message::Passing::Role::Output
        Message::Passing::Role::HasErrorChain
    /;

    sub consume {
        my ($self, $message) = @_;
        $self->error->consume($message);
    }

=head1 DESCRIPTION

Some components can create an error stream in addition to a message stream.

=head1 METHODS

=head2 error

An attribute containing the error chain.

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored its development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Message::Passing>.

=cut
