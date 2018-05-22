#!/usr/bin/perl -w
$tile_path = $ARGV[1];
$tile_name = $ARGV[0];
##start run
system "cp -rf $tile_path/rpts/DgSynFinalRpt/DgSynFinalRpt.postwaived.rpt.gz ./syn_rpt/$tile_name.postwaived.rpt.gz";
open (SRC, "gzip -cd ./syn_rpt/$tile_name.postwaived.rpt.gz |") or die;
open DST, "> ./syn_rpt/$tile_name.csv" or die;
open DST1, ">> ./syn_rpt/err.list" or die;
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
 print DST "Haiping,$name,$ser,$number,$waive,";
 } elsif ($name =~ /(TIM)|(NO_INPUT_DELAY)|(UNCONSTRAINED_ENDPOINTS)/) {
 print DST "Jack,$name,$ser,$number,$waive,";
 print DST1 "Jack,$name,$ser\n";
 } elsif ($name =~ /(VO)|(DONT)|(NO_CLOCK)-/) {
 print DST "Dean,$name,$ser,$number,$waive,";
 print DST1 "Dean,$name,$ser\n";
 } else {
 print DST "SOC,$name,$ser,$number,$waive,";
 print DST1 "SOC,$name,$ser\n";
 }
 } elsif ($next_line == 1) {
 print DST "$_\n";
 $next_line = 0;
 }
}

close SRC;
close DST;
close DST1;

&remove_rebundant("./syn_rpt/err.list", "./syn_rpt/err.list.csv");

open SRC, "./syn_rpt/$tile_name.csv" or die;
open DST, "> ./syn_rpt/$tile_name.final.csv" or die;
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

unlink "./syn_rpt/$tile_name.csv";
