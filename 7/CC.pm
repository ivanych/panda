package CC;
use parent qw(AA);
sub func { print "CC\n"; shift->SUPER::func(@_); }

1;