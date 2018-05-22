#!/usr/bin/perl -w
unlink "./dc_tim_qor/2de.rpt";
open DST, ">./dc_tim_qor/2de.rpt";

&print_tile("usb0_s0","setup");
&print_tile("usb1_s0","setup");
&print_tile("usb0_phy","setup");
&print_tile("usb1_phy","setup");

sub print_tile {
 $tile = $_[0];
 $type = $_[1];
 if($type =~ /hold/) {
 $src = "${tile}.hold.xls";
 } else {
 $src = "${tile}.xls";
 }
print DST "In $tile:\n";
print DST "type:$type\n";
open SRC, "./dc_tim_qor/$src";
while(<SRC>) {
 chomp;
 if(/Path Group\s*TNS/) {
  last;
 }
 if(/(Path Group\s*WNS)|(^$)/) {
  next;
 }
 ($clock,$slack)= split /\s+/, $_;
 print DST "$clock\t$slack\n" if($slack<0);
}
close SRC;
}

