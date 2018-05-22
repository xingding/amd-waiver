#!/usr/bin/perl -w
$xml = $ARGV[0];
$clock_list = $ARGV[1];
$pat_name = $ARGV[2];
if(@ARGV != 3) {
die "usage: please indicate src_file, clock_list_file,module name\n";
}
unlink "insdc_inxml","insdc_notinxml","tmp","inxml_notinsdc";
open SRC, "<$xml" or die $!;
open CLOCK, "<$clock_list" or die $!;
open DST1, ">insdc_inxml" or die $!;
open DST2, ">insdc_notinxml" or die $!;
open TMP, ">tmp" or die $!; ##xml clock group
open DST3, ">inxml_notinsdc" or die $!;
$clk_name = " ";
while(<SRC>) {
  chomp;
  if (/tile name="$pat_name"/) {
    print TMP "$clk_name\n";
  } elsif (/clock name="([_a-zA-Z0-9]+)"/) {
    $clk_name = $1;
  }
}

close TMP;
open TMP, "tmp" or die $!; ##read xml clock_group
my %sdc_clk ={};
while (<CLOCK>) {
 chomp;
 $sdc_clk{$_} = 0;
}
while (<TMP>) {
 chomp;
 if (defined $sdc_clk{$_}) {
  print DST1 "$_\n"; ##both in
  $sdc_clk{$_} = 1; ## hash valus is 1
 } else {
  print DST3 "$_\n"; ## in xml not in sdc
 }
}

foreach (keys %sdc_clk) {
if (defined $sdc_clk{$_} &&($sdc_clk{$_}==0)) {
  print DST2 "$_\n"; ## in sdc not in xml
 }
}
