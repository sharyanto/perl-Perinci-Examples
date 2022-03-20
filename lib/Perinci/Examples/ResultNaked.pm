package Perinci::Examples::ResultNaked;

use 5.010001;
use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Demonstrate `result_naked` property',
    description => <<'_',

The functions in this package can test:

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

$SPEC{result_not_naked} = {
    v => 1.1,
    summary => 'This is the default',
    args => $args,
    examples => $examples,
    result_naked => 0,
};
sub result_not_naked {
    [200,"OK",\@_];
}

$SPEC{result_naked} = {
    v => 1.1,
    summary => 'This function does not return enveloped result',
    args => $args,
    examples => $examples,
    result_naked => 1,
};
sub result_naked {
    \@_;
}

1;
# ABSTRACT:
