package Message::Passing::Output::File;
use Moose;
use namespace::autoclean;

with 'Message::Passing::Role::Output';

has filename => (
    isa => 'Str',
    is => 'ro',
    predicate => '_has_filename',
);

has fh => (
    is => 'ro',
    lazy => 1,
    builder => '_build_fh',
);

has append => (
    is => 'ro',
    isa => 'Bool',
    default => 1,
);

sub _build_fh {
    my $self = shift;
    confess("Need a filename to output to") unless $self->_has_filename;
    my $mode = $self->append ? '>>' : '>';
    open(my $fh, $mode, $self->filename) or confess("Could not open ".
        $self->filename . " for writing: $!");
    $fh;
}

sub BUILD {
    my $self = shift;
    $self->fh;
}

sub consume {
    my $self = shift;
    my $saved = select($self->fh);
    local $|=1;
    print $self->encode(shift()) . "\n";
    select($saved);
    return 1;
}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Message::Passing::Output::File - File output

=head1 SYNOPSIS

    message-pass --input STDIN --output File --output_options '{"filename": "/tmp/my.log"}'
    {"foo": "bar"}
    {"foo":"bar"}

=head1 DESCRIPTION

Output messages to File

=head1 METHODS

=head2 consume

Consumes a message by JSON encoding it and printing it, followed by \n

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

