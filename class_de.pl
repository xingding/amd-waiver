#!/usr/bin/perl -w
$tile = $ARGV[0];
$src_rpt = "${tile}.postwaived.rpt.gz";
$dst_rpt = "${tile}.fun";
$dst_rpt1 = "${tile}.gasket";
$dst_rpt2 = "${tile}.dft";
#$dir =  $ARGV[1];
open (SRC, "gzip -cd ./$src_rpt |") or warn "$src_rpt canont find";
open DST, ">./$dst_rpt" or warn "$dst_rpt canont find";
open DST1, ">./$dst_rpt1" or warn "$dst_rpt1 canont find";
open DST2, ">./$dst_rpt2" or warn "$dst_rpt2 canont find";

while (<SRC>) {
 chomp;
 if (/.*dft_gasket_housing.*/) {
  print DST1 "$_\n";
 } elsif (/.*tile_dfx.*/) {
  print DST2 "$_\n";
 } else {
  print DST "$_\n";
 }
}
