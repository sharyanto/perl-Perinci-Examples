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

$SPEC{animals} = {
    v => 1.1,
    summary => 'Specify an animal (optional) and a color (optional), '.
        'with some examples given in argument spec or schema (for completion)',
    args => {
        animal => {
            schema => ['str*', {
                'examples' => [
                    {value=>'dog', summary=>'You cannot teach this animal new tricks when it is old'},
                    {value=>'bird', summary=>'Two of this can be killed with one stone'},
                    {value=>'elephant', summary=>'It never forgets'},
                ],
            }],
            pos => 0,
        },
        color => {
            schema => ['str*'],
            examples => [
                'black',
                'blue',
                {value=>'chartreuse', summary=>'half green, half yellow'},
                {value=>'cyan', summary=>'half green, half blue'},
                'green',
                'grey',
                {value=>'magenta', summary=>'half red, half blue'},
                'red',
                'white',
                'yellow',
            ],
            pos => 0,
        },
    },
    description => <<'_',

Demonstrates Rinci argument spec `examples` property as well as Sah schema's
`examples` clause. This property is a source of valid values for the argument
and can be used for testing, documentation, or completion.

_
};
sub animals {
    [200, "OK", {@_}];
}

1;
#ABSTRACT:

=for Pod::Coverage .*
