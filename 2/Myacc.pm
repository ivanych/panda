package Myacc;

use strict;
use warnings;

sub new {
    return bless {}, $_[0];
};

sub create_acc {
    my ($self, @args) = @_;
    
    my $caller = caller;
    
    no strict 'refs';
    
    for my $name ( @args ) {
        *{ $caller . '::' . $name } = sub {
            if (@_ > 1) {
                $_[0]->{$name} = $_[1];
            }

            return $_[0]->{$name};
        };
    }
}

1;
