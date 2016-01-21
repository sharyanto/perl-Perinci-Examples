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
            summary => 'Limit number of numbers to produce',
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

$SPEC{word} = {
    v => 1.1,
    summary => 'This function produces a stream of random words',
    args => {
        num => {
            summary => 'Limit number of words to produce',
            schema => 'int*',
            cmdline_aliases => {n=>{}},
        },
    },
    result => {
        stream => 1,
        schema => ['str*', match=>'\A\w+\z'],
    },
};
sub word {
    my %args = @_;
    my $i = 1;
    my $num = $args{num};
    [200, "OK", sub {
         return undef if defined($num) && $i > $num;
         $i++;
         join('', map { ['a'..'z']->[26*rand()] } 1..(int(6*rand)+5));
     }];
}

$SPEC{word_err} = {
    v => 1.1,
    summary => 'Like word(), but 1 in every 10 words will be a non-word (which fails result schema)',
    args => {
        num => {
            summary => 'Limit number of words to produce',
            schema => 'int*',
            cmdline_aliases => {n=>{}},
        },
    },
    result => {
        stream => 1,
        schema => ['str*', match=>'\A\w+\z'],
    },
};
sub word_err {
    my %args = @_;
    my $i = 1;
    my $num = $args{num};
    [200, "OK", sub {
         return undef if defined($num) && $i > $num;
         if ($i++ % 10 == 0) {
             "contain space";
         } else {
             join('', map { ['a'..'z']->[26*rand()] } 1..(int(6*rand)+5));
         }
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

$SPEC{square_input_from_file} = {
    v => 1.1,
    summary => 'This function squares its stream input',
    args => {
        input => {
            req => 1,
            pos => 0,
            stream => 1,
            schema => 'float*',
            cmdline_src => 'file',
        },
    },
    result => {
        stream => 1,
        schema => 'float*',
    },
};
sub square_input_from_file {
    goto &square_input;
}

$SPEC{square_input_from_stdin} = {
    v => 1.1,
    summary => 'This function squares its stream input',
    args => {
        input => {
            req => 1,
            pos => 0,
            stream => 1,
            schema => 'float*',
            cmdline_src => 'stdin',
        },
    },
    result => {
        stream => 1,
        schema => 'float*',
    },
};
sub square_input_from_stdin {
    goto &square_input;
}

$SPEC{square_input_from_stdin_or_file} = {
    v => 1.1,
    summary => 'This function squares its stream input',
    args => {
        input => {
            req => 1,
            pos => 0,
            stream => 1,
            schema => 'float*',
            cmdline_src => 'stdin_or_file',
        },
    },
    result => {
        stream => 1,
        schema => 'float*',
    },
};
sub square_input_from_stdin_or_file {
    goto &square_input;
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
        schema => 'hash*',
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
        schema => 'hash*',
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
