#!/usr/bin/perl -w
###plase first config this perl, then run perl
### config begin ###
$dst_tag =  "$ARGV[0]";
##please dst0-- phy, dst1-- vdci, dst2-- s5, dst3-- s0
#$dst[0] = '/proj/kaifeng_feint/usb/supra_regr/usb_regr_sms_nopower_1027/main/pd/tiles/usb0_phy_t_kf_syna_sms_1027_TileBuilder_Oct27_1625_26294_kf_syna_sms_1027/';
#$dst[1] = '/proj/kaifeng_feint/usb/supra_regr/usb_regr_sms_nopower_1027/main/pd/tiles/usb0_vdci_t_kf_syna_sms_1027_TileBuilder_Oct27_1625_26294_kf_syna_sms_1027/';
#$dst[2] = '/proj/kaifeng_feint/usb/supra_regr/usb_regr_sms_nopower_1027/main/pd/tiles/usb0_s5_t_kf_syna_sms_1027_TileBuilder_Oct27_1625_26294_kf_syna_sms_1027/';
#$dst[3] = '/proj/kaifeng_feint/usb/supra_regr/usb_regr_sms_nopower_1027/main/pd/tiles/usb0_s0_t_kf_syna_sms_1027_TileBuilder_Oct27_1625_26294_kf_syna_sms_1027/';

$dst[0] = "$ARGV[1]";
$dst[1] = "$ARGV[2]";
$dst[2] = "$ARGV[3]";
$dst[3] = "$ARGV[4]";
### config end ###

$rpt_name = '/rpts/DgSynFinalRpt/DgSynFinalRpt_post.dat';
#$rpt_name = '/rpts/DgSynFinalRpt/DgSynFinalRpt.dat';

open DATA, "> ./area/syn_data.$dst_tag";
open TIM, "> ./area/timing.$dst_tag.txt";

foreach $_ (@dst) {
open RPT, "$_$rpt_name" or warn "cannot open $_$rpt_name: $!";
while (<RPT>) {
  chomp;
  if(/totalCellCount/) {
   print DATA "$_\n";
  } elsif(/sequCount/) {
     print DATA "$_\n"; 
  } elsif(/combCount/) {
     print DATA "$_\n"; 
  } elsif(/RAMCount/) {
     print DATA "$_\n"; 
  } elsif(/MACROCount/) {
     print DATA "$_\n"; 
  } elsif(/totalCellArea/) {
     print DATA "$_\n"; 
  } elsif(/nonCombArea/) {
     print DATA "$_\n"; 
  } elsif(/combArea/) {
     print DATA "$_\n"; 
  } elsif(/memoryArea/) {
     print DATA "$_\n"; 
  } elsif(/macroArea/) {
     print DATA "$_\n"; 
  } elsif(/stdCellArea/) {
     print DATA "$_\n"; 
  } elsif(/flopCount/) {
     print DATA "$_\n"; 
  } elsif(/module: /) {
     print DATA "$_\n";
     print TIM "$_\n";
  } elsif(/macro: /) {
     print DATA "$_\n";
  } elsif(/costGroup: (\S+) (\S+) (\S+)/) {
     print TIM "$1 $2 $3\n";
  }
}
}

close TIM;

##calculate sum##
close DATA;
open DATA, "./area/syn_data.$dst_tag";
my $t_flopCount = 0;
my $t_totalCellCount = 0;
my $t_sequCount = 0;
my $t_combCount = 0;
my $t_RAMCount = 0;
my $t_MACROCount = 0;
my $t_totalCellArea = 0;
my $t_nonCombArea = 0;
my $t_combArea = 0;
my $t_memoryArea = 0;
my $t_macroArea = 0;
my $t_stdCellArea = 0;
while(<DATA>) {
  if(/flopCount: (.*)/) {
    $t_flopCount =  $t_flopCount + $1;
  } elsif (/totalCellCount: (.*)/) {
     $t_totalCellCount = $t_totalCellCount + $1;
  } elsif (/sequCount: (.*)/) {
     $t_sequCount = $t_sequCount + $1;
  } elsif (/combCount: (.*)/) {
     $t_combCount = $t_combCount + $1;
  } elsif (/RAMCount: (.*)/) {
     $t_RAMCount = $t_RAMCount + $1; 
  } elsif (/MACROCount: (.*)/) {
     $t_MACROCount = $t_MACROCount + $1;
  } elsif (/totalCellArea: (.*)/) {
     $t_totalCellArea = $t_totalCellArea + $1;
  } elsif (/nonCombArea: (.*)/) {
     $t_nonCombArea = $t_nonCombArea + $1;
  } elsif (/combArea: (.*)/) {
     $t_combArea = $t_combArea + $1;
  } elsif (/memoryArea: (.*)/) {
     $t_memoryArea = $t_memoryArea + $1;
  } elsif (/macroArea: (.*)/) {
     $t_macroArea = $t_macroArea + $1;
  } elsif (/stdCellArea: (.*)/) {
     $t_stdCellArea = $t_stdCellArea + $1;
  }
}

close DATA;
open DATA, ">>./area/syn_data.$dst_tag";
print DATA "the summary of : \n";
print DATA "\n";
print DATA "t_flopCount: $t_flopCount\n";
print DATA "totalCellCount: $t_totalCellCount\n";
print DATA "sequCount: $t_sequCount\n";
print DATA "combCount: $t_combCount\n";
print DATA "RAMCount: $t_RAMCount\n";
print DATA "MACROCount: $t_MACROCount\n";
print DATA "totalCellArea: $t_totalCellArea\n";
print DATA "nonCombArea: $t_nonCombArea\n";
print DATA "combArea: $t_combArea\n";
print DATA "memoryArea: $t_memoryArea\n";
print DATA "macroArea: $t_macroArea\n";
print DATA "stdCellArea: $t_stdCellArea\n";

close DATA;
###change syn_data format for easy to translate to EXCEL
eval `./script/change_format.pl ./area/syn_data.$dst_tag`;
unlink "./area/timing*";
unlink "./area/*tmp*";
