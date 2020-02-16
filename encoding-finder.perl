#!/usr/bin/perl -w
use strict;
$| = 1;

my $debugger = 0; # set to 1 to enable debugging

my $first_time = 1;
my $ascii = 0;
my $utf8 = 0;
my $isoLatin9 = 0;

sub riconosci{
    my $sequenza = shift;
    my @sequenza_byte = split(//, $sequenza);
    
    for(my $i=0; $i<$#sequenza_byte; $i++){
        my $val1 = unpack("C",$sequenza_byte[$i]);
        printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val1, $val1, $val1) if($debugger);
 
  	if($first_time){
	    if($val1 == 255){
		my $val2 = unpack("C",$sequenza_byte[$i+1]);
		printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val2, $val2, $val2) if($debugger);
		if($val2 == 254){
		    print "utf16-le \/ UCS2-le file\n";
		    exit 0;
		}
	    }
	    if($val1 == 254){
		my $val2 = unpack("C",$sequenza_byte[$i+1]);
		printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val2, $val2, $val2) if($debugger);
		if($val2 == 255){
		    print "utf16-be \/ UCS2-be file\n";
		    exit 0;
		}
	    }
	    $first_time = 0;
	}

        if($val1 < 128) { # 0???????
	      $ascii++;
        }elsif($val1 == 164) {# || $val1 == 166 || $val1 == 168 || $val1 == 180 || $val1 == 184 || $val1 == 188 || $val1 == 189 || $val1 == 190)
	    $isoLatin9++;
	}
	elsif($val1 >= 192 && $val1 <224) { # II0?????
	    my $val2 = unpack("C",$sequenza_byte[$i+1]);
	    printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val2, $val2, $val2) if($debugger);
	    if($val2 >= 128 && $val2 < 192) # I0?????? 
	    {
		$utf8++;
	    }
	}
	elsif($val1 >= 224 && $val1 <240) {  #Bits: III0????
	      my $val2 = unpack("C",$sequenza_byte[$i+1]);
	      printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val2, $val2, $val2) if($debugger);

	      my $val3 = unpack("C",$sequenza_byte[$i+2]);
	      printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val3, $val3, $val3) if($debugger);
	      if(($val2 >= 128 && $val2 < 192) && ($val3 >= 128 && $val3 <192)) { # I0?????? 
		  $utf8+=2;
	      } 
	}
	elsif($val1 >= 240 && $val1 <248) { #Bits: IIII0???
	    my $val2 = unpack("C",$sequenza_byte[$i+1]);
	    printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val2, $val2, $val2) if($debugger);

	    my $val3 = unpack("C",$sequenza_byte[$i+2]);
	    printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val3, $val3, $val3) if($debugger);

	    my $val4 = unpack("C",$sequenza_byte[$i+3]);
	    printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val4, $val4, $val4) if($debugger);

	      if(($val2 >= 128 && $val2 < 192) && ($val3 >= 128 && $val3 <192) && ($val4 >= 128 && $val4 <192) ) { # I0?????? 
		  $utf8+=3;
	      } 
	}
	elsif($val1 >= 248 && $val1 <252) { #Bits: IIIII0??
	    my $val2 = unpack("C",$sequenza_byte[$i+1]);
	    printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val2, $val2, $val2) if($debugger);

	    my $val3 = unpack("C",$sequenza_byte[$i+2]);
	    printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val3, $val3, $val3) if($debugger);

	    my $val4 = unpack("C",$sequenza_byte[$i+3]);
	    printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val4, $val4, $val4) if($debugger);
	    
	    my $val5 = unpack("C",$sequenza_byte[$i+4]);
	    printf STDERR ("ROUND:%3d%6d%10b\t%c\n", $i, $val5, $val5, $val5) if($debugger);
	    
	    if(($val2 >= 128 && $val2 < 192) && ($val3 >= 128 && $val3 <192) && ($val4 >= 128 && $val4 <192) && ($val5 >= 128 && $val5 <192)) { # I0?????? 
		$utf8+=4;
	    }
	}
    }
}

while(<>) {
    chomp;
    riconosci($_);
    last if ($. > 100); # only read first 100 lines
}

if($debugger) {
  print STDERR "ASCII: $ascii, Vergleich: " . $ascii / 5000 . "\n";
  print STDERR "UTF-8: $utf8\n";
  print STDERR "ISO-LATIN-9: $isoLatin9\n";
}

if( $utf8 > ($ascii / 5000)) { # minimum Req: one diacritic Char every 5000 ascii chars
    print "utf-8 file\n";
}
elsif($isoLatin9 > 0) {
    print "ISO-Latin-9(ISO 8859-15) file\n";
}
else {
    print "ISO-Latin-1(ISO 8859-1) file\n";
}

