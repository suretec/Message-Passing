package Message::Passing::Input::STDIN;
use Moose;
use AnyEvent;
use Try::Tiny;
use Scalar::Util qw/ weaken /;
use namespace::autoclean;

with qw/
    Message::Passing::Role::Input
/;

has reader => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        weaken($self);
        AnyEvent->io(fh => \*STDIN, poll => 'r', cb => sub {
            my $input = <STDIN>;
            return unless defined $input;
            chomp($input);
            return unless length $input;
            $self->output_to->consume($input);
        });
    },
);

sub BUILD {
    my $self = shift;
    $self->reader;
}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Message::Passing::Input::STDIN - STDIN input

=head1 SYNOPSIS

    message-pass --input STDIN --output STDOUT
    {"foo": "bar"}
    {"foo":"bar"}

=head1 DESCRIPTION

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
