package Perinci::Examples::Tiny::Args;

# DATE
# VERSION

our %SPEC;

# this Rinci metadata is already normalized
$SPEC{as_is} = {
    v => 1.1,
    summary => "This function returns the argument as-is",
    args => {
        'arg' => {
            schema => ['any',{},{}],
        },
    },
};
sub as_is {
    my %args = @_;
    [200, "OK", $args{arg}];
}

# this Rinci metadata is already normalized
$SPEC{has_dot_args} = {
    v => 1.1,
    summary => "This function contains arguments with dot in their names",
    args => {
        'a.number' => {
            schema => ['int' => {req=>1}, {}],
            pos => 0,
            req => 1,
        },
        'another.number' => {
            schema => ['float' => {req=>1}, {}],
            pos => 1,
            req => 1,
        },
    },
    result => {
        summary => 'Return the two numbers multiplied',
    },
};
sub has_dot_args {
    my %args = @_;
    [200, "OK", $args{'a.number'} * $args{'another.number'}];
}

# this Rinci metadata is already normalized
$SPEC{has_date_arg} = {
    v => 1.1,
    summary => "This function contains a date argument",
    args => {
        'date' => {
            schema => ['date', {req=>1}, {}],
            pos => 0,
            req => 1,
        },
    },
};
sub has_date_arg {
    my %args = @_;
    my $date = $args{date};
    [200, "OK", {
        "ref(value)" => ref($date),
        "value (stringified)" => "$date",
    }];
}

# this Rinci metadata is already normalized
$SPEC{has_duration_arg} = {
    v => 1.1,
    summary => "This function contains a duration argument",
    args => {
        'duration' => {
            schema => ['duration', {req=>1}, {}],
            pos => 0,
            req => 1,
        },
    },
};
sub has_duration_arg {
    my %args = @_;
    my $duration = $args{duration};
    [200, "OK", {
        "ref(value)" => ref($duration),
        "value (stringified)" => "$duration",
    }];
}

1;
# ABSTRACT: Tests related to function arguments

=head1 DESCRIPTION

Like the other Perinci::Examples::Tiny::*, this module does not use other
modules and is suitable for testing Perinci::CmdLine::Inline as well as other
Perinci::CmdLine frameworks.
