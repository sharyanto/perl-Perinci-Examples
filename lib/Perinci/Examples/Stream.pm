package Perinci::Examples::Stream;

use 5.010;
use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Examples for streaming input/output',
    description => <<'_',

This package contains functions that demonstrate streaming input/output.

_
};

my %arg_num = (
    num => {
        summary => 'Limit number of entries to produce',
        description => <<'_',

The default is to produce an infinite number.

_
        schema => ['int*', min=>0],
        cmdline_aliases => {n=>{}},
        pos => 0,
    },
);

$SPEC{produce_ints} = {
    v => 1.1,
    summary => 'This function produces a stream of integers, starting from 1',
    tags => ['category:streaming-result'],
    args => {
        %arg_num,
    },
    result => {
        stream => 1,
        schema => ['array*', of=>'int*'],
    },
};
sub produce_ints {
    my %args = @_;
    my $i = 1;
    my $num = $args{num};
    [200, "OK", sub {
         return undef if defined($num) && $i > $num; ## no critic: Subroutines::ProhibitExplicitReturnUndef
         $i++;
     }];
}

$SPEC{count_ints} = {
    v => 1.1,
    summary => 'This function accepts a stream of integers and return the number of integers input',
    tags => ['category:streaming-input'],
    args => {
        input => {
            summary => 'Numbers',
            schema => ['array*', of=>'int*'],
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
    [200, "OK", $n];
}

$SPEC{count_lines} = {
    v => 1.1,
    summary => 'Count number of lines in the input',
    tags => ['category:streaming-input'],
    args => {
        input => {
            summary => 'Lines',
            schema => ['array*', of=>'str*'],
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
        %arg_num,
    },
    result => {
        stream => 1,
        schema => ['array*', of=>['str*', match=>'\A\w+\z']],
    },
};
sub produce_words {
    my %args = @_;
    my $i = 1;
    my $num = $args{num};
    [200, "OK", sub {
         return undef if defined($num) && $i > $num; ## no critic: Subroutines::ProhibitExplicitReturnUndef
         $i++;
         join('', map { ['a'..'z']->[26*rand()] } 1..(int(6*rand)+5));
     }];
}

$SPEC{produce_words_err} = {
    v => 1.1,
    summary => 'Like `produce_words()`, but 1 in every 10 words will be a non-word (which fails the result schema)',
    tags => ['categoryr:streaming-result'],
    args => {
        %arg_num,
    },
    result => {
        stream => 1,
        schema => ['array*', of => ['str*', match=>'\A\w+\z']],
    },
};
sub produce_words_err {
    my %args = @_;
    my $i = 1;
    my $num = $args{num};
    [200, "OK", sub {
         return undef if defined($num) && $i > $num; ## no critic: Subroutines::ProhibitExplicitReturnUndef
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
        input => {
            schema => ['array*', of=>['str*', match=>'\A\w+\z']],
            stream => 1,
            cmdline_src => 'stdin_or_files',
        },
    },
};
sub count_words {
    my %args = @_;

    my $input = $args{input};
    my $num = 0;
    while (defined($input->())) {
        $num++;
    }
    [200, "OK", $num];
}

$SPEC{produce_hashes} = {
    v => 1.1,
    summary => 'This function produces a stream of hashes',
    args => {
        %arg_num,
    },
    result => {
        stream => 1,
        schema => ['array*', of=>'hash*'],
    },
};
sub produce_hashes {
    my %args = @_;
    my $num = $args{num};

    my $i = 1;
    [200, "OK", sub {
         return undef if defined($num) && $i > $num; ## no critic: Subroutines::ProhibitExplicitReturnUndef
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
            schema => ['array*', of=>'float*'],
            cmdline_src => 'stdin_or_files',
        },
    },
    result => {
        stream => 1,
        schema => ['array*', of=>'float*'],
    },
};
sub square_nums {
    my %args = @_;
    my $input = $args{input};

    [200, "OK", sub {
         my $n = $input->();
         return undef unless defined $n; ## no critic: Subroutines::ProhibitExplicitReturnUndef
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
            schema => ['array*', of=>'float*'],
            cmdline_src => 'file',
        },
    },
    result => {
        stream => 1,
        schema => ['array*', of=>'float*'],
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
            schema => ['array*', of=>'float*'],
            cmdline_src => 'stdin',
        },
    },
    result => {
        stream => 1,
        schema => ['array*', of=>'float*'],
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
        schema => ['array*', of=>'float*'],
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
            schema => ['array*', of=>'str*'],
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
            schema => ['array*', of=>'hash*'],
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
