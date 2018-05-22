#!/usr/bin/perl -w
##config vars
@tile_list = (usb0_s0,usb1_s0,usb1_phy,usb0_phy);
$tag_date = 1207;
$dir = '/proj/kaifeng_feint/usb/supra/kfNlbRelPaV1p2_dec02/main/pd/tiles/usb0_s0_t_kfNlbRelPav1p2_dec02_TileBuilder_Dec02_1613_17633_GUI';
system "mkdir $tag_date";
foreach $tile (@tile_list){
$tag = "${tile}_${tag_date}";
$dir =~ s#(usb[01]_.*?_t)#${tile}\_t#;
print "$dir\n";
$rpt_dir = $dir;
##start run
system "cp -rf $rpt_dir/rpts/PtPreTimSynthesizett0p65v0cPretimingStp/qor_fch.rpt.gz ./";
system "gunzip qor_fch.rpt.gz";
system "mv qor_fch.rpt $tag.qor.rpt";
open SRC, "$tag.qor.rpt" or die;
open DST, "> ./$tag_date/$tag.qor.sum" or die;

while (<SRC>) {
 chomp;
 #print DST "$_\n" if (/Startpoint|Endpoint|Path Group|Path Type|clock|data required time|slack.*-/);
 if (/.*?max_delay\/setup/) {
    @slack = split /\s+/;
    print DST "$_\n" if($slack[4] < 0);
 } elsif (/.*?min_delay\/hold/) {
    @slack = split /\s+/;
    print DST "$_\n" if($slack[4] < -200);
 } elsif (/(Critical Path|Group|----------------------------------------------------------------------------------------------------------------------)/){
    print DST "$_\n";
 }
}
close SRC;
close DST;

######### timing filter##############
 if($tile eq "usb1_phy") {
  system ("check_setup.pl $tile $tag_date ./$tag_date/$tag.qor.sum $rpt_dir");
 } elsif($tile eq "usb0_phy") {
  system ("check_setup.pl $tile $tag_date ./$tag_date/$tag.qor.sum $rpt_dir");
 }
}




