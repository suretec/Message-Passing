package Message::Passing::Filter::Decoder::Crypt::CBC;
use Moose;
use Compress::Zlib;
use namespace::autoclean;

with qw/
    Message::Passing::Role::Filter
    Message::Passing::Role::Crypt::CBC
/;

sub filter {
    my ($self, $message) = @_;
    $self->cbc->decrypt($message);
}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Message::Passing::Decoder::Crypt::CBC - Use Crypt::CBC to decrypt messages

=head1 SYNOPSIS

    message-pass --input STDIN --decoder Crypt::CBC \
        --decoder_options '{}' \
        --output ZeroMQ --output_options '...'

=head1 DESCRIPTION

Decrypts messages with Crypt::CBC.

=head1 SEE ALSO

=over

=item L<Message::Passing::Role::Filter>

=item L<Message::Passing::Role::Crypt::CBC>

=back

=head1 METHODS

=head2 filter

Decrypts the message

=head1 AUTHOR, COPYRIGHT & LICENSE

See L<Message::Passing>.

=cut

