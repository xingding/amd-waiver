#!/usr/bin/perl -w
#usage : input_sdc.pl io.sdc ./port_file 
$src_sdc = $ARGV[0];
$vio_port = $ARGV[1];

open SRC, "$src_sdc" or warn "the sdc list file dont exist\n";
open PORT, "$vio_port" or warn "the port list file dont exist\n";
open DST, "> ./dst" or warn "the dst file dont exist\n";
open DST1, "> ./port" or warn "the dst file dont exist\n";
open DST2, "> ./change" or warn "the dst file dont exist\n";
@port_list = ();
while (<PORT>) {
 chomp;
 if (/port : (\S+)/) {
 push @port_list, $1;
 } elsif (/put\s*: (\S+)/) {
 push @port_list, $1;
 }
}
   print DST1 "@port_list\n";
while (<SRC>) {
 chomp;
 $sdc = $_;
 if ($sdc =~ /-max.*get_ports \{(.*)\}/) {
 $port = $1;
   #print DST1 "$port\n";
 if ($port ~~ @port_list) {
   $sdc =~ s/1\.5/0\.6/;
   print DST1 "$port\n";
 print DST2 "$sdc\n"; 
   }
  } elsif ($sdc =~ /-clock \S+ -add_delay -network_latency_included -source_latency_included \[get_ports \{(.*)\}/) {
 $port = $1;
   #print DST1 "$port\n";
 if ($port ~~ @port_list) {
   $sdc =~ s/1\.5/0\.6/;
   print DST1 "$port\n";
 print DST2 "$sdc\n"; 
   }
  }
 print DST "$sdc\n"; 
 }
