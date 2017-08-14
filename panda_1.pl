#!/usr/bin/perl

use strict;
use warnings;

use DDP;

use Benchmark qw(:all) ;

my %h;

for (my $i=1; $i< 10000; $i++) {
    $h{$i} = int rand(10000);
}

=pod
p %h;

my %r_1 = clean_1(%h);
p %r_1;

my %r_2 = clean_2(%h);
p %r_2;

my %r_3 = clean_3(%h);
p %r_3;
=cut

cmpthese(100, {
    'clean_1' => sub { clean_1(%h) },
    'clean_2' => sub { clean_2(%h) },
    'clean_3' => sub { clean_3(%h) },
});


sub clean_1 {
    my (%h) = (@_);
    
    my %r;
    my %n;
    
    while (my ($k, $v) = each %h) {
        $r{$v} = $k;
    }
    
    while (my ($k, $v) = each %r) {
        $n{$v} = $k;
    }
    
    return %n;
}

sub clean_2 {
    my (%h) = (@_);
    
    my %r;
    my %n;
    
    %r = map {$h{$_}, $_} keys %h;
    %n = map {$r{$_}, $_} keys %r;
    
    return %n;
}

# 
sub clean_3 {
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

