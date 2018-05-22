#!/usr/bin/perl -w
$tag = $ARGV[0];
$name = $ARGV[1];
$pa = $ARGV[2];
#mkdir 'fm' or warn "fm directory cannot make";
#open SRC, "gzip -cd $tag/rpts/VsiGenPreSynUpfPRC/VsiGenPreSynUpfPRC.rpt.gz |" or die "can not open $tag/rpts/VsiGenPreSynUpfPRC/VsiGenPreSynUpfPRC.rpt.gz $!";
open DST, "> ./fm/$name.syn.result" or die "can not create ./fm/$name.result file";
if ($pa) {
 $src = "$tag/rpts/FmEqvPwrSynthesizeVsSynRtl/FmEqvPwrSynthesizeVsSynRtl.dat";
 $src1 = "$tag/rpts/FmEqvPwrAllUpfSuppliesOnSynthesizeVsSynRtl/FmEqvPwrAllUpfSuppliesOnSynthesizeVsSynRtl.dat";
 &check_fm ($src, FmEqvPwrSynthesizeVsSynRtl);
 close DST;
 open DST, ">> ./fm/$name.syn.result" or die "can not create ./fm/$name.result file";
 &check_fm ($src1,FmEqvPwrAllUpfSuppliesOnSynthesizeVsSynRtl);
 close DST;
} else {
 $src = "$tag/rpts/FmEqvSynthesizeVsSynRtl/FmEqvSynthesizeVsSynRtl.dat";
 &check_fm ($src, FmEqvSynthesizeVsSynRtl);
 close DST;
}

sub check_fm {
open SRC, "$_[0]" or warn "can not open the $_[0] file $!";
while (<SRC>) {
 chomp;
 if (/lecResult: SUCCEEDED/) {
   print DST "$_[1]: success\n";
 } elsif (/lecResult/) {
   print DST "$_[1]: fail\n";
  }
}
close SRC;
#close DST;
}
