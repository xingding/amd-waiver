#!/usr/bin/perl -w
$run_dir = $ARGV[0];
$tile = $ARGV[1];
 open SRC, "gzip -cd $run_dir/rpts/DgSynFinalRpt/DgSynFinalRpt.postwaived.rpt.gz |" or die "the file do not exist";
 open DST, ">./no_clock/${tile}.afterwaive" or die "the file do not exist";
 while(<SRC>) {
  chomp;
  if(/NO_CLOCK:(\S+) has no clock/) {
   print DST "$_\n";
  }
}

close SRC;
close DST;

$src_rpt = "${tile}.afterwaive";
$dst_rpt = "${tile}.afterwaive.fun";
$dst_rpt1 = "${tile}.afterwaive.gasket";
$dst_rpt2 = "${tile}.afterwaive.dft";
open SRC, "./no_clock/$src_rpt" or warn "$src_rpt canont find";
open DST, ">./no_clock/$dst_rpt" or warn "$dst_rpt canont find";
open DST1, ">./no_clock/$dst_rpt1" or warn "$dst_rpt1 canont find";
open DST2, ">./no_clock/$dst_rpt2" or warn "$dst_rpt2 canont find";

while (<SRC>) {
 chomp;
 if (/NO_CLOCK:(.*dft_gasket_housing.*)/) {
  print DST1 "$_\n";
 } elsif (/Warning: (.*tile_dfx.*)/) {
  print DST2 "$_\n";
 } else {
  print DST "$_\n";
 }
}
close SRC;
close DST;
close DST1;
close DST2;

&gen_waive ("$dst_rpt"); 
&gen_waive ("$dst_rpt1"); 
&gen_waive ("$dst_rpt2"); 
sub gen_waive {
$input_file = "$_[0]";
open IN_FILE ,"./no_clock/$input_file" or die "cannot find $input_file file: $!";
open OUT_FILE ,">./no_clock/$input_file.waive" or die $!;
my $t;
while(<IN_FILE>) {
  chomp;
  if ($_ =~ /NO_CLOCK:(\S+)/) {
    print OUT_FILE "DgSynFinalRpt WAIVE xguo1 all NO_CLOCK \.\*"."$1"."\.\*"."\n";
  }
  
}
close IN_FILE;
close OUT_FILE;
##end generate waive file
}

