#!/usr/bin/perl -w
$src = $ARGV[0];
$target = $ARGV[1];
$issue = $ARGV[2];

open SRC, "$src" or warn "the list file dont exist\n";
open DST, "> ./dst" or warn "the dst file dont exist\n";
while (<SRC>) {
 chomp;
 if (/(.*)\[(\d+)\]/) {
 #print DST "$target WAIVE xguo1 all $issue \.\*$1\.\*\n";
 print DST "$target WAIVE xguo1 all $issue \.\*$1\\\[$2\\\]\.\*\n";
 } else {
 print DST "$target WAIVE xguo1 all $issue \.\*$_\.\*\n";
 }
}

#system "sort -u dst > ./dst.sort";
