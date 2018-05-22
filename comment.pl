#!/usr/bin/perl -w

$src = "$ARGV[0]";
$dst = "$ARGV[0].mod";

open SRC, "$src";
open DST, ">$dst";
while (<SRC>) {
 if (/^set.* -clock DFX_CHIP_TCLK /) {
  print DST "#$_";
 } else {
  print DST "$_";
 }
}
