#!/usr/bin/perl -w
$tile = $ARGV[0]; ##module name 
$tag_date = $ARGV[1];
$tag = $ARGV[2];  ##clock summary rpt
$rpt_dir = $ARGV[3];##timing rpt directory

$vio_file = "${tile}_${tag_date}";
system "mkdir -p ./$tag_date/$vio_file";
open CLOCK, "$tag" or die $!;

while (<CLOCK>) {
 chomp;
 if(/^(.*?)\s+\(max_delay/) { ##grep clock name
  $clk_name = $1 ;
  system "cp -rf $rpt_dir/rpts/PtPreTimSynthesizett0p65v0cPretimingStp/${clk_name}_max.rpt.gz ./";
  print "${clk_name}_max.rpt.gz\n";
  system "gunzip ${clk_name}_max.rpt.gz";
  open SRC, "./${clk_name}_max.rpt" or die "can not open ${clk_name}_max.rpt, $!";
  open DST, ">./${clk_name}_max.vio.rpt" or die $!;
  open DST1, ">./${clk_name}_max.vio.non_pma.rpt" or die $!;
  while (<SRC>) {
   chomp;
   if (/(Startpoint\|Endpoint): (.*)/) {
     $start = $_;
     $pma = 0;
     if ($2 =~ /u_fch_usb_gen2phy_wrapper\/usb31typec_dft_gasket_housing_[01]\/u_dwc_usbc31dptxphy_upcs_x4_ns_x1_x4_pipe\/phy0\/pma/) {
     $pma = 1;
     }
   } 
   if ($pma == 0) {
    print DST,"$_\n";
   } 
  }
 system "mv ${clk_name}_max.rpt ${clk_name}_max.vio.rpt ${clk_name}_max.vio.non_pma.rpt ./$tag_date/$vio_file"; 
 }
}
