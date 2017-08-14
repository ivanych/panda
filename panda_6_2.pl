#!/usr/bin/perl

use strict;
use warnings;

use DDP;
use IO::Socket;
use IO::Select; 

# Флаг выхода по таймауту
my $stop = 0;
local $SIG{ALRM} = sub { $stop = 1 };


#my $result = http_get('jd.com', '/ghrrr', {k=>1,b=>2}, 3);
my $result = http_get('ya.ru', '/', {k=>1,b=>2}, 3);

p $result;


sub http_get {
    my ($host, $path, $query, $timeout) = @_;
    
    my $socket = IO::Socket::INET->new(PeerAddr => $host,
                                       PeerPort => 80,
                                       Proto    => "tcp",
                                       Type     => SOCK_STREAM) or die $!;

    my $select = IO::Select->new($socket);
    
    my $req = "GET $path HTTP/1.1\r\nHost: $host\r\n\r\n";
    
    p $req;

    syswrite $socket, $req;
    
    # Ответ
    my $res;
    
    # Размер ответа
    my $size;
    
    # Массив для заполнения ерундой во время ожидания
    my @idle;
    
    # Взводим курок
    alarm $timeout;

    while (1) {
        
        # Есть чо?
        my @ready = $select->can_read(0);
    
        if (@ready) {
            
            # Если есть - читаем
            foreach my $fh (@ready) {
                print "+";

                sysread $fh, my $buf, 1024;

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
                    print "\n\@idle = ", scalar @idle, "\n";

                    return $res;
                }
            }
        }
        else {
            
            # Если читать нечего, пишем в idle ерунду
            print ".";
            
            push @idle, 1;
        }
        
        # Не настал ли нам таймаут?
        if ($stop) {
            print "\nTimeout $timeout!\n";
            print '@idle = ', scalar @idle, "\n";
            
            return;
        }
    }
}

