#!/usr/bin/perl

use strict;
use warnings;

use DDP;

use Mymod;

my $obj = Mymod->new();

$obj->acc1( "attr1_value" );
p $obj->acc1;

$obj->acc2( "attr2_value" );
p $obj->acc2;
