#!/usr/bin/perl -w
#$src = $ARGV[0];
open SRC, "<clk.final" or die "cannot open clk.final";
open DST, ">group" or die "cannot open group";

while (<SRC>) {
 chomp;
 if (/set\s+(\S+)\s+/) {
 print DST "set_clock_groups -asynchronous -group \$$1\n";
 }
}
