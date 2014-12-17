package Perinci::Examples::Completion;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;
use experimental 'smartmatch';

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'More completion examples',
};

$SPEC{fruits} = {
    v => 1.1,
    args => {
        fruits => {
            schema => [array => of => 'str'],
            element_completion => sub {
                my %args = @_;
                # complete with unmentioned fruits
                my @allfruits = qw(apple apricot banana cherry durian);
                my $ary = $args{args}{fruits};
                my $res = [];
                for (@allfruits) {
                    push @$res, $_ unless $_ ~~ @$ary;
                }
                $res;
            },
            #req => 1,
            pos => 0,
            greedy => 1,
        },
    },
    description => <<'_',

Demonstrates completion of array elements.

_
};
sub fruits {
    [200];
}

1;
#ABSTRACT:

=for Pod::Coverage .*
