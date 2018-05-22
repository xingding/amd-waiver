#!/usr/bin/perl -w
$org_file = $ARGV[0];
$dst_file = $ARGV[0].'.tmp.txt';
open ORG,"$org_file" or die $!;
open DST,">$dst_file" or die $!;
##%area;
print DST "USB0,flopCount,totalCellCount,sequCount,combCount,RAMCount,MACROCount,totalCellArea,".
"nonCombArea,combArea,memoryArea,macroArea,stdCellArea\n";
foreach (<ORG>) {
  chomp;
  if(/module:\s+(.*)/) {
    ##$area[module] = $1;
    print DST "$1,";
  } elsif (/flopCount:\s+(.*)/) {
    print DST "$1,";
  } elsif (/totalCellCount:\s+(.*)/) {
    print DST "$1,";
  } elsif (/sequCount:\s+(.*)/) {
    print DST "$1,";
  } elsif (/combCount:\s+(.*)/) {
    print DST "$1,";
  } elsif (/RAMCount:\s+(.*)/) {
    print DST "$1,";
  } elsif (/MACROCount:\s+(.*)/) {
    print DST "$1,";
  } elsif (/totalCellArea:\s+(.*)/) {
    print DST "$1,";
  } elsif (/nonCombArea:\s+(.*)/) {
    print DST "$1,";
  } elsif (/combArea:\s+(.*)/) {
    print DST "$1,";
  } elsif (/memoryArea:\s+(.*)/) {
    print DST "$1,";
  } elsif (/macroArea:\s+(.*)/) {
    print DST "$1,";
  } elsif (/stdCellArea:\s+(.*)/) {
    print DST "$1\n";
  } elsif (/the summary of :/) {
    print DST "summary,";
  }
}

close DST;
open  TMP,"$dst_file" or die $!; ###rearray
$final_file = $ARGV[0].'.csv';
open  DST,">$final_file" or die $!; ###rearray
while (<TMP>) {
  chomp;
  @words = split(/,/,$_);
  $tmp = $words[2];
  $words[2] = $words[1];
  $words[1] = $tmp;
  $intent = join ",",@words;
  print DST "$intent\n";
}
close TMP;
close DST;
