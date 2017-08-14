#!/usr/bin/perl

use strict;
use warnings;

use DDP;
use Time::HiRes;
use Memory::Usage;
use Devel::Refcount qw( refcount );
use Devel::Peek qw( SvREFCNT );
use Scalar::Util qw(weaken);

my $mu = Memory::Usage->new();

$mu->record('before');

for (1..1000) {
    my $a = {b => {}};
    $a->{b}{a} = $a;

    weaken $a->{b}{a};
    
    #p $a;
    
    warn SvREFCNT( $a );
    warn refcount( $a );
    
    #Time::HiRes::sleep(0.001);
}

$mu->record('after');

$mu->dump();