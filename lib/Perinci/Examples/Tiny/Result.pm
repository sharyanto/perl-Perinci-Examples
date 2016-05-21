package Perinci::Examples::Tiny::Result;

# DATE
# VERSION

our %SPEC;

# this Rinci metadata is already normalized
$SPEC{returns_circular} = {
    v => 1.1,
    summary => "This function returns circular structure",
    description => <<'_',

This is an example of result that needs cleaning if to be displayed as JSON.

_
    args => {
    },
};
sub returns_circular {
    my $circ = [1, 2, 3];
    push @$circ, $circ;
    [200, "OK", $circ];
}

# this Rinci metadata is already normalized
$SPEC{returns_scalar_ref} = {
    v => 1.1,
    summary => "This function returns a scalar reference",
    description => <<'_',

This is an example of result that needs cleaning if to be displayed as JSON.

_
    args => {
    },
};
sub returns_scalar_ref {
    [200, "OK", \10];
}

1;
# ABSTRACT: Tests related to function result

=head1 DESCRIPTION

Like the other Perinci::Examples::Tiny::*, this module does not use other
modules and is suitable for testing Perinci::CmdLine::Inline as well as other
Perinci::CmdLine frameworks.
