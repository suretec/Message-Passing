package Message::Passing::Filter::Encoder::Gzip;
use Moose;
use Compress::Zlib;
use namespace::autoclean;

with 'Message::Passing::Role::Filter';

sub filter {
    my ($self, $message) = @_;
    Compress::Zlib::memGzip($message);
}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Message::Passing::Filter::Encoder::Gzip - Compresses messages with Compress::Zlib

=head1 SYNOPSIS

    message-pass --input STDIN --encoder Gzip \
        --output ZeroMQ --output_options '...'

=head1 DESCRIPTION

Compresses messages with Compress::Zlib.

=head1 METHODS

=head2 filter

Compresses the message

=head1 SEE ALSO

=over

=item L<Message::Passing::Role::Filter>

=back

