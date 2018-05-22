#!/usr/bin/perl -w
use File::Basename;
$tag = "$ARGV[0]";
$src_dir = "$ARGV[1]";

if (-e "$src_dir/logs/DgSynthesize.log.gz") {
 open SRC, "gzip -cd $src_dir/logs/DgSynthesize.log.gz |" or exit "cannot find $src_dir/logs/DgSynthesize.log.gz\n";
} else {
 open SRC, "$src_dir/logs/DgSynthesize/DgSynthesize.log" or exit "cannot find $src_dir/logs/DgSynthesize.log\n";
}
open DST , ">> ./time/time.csv";
@lines = <SRC>;
($be,$end) = @lines[0 , -1];
#print DST "$be" ;
#print DST "$end";
($be_day, $be_h) = (split / /, $be)[3,4];
($end_day, $end_h) = (split / /, $end)[3,4];
($be_h, $be_m) = (split /:/, $be_h)[0,1];
($end_h, $end_m) = (split /:/, $end_h)[0,1];
&CAL;
close SRC;
close DST;
sub CAL {
 $dec_day = $end_day - $be_day;
 $end_h = 24 * $dec_day + $end_h;
 if ($end_m < $be_m) {$final_m = $end_m + 60 - $be_m; $end_h--}
 else {$final_m = $end_m - $be_m;}
 $final_h = $end_h - $be_h;
print DST "$tag,$final_h hours $final_m minutes\n";
}
