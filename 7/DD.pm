package DD;
use parent qw/BB CC/;
sub func { print "DD\n"; shift->SUPER::func(@_); }

1;