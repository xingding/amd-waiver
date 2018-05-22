#!/usr/bin/perl -w
$tile_path = $ARGV[1];
$tile_name = $ARGV[0];
##start run
system "cp -rf $tile_path/rpts/DgDesignChecks/DgDesignChecks.postwaived.rpt.gz ./dg_check/$tile_name.postwaived.rpt.gz";
open (SRC, "gzip -cd ./dg_check/$tile_name.postwaived.rpt.gz |") or die;
open DST, "> ./dg_check/$tile_name.csv" or die;
open DST1, ">> ./dg_check/err.list" or die;
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

&remove_rebundant("./dg_check/err.list", "./dg_check/err.list.csv");

open SRC, "./dg_check/$tile_name.csv" or die;
open DST, "> ./dg_check/$tile_name.final.csv" or die;
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

unlink "./dg_check/$tile_name.csv";

&waive ("./dg_check/$tile_name.postwaived.rpt.gz", "./dg_check/$tile_name.waive");
system "sort -u ./dg_check/$tile_name.waive > ./dg_check/$tile_name.tmp.waive";
unlink "./dg_check/$tile_name.waive";
rename "./dg_check/$tile_name.tmp.waive" , "./dg_check/$tile_name.waive";

sub waive {
 $src = $_[0];
 $dst = $_[1];
 open (SRC, "gzip -cd $src |") or die;;
 open DST, ">$dst";
 while (<SRC>) {
  chomp;
  $p_con = '.*';
  $j = 0;
  $line = $_;
  if($line =~ /^\s+(LINT-\d+):(.*)/) {
    $tag1 = $1;
    $content = $2;
    $content =~ s/\[\d+\]/\.\*/g;
    @content = split /\'/, $content;
    foreach $key (@content) {
     if ($j%2) {
      $p_con = "$p_con"."$key".'.*';
     }
     $j++;
    }
    $p_con =~ s/\.\*\.\*/\.\*/g;
    $p_con =~ s/\.\*input//g;
    $p_con =~ s/\.\*output//g;
    $p_con =~ s/\.\*port//g;
     print DST "DgDesignChecks WAIVE dixi all $tag1 $p_con\n";
    } elsif ($line =~ /^\s+(LATCH):Found latch (\S+)/) {
    $tag1 = $1;
    $content = $2;
    print DST "DgDesignChecks WAIVE dixi all $tag1 .*$content.*\n";
    } elsif ($line =~ /^\s+(UNCONSTRAINED_ENDPOINTS):(\S+)/) {
    $tag1 = $1;
    $content = $2;
    print DST "DgDesignChecks WAIVE dixi all $tag1 .*$content.*\n";
    } elsif ($line =~ /^\s+(.*?):/) {
    $tag1 = $1;
    print DST "DgDesignChecks WAIVE dixi all $tag1 \.\*\n";
    }
 }
 close SRC;
 close DST;
}
