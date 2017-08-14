#!/usr/bin/perl

use strict;
use warnings;

my $array = [ 1, 2, 3, 4, 5, 6, 9, 10, 11, 12, 13, 14,, 17, 18, 19, 20, 21, 22 ];

my $val = $ARGV[0] || 0;

my $i = binary( $array, $val, 0, $#{$array} );

print "$i ($array->[$i])\n";

sub binary {
    my ( $array, $val, $imin, $imax ) = @_;

    if ( $imax < $imin ) {
        return 0 if $imax < 0;
        return $#{$array} if $imin > $#{$array};
        return ( $val - $array->[$imax] < $array->[$imin] - $val ) ? $imax : $imin;
    }

    my $imid = int( ( $imin + $imax ) / 2 );

    if ( $array->[$imid] > $val ) {
        return binary( $array, $val, $imin, $imid - 1 );
    }
    elsif ( $array->[$imid] < $val ) {
        return binary( $array, $val, $imid + 1, $imax );
    }
    else {
        return $imid;
    }
}
