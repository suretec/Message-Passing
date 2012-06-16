package Message::Passing::Role::Crypt::CBC;
use Moose::Role;
use Crypt::CBC;
use namespace::autoclean;

has [qw/
    encryption_key
    encryption_cipher
/] => (
    isa => 'Str',
    is => 'ro',
    required => 1,
);

# NOTE - We need a new CBC object per message, otherwise if we _EVER_ drop
#        messages then we totally screw ourselves!
sub cbc {
    my $self = shift;
    Crypt::CBC->new(
        -key    => $self->encryption_key,
        -cipher => $self->encryption_cipher,
    );
}

1;

