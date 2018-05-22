#!/usr/bin/perl -w
$tag = $ARGV[0];
$name = $ARGV[1];
#mkdir 'vsi' or warn "vsi directory cannot make";
open SRC, "gzip -cd $tag/rpts/VsiPrePhysicalPRC/VsiPrePhysicalPRC.rpt.gz |" or die "can not open $tag/rpts/VsiPrePhysicalPRC/VsiPrePhysicalPRC.rpt.gz $!";
open DST, "> ./vsi/$name.result" or die "can not create ./vsi/$name.result file";

while (<SRC>) {
 chomp;
 if (/Total\s+0\s+0\s+0/) {
   print DST "$_\n";
   print DST "success\n";
 } elsif (/Total.*[1-9].*/) {
   print DST "$_\n fail\n";
  }
}

close SRC;
close DST;

