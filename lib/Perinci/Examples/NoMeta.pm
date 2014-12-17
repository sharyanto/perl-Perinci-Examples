package Perinci::Examples::NoMeta;

# DATE
# VERSION

# This is a sample of a "traditional" Perl module, with no metadata or enveloped
# result.

use 5.010;
use strict;
use warnings;

our $Var1 = 1;

sub pyth($$) {
    my ($a, $b) = @_;
    ($a*$a + $b*$b)**0.5;
}

sub gen_array {
    my ($len) = @_;
    $len //= 10;
    my @res;
    for (1..$len) { push @res, int(rand $len)+1 }
    \@res;
}

1;
#ABSTRACT: Example of module without any metadata

=for Pod::Coverage .*
