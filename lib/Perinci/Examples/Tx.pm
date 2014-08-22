package Perinci::Examples::Tx;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Examples for using transaction',
};

$SPEC{check_state} = {
    v => 1.1,
    summary => "Return 'check_state' if checking state, otherwise empty string",
    features => {tx=>{v=>2}, idempotent=>1},
};
sub tx {
    my %args = @_;
    [200, "OK", $args{-tx_action} eq 'check_state' ? "check_state" : ""];
}

1;
# ABSTRACT: Examples for using transaction
