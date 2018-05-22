#!/usr/bin/perl -w
$tag = $ARGV[0];
$name = $ARGV[1];
mkdir 'vsi' or warn "vsi directory cannot make";
open SRC, "gzip -cd $tag/rpts/VsiSynthesizePRC/VsiSynthesizePRC.rpt.gz |" or die "can not open $tag/rpts/VsiSynthesizePRC/VsiSynthesizePRC.rpt.gz $!";
open DST, "> ./vsi/$name.result" or die "can not create ./vsi/$name.result file";
#system "ln  $tag/rpts/VsiSynthesizePRC/VsiSynthesizePRC.rpt.gz";
open SRC_BAK, "> ./vsi/$name.rpt.gz";
while (<SRC>) {
 chomp;
 print SRC_BAK "$_\n";
 if (/Total\s+0\s+0\s+0/) {
   print DST "$_\n";
   print DST "success\n";
 } elsif (/Total\s+\d+\s+\d+\s+\d+/) {
   print DST "$_\n fail\n";
  }
}

close SRC;
close DST;

open SRC, "gzip -cd $tag/rpts/VsiSynthesizePRC/VsiSynthesizePRC.postwaived.rpt.gz |" or die "can not open $tag/rpts/VsiSynthesizePRC/VsiSynthesizePRC.postwaived.rpt.gz $!";
open DST, "> ./vsi/$name.waive" or die "can not create ./vsi/$name.waive file";
while (<SRC>) {
 chomp;
if (/Occurrence: \d+ Remaining, \d+ Waived Out of \d+/) {
 } elsif (/LS_INST_MISSING:\d+.*Source  PinName : (\S+)/) {
  print DST "vsi WAIVE dixi all LS_INST_MISSING .*${1}.*\n";
 } elsif (/LS_INPUT_TIELO:\d+.*  Instance : (\S+)/) {
  print DST "vsi WAIVE dixi all LS_INPUT_TIELO .*${1}.*\n";
 } elsif (/LS_INPUT_TIEHI:\d+.*  Instance : (\S+)/) {
  print DST "vsi WAIVE dixi all LS_INPUT_TIEHI .*${1}.*\n";
 } elsif (/LS_INST_REDUND:\d+.* Instance : (\S+)/) {
  print DST "vsi WAIVE dixi all LS_INST_REDUND .*${1}.*\n";
 } elsif (/LS_INST_NOSHIFT:\d+.* Instance : (\S+)/) {
  print DST "vsi WAIVE dixi all LS_INST_NOSHIFT .*${1}.*\n";
 } else {
  print "$_ ,cannot support, please double check\n";
 }
}

close SRC;
close DST;
