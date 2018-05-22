#!/usr/bin/perl -w
$tile = $ARGV[0];
$dir =  $ARGV[1];
if(-d 'dc_hier_area') {
} else {
mkdir 'dc_hier_area';
}
$src_file = "$dir/rpts/DgSynFinalRpt/DgSynFinalRpt.rpt.gz";
$dst_file = "./dc_hier_area/$tile.xls";
#$dst_file = "$tile.csv";
open SRC, "gzip -cd $src_file |" or die "can not open $src_file";
open DST, "> $dst_file";
while (<SRC>) {
 chomp;
 if (/Hierarchical area distribution/) {
 $begin = 1;
 print "beginto deal\n";
 } elsif ($begin && (/^Total\s+\d+/))  {
 print "end deal\n";
 last;
 } elsif (($begin) && (/\w+\s+\d+/)) {
  #&extract_area($_);
  $line = $_;
  @area = split (/\s+/,$line);
  #print "$area[0] $area[1]\n";
  unless($area[0] =~ /\//) {
  print DST "$area[0]\t";
  print DST "$area[1]\n";
}
}
}

