package Perinci::Examples::CSV;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

our %SPEC;

$SPEC{output_table} = {
    v => 1.1,
    summary => "Output some table, try displaying it on CLI with --format=csv",
    args => {
    },
};
sub output_table {
    my %args = @_;

    my $table = [
        ["col1", "col2", "col3"],
        [1,2,3],
        [qw/foo bar baz/],
        ['"contains quotes"', 'contains \\backslash', '"contains \\both\\"'],
    ];

    [200, "OK", $table];
}

1;
# ABSTRACT: Test CSV output

=head1 DESCRIPTION
