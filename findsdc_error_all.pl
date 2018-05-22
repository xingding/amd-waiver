#!/usr/bin/perl -w
use File::Basename;
$tag = "$ARGV[0]";
$src_dir = "$ARGV[1]";
$tmp_file = "$tag.sdc.error";
$tmp_file1 = "$tag.port.error";
$tmp_file2 = "$tag.all.error";
$dst = "$tag.sdc.error.final";
$dst1 = "$tag.port.error.final";
$dst2 = "$tag.all.error.final";
if (-e "$src_dir/rpts/DgSynthesize/DgSynthesize.sourceSdc.rpt.gz") {
 open SRC, "gzip -cd $src_dir/rpts/DgSynthesize/DgSynthesize.sourceSdc.rpt.gz |" or die "cannot find $src_dir/rpts/DgSynthesize/DgSynthesize.sourceSdc.rpt.gz\n";
} else {
 open SRC, "$src_dir/rpts/DgSynthesize/DgSynthesize.sourceSdc.rpt" or die "cannot find $src_dir/rpts/DgSynthesize/DgSynthesize.sourceSdc.rpt\n";
}
open TMP, "> ./sdc_all/$tmp_file";
open TMP_PORT, "> ./sdc_all/$tmp_file1";
open TMP_ALL, "> ./sdc_all/$tmp_file2";
$i = 0;
$sdc_name = "";
while (<SRC>) {
 chomp;
 $i++;
 if (/^(\s)?Info: Begin to source file:.*sdc$/) {
  $sdc_name = basename $_; ##obtain sdc name
  $fire = 1;
  print TMP_ALL "$i: $_\n";
 } elsif (/^(\s)?Info: End of(.*)\/$sdc_name$/) {
  $fire = 0;
  print TMP_ALL "$i: $_\n";
 } elsif (/Warning: Can't find clock '(.*)' in design/) {
  print TMP "$1\n";
  print TMP_ALL "$i: $_\n";
 } elsif (/Warning: Can't find port '(.*)' in design/) {
  print TMP_PORT "$1\n";
  print TMP_ALL "$i: $_\n";
 } elsif (/Warning: Can't find/) {
  print TMP_ALL "$i: $_\n";
} elsif (/^ERROR:/i) {
  print TMP_ALL "$i: $_\n";
}
}
close SRC;
close TMP;
close TMP_PORT;
close TMP_ALL;
&remove_rebundant("./sdc_all/$tmp_file", "./sdc_all/$dst");
&remove_rebundant("./sdc_all/$tmp_file1", "./sdc_all/$dst1");
#&remove_rebundant("./sdc_all/$tmp_file2", "./sdc_all/$dst2");
&remove_useless_info ("./sdc_all/$tmp_file2", "./sdc_all/$dst2");

unlink "./sdc_all/$tmp_file", "./sdc_all/$tmp_file1", "./sdc_all/$tmp_file2";


sub remove_rebundant {
open SRC, "./$_[0]" or die; #srouce file before rebundant.
open DST, "> ./$_[1]" or die; #dst file after rebundant.
%ha = ();
while (<SRC>) {
  chomp;
  $ha{$_} = 1;
}

@clk_group= sort keys %ha;
foreach  (@clk_group) {
 print DST "$_\n";
}

close SRC;
close DST;
}

$flag = 0;
$sdc = "";
$sdc_name = "";
sub remove_useless_info {
 $i = 0;
 open SRC, "./$_[0]" or die; #srouce file before rebundant.
 open DST, "> ./$_[1]" or die; #dst file after rebundant.
 while (<SRC>) {
  chomp;
  if (/Info: Begin to source file:.*sdc$/) {$sdc_name = basename $_; $flag = 1; $sdc = $_; print "$sdc_name\n";}
  elsif (/Info: End of(.*)\/$sdc_name$/) {
    if($flag == 0) {
     print DST "$_\n";
     } 
  } elsif (/(Error) || (Warning)/ && ($flag == 1)) {
   $flag = 0;
   print DST "$sdc\n";
   print DST "$_\n";
  } else {
   print DST "$_\n";
  }
 }
 close SRC;
 close DST;
}
