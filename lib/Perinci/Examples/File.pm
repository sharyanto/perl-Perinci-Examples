package Perinci::Examples::File;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

use Fcntl qw(:DEFAULT);

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Examples for reading/writing files',
    description => <<'_',

These functions support partial argument (`partial_arg` feature) and partial
result (`partial_res` feature). It also demos handling binary data

The functions are separated into this module because these functions read/write
files on the filesystem and might potentially be dangerous if
`Perinci::Examples` is exposed to the network by accident.

_
};

$SPEC{read_file} = {
    v => 1.1,
    args => {
        path => {schema=>'str*', req=>1, pos=>0},
    },
    features => {partial_res=>1},
    result => {schema=>'buf*'},
};
sub read_file {
    my %args = @_; # VALIDATE_ARGS

    my $path = $args{path};
    (-f $path) or return [404, "No such file '$path'"];
    my $size = (-s _);
    my $start = $args{-res_part_start} // 0;
    $start = 0     if $start < 0;
    $start = $size if $start > $size;
    my $len   = $args{-res_part_len} // $size;
    $len = $size-$start if $start+$len > $size;
    $len = 0            if $len < 0;

    my $is_partial = $start > 0 || $start+$len < $size;

    open my($fh), "<", $path or return [500, "Can't open '$path': $!"];
    seek $fh, $start, 0;
    my $data;
    read $fh, $data, $len;

    [$is_partial ? 206 : 200,
     $is_partial ? "Partial content" : "OK (whole content)",
     $data,
     {res_part_start=>$start, res_part_len=>$len}];
}

$SPEC{write_file} = {
    v => 1.1,
    args => {
        path => {schema=>'str*', req=>1, pos=>0},
        content => {schema=>'buf*', req=>1, pos=>1, partial=>1,
                    cmdline_src=>'stdin_or_files'},
    },
    features => {partial_arg=>1},
};
sub write_file {
    my %args = @_; # VALIDATE_ARGS

    my $path = $args{path};
    my $start = $args{"-arg_part_start/content"} // 0;

    sysopen my($fh), $path, O_WRONLY | O_CREAT
        or return [500, "Can't open '$path' for writing: $!"];
    sysseek $fh, $start, 0
        or return [500, "Can't seek to $start: $!"];
    my $written = syswrite $fh, $args{content};
    defined($written) or return [500, "Can't write content to '$path': $!"];

    [200, "Wrote $written byte(s) from position $start"];
}

$SPEC{append_file} = {
    v => 1.1,
    description => <<'_',

We don't set the `content` argument as `partial` because it's actually hard to
handle unordered/non-contiguous partial arguments if we open the file in append
mode. We'll need to put the whole argument to temporary file first, and then
append that temporary file to the target file.

_
    args => {
        path => {schema=>'str*', req=>1, pos=>0},
        content => {schema=>'buf*', req=>1, pos=>1,
                    cmdline_src=>'stdin_or_files'},
    },
};
sub append_file {
    my %args = @_; # VALIDATE_ARGS

    my $path = $args{path};

    sysopen my($fh), $path, O_WRONLY | O_APPEND | O_CREAT
        or return [500, "Can't open '$path' for appending: $!"];
    my $written = syswrite $fh, $args{content};
    defined($written) or return [500, "Can't append content to '$path': $!"];

    [200, "Appended $written byte(s)"];
}

1;
# ABSTRACT: Examples for reading/writing files (demos partial_arg/partial_res)

