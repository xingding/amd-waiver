#!/usr/bin/perl -w
$input_file = $ARGV[0];
open IN_FILE ,"./no_clock/$input_file" or die "cannot find $input_file file: $!";
open OUT_FILE ,">./no_clock/$input_file.waive" or die $!;
open OUT_FILE1 ,">./no_clock/$input_file.phy_p.waive" or die $!;
my $t;
while(<IN_FILE>) {
  chomp;
  if($_ =~ /Start points: PHY_REF_CLK_P/ ) {
    print OUT_FILE1 "##$_\n";
    print OUT_FILE1 "DgSynFinalRpt WAIVE xguo1 all NO_CLOCK \.\*"."$t"."\.\*"."\n";
  } elsif ($_ =~ /Start points:/) {
    print OUT_FILE "##double_check $_\n";
    print OUT_FILE "DgSynFinalRpt WAIVE xguo1 all NO_CLOCK \.\*"."$t"."\.\*"."\n";
  }
  $t = $_;
  if($t =~ /Warning: (.*) has no clock/) { 
 # print "$t\n";
 $t = $1;
 }
 $t =~ s/\//\\\//g;
}
