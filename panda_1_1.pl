#!/usr/bin/perl

use strict;
use warnings;

use DDP;

my %h;

for (my $i=1; $i< 10; $i++) {
    $h{$i} = int rand(10);
}

p %h;

%h = clean(%h);

p %h;

sub clean {
    my (%h) = (@_);
    
    my %r;
    
    while (my ($k, $v) = each %h) {
        if (exists $r{$v}) {
            delete $h{$k};
        }
        else {
            $r{$v} = 1;
        }
    }
    
    return %h;
}
