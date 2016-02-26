package Perinci::Examples::ArgsAs;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Demonstrate various values of `args_as` '.
        'function metadata property',
    description => <<'_',

The functions in this package can test:

- argument passing;
- whether module POD is rendered correctly;
- whether examples (in module POD or CLI help) are rendered correctly;

_
};

my $args = {
    arg1 => {schema=>'str*', req=>1, pos=>0},
    arg2 => {schema=>'int*', req=>1, pos=>1},
    arg3 => {schema=>['float*', between=>[0,1]], pos=>2},
};

my $examples = [
    {
        summary => 'Without the optional arg3',
        args    => {arg1=>"abc", arg2=>10},
    },
    {
        summary => 'With the optional arg3',
        args    => {arg1=>"def", arg2=>20, arg3=>0.5},
    },
];

$SPEC{args_as_hash} = {
    v => 1.1,
    summary => 'This is the default',
    args => $args,
    args_as => 'hash',
    examples => $examples,
};
sub args_as_hash {
    [200,"OK",\@_];
}

$SPEC{args_as_hashref} = {
    v => 1.1,
    summary => 'Alternative to `hash` to avoid copying',
    args => $args,
    args_as => 'hashref',
    examples => $examples,
};
sub args_as_hashref {
    [200,"OK",\@_];
}

$SPEC{args_as_array} = {
    v => 1.1,
    summary => 'Regular perl subs use this',
    args => $args,
    args_as => 'array',
    examples => $examples,
};
sub args_as_array {
    [200,"OK",\@_];
}

$SPEC{args_as_arrayref} = {
    v => 1.1,
    summary => 'Alternative to `array` to avoid copying',
    args => $args,
    args_as => 'arrayref',
    examples => $examples,
};
sub args_as_arrayref {
    [200,"OK",\@_];
}

1;
# ABSTRACT:
