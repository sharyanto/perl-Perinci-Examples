package Sub::Spec::Examples::NoSpec;

# This is a sample of a "traditional" Perl module, with no spec or full response
# sub return.

use 5.010;
use strict;
use warnings;

sub pyth($$) {
    my ($a, $b) = @_;
    ($a*$a + $b*$b)**0.5;
}

sub gen_array {
    my ($len) = @_;
    $len //= 10;
    my @res;
    for (1..$len) { push @res, int($len)+1 }
    \@res;
}

# VERSION

1;
#ABSTRACT: Example of module without spec
