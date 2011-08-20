package Sub::Spec::Examples;

use 5.010;
use strict;
use warnings;

use List::Util qw(min max);
use Log::Any '$log';

# VERSION

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       delay dies err randlog
                       gen_array gen_hash
                       noop
               );
our %SPEC;

$SPEC{delay} = {
    summary => "Sleep, by default for 10 seconds",
    description => <<'_',

Can be used to test time_limit clause.

_
    args => {
        n => ['int*' => {
            summary => 'Number of seconds to sleep',
            arg_pos => 0,
            default => 10,
            min => 0, max => 7200,
        }],
        per_second => ['bool*' => {
            summary => 'Whether to sleep(1) for n times instead of sleep(n)',
            default => 0,
        }],
    },
};
sub delay {
    my %args = @_;
    my $n = $args{n} // 10;

    if ($args{per_second}) {
        sleep 1 for 1..$n;
    } else {
        sleep $n;
    }
    [200, "OK", "Slept for $n sec(s)"];
}

$SPEC{dies} = {
    summary => "Dies tragically",
    description => <<'_',

Can be used to test exception handling.

_
    args => {
    },
};
sub dies {
    my %args = @_;
    die;
}

$SPEC{err} = {
    summary => "Return error response",
    description => <<'_',


_
    args => {
        code => ['int*' => {
            summary => 'Error code to return',
            default => 500,
        }],
    },
};
sub err {
    my %args = @_;
    my $code = int($args{code}) // 0;
    $code = 500 if $code < 100 || $code > 555;
    [$code, "Response $code"];
}

my %num_levels = (
    fatal => 1, error => 2, warn  => 3,
    info  => 4, debug => 5, trace => 6,
);
my %str_levels = reverse %num_levels;
#use Data::Dump; dd(\%num_levels); dd(\%str_levels);
$SPEC{randlog} = {
    summary => "Produce some random Log::Any log messages",
    description => <<'_',

_
    args => {
        n => ['int*' => {
            summary => 'Number of log messages to produce',
            arg_pos => 0,
            default => 10,
            min => 0, max => 1000,
        }],
        min_level => ['str*' => {
            summary => 'Minimum level',
            arg_pos => 1,
            default => 'fatal',
            in      => [keys %num_levels],
        }],
        max_level => ['str*' => {
            summary => 'Maximum level',
            arg_pos => 2,
            default => 'trace',
            in      => [keys %num_levels],
        }],
    },
};
sub randlog {
    my %args      = @_;
    my $n         = $args{n} // 10;
    $n = 1000 if $n > 1000;
    my $min_level = $args{min_level} // "fatal";
    $min_level    = $str_levels{ min(keys %str_levels) }
        if !defined($num_levels{$min_level});
    my $max_level = $args{max_level} // "trace";
    $max_level    = $str_levels{ max(keys %str_levels) }
        if !defined($num_levels{$max_level});

    for my $i (1..$n) {
        my $num_level = int($num_levels{$min_level} +
            rand()*($num_levels{$max_level}-$num_levels{$min_level}+1));
        my $str_level = $str_levels{$num_level};
        $log->$str_level("This is random log message #$i, level=$str_level: ".
                             int(rand()*9000+1000));
    }
    [200, "OK"];
}

$SPEC{gen_array} = {
    summary => "Generate an array of specified length",
    description => <<'_',


_
    args => {
        len => ['int*' => {
            summary => 'Array length',
            arg_pos => 0,
            min => 0, max => 1000,
        }],
    },
};
sub gen_array {
    my %args = @_;
    my $len = int($args{len});
    defined($len) or return [400, "Please specify len"];
    $len = 1000 if $len > 1000;

    my $array = [];
    for (1..$len) {
        push @$array, int(rand()*$len)+1;
    }
    [200, "OK", $array];
}

$SPEC{gen_hash} = {
    summary => "Generate a hash with specified number of pairs",
    description => <<'_',


_
    args => {
        pairs => ['int*' => {
            summary => 'Number of pairs',
            arg_pos => 0,
            min => 0, max => 1000,
        }],
    },
};
sub gen_hash {
    my %args = @_;
    my $pairs = int($args{pairs});
    defined($pairs) or return [400, "Please specify pairs"];
    $pairs = 1000 if $pairs > 1000;

    my $hash = {};
    for (1..$pairs) {
        $hash->{$_} = int(rand()*$pairs)+1;
    }
    [200, "OK", $hash];
}

$SPEC{noop} = {
    summary => "Do nothing, return original argument",
    description => <<'_',


_
    args => {
        arg => ['any*' => {
            summary => 'Argument',
            arg_pos => 0,
        }],
    },
    features => {pure => 1},
};
sub noop {
    my %args = @_;
    [200, "OK", $args{arg}];
}

1;
# ABSTRACT: Various spec'ed functions, for examples and testing
__END__

=head1 SYNOPSIS

 use Sub::Spec::Examples qw(delay);
 delay();


=head1 DESCRIPTION

This module and its submodules contain an odd mix of various functions, mostly
simple ones, each with its L<Sub::Spec> spec. Mostly used for testing spec or
various Sub::Spec modules.


=head1 FUNCTIONS

None are exported by default, but they are exportable.


=head1 SEE ALSO

L<Sub::Spec>

=cut
