#!/usr/bin/perl

use strict;
use warnings;

use DDP;
use IO::Socket;

http_get('ya.ru');

sub http_get {
    my ($host, $path, $query, $timeout) = @_;
    
    my $socket = IO::Socket::INET->new(PeerAddr => $host,
                                       PeerPort => 80,
                                       Proto    => "tcp",
                                       Type     => SOCK_STREAM) or die "Couldn't connect to $host:80 : $@\n";
                                       
    
    my $req = "GET / HTTP/1.1\r\nHost: $host\r\n\r\n";
    
    p $req;
    
    print $socket $req;
    
    for my $str (<$socket>) {
        print $str;
    }
};
