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

The functions in this package demonstrate byte streaming of input and output.

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
    description => <<'_',

This function demonstrate output streaming of bytes.

To do output streaming, on the function side, you just return an opened
filehandle glob which can be read from, or an `IO::Handle` object (anything that
supports `getline()` or `getitem()` method) or an array (usually a tied array).

`Perinci::CmdLine` supports this and will read items/lines from the
handle/object/tied array until exhausted, and then output them.

This works over remote (HTTP) too, because output streaming is supported by
`Riap::HTTP` (version 1.2) and `Perinci::Access::HTTP::Client`. Streams are
translated into HTTP chunks.

_
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

This function demonstrates input streaming of bytes.

To do input streaming, on the function side, you just specify one your args with
the `stream` property set to true (`stream => 1`). In this example, the
`content` argument is set to streaming.

If you run the function through `Perinci::CmdLine`, you'll get a filehandle
instead of the actual value. You can then iterate the content from this
filehandle. This currently works for local functions only. As of this writing,
`Riap::HTTP` protocol does not support input streaming. It supports partial
input though (see the documentation on how this works) and theoretically
streaming can be emulated by client library using partial input. However, client
like `Perinci::Access::HTTP::Client` does not yet support this.

Note that the argument's schema is still `buf*`, not `obj*`.

Note: This function overwrites existing file.

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

This is like `write_file()` except that it appends instead of overwrites
existing file.

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
