#!/usr/bin/perl

use strict;
use warnings;

use DDP;
use IO::Socket;

# Флаг выхода по таймауту
my $stop = 0;
local $SIG{ALRM} = sub { $stop = 1 };


#my $result = http_get('jd.com', '/grgrgr', {k=>1,b=>2}, 3);
my $result = http_get('ya.ru', '/', {k=>1,b=>2}, 3);

p $result;


sub http_get {
    my ($host, $path, $query, $timeout) = @_;
    
    my $socket = IO::Socket::INET->new(PeerAddr => $host,
                                       PeerPort => 80,
                                       Proto    => "tcp",
                                       Type     => SOCK_STREAM) or die $!;

    my $req = "GET $path HTTP/1.1\r\nHost: $host\r\n\r\n";
    
    p $req;

    syswrite $socket, $req;
    
    # Ответ
    my $res;
    
    # Размер ответа
    my $size;

    # Взводим курок
    alarm $timeout;

    while (1) {
        print "+";
        
        sysread $socket, my $buf, 1024;
        
        $res .= $buf;
        
        # Определение размера ответа
        if (!$size) {
            if ($res =~ /\r?\n\r?\n/) {
                
                my ($cl) = ($res =~ /Content-Length: (\d+)/i);
                print "\nContent-Length = $cl\n";
                
                my ($head) = ($res =~ /(.*\r?\n\r?\n)/s);
                my $hl = length $head;
                print "Header length = $hl\n";
                
                $size = $hl + $cl;
                print "Full size = $size\n";
            }
        }

        # Если размер прочитанного равен вычисленному размеру ответа - всё, готово
        if (defined $size and length $res == $size) {
            print "\nEnd\n";
            return $res;
        }

        
        # Не настал ли нам таймаут?
        if ($stop) {
            print "\nTimeout $timeout!\n";

            return;
        }
    }
}

