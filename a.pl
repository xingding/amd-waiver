#!/usr/bin/perl -w
  $src = $ARGV[0];
  $sort = $ARGV[1];
  $dst = $ARGV[2];
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
   %ha = {};
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
 } elsif (!($line =~ /^\s*$/))  {
  @clock_value = split /\s+/, $line;
  $ha{$clock_value[0]} = $clock_value[1];
  }
}
close SRC;
close SORT;
open SRC, "$src";
open SORT, "$sort";
 while (<SRC>) {
  chomp;
  $line = $_;
 if($line =~ /Path Group	 TNS/) {
   $flag = 1;
   %ha = {};
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
  last;
 } elsif (!($line =~ /^\s*$/))  {
  @clock_value = split /\s+/, $line;
  $ha{$clock_value[0]} = $clock_value[1];
  }
}

close SRC;
close SORT;
#close DST;
open SRC, "$src";
open SORT, "$sort";
$flag = 0;
 while (<SRC>) {
  chomp;
  $line = $_;
 if($line =~ /Path Group	 TNS/) {
   $flag = 1;
   %ha = {};
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
  last;
 } elsif ($flag && (!($line =~ /^\s*$/)))  {
  @clock_value = split /\s+/, $line;
  $ha{$clock_value[0]} = $clock_value[1];
  }
}

close SRC;
close SORT;
close DST; 

