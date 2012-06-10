package Message::Passing::Role::CLIComponent;
use MooseX::Role::Parameterized;
use Moose::Util::TypeConstraints;
use Message::Passing::Types qw/
    Hash_from_JSON
/;
use namespace::autoclean;

parameter name => (
    isa      => 'Str',
    required => 1,
);

parameter default => (
    isa => 'Str',
    predicate => 'has_default',
);

role {
    my $p = shift;

    my $name = $p->name;
    my $has_default = $p->has_default;
    my $default = $has_default ? $p->default : undef;

    has $name => (
        isa => 'Str',
        is => 'ro',
        required => $has_default ? 0 : 1,
        $has_default ? ( default => $default ) : (),
    );

    has "${name}_options" => (
        isa => Hash_from_JSON,
        traits    => ['Hash'],
        default => sub { {} },
        handles => {
            "${name}_options" => 'elements',
        },
        coerce => 1,
    );
};

1;

=head1 NAME

Message::Passing::Role::CLIComponent - Role providing 'foo' and 'foo_options' attributes

=head1 SYNOPSIS

    package My::Message::Passing::Script;
    use Moose;

    with
        'Message::Passing::Role::CLIComponent' => { name => 'input', default => 'STDIN' },
        qw/
            Message::Passing::Role::Script
            MooseX::Getopt
        /;
    
    sub build_chain {
        my $self = shift;
        message_chain {
            input example => ( %{ $self->input_options }, output_to => 'test_out', class => $self->input, );
            output test_out => ( ... );
        };
    }

    __PACKAGE__->start unless caller;
    1;

=head1 DESCRIPTION

A L<MooseX::Role::Parameterized> role, which is used to provide a pair of attributes for name/options
as per the L<message-pass> script.

=head1 ROLE PARAMETERS

=head2 name

The name of the main attribute. An additional attribute called "${name}_options" will also be added,
which coerces a hashref from JSON.

=head2 default

A default value for the main attribute. If this is not supplied, than the attribute will be required.

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored its development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Message::Passing>.

=cut
