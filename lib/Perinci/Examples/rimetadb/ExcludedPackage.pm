package Perinci::Examples::rimetadb::ExcludedPackage;

use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Example of excluded package',
    description => <<'_',

This package (and its contents) should not be imported to database because of
this attribute:

    x.app.rimetadb.exclude => 1

_
    'x.app.rimetadb.exclude' => 1,
};

our $Var1;
$SPEC{'$Var1'} = {
    v => 1.1,
    summary => 'A sample variable',
    description => <<'_',

Even though this variable metadata does not have this attribute:

    x.app.rimetadb.exclude => 1

but because the package is excluded, all the contents including this are also
excluded.

_
};

$SPEC{'func1'} = {
    v => 1.1,
    summary => 'A sample function',
    description => <<'_',

Even though this function metadata does not have this attribute:

    x.app.rimetadb.exclude => 1

but because the package is excluded, all the contents including this are also
excluded.

_
};
sub func1 { [200] }

1;
# ABSTRACT:
