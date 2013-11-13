package Perinci::Examples::Completion;

use 5.010;
use strict;
use warnings;
use experimental 'smartmatch';

#use SHARYANTO::Complete::Util qw(complete_array);

our %SPEC;

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

# VERSION

1;
#ABSTRACT: More completion examples

=for Pod::Coverage .*
