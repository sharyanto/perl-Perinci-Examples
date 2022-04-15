package Perinci::Examples::Table;

use 5.010001;
use strict;
use utf8;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

$SPEC{aoaos} = {
    v => 1.1,
    summary => "Return an array of array-of-scalar (aoaos) data",
    args => {
    },
};
sub aoaos {
    my %args = @_;

    return [
        200, "OK",
        [[qw/ujang 25 laborer/],
         [qw/tini 33 nurse/],
         [qw/deden 27 actor/],],
        {
            'table.fields' => [qw/name age occupation/],
            'table.field_units' => [undef, 'year'],
        },
    ];
}

$SPEC{aohos} = {
    v => 1.1,
    summary => "Return an array of hash-of-scalar (aohos) data",
    args => {
    },
};
sub aohos {
    my %args = @_;

    return [
        200, "OK",
        [{name=>'ujang', age=>25, occupation=>'laborer', note=>'x'},
         {name=>'tini', age=>33, occupation=>'nurse', note=>'x'},
         {name=>'deden', age=>27, occupation=>'actor', note=>'x'},],
        {
            'table.fields' => [qw/name age occupation/],
            'table.field_units' => [undef, 'year'],
            'table.hide_unknown_fields' => 1,
        },
    ];
}

$SPEC{sales} = {
    v => 1.1,
    summary => "Return a table of sales data (sales of Celine Dion studio albums)",
    args => {
    },
};
sub sales {
    my %args = @_;

    my $table = [
        # french
        {year=>1981, lang=>"fr", title=>"La voix du bon Dieu", sales=>0.1e6},
        # Céline Dion chante Noël (1981), no sales data
        {year=>1982, lang=>"fr", title=>"Tellement j'ai d'amour...", sales=>0.15e6},
        {year=>1983, lang=>"fr", title=>"Les chemins de ma maison", sales=>0.1e6},
        # Chants et contes de Noël (1983), no sales data
        # Mélanie (1984), no sales data
        # C'est pour toi (1985), no sales data
        {year=>1987, lang=>"fr", title=>"Incognito", sales=>0.5e6},
        {year=>1991, lang=>"fr", title=>"Dion chante Plamondon", sales=>2e6},
        {year=>1995, lang=>"fr", title=>"D'eux", sales=>10e6},
        {year=>1998, lang=>"fr", title=>"S'il suffisait d'aimer", sales=>4e6},
        {year=>2003, lang=>"fr", title=>"1 fille & 4 types", sales=>0.876e6},
        {year=>2007, lang=>"fr", title=>"D'elles", sales=>0.3e6},
        {year=>2012, lang=>"fr", title=>"Sans attendre", sales=>1.5e6},
        {year=>2016, lang=>"fr", title=>"Encore un soir", sales=>1.5e6},

        # english
        {year=>1990, lang=>"en", title=>"Unison", sales=>4e6},
        {year=>1992, lang=>"en", title=>"Celine Dion", sales=>5e6},
        {year=>1993, lang=>"en", title=>"The color of my love", sales=>20e6},
        {year=>1996, lang=>"en", title=>"Falling into you", sales=>32e6},
        {year=>1997, lang=>"en", title=>"Let's talk about love", sales=>31e6},
        {year=>1998, lang=>"en", title=>"These are special times", tags=>"christmas", sales=>12e6},
        {year=>2002, lang=>"en", title=>"A new day has come", sales=>12e6},
        {year=>2003, lang=>"en", title=>"One heart", sales=>5e6},
        {year=>2004, lang=>"en", title=>"Miracle", sales=>2e6},
        {year=>2007, lang=>"en", title=>"Taking chances", sales=>3.1e6},
        {year=>2013, lang=>"en", title=>"Loved me back to life", sales=>1.5e6},
        {year=>2019, lang=>"en", title=>"Courage", sales=>0.332e6},
    ];

    [200, "OK", $table, {
        'table.fields'        => [qw/year   lang   title sales/],
        'table.field_types'   => [qw/int    str    str   float/],
        'table.field_formats' => [   '',    '',    '',   'number'],
        'table.field_aligns'  => [qw/middle middle left  right/],
    }];
}

1;
# ABSTRACT: Table examples

=head1 DESCRIPTION

The examples in this module return table data.
