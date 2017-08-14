#!/usr/bin/perl

use strict;
use warnings;

use DDP;
use Time::HiRes;
use Memory::Usage;
use Devel::Refcount qw( refcount );
use Devel::Peek qw( SvREFCNT );

my $mu = Memory::Usage->new();

$mu->record('before');

for (1..1000) {
    my $a = {};

    my $c = \$a->{cnt};
    $a->{func} = sub {
        $$c++;
    };
    
    #p $a->{func};
    
    warn $a->{func}->();
    warn $a->{cnt};
    
    warn 'SvREFCNT: ', SvREFCNT($a), "\n";
    warn 'refcount: ', refcount($a), "\n";
    
    #Time::HiRes::sleep(0.001);
}

$mu->record('after');

$mu->dump();