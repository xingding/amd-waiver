#!/usr/bin/perl -w
$tag = "$ARGV[0]";
$src_dir = "$ARGV[1]";
$tmp_file = "$tag.sdc.error";
$dst = "$tag.sdc.error.final";
if (-e "$src_dir/rpts/DgSynthesize/DgSynthesize.sourceFcSdc.rpt.gz") {
 open SRC, "gzip -cd $src_dir/rpts/DgSynthesize/DgSynthesize.sourceFcSdc.rpt.gz |" or die "can not find $src_dir/rpts/DgSynthesize/DgSynthesize.sourceFcSdc.rpt.gz\n";
 } else {
 open SRC, "$src_dir/rpts/DgSynthesize/DgSynthesize.sourceFcSdc.rpt" or die "can not find $src_dir/rpts/DgSynthesize/DgSynthesize.sourceFcSdc.rpt.gz\n";
 }
open TMP, "> ./sdc/$tmp_file";
while (<SRC>) {
 chomp;
 if (/Warning: Can't find clock '(.*)' in design/) {
  print TMP "$1\n";
 }
}
close SRC;
close TMP;
&remove_rebundant("./sdc/$tmp_file", "./sdc/$dst");


sub remove_rebundant {
open SRC, "./$_[0]" or die; #srouce file before rebundant.
open DST, "> ./$_[1]" or die; #dst file after rebundant.
%ha = ();
while (<SRC>) {
  chomp;
  $ha{$_} = 1;
}

@clk_group= sort keys %ha;
foreach  (@clk_group) {
 print DST "$_\n";
}

close SRC;
close DST;
}
