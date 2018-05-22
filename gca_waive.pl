#!/usr/bin/perl -w

$src_file = $ARGV[0];
$tile =  $ARGV[1];
$i = 0;
$j = 0;
open (SRC, "$src_file") or die "can not open $src_file\n";
open (DST, ">${tile}.waive") or die "can not create ${tile}.waive\n";
while (<SRC>) {
 $i++;
 $j = 0;
 $p_con = '.*';
 if (/^\s+(\w+_\d+):(.*)/) {
  $tag = $1;
  $content = $2;
  @content = split /\'/, $content;
  foreach $key (@content) {
   if ($j%2) {
    $p_con = "$p_con"."$key".'.*';
   }
   $j++;
  }
  #$p_con = "$p_con".'.*';
  print DST "GcSynthesizeCheckSdc WAIVE xguo all $tag $p_con\n";
 }
}

