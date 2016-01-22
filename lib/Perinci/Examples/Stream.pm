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

$SPEC{produce_ints} = {
    v => 1.1,
    summary => 'This function produces a stream of integers, starting from 1',
    tags => ['category:streaming-result'],
    args => {
        num => {
            summary => 'Limit number of numbers to produce',
            description => <<'_',

The default is to produce an infinite number.

_
            schema => 'int*',
            cmdline_aliases => {n=>{}},
            pos => 0,
        },
    },
    result => {
        stream => 1,
        schema => 'int*',
    },
};
sub produce_ints {
    my %args = @_;
    my $i = 1;
    my $num = $args{num};
    [200, "OK", sub {
         return undef if defined($num) && $i > $num;
         $i++;
     }];
}

$SPEC{count_ints} = {
    v => 1.1,
    summary => 'This function accepts a stream of integers and return the number of integers input',
    tags => ['category:streaming-input'],
    args => {
        input => {
            summary => 'Number',
            schema => 'int*',
            stream => 1,
            cmdline_src => 'stdin_or_files',
        },
    },
};
sub count_ints {
    my %args = @_;
    my $input = $args{input};
    my $n = 0;
    $n++ while defined $input->();
    [200, "OK", "You input $n int(s)"];
}

$SPEC{count_lines} = {
    v => 1.1,
    summary => 'Count number of lines in the input',
    tags => ['category:streaming-input'],
    args => {
        input => {
            summary => 'Input',
            schema => 'str*',
            stream => 1,
            cmdline_src => 'stdin_or_files',
        },
    },
};
sub count_lines {
    my %args = @_;
    my $input = $args{input};
    my $n = 0;
    $n++ while defined $input->();
    [200, "OK", "Input is $n line(s)"];
}

$SPEC{produce_words} = {
    v => 1.1,
    summary => 'This function produces a stream of random words',
    tags => ['category:streaming-result'],
    args => {
        num => {
            summary => 'Limit number of words to produce',
            schema => 'int*',
            cmdline_aliases => {n=>{}},
            pos => 0,
        },
    },
    result => {
        stream => 1,
        schema => ['str*', match=>'\A\w+\z'],
    },
};
sub produce_words {
    my %args = @_;
    my $i = 1;
    my $num = $args{num};
    [200, "OK", sub {
         return undef if defined($num) && $i > $num;
         $i++;
         join('', map { ['a'..'z']->[26*rand()] } 1..(int(6*rand)+5));
     }];
}

$SPEC{produce_words_err} = {
    v => 1.1,
    summary => 'Like `produce_words()`, but 1 in every 10 words will be a non-word (which fails the result schema)',
    tags => ['categoryr:streaming-result'],
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
sub produce_words_err {
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

$SPEC{count_words} = {
    v => 1.1,
    summary => 'This function receives a stream of words and return the number of words',
    tags => ['category:streaming-input'],
    description => <<'_',

Input validation will check that each record from the stream is a word.

_
    args => {
        words => {
            schema => ['str*', match=>'\A\w+\z'],
            stream => 1,
            cmdline_src => 'stdin_or_files',
        },
    },
};
sub count_words {
    my %args = @_;

    my $words = $args{words};
    my $num = 0;
    while (defined($words->())) {
        $num++;
    }
    [200, "OK", $num];
}

$SPEC{produce_hashes} = {
    v => 1.1,
    summary => 'This function produces a stream of hashes',
    args => {
        num => {
            schema => 'int*',
            cmdline_aliases => {n=>{}},
            pos => 0,
        },
    },
    result => {
        stream => 1,
        schema => 'hash*',
    },
};
sub produce_hashes {
    my %args = @_;
    my $num = $args{num};

    my $i = 1;
    [200, "OK", sub {
         return undef if defined($num) && $i > $num;
         {num=>$i++};
     }];
}

$SPEC{square_nums} = {
    v => 1.1,
    summary => 'This function squares its stream input',
    tags => ['category:streaming-input', 'category:streaming-result'],
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
sub square_nums {
    my %args = @_;
    my $input = $args{input};

    [200, "OK", sub {
         my $n = $input->();
         return undef unless defined $n;
         $n*$n;
     }];
}

$SPEC{square_nums_from_file} = {
    v => 1.1,
    summary => 'This function squares its stream input',
    tags => ['category:streaming-input', 'category:streaming-result'],
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
sub square_nums_from_file {
    goto &square_input;
}

$SPEC{square_nums_from_stdin} = {
    v => 1.1,
    summary => 'This function squares its stream input',
    tags => ['category:streaming-input', 'category:streaming-result'],
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
sub square_nums_from_stdin {
    goto &square_input;
}

$SPEC{square_nums_from_stdin_or_file} = {
    v => 1.1,
    summary => 'This function squares its stream input',
    tags => ['category:streaming-input', 'category:streaming-result'],
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
sub square_nums_from_stdin_or_file {
    goto &square_input;
}

$SPEC{wc} = {
    v => 1.1,
    summary => 'Count the number of lines/words/characters of input, like the "wc" command',
    tags => ['category:streaming-input'],
    args => {
        input => {
            req => 1,
            stream => 1,
            schema => 'str*',
            cmdline_src => 'stdin_or_files',
            'cmdline.chomp' => 0,
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
    tags => ['category:streaming-input'],
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
