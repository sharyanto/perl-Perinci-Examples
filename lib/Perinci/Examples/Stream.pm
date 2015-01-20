package Perinci::Examples::Stream;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Examples for streaming input/output',
    description => <<'_',

This package contains functions that demonstrate streaming input/output.

_
};

$SPEC{nat} = {
    v => 1.1,
    summary => 'This function produces a stream of natural numbers',
    args => {
        num => {
            schema => 'int*',
            cmdline_aliases => {n=>{}},
        },
    },
    result => {
        stream => 1,
        schema => 'int*',
    },
};
sub nat {
    my %args = @_;
    my $i = 1;
    my $num = $args{num};
    [200, "OK", sub {
         return undef if defined($num) && $i > $num;
         $i++;
     }];
}

$SPEC{hash_stream} = {
    v => 1.1,
    summary => 'This function produces a stream of hashes',
    args => {
        num => {
            schema => 'int*',
            cmdline_aliases => {n=>{}},
        },
    },
    result => {
        stream => 1,
        schema => 'hash*',
    },
};
sub hash_stream {
    my %args = @_;
    my $num = $args{num};

    my $i = 1;
    [200, "OK", sub {
         return undef if defined($num) && $i > $num;
         {num=>$i++};
     }];
}

$SPEC{square_input} = {
    v => 1.1,
    summary => 'This function squares its stream input',
    args => {
        input => {
            req => 1,
            stream => 1,
            schema => 'float*',
            cmdline_src => 'stdin_or_files',
        },
    },
    result => {
        stream => 1,
        schema => 'float*',
    },
};
sub square_input {
    my %args = @_;
    my $input = $args{input};

    [200, "OK", sub {
         my $n = $input->();
         return undef unless defined $n;
         $n*$n;
     }];
}

$SPEC{wc} = {
    v => 1.1,
    summary => 'Count the number of lines/words/characters of input, like the "wc" command',
    args => {
        input => {
            req => 1,
            stream => 1,
            schema => 'str*',
            cmdline_src => 'stdin_or_files',
        },
    },
    result => {
        schema => 'str*',
    },
};
sub wc {
    my %args = @_;
    my $input = $args{input};

    my ($lines, $words, $chars) = (0,0,0);
    while (defined( my $line = $input->())) {
        $lines++;
        $words++ for $line =~ /(\S+)/g;
        $chars += length($line);
    }
    [200, "OK", {lines=>$lines, words=>$words, chars=>$chars}];
}

$SPEC{wc_keys} = {
    v => 1.1,
    summary => 'Count the number of keys of each hash',
    description => <<'_',

This is a simple demonstration of accepting a stream of hashes. In command-line
application this will translate to JSON stream.

_
    args => {
        input => {
            req => 1,
            stream => 1,
            schema => 'hash*',
            cmdline_src => 'stdin_or_files',
        },
    },
    result => {
        schema => 'str*',
    },
};
sub wc_keys {
    my %args = @_;
    my $input = $args{input};

    my ($keys) = (0);
    while (defined(my $hash = $input->())) {
        $keys += keys %$hash;
    }
    [200, "OK", {keys=>$keys}];
}

1;
# ABSTRACT:
