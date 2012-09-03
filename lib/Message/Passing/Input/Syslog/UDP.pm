package Message::Passing::Input::Syslog::UDP;
use Moo;
use MRO::Compat;
use Time::ParseDate;
use namespace::clean -except => 'meta';

extends 'Message::Passing::Input::Socket::UDP';

has '+port' => (
    default => sub { 5140 },
    required => 0,
);

our $SYSLOG_REGEXP = q|
^<(\d+)>                       # priority -- 1
    (?:
        (\S{3})\s+(\d+)        # month day -- 2, 3
        \s
        (\d+):(\d+):(\d+)      # time  -- 4, 5, 6
    )?
    \s*
    (.*)                       # text  --  7
$
|;

sub _send_data {
    my ( $self, $message, $from ) = @_;
    if ( $message =~ s/$SYSLOG_REGEXP//sx ) {
        my $time = $2 && parsedate("$2 $3 $4:$5:$6");
        $self->output_to->consume({
            time     => $time,
            pri      => $1,
            facility => int($1/8),
            severity => int($1%8),
            message      => $7,
        });
    }
}

1;

