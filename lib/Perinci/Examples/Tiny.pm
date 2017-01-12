package Perinci::Examples::Tiny;

# DATE
# VERSION

our %SPEC;

# this Rinci metadata is already normalized
$SPEC{noop} = {
    v => 1.1,
    summary => "Do nothing",
};
sub noop {
    [200];
}

# this Rinci metadata is already normalized
$SPEC{hello_naked} = {
    v => 1.1,
    summary => "Hello world",
    result_naked => 1,
};
sub hello_naked {
    "Hello, world";
}

# this Rinci metadata is already normalized
$SPEC{odd_even} = {
    v => 1.1,
    summary => "Return 'odd' or 'even' depending on the number",
    args => {
        number => {
            summary => 'Number to test',
            schema => ['int' => {req=>1}, {}],
            pos => 0,
            req => 1,
        },
    },
    result => {
        schema => ['str', {}, {}],
    },
};
sub odd_even {
    my %args = @_;
    [200, "OK", $args{number} % 2 == 0 ? "even" : "odd"];
}

# this Rinci metadata is already normalized
$SPEC{foo1} = {
    v => 1.1,
    summary => "Return the string 'foo1'",
    args => {},
};
sub foo1 { [200, "OK", "foo1"] }

# this Rinci metadata is already normalized
$SPEC{foo2} = {
    v => 1.1,
    summary => "Return the string 'foo1'",
    args => {},
};
sub foo2 { [200, "OK", "foo2"] }

# this Rinci metadata is already normalized
$SPEC{foo3} = {
    v => 1.1,
    summary => "Return the string 'foo1'",
    args => {},
};
sub foo3 { [200, "OK", "foo3"] }

# this Rinci metadata is already normalized
$SPEC{foo4} = {
    v => 1.1,
    summary => "Return the string 'foo1'",
    args => {},
};
sub foo4 { [200, "OK", "foo4"] }

# this Rinci metadata is already normalized
$SPEC{sum} = {
    v => 1.1,
    summary => "Sum numbers in array",
    description => <<'_',

This function can be used to test passing nonscalar (array) arguments.

_
    args => {
        array => {
            summary => 'Array',
            schema  => ['array', {req=>1, of => ['float', {req=>1}, {}]}, {}],
            req     => 1,
            pos     => 0,
            greedy  => 1,
        },
        round => {
            summary => 'Whether to round result to integer',
            schema  => [bool => {default => 0}, {}],
        },
    },
};
sub sum {
    my %args = @_;

    my $sum = 0;
    for (@{$args{array}}) {
        $sum += $_ if defined && /\A(?:\d+(?:\.\d*)?|\.\d+)\z/;
    }
    $sum = int($sum) if $args{round};
    [200, "OK", $sum];
}

1;
# ABSTRACT: Small examples

=head1 DESCRIPTION

This module only has a couple of examples and very lightweight. Used e.g. for
benchmarking startup overhead of L<Perinci::CmdLine::Inline>-generated scripts.
