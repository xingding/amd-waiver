#!/usr/bin/perl -w
$dir = $ARGV[1];
$tile = $ARGV[0];
open (SRC, "gzip -cd $dir/rpts/DgSynthesize/DgSynthesize.multibit.rpt.gz |") or warn "src file canont find";
open DST , ">> ./mbb_rate/2de.xls";
#print DST "$tile\tActual Swap Rate\tEffective Swap Rate\n";
while (<SRC>) {
 chomp;
 if (/Actual Swap Rate:\s*(\S*)/) {
  print DST "$tile\t$1";
 } elsif (/Effective Swap Rate:\s*(\S*)/) {
  print DST "\t$1\n";
 }
}

system "sort -u ./mbb_rate/2de.xls > ./mbb_rate/2de.final.xls"
