#!/usr/bin/perl -w
$dir = $ARGV[0];
$tile = $ARGV[1];
$src_rpt = ${tile}.'.sortbystart';
$dst_rpt = ${tile}.'.2de'.'.fun';
$dst_rpt1 = ${tile}.'.2de'.'.gasket';
$dst_rpt2 = ${tile}.'.2de'.'.dft';
#$dir =  $ARGV[1];
system "cp -f $dir/rpts/DgSynFinalRpt/DgSynFinalRpt.allfanin_of_noclkreg.gz ./no_clock/${tile}.tmp.gz";
system "gunzip -f ./no_clock/${tile}.tmp.gz > ./no_clock/$tile.tmp";
#`grep "Warning\|Start points" ./no_clock/${tile}.tmp >  ./no_clock/${tile}.t`;
#system "grep Warning ./no_clock/${tile}.tmp >  ./no_clock/${tile}.t";
open TMP, "./no_clock/${tile}.tmp";
open TEST, ">./no_clock/${tile}.t";
#@all = <TMP>;
@need = grep /(Warning.*NO_CLOCK)|(Start points)/ , <TMP>;
print TEST "@need";

close TMP;
close TEST;
#unlink "./no_clock/${tile}.tmp.gz","./no_clock/$tile.tmp";
###gen waive file
&gen_waive ("${tile}.t");
sub gen_waive {
$input_file = "$_[0]";
open IN_FILE ,"./no_clock/$input_file" or die "cannot find $input_file file: $!";
open OUT_FILE ,">./no_clock/$input_file.waive" or die $!;
open OUT_FILE1 ,">./no_clock/$input_file.phy_p.waive" or die $!;
my $t;
while(<IN_FILE>) {
  chomp;
  if($_ =~ /Start points: PHY_REF_CLK_P/ ) {
    print OUT_FILE1 "##$_\n";
    print OUT_FILE1 "DgSynFinalRpt WAIVE xguo1 all NO_CLOCK \.\*"."$t"."\.\*"."\n";
  } elsif ($_ =~ /Start points:/) {
    print OUT_FILE "##double_check $_\n";
    print OUT_FILE "DgSynFinalRpt WAIVE xguo1 all NO_CLOCK \.\*"."$t"."\.\*"."\n";
  }
  $t = $_;
  if($t =~ /Warning: (.*) has no clock/) { 
 # print "$t\n";
 $t = $1;
 }
 $t =~ s/\//\\\//g;
}
close IN_FILE;
close OUT_FILE1;
close OUT_FILE;
##end generate waive file
}

##sort by startpoints
 open SRC, "./no_clock/$input_file" or die "the file do not exist";
 open DST, ">./no_clock/$tile.sortbystart" or die "the file do not exist";
 open DST1, ">./no_clock/$tile.start" or die "the file do not exist";
 while(<SRC>) {
  chomp;
  if(/Start points: (.*)/) {
     if(exists($ha{$1})) {
       $ha{$1} = "$ha{$1}$dff\n";
       } else {
       $ha{$1} = "$dff\n";
       }
    } else {
      $dff = $_;
    }
  }
  foreach $key (sort keys %ha) {
  print DST "Start points: $key\n";
  print DST1 "Start points: $key\n";
  print DST "$ha{$key}";
  }
##sort by startpoints end


open SRC, "./no_clock/$src_rpt" or warn "$src_rpt canont find";
open DST, ">./no_clock/$dst_rpt" or warn "$dst_rpt canont find";
open DST1, ">./no_clock/$dst_rpt1" or warn "$dst_rpt1 canont find";
open DST2, ">./no_clock/$dst_rpt2" or warn "$dst_rpt2 canont find";

while (<SRC>) {
 chomp;
 if (/Start points/) {
  $t = $_;
 } elsif (/Warning: (.*dft_gasket_housing.*)/) {
  print DST1 "$_\n";
  print DST1 "$t\n";
 } elsif (/Warning: (.*tile_dfx.*)/) {
  print DST2 "$_\n";
  print DST2 "$t\n";
 } else {
  print DST "$_\n";
  print DST "$t\n";
 }
}
