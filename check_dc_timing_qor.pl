#!/usr/bin/perl -w
$tile = $ARGV[0];
$dir =  $ARGV[1];
$src_file = "$dir/rpts/DgSynFinalRpt/qor.csv.gz";
$dst_file = "./dc_tim_qor/$tile.xls";
$dst_file_all = "./dc_tim_qor/$tile.all.xls";
$dst_file_h = "./dc_tim_qor/$tile.hold.xls";
system "cp -rf $src_file ./dc_tim_qor/$tile.csv.gz";
open SRC, "gzip -cd $src_file |" or die "can not open $src_file";
open DST, "> $dst_file";
open DST_H, "> $dst_file_h";
open DST_ALL, "> $dst_file_all";

@clk_name = ();
while (<SRC>) {
 chomp;
 @tim = split /,/;
 if($tim[0] =~ /Summary/) {
 print DST "\n\n";
 print DST_H "\n\n";
 print DST_ALL "\n\n";
 last;
 }
 elsif (!($tim[0] =~ /((I2C)|(C2O)|(TO_GCLK)|(I2O))/)) {
 print DST "$tim[0]\t";
 print DST "$tim[1]\n";
 print DST_ALL "$tim[0]\t";
 print DST_ALL "$tim[1]\n";
 print DST_H "$tim[0]\t";
 print DST_H "$tim[5]\t";
 print DST_H "$tim[6]\n";
 if (!($tim[0] =~ /Path Group/)) {
 push @clk_name,$tim[0];
 }
 } else {
 print DST_ALL "$tim[0]\t";
 print DST_ALL "$tim[1]\n";
 print DST_H "$tim[0]\t";
 print DST_H "$tim[5]\t";
 print DST_H "$tim[6]\n";

 }
}

#print DST "\n";
close SRC;
close DST;

open SRC, "gzip -cd $src_file |" or die "can not open $src_file";
open DST, ">> $dst_file";
while (<SRC>) {
 chomp;
 @tim = split /,/;
 if($tim[0] =~ /Summary/) {
 last;
 }
 elsif (!($tim[0] =~ /((I2C)|(C2O)|(TO_GCLK)|(I2O))/)) {
 print DST "$tim[0]\t";
 print DST "$tim[2]\n";
 }
}
print DST "\n";
close SRC;
close DST;
##check clock is full
$src_file = "$dir/rpts/DgSynFinalRpt/DgSynFinalRpt.clock_list.gz";
open SRC, "gzip -cd $src_file |" or die "can not open $src_file";
@clk_list = ();
while (<SRC>) {
  chomp;
  if(/(.*):/) {
  push @clk_list, $1;
  }
}
close SRC;

$src_file = "$dir/rpts/DgSynFinalRpt/DgSynFinalRpt.regsPerClock.rpt.gz";
open SRC, "gzip -cd $src_file |" or die "can not open $src_file";
#@empty_clock_list = ();
while (<SRC>) {
  chomp;
  if(/There are 0 registers driven by clock : (.*)/) {
  push @clk_name, $1;
  }
}
close SRC;

@clk_name = sort @clk_name; ##empty clock add tim clock
@clk_list = sort @clk_list; ##golden
if (@clk_name == @clk_list) 
{
 print "success: clock info is full...";
} else {
         $dst_file = "./dc_tim_qor/$tile.err";
         open DST, "> $dst_file";
         foreach (@clk_list) {
          @clk_name_bak = @clk_name;
          print DST "$_ miss\n" unless ($_ ~~ @clk_name_bak);
          }
        }
&arrange ("./dc_tim_qor/$tile.xls","./script/tim_qor/$tile","./dc_tim_qor/$tile.final.xls");
system "sed \'/HASH/d\'  ./dc_tim_qor/$tile.final.xls > ./dc_tim_qor/$tile.fin.xls";
#unlink "./dc_tim_qor/$tile.final.xls";
sub arrange {
  $src = $_[0];
  $sort = $_[1];
  $dst = $_[2];
 open SRC, "$src";
 open SORT, "$sort";
 open DST, ">$dst";
 #@sort = chomp <SORT>;
 while (<SORT>) {
  chomp;
  push @sort, $_;
 }
 while (<SRC>) {
  chomp;
  $line = $_;
 if($line =~ /Path Group	 WNS/) {
   $flag = 1;
   %ha = ();
   print DST "$_\n";
 } elsif ($line =~ /^\s*$/) {
   $flag = 0;
  foreach $key (@sort) {
   if(exists $ha{$key}) {
   print DST "$key\t$ha{$key}\n";
   delete $ha{$key};
   } else {
   print DST "$key\t\n";
   }
  }
  foreach $key (keys %ha) {
   print DST "$key\t$ha{$key}\n";
  }
   print DST "\n\n";
  last;
 } else  {
  @clock_value = split /\s+/, $line;
  $ha{$clock_value[0]} = $clock_value[1];
  }
}
close SRC;
close SORT;
open SRC, "$src";
open SORT, "$sort";
$flag = 0;
 while (<SRC>) {
  chomp;
  $line = $_;
 if($line =~ /Path Group	 TNS/) {
   $flag = 1;
   %ha = ();
   print DST "$_\n";
 } elsif ($flag && ($line =~ /^\s*$/)) {
   $flag = 0;
   print "matched\n";
  foreach $key (@sort) {
   if(exists $ha{$key}) {
   print DST "$key\t$ha{$key}\n";
   delete $ha{$key};
   } else {
   print DST "$key\t\n";
   }
  }
  foreach $key (keys %ha) {
   print DST "$key\t$ha{$key}\n";
  }
  print DST "\n";
  last;
 } elsif ($flag && (!($line =~ /^\s*$/)))  {
  @clock_value = split /\s+/, $line;
  $ha{$clock_value[0]} = $clock_value[1];
  }
}

close SRC;
close SORT;
close DST; 
}
