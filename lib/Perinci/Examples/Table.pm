package Perinci::Examples::Table;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

our %SPEC;

$SPEC{aoaos} = {
    v => 1.1,
    summary => "Return an array of array-of-scalar (aoaos) data",
    args => {
    },
};
sub aoaos {
    my %args = @_;

    return [
        200, "OK",
        [[qw/ujang 25 laborer/],
         [qw/tini 33 nurse/],
         [qw/deden 27 actor/],],
        {
            'table.fields' => [qw/name age occupation/],
            'table.field_units' => [undef, 'year'],
        },
    ];
}

$SPEC{aohos} = {
    v => 1.1,
    summary => "Return an array of hash-of-scalar (aohos) data",
    args => {
    },
};
sub aohos {
    my %args = @_;

    return [
        200, "OK",
        [{name=>'ujang', age=>25, occupation=>'laborer', note=>'x'},
         {name=>'tini', age=>33, occupation=>'nurse', note=>'x'},
         {name=>'deden', age=>27, occupation=>'actor', note=>'x'},],
        {
            'table.fields' => [qw/name age occupation/],
            'table.field_units' => [undef, 'year'],
            'table.hide_unknown_fields' => 1,
        },
    ];
}
1;
# ABSTRACT: Table examples

=head1 DESCRIPTION

The examples in this module return table data.
