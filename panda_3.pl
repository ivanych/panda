#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say state);


func() for 1..10;
sub func {
    my $var if 1;
    $var++;
    say "A=$var";
}
print $var;