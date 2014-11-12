package Perinci::Examples::CmdLineSrc;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Examples for using cmdline_src function property',
};

$SPEC{cmdline_src_unknown} = {
    v => 1.1,
    summary => 'This function has arg with unknown cmdline_src value',
    args => {
        a1 => {schema=>'str*', cmdline_src=>'foo'},
    },
};
sub cmdline_src_unknown {
    my %args = @_;
    [200, "OK", "a1=$args{a1}"];
}

$SPEC{cmdline_src_invalid_arg_type} = {
    v => 1.1,
    summary => 'This function has non-str/non-array arg with cmdline_src',
    args => {
        a1 => {schema=>'int*', cmdline_src=>'stdin'},
    },
};
sub cmdline_src_invalid_arg_type {
    my %args = @_;
    [200, "OK", "a1=$args{a1}"];
}

$SPEC{cmdline_src_stdin_str} = {
    v => 1.1,
    summary => 'This function has arg with cmdline_src=stdin',
    args => {
        a1 => {schema=>'str*', cmdline_src=>'stdin'},
    },
};
sub cmdline_src_stdin_str {
    my %args = @_;
    [200, "OK", "a1=$args{a1}", {'func.args'=>\%args}];
}

$SPEC{cmdline_src_stdin_array} = {
    v => 1.1,
    summary => 'This function has arg with cmdline_src=stdin',
    args => {
        a1 => {schema=>'array*', cmdline_src=>'stdin'},
    },
};
sub cmdline_src_stdin_array {
    my %args = @_;
    [200, "OK", "a1=[".join(",",@{ $args{a1} })."]",
     {'func.args'=>\%args}];
}

$SPEC{cmdline_src_file} = {
    v => 1.1,
    summary => 'This function has args with cmdline_src _file',
    args => {
        a1 => {schema=>'str*', req=>1, cmdline_src=>'file'},
        a2 => {schema=>'array*', cmdline_src=>'file'},
    },
};
sub cmdline_src_file {
    my %args = @_;
    [200, "OK", "a1=$args{a1}\na2=[".join(",", @{ $args{a2} // [] })."]",
     {'func.args'=>\%args}];
}

$SPEC{cmdline_src_stdin_or_files_str} = {
    v => 1.1,
    summary => 'This function has str arg with cmdline_src=stdin_or_files',
    args => {
        a1 => {schema=>'str*', cmdline_src=>'stdin_or_files'},
    },
};
sub cmdline_src_stdin_or_files_str {
    my %args = @_;
    [200, "OK", "a1=$args{a1}", {'func.args'=>\%args}];
}

$SPEC{cmdline_src_stdin_or_files_array} = {
    v => 1.1,
    summary => 'This function has array arg with cmdline_src=stdin_or_files',
    args => {
        a1 => {schema=>'array*', cmdline_src=>'stdin_or_files'},
    },
};
sub cmdline_src_stdin_or_files_array {
    my %args = @_;
    [200, "OK", "a1=[".join(",",@{ $args{a1} })."]", {'func.args'=>\%args}];
}

$SPEC{cmdline_src_multi_stdin} = {
    v => 1.1,
    summary => 'This function has multiple args with cmdline_src stdin/stdin_or_files',
    args => {
        a1 => {schema=>'str*', cmdline_src=>'stdin_or_files'},
        a2 => {schema=>'str*', cmdline_src=>'stdin'},
    },
};
sub cmdline_src_multi_stdin {
    my %args = @_;
    [200, "OK", "a1=$args{a1}\na2=$args{a2}", {'func.args'=>\%args}];
}

$SPEC{cmdline_src_stdin_line} = {
    v => 1.1,
    summary => 'This function has a single stdin_line argument',
    args => {
        a1 => {schema=>'str*', req=>1, cmdline_src=>'stdin_line'},
        a2 => {schema=>'str*', req=>1},
    },
};
sub cmdline_src_stdin_line {
    my %args = @_;
    [200, "OK", "a1=$args{a1}\na2=$args{a2}"];
}

$SPEC{cmdline_src_multi_stdin_line} = {
    v => 1.1,
    summary => 'This function has several stdin_line arguments',
    description => <<'_',

And one also has its is_password property set to true.

_
    args => {
        a1 => {schema=>'str*', req=>1, cmdline_src=>'stdin_line'},
        a2 => {schema=>'str*', req=>1, cmdline_src=>'stdin_line', is_password=>1},
        a3 => {schema=>'str*', req=>1},
    },
};
sub cmdline_src_multi_stdin_line {
    my %args = @_;
    [200, "OK", "a1=$args{a1}\na2=$args{a2}\na3=$args{a3}",
     {'func.args'=>\%args}];
}

$SPEC{test_binary} = {
    v => 1.1,
    summary => "Accept binary in stdin/file",
    description => <<'_',

This function is like the one in `Perinci::Examples` but argument is accepted
via `stdin_or_files`.

_
    args => {
        data => {
            schema  => "buf*",
            pos     => 0,
            default => "\0\0\0",
            cmdline_src => "stdin_or_files",
        },
    },
    result => {
        schema => "buf*",
    },
};
sub test_binary {
    my %args = @_; # NO_VALIDATE_ARGS
    my $data = $args{data} // "\0\0\0";
    return [200, "OK", $data, {'func.args'=>\%args}];
}

1;
# ABSTRACT: Examples for using cmdline_src function property
