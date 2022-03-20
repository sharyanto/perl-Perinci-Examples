## no critic: RequireUseStrict
package Perinci::Examples::Tiny;

# AUTHORITY
# DATE
# DIST
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
            slurpy  => 1,
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

$SPEC{noop2} = {
    v => 1.1,
    summary => "Just like noop, but accepts several arguments",
    description => <<'_',

Will return arguments passed to it.

This function is also marked as `pure`, meaning it will not cause any side
effects. Pure functions are safe to call directly in a transaction (without
going through the transaction manager) or during dry-run mode.

_
    args => {
        a => {
            summary => 'Argument',
            schema => ['any', {}, {}],
            pos => 0,
        },
        b => {
            summary => 'Argument',
            schema => ['any', {}, {}],
            pos => 1,
        },
        c => {
            summary => 'Argument',
            schema => ['any', {}, {}],
            pos => 2,
        },
        d => {
            summary => 'Argument',
            schema => ['any', {}, {}],
            pos => 3,
        },
        e => {
            summary => 'Argument',
            schema => ['any', {}, {}],
            pos => 4,
        },
    },
    features => {pure => 1},
};

sub noop2 {
    my %args = @_;
    [200, "OK", "a=$args{a}\nb=$args{b}\nc=$args{c}\nd=$args{d}\ne=$args{e}"];
}

1;
# ABSTRACT: Small examples

=head1 DESCRIPTION

This module only has a couple of examples and very lightweight. Used e.g. for
benchmarking startup overhead of L<Perinci::CmdLine::Inline>-generated scripts.
