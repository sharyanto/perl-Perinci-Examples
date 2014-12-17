package Perinci::Examples::CmdLineResMeta;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Functions in this package contains cmdline.* result metadata',
};

$SPEC{exit_code} = {
    v => 1.1,
    summary => 'Returns cmdline exit code 7, even though status is 200',
    args => {
    },
};
sub exit_code {
    my %args = @_;
    [200, "OK", undef, {'cmdline.exit_code'=>7}];
}

$SPEC{result} = {
    v => 1.1,
    summary => 'Returns false, but cmdline.result the string "false"',
    args => {
    },
};
sub result {
    my %args = @_;
    [200, "OK", 0, {'cmdline.result'=>'false'}];
}

$SPEC{is_palindrome} = {
    v => 1.1,
    summary => 'Return true if string is palindrome',
    args => {
        str => {schema=>'str*', req=>1, pos=>0},
    },
};
sub is_palindrome {
    my %args = @_;
    my $str = $args{str};
    my $res = $str eq reverse($str);
    [200, "OK", $res, {'cmdline.result'=>$res ?
                           'Is palindrome' : 'Not palindrome'}];
}

$SPEC{default_format} = {
    v => 1.1,
    summary => 'Set cmdline.default_format json',
    args => {
    },
};
sub default_format {
    my %args = @_;
    [200, "OK", undef, {'cmdline.default_format'=>'json'}];
}

$SPEC{skip_format} = {
    v => 1.1,
    summary => 'Set cmdline.skip_format => 1',
    args => {
    },
};
sub skip_format {
    my %args = @_;
    [200, "OK", [], {'cmdline.skip_format'=>1}];
}

1;
# ABSTRACT:
