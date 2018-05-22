#!/usr/bin/perl -w

$src = $ARGV[0];
$dst = "LcEco.SynEcoSynthesizeVsPreEcoPrePhysical.before.lecmode.tcl";
open SRC, "./$src" or die "can not find $src file\n";
open DST, ">./$dst" or die "can not create $dst file\n";
print DST "vpxmode\n";
while (<SRC>) {
 chomp;
 if(/(^$)|(^(\s)*#)/) {print DST "$_\n"}
 elsif (/U_((\w|\d)*bn)\//) {
 $sram = $1;
 print DST "vpx add ignore input SI_* -module  $sram -both\n";
 }
 elsif(/set_constant.*i:(.*)/) {
  $con = $1;
  $con =~ s/\/FMWORK_IMPL_.*_T\/usb._.*_t\///;
  if($con =~ /\//) {
   print DST "vpx add primary input -cut $con -revised\n";
   print DST "vpx add pin constraint 0   $con -revised\n";
  } else {
   print DST "vpx add pin constraint 0   $con -revised\n";
  }
 }
 elsif(/set_constant.*r:(.*)/) {
  $con = $1;
  $con =~ s/\/FMWORK_REF_USB._.*_T\/usb._.*_t\///;
  if($con =~ /\//) {
   print DST "vpx add primary input -cut $con -golden\n";
   print DST "vpx add pin constraint 0   $con -golden\n";
  } else {
   print DST "vpx add pin constraint 0   $con -golden\n";
  }
 } else {
  print "can not translate $_\n";
 }
}


print DST "tclmode\n";
