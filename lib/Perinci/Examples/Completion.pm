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
            'x.name.is_plural' => 1,
            schema => [array => of => 'str'],
            element_completion => sub {
                my %args = @_;
                my $word = $args{word} // '';

                # complete with unmentioned fruits
                my %allfruits = (
                    apple => "One a day of this and you keep the doctor away",
                    apricot => "Another fruit that starts with the letter A",
                    banana => "A tropical fruit",
                    "butternut squash" => "Popular among babies' parents", # contain space, description contains quote
                    cherry => "Often found on cakes or drinks",
                    durian => "Lots of people hate this, but it's popular in Asia",
                );
                my $ary = $args{args}{fruits};
                my $res = [];
                for (keys %allfruits) {
                    next unless /\A\Q$word\E/i;
                    push @$res, {word=>$_, summary=>$allfruits{$_}}
                        unless $_ ~~ @$ary;
                }
                $res;
            },
            #req => 1,
            pos => 0,
            slurpy => 1,
        },
        category => {
            summary => 'This argument contains valid values and '.
                'their summaries in the schema',
            schema => ['str*' => {
                in => [qw/citrus tropical melon stone/],
                'x.in.summaries' => [
                    "Oranges, grapefruits, pomelos",
                    "Bananas, mangoes",
                    "Watermelons, honeydews",
                    "Apricots, nectarines, peaches",
                ],
            }],
        },
    },
    description => <<'_',

Demonstrates completion of array elements, with description for each word.

_
};
sub fruits {
    [200, "OK", {@_}];
}

$SPEC{animal_choice} = {
    v => 1.1,
    summary => 'Specify an animal (optional), some examples given in schema (for completion)',
    args => {
        animal => {
            schema => ['str*', {
                'x.examples' => [
                    'dog',
                    'bird',
                    'elephant',
                ],
                'x.examples.summaries' => [
                    'You cannot teach this animal new tricks when it is old',
                    'Two of this can be killed with one stone',
                    'It never forgets',
                ],
            }],
            pos => 0,
        },
    },
    description => <<'_',

Demonstrates `x.examples` and `x.examples.summaries` Sah schema attributes.
Unlike the `in` clause, the value of an argument is not restricted to only
values specified in the `x.examples`. `x.examples` serves to give examples of
valid values, hint for completion, etc.

_
};
sub animal_choice {
    [200, "OK", {@_}];
}

1;
#ABSTRACT:

=for Pod::Coverage .*
