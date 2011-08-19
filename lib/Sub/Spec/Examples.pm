package Sub::Spec::Examples;

use 5.010;
use strict;
use warnings;

# VERSION

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(delay);
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
        },
    },
};
sub err {
    my %args = @_;
    my $code = int($args{code}) // 0;
    $code = 500 if $code < 100 || $code > 555;
    [$code, "Response $code"];
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


=head1 SEE ALSO

L<Sub::Spec>

=cut
