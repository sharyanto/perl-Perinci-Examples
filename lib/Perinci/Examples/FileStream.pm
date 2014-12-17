package Perinci::Examples::FileStream;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

use Fcntl qw(:DEFAULT);

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Examples for reading/writing files (using streaming result)',
    description => <<'_',

The functions in this package demos streaming input and output.

The functions are separated into this module because these functions read/write
files on the filesystem and might potentially be dangerous if
`Perinci::Examples` is exposed to the network by accident.

See also `Perinci::Examples::FilePartial` which uses partial technique instead
of streaming.

_
};

$SPEC{read_file} = {
    v => 1.1,
    args => {
        path => {schema=>'str*', req=>1, pos=>0},
    },
    result => {schema=>'buf*', stream=>1},
};
sub read_file {
    my %args = @_; # VALIDATE_ARGS

    my $path = $args{path};
    (-f $path) or return [404, "No such file '$path'"];

    open my($fh), "<", $path or return [500, "Can't open '$path': $!"];

    [200, "OK", $fh, {stream=>1}];
}

$SPEC{write_file} = {
    v => 1.1,
    description => <<'_',

Overwrites existing file.

_
    args => {
        path => {schema=>'str*', req=>1, pos=>0},
        content => {schema=>'buf*', req=>1, pos=>1, stream=>1,
                    cmdline_src=>'stdin_or_files'},
    },
};
sub write_file {
    my %args = @_; # VALIDATE_ARGS

    my $path = $args{path};

    open my($fh), ">", $path
        or return [500, "Can't open '$path' for writing: $!"];
    my $content = $args{content};
    my $written = 0;
    if (ref($content)) {
        my $fh = $content;
        local $/ = \(64*1024);
        while (<$fh>) { print $fh $_; $written += length($_) }
    } else {
        print $fh $content;
        $written += length($content);
    }

    [200, "Wrote $written byte(s)"];
}

$SPEC{append_file} = {
    v => 1.1,
    description => <<'_',

_
    args => {
        path => {schema=>'str*', req=>1, pos=>0},
        content => {schema=>'buf*', req=>1, pos=>1, stream=>1,
                    cmdline_src=>'stdin_or_files'},
    },
};
sub append_file {
    my %args = @_; # VALIDATE_ARGS

    my $path = $args{path};

    open my($fh), ">>", $path
        or return [500, "Can't open '$path' for writing: $!"];
    my $content = $args{content};
    my $written = 0;
    if (ref($content)) {
        my $fh = $content;
        local $/ = \(64*1024);
        while (<$fh>) { print $fh $_; $written += length($_) }
    } else {
        print $fh $content;
        $written += length($content);
    }

    [200, "Appended $written byte(s)"];
}

1;
# ABSTRACT:
