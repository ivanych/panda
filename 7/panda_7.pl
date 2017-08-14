#!/usr/bin/perl

use strict;
use warnings;

use DD;

{
local @BB::ISA = qw(CC AA);
DD->func();
}

print "\n";

DD->func();
