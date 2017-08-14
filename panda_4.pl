#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use DDP;
use DBI;
use DBD::Pg;
use Devel::Size qw(size total_size);

my $db = '';
my $host = '';
my $port = '';
my $user = '';
my $pass = '';


 my $dbh = DBI->connect(
            "DBI:Pg:dbname=$db;host=$host;port=$port", 
            $user, $pass
        ) or die "ups $!";


my $all_a = $dbh->selectall_arrayref('select * from clients limit 3');
my $all_h = $dbh->selectall_hashref('select * from clients limit 3', 'client_id');

print '$all_a = ' . total_size ($all_a) . "\n";
print '$all_h = ' . total_size ($all_h) . "\n";




my @data_h;
my $sth = $dbh->prepare('select * from clients limit 3');
$sth->execute;
while (my $row = $sth->fetchrow_hashref) { push @data_h, $row };
print '@data_h = ' . total_size (\@data_h) . "\n";
#p @data_h;



my @data_a;
my $sth2 = $dbh->prepare('select * from clients limit 3') or die $dbh->errstr;
$sth2->execute or die $sth2->errstr;
while (my $row2 = $sth2->fetchrow_arrayref) {push @data_a, [@{$row2}]};
print '@data_a = ' . total_size (\@data_a) . "\n";
#p @data_a;

