package BB;
use parent qw(AA);
sub func { print "BB\n"; shift->SUPER::func(@_); }

1;