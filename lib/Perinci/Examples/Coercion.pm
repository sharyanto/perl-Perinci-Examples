package Perinci::Examples::Coercion;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

our %SPEC;

$SPEC{coerce_to_epoch} = {
    v => 1.1,
    summary => "Accept a date (e.g. '2015-11-20', etc), return its Unix epoch",
    args => {
        date => {
            schema => 'date*',
            req => 1,
            pos => 0,
            'x.perl.coerce_to' => 'int(epoch)',
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
            schema => 'duration*',
            req => 1,
            pos => 0,
            'x.perl.coerce_to' => 'int(secs)',
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
