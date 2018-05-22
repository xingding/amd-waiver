#!/usr/bin/perl -w
#usage : input_sdc.pl list clk_name ratio clock_period 
$src = $ARGV[0];
$height = $ARGV[2];
#$period = $ARGV[3];
#$port_direction = $ARGV[4];

open SRC, "$src" or warn "the list file dont exist\n";
open DST, "> ./dst" or warn "the dst file dont exist\n";
while (<SRC>) {
 chomp;
 if (/input: (.*?)\s+(.*?)\s+(.*)/) {
  $period = $3;
  $clk = $2;
  $port = $1;
  print DST "set_input_delay \[expr $height \* $period\] -clock $clk -add_delay -network_latency_included -source_latency_included \[get_ports \{$port\}\]";
 } elsif (/output: (.*?)\s+(.*?)\s+(.*)/) {
  print DST "set_output_delay \[expr $height \* $period\] -clock $clk -add_delay -network_latency_included -source_latency_included \[get_ports \{$port\}\]";
 } else {
  print "Error format...";
 }
 print DST "\n";
}
