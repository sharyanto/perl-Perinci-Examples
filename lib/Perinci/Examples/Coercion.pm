package Perinci::Examples::Coercion;

use 5.010;
use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

$SPEC{coerce_to_epoch} = {
    v => 1.1,
    summary => "Accept a date (e.g. '2015-11-20', etc), return its Unix epoch",
    args => {
        date => {
            schema => ['date*', {
                'x.perl.coerce_to' => 'float(epoch)',
            }],
            req => 1,
            pos => 0,
        },
    },
};
sub coerce_to_epoch {
    my %args = @_;
    [200, "OK", $args{date}];
}

$SPEC{coerce_to_secs} = {
    v => 1.1,
    summary => "Accept a duration (e.g. '2hour', 'P2D'), return number of seconds",
    args => {
        duration => {
            schema => ['duration*', {
                'x.perl.coerce_to' => 'float(secs)',
            }],
            req => 1,
            pos => 0,
        },
    },
};
sub coerce_to_secs {
    my %args = @_;
    [200, "OK", $args{duration}];
}

1;
# ABSTRACT: Coercion examples

=head1 DESCRIPTION
