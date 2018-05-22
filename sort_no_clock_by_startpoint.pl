#!/usr/bin/perl -w
foreach (@ARGV) {
 chomp;
 open SRC, "./no_clock/$_" or die "the file do not exist";
 open DST, ">./no_clock/$_.sortbystart" or die "the file do not exist";
 open DST1, ">./no_clock/$_.start" or die "the file do not exist";
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
}
