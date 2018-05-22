#!/usr/bin/perl -w
$tile_path = $ARGV[1];
$tile_name = $ARGV[0];
##start run
system "cp -rf $tile_path/rpts/DcDfpInsert/DcDfpInsert.postwaived.rpt.gz ./dfp/$tile_name.postwaived.rpt.gz";
open (SRC, "gzip -cd ./dfp/$tile_name.postwaived.rpt.gz |") or die;
open DST, "> ./dfp/$tile_name.csv" or die;
open DST1, ">> ./dfp/err.list" or die;
#print DST "name,'w/r',number,waiveed\n";
while (<SRC>) {
chomp;
 if (/^(\S+): Severity: (\w+)\s*.*\(Occurrence: (\d+) Remaining, (\d+) Waived Out of (\d+)/) {
 print "$_\n";
 $next_line = 1;
 $name = $1;
 $ser = $2;
 $number = $5;
 $waive = $4;
 if ($name =~ /MV-/) {
 print DST "Sharon,$name,$ser,$number,$waive,";
 } elsif ($name =~ /(TIM)|(NO_INPUT_DELAY)|(UNCONSTRAINED_ENDPOINTS)/) {
 print DST "Jack,$name,$ser,$number,$waive,";
 print DST1 "Jack,$name,$ser\n";
 } elsif ($name =~ /(VO)|(DONT)|(NO_CLOCK)-/) {
 print DST "Xixun,$name,$ser,$number,$waive,";
 print DST1 "Xixun,$name,$ser\n";
 } else {
 print DST "Lib,$name,$ser,$number,$waive,";
 print DST1 "Lib,$name,$ser\n";
 }
 } elsif ($next_line == 1) {
 print DST "$_\n";
 $next_line = 0;
 }
}

close SRC;
close DST;
close DST1;

&remove_rebundant("./dfp/err.list", "./dfp/err.list.csv");

open SRC, "./dfp/$tile_name.csv" or die;
open DST, "> ./dfp/$tile_name.final.csv" or die;
@lines = <SRC>;
@lines = sort @lines;
print DST "owner,name,'w/r',number,waiveed\n";
foreach $line (@lines) {
 print DST "$line";
}

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

unlink "./dfp/$tile_name.csv";
