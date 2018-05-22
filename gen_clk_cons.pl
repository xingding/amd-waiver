#!/usr/bin/perl -w
#$src = $ARGV[0];
open SRC, "<clk.list" or die "cannot open clk.list";
open DST, ">clk.final" or die "cannot open clk.final";
@single = ();
$max = 1;
$clk = "";
$tag = "";
%ha = ();
while (<SRC>) {
 chomp;
 if(/(.*)\s+\\##(\d+)/) {
  $clk = $1;
  $tag = $2;
  $max = ($tag > $max) ? $tag : $max; ##max is the lasr index
  print "$1\t$2";
  print DST "$clk \\\n";
  #push @group_$tag, $clk;
  $ha{$tag} = "$ha{$tag}" . "$clk \\\n";
 } elsif (/(.*)\s+\\##single/){
  $clk = $1;
  print DST "$clk \\\n";
  push @single, $clk;
 } else {
  warn "$_ line dont match format...\n";
 }
}

foreach $_ (@single) {
 print DST "set_clock_groups -asynchronous -group \{$_\}\n";
}
print DST "\n\n";
foreach $_ (sort keys %ha) {
 print DST "set USB0_${_}_GROUP \[get_clocks \" \\\n";
 print DST "$ha{$_}";
 print DST "\"\]";
 print DST "\n";
}

