package Perinci::Examples::SubMeta;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Test argument submetadata',
    description => <<'_',

Argument submetadata is introduced in Rinci 1.1.55, mainly to support (complex)
form. With this, you can submit a complex form (one that has subforms) to a
function. The function will receive the form submission as a nested data
structure.

To add an argument submetadata, you specify a hash argument with a `meta`
property, or an array argument with `element_meta` property. The value of the
property is another Rinci function metadata.

_
};

$SPEC{register_student} = {
    v => 1.1,
    summary => 'Register a student to a class',
    description => <<'_',

This example function registers a student to a class. You specify the student's
name, gender, and age, as well as the desired class to register to. You can only
register one student at a time.

Actually, this function just returns its arguments.

_
    args => {
        class => {
            summary => 'Desired class',
            schema => ['str*', in=>[
                'Cooking 101', 'Auto A', 'Auto B', 'Sewing', 'Singing',
                'Advanced Singing']],
        },
        student => {
            schema => 'hash*',
            meta => {
                v => 1.1,
                args => {
                    name => {
                        schema=>'str*',
                        req=>1,
                        pos=>0,
                    },
                    gender => {
                        schema=>['str*', in=>[qw/M F/]],
                        req=>1,
                    },
                    age => {
                        schema=>['int*', min=>4, max=>200],
                    },
                },
            },
            tags => ['student'],
        },
        note => {
            schema=>'str*',
            req=>1,
        },
    },
};
sub register_student {
    my %args = @_; # NO_VALIDATE_ARGS
    [200, "OK", \%args];
}

$SPEC{register_donors} = {
    v => 1.1,
    summary => 'Register donor(s)',
    description => <<'_',

This example function registers one or more blood donors. For each donor, you
need to specify at least the name, gender, age, and blood type.

In the command-line, you can specify them as follow:

    % register-donors --date 2014-10-11 \
        --donor-name Ujang --donor-age 31 --donor-male --donor-t A \
        --donor-name Ita   --donor-age 25 --donor-F    --donor-t O \
          --donor-note Tentative \
        --donor-name Eep   --donor-age 37 --donor-male --donor-t B

Actually, this function just returns its arguments. This function demonstrates
argument element submetadata.

_
    args => {
        date => {
            summary => 'Planned donation date',
            schema => ['date*'],
            req => 1,
        },
        donor => {
            schema => ['array*', min_len=>1],
            req => 1,
            element_meta => {
                v => 1.1,
                args => {
                    name => {
                        schema=>'str*',
                        req=>1,
                        pos=>0,
                    },
                    gender => {
                        schema=>['str*', in=>[qw/M F/]],
                        req=>1,
                        pos=>1,
                        cmdline_aliases=>{
                            M      => {is_flag=>1, code=>sub { $_[0]{gender} = 'M'}},
                            male   => {is_flag=>1, code=>sub { $_[0]{gender} = 'M'}},
                            F      => {is_flag=>1, code=>sub { $_[0]{gender} = 'F'}},
                            female => {is_flag=>1, code=>sub { $_[0]{gender} = 'F'}},
                        },
                    },
                    age => {
                        schema=>['int*', min=>17, max=>65],
                        req=>1,
                        pos=>2,
                        cmdline_aliases=>{a=>{}},
                    },
                    blood_type => {
                        schema=>['str*', in=>[qw/A B O AB/]],
                        req=>1,
                        pos=>3,
                        cmdline_aliases=>{t=>{}},
                    },
                    note => {
                        schema=>'str*',
                        req=>1,
                    },
                },
            },
            tags => ['Donor data'],
        },
    },
};
sub register_donors {
    my %args = @_; # NO_VALIDATE_ARGS
    [200, "OK", \%args];
}

1;
# ABSTRACT:
