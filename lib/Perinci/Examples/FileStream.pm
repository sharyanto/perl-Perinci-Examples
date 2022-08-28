package Perinci::Examples::FileStream;

use 5.010;
use strict;
use warnings;

use Fcntl qw(:DEFAULT);

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Examples for reading/writing files (using streaming result)',
    description => <<'_',

The functions in this package demonstrate byte streaming of input and output.

The functions are separated into this module because these functions read/write
files on the filesystem and might potentially be dangerous if
<pm:Perinci::Examples> is exposed to the network by accident.

See also <pm:Perinci::Examples::FilePartial> which uses partial technique
instead of streaming.

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

To do output streaming, on the function side, you just return a coderef which
can be called by caller (e.g. CLI framework <pm:Perinci::CmdLine>) to read data
from. Code must return data or undef to signify exhaustion.

This works over remote (HTTP) too, because output streaming is supported by
<pod:Riap::HTTP> (version 1.2) and <pm:Perinci::Access::HTTP::Client>. Streams
are translated into HTTP chunks.

_
};
sub read_file {
    my %args = @_; # VALIDATE_ARGS

    my $path = $args{path};
    (-f $path) or return [404, "No such file '$path'"];

    open my($fh), "<", $path or return [500, "Can't open '$path': $!"];

    [200, "OK", sub { scalar <$fh> }, {stream=>1}];
}

$SPEC{write_file} = {
    v => 1.1,
    description => <<'_',

This function demonstrates input streaming of bytes.

To do input streaming, on the function side, you just specify one your args with
the `stream` property set to true (`stream => 1`). In this example, the
`content` argument is set to streaming.

If you run the function through <pm:Perinci::CmdLine>, you'll get a coderef
instead of the actual value. You can then repeatedly call the code to read data.
This currently works for local functions only. As of this writing,
<pod:Riap::HTTP> protocol does not support input streaming. It supports partial
input though (see the documentation on how this works) and theoretically
streaming can be emulated by client library using partial input. However, client
like <pm:Perinci::Access::HTTP::Client> does not yet support this.

Note that the argument's schema is still `buf*`, not `code*`.

Note: This function overwrites existing file.

_
    args => {
        path => {schema=>'str*', req=>1, pos=>0},
        content => {schema=>'buf*', req=>1, pos=>1, stream=>1,
                    cmdline_src=>'stdin_or_files',
                },
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
        local $_;
        while (defined($_ = $content->())) {
            print $fh $_; $written += length($_);
        }
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
        local $_;
        while (defined($_ = $content->())) {
            print $fh $_; $written += length($_);
        }
    } else {
        print $fh $content;
        $written += length($content);
    }

    [200, "Appended $written byte(s)"];
}

1;
# ABSTRACT:
