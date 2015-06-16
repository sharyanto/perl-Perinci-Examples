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
$SPEC{odd_even} = {
    v => 1.1,
    summary => "Print 'odd' or 'even' depending on the number",
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

1;
# ABSTRACT: Small examples

=head1 DESCRIPTION

This module only has a couple of examples and very lightweight. Used e.g. for
benchmarking startup overhead of L<Perinci::CmdLine::Inline>-generated scripts.
