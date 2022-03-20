package Perinci::Examples::rimetadb::IncludedPackage;

use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Example of included package',
    description => <<'_',

This package should be imported to database because of there is no attribute:

    x.app.rimetadb.exclude => 1

_
};

our $Var1;
$SPEC{'$Var1'} = {
    v => 1.1,
    summary => 'A sample variable',
    description => <<'_',

This variable is included because the metadata does not have this attribute:

    x.app.rimetadb.exclude => 1

_
};

our $Var2;
$SPEC{'$Var2'} = {
    v => 1.1,
    summary => 'A sample variable',
    description => <<'_',

This variable is excluded because the metadata has this attribute:

    x.app.rimetadb.exclude => 1

_
    'x.app.rimetadb.exclude' => 1,
};

$SPEC{'func1'} = {
    v => 1.1,
    summary => 'A sample function',
    description => <<'_',

This function is included because the metadata does not have this attribute:

    x.app.rimetadb.exclude => 1

_
};
sub func1 { [200] }

$SPEC{'func2'} = {
    v => 1.1,
    summary => 'A sample function',
    description => <<'_',

This function is excluded because the metadata has this attribute:

    x.app.rimetadb.exclude => 1

_
    'x.app.rimetadb.exclude' => 1,
};
sub func2 { [200] }

$SPEC{'func3'} = {
    v => 1.1,
    summary => 'A sample function',
    description => <<'_',

This function is included because the metadata does not have this attribute:

    x.app.rimetadb.exclude => 1

but some of its arguments are excluded because the argument specification has
the abovementioned attribute.

_
    args => {
        arg1 => {
            schema => 'int',
            summary => 'This argument is included',
            req => 1,
            pos => 0,
        },
        arg2 => {
            schema => 'int',
            summary => 'This argument is EXCLUDED and will not show up in the database',
            'x.app.rimetadb.exclude' => 1,
            pos => 1,
        },
        arg3 => {
            schema => 'int',
            summary => 'This argument is included',
            'x.app.rimetadb.exclude' => 0,
        },
    },
};
sub func3 { [200] }

1;
# ABSTRACT:
