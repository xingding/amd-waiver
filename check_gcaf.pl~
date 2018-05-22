#!/usr/bin/perl -w
#@tile_list = (usb0_s0,usb1_s0,usb1_phy,usb0_phy);
#@tile_list = (usb0_s0,usb1_s0,usb0_phy,usb1_phy);
$tile = $ARGV[0];
$tag_date = $ARGV[1];
$piority = 0;
$dir = $ARGV[2];
$tag = "${tile}_${tag_date}";
#$dir =~ s#(usb[01]_.*?_t)#${tile}\_t#;
print "$dir\n";
$rpt_dir = $dir;
##start run
system "cp -rf $rpt_dir/rpts/GcSynthesizeCheckSdc/GcSynthesizeCheckSdc.postwaived.rpt.gz ./gca";
system "gunzip ./gca/GcSynthesizeCheckSdc.postwaived.rpt.gz";
system "mv ./gca/GcSynthesizeCheckSdc.postwaived.rpt ./gca/$tag.gca.rpt";
open SRC, "./gca/$tag.gca.rpt" or warn;
open DST, "> ./gca/$tag.gca.txt" or die;
open ERR, "./script/Error_info_sort" or die;
open TODE, "> ./gca/${tag}.2de" or die; ##every error has an example, release to designer
open CLK, "> ./gca/${tag}.clk" or die; ##every error has an example, release to designer
open NONCLK, "> ./gca/${tag}.noclk" or die; ##every error has an example, release to designer
@err = <ERR>; ##open error list
close ERR;
@err_list = "";
foreach (@err) {
 if ($piority == 1) {
   if (/P1\s+(.*?)(\s+)/) {
   push @err_list,$1;
   }
 } elsif ($piority == 2) {
    if (/P[1-2]\s+(.*?)(\s+)/) {
    push @err_list,$1;
    }
 } elsif ($piority == 3) {
    if (/P[1-3]\s+(.*?)(\s+)/) {
    push @err_list,$1;
    }
 } elsif ($piority == 4) {
    if (/P[1-4]\s+(.*?)(\s+)/) {
    push @err_list,$1;
    }
 } elsif ($piority == 5) {
    if (/P[1-5]\s+(.*?)(\s+)/) {
    push @err_list,$1;
    }
 } elsif ($piority == 0) {
   last; 
    }
} ##get Error pattern name
print "@err_list\n";
while (<SRC>) {
 chomp;
 $line = $_;
 #@err_list_bak = @err_list;
 s/^\s+//g;##remove the null at the begin of line
 @err_type = split /:/; ##extract the error type
 #@err_type_bak = @err_type;
if ($piority == 0) {
   push @err_list,$err_type[0];
  }
  @err_list_bak = @err_list;
 if ($line =~ /^\s*((CLK)|(CGR))/) {
 print CLK "$line\n";
 } else {
  print NONCLK "$line\n";
 }
 foreach (@err_list_bak) {
   if(/$err_type[0]/s) {
   print DST  "@err_type\n";
   last;
   }
   }
   if($line =~ /([A-Z]+_[0-9]+:\s+)|([A-Z]+_[0-9]+:1 of )/) {
   print TODE "$line\n";
   }
 }
 close SRC;
 close DST;
 close TODE;
 close CLK;
 close NONCLK;

open TODE, "./gca/${tag}.2de" or die; ##every error has an example, release to designer
open TODE_F, "> ./gca/${tag}.2de.final" or die; ##every error has an example, release to designer
@lines = <TODE>;
foreach (@lines) {
 chomp;
 if (/^(\s)*(CLK)|(CGR)/) {
  print TODE_F "$_\n";
  }
}
close TODE;
close TODE_F;
#system "grep CLK\|CGR ./gca/${tag}.2de > ./gca/${tag}.2de.final";
&waive ("./gca/$tag.gca.txt", "./gca/$tag.waive");
system "sort -u ./gca/$tag.waive > ./gca/$tag.final.waive";
unlink "./gca/$tag.waive";

sub waive {
 $src = $_[0];
 $dst = $_[1];
 open SRC, "$src" or die;
 open DST, ">$dst";
 while (<SRC>) {
  chomp;
  $p_con = '.*';
  $j = 0;
  $line = $_;
  if($line =~ /([A-Z]+_[0-9]+)\s\d+ of \d+\s+(.*)/) {
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
    if ($line =~ /(sdc.gz)|(set_timing_derate)|(design)/) {
     print DST "GcSynthesizeCheckSdc WAIVE dixi all $tag1 .*\n";
    } else {
     print DST "GcSynthesizeCheckSdc WAIVE dixi all $tag1 $p_con\n";
    }
  }
 }
 close SRC;
 close DST;
}
