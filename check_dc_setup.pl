#!/usr/bin/perl
$tag = $ARGV[0];
$rpt_dir = $ARGV[1];
system "cp -rf $rpt_dir/rpts/DgSynFinalRpt/DgSynFinalRpt.rpt.gz ./sta";
system "gunzip ./sta/DgSynFinalRpt.rpt.gz";
system "mv ./sta/DgSynFinalRpt.rpt ./sta/$tag.rpt";
open SRC, "./sta/$tag.rpt" or die;
open DST, "> ./sta/$tag.summary" or die;

while (<SRC>) {
 chomp;
 $line = $_;
 $print_en = 0;
 if (/Startpoint: (.*)/) {
   $fire = 1;
 } elsif (/slack \(MET\)/) {
   $fire = 0;
 } elsif  (/slack \(VIOLATED\)/) {
   $print_en = 1;
 }
 if($fire) {
  push @path, "$line\n";
 } else {
  @path = ();
 }
 if($print_en) {
  print DST "@path";
  print DST "\n";
  @path = ();
  $fire = 0;
 }
}

close SRC;
close DST;

open TMP, "./sta/$tag.summary" or die;
#open DST, "> ./sta/$tag.final" or die;
#open PMA, "> ./sta/$tag.pma" or die;
open PORT, "> ./sta/$tag.vio.port" or die;
open FUN, "> ./sta/$tag.fun" or die;
@tim_rpt = "";
while(<TMP>) {
 chomp;
 if(/Startpoint/) {
  @tim_rpt = ();
  push @tim_rpt, "$_\n";
  $fire = 1;
 } elsif (/slack/) {
  $fire = 0;
  push @tim_rpt, "$_\n";
  #if (!(($tim_rpt[0] =~ /Startpoint.*pma/)||($tim_rpt[1] =~ /pma/)||($tim_rpt[2] =~ /Endpoint.*pma/)||($tim_rpt[3] =~ /pma/))) {
   if (!(($tim_rpt[4] =~ /[IC]2[CO]/) || ($tim_rpt[3] =~ /[IC]2[CO]/))) {
   print FUN "@tim_rpt\n";
   print FUN "\n";
   } else {
   print PORT "@tim_rpt\n";
   print PORT "\n";
   } 
  } else {
  push (@tim_rpt, "$_\n") if($fire);
 }
}

close TMP;
#close DST;
#close PMA;
close PORT;
close FUN;

open PORT, "./sta/$tag.vio.port" or die "can not find ./sta/$tag.vio.port";
open PORTLIST, "> ./sta/$tag.vio.portlist" or die "can not find ./sta/$tag.vio.portlist";

&check_port_delay (*PORT , *PORTLIST);
&remove_rebundant("./sta/$tag.vio.portlist", "./sta/$tag.vio_portlist");
#unlink "./sta/$tag.vio.portlist";

##check port delay whtether is reason
sub check_port_delay {
 local (*SRC) = shift @_;
 local (*DST) = shift @_;
 $slack_en = 0;
 while (<SRC>) {
  chomp;
  $line = $_;
  if(/Startpoint: (.*)/) {
   $st = $1;
   $fall = 0;
   unless ($st ~~ /\//) {
    if ($st ~~ /(.*)\s\(/) { $stport = $1;}
    else {$stport = $st;}
   }
  }
  elsif (/Endpoint: (.*)/) {
   $et = $1;
   unless ($et ~~ /\//) {
    if ($et ~~ /(.*)\s\(/) { $etport = $1;}
    else {$etport = $et;}
   }
  }
  elsif (/Path Group: C2O/) {$output = 1; $input = 0;}
  elsif (/Path Group: I2C/) {$output = 0; $input = 1;}
  elsif (/Path Group: I2O/) {$output = 1; $input = 1;}
  elsif(/input external delay\s+(\d+\S+)\s/ && ($input == 1)) {
   $input_delay = $1;
   $input_delay_falg = 1; 
   } 
   elsif(/clock (\S+) .*edge(\S+)\s+(\d+\S+)\s/ && ($input_delay_falg == 1)) {
    $clock_cycle = $3;
    $input_delay_falg = 0;
    if(/clock (\S+) .*fall edge(\S+)\s+(\d+\S+)\s/)  {$fall = 1;}
    if (($fall == 0) &&($input_delay/$clock_cycle >= 0.6)) {
     print DST "input port : $stport\tdelay: $input_delay clock_cycle: $clock_cycle\t";
     $slack_en = 1;
     print "input port : $stport\tdelay: $input_delay clock_cycle: $clock_cycle\n";
     } elsif (($fall == 1) &&($input_delay/$clock_cycle >= 0.3)) {
     print DST "input port : $stport\tdelay: $input_delay half clock_cycle: $clock_cycle\t";
     $slack_en = 1;
     print "input port : $stport\tdelay: $input_delay clock_cycle: $clock_cycle\n";
     }
    }
  elsif(/clock (\S+) .*fall edge(\S+)\s+(\d+\S+)\s/ && ($output == 1)) {
    $clock_cycle = $3;
    $fall = 1;
    }
  elsif(/clock (\S+) .*edge(\S+)\s+(\d+\S+)\s/ && ($output == 1)) {
    $clock_cycle = $3;
    }
  elsif(/output external delay\s+-(\d+\S+)\s/ && ($output == 1)) {
     $output_delay = $1;
     if ( ($fall == 0) && ($output_delay/$clock_cycle >= 0.6)) {
     print DST "output port : $etport\tdelay: $output_delay clock_cycle: $clock_cycle\t";
     $slack_en = 1;
     print "output port : $etport\tdelay: $output_delay clock_cycle: $clock_cycle\n";
     } elsif (($fall == 1) && ($output_delay/$clock_cycle >= 0.3)) {
     print DST "output port : $etport\tdelay: $output_delay half clock_cycle: $clock_cycle\t";
     $slack_en = 1;
     print "output port : $etport\tdelay: $output_delay half clock_cycle: $clock_cycle\n";
   }
  } elsif (/slack.*(-.*)/) {
     if($slack_en) {print DST "slack $1\n";$slack_en = 0;}
   }
  }
 close SRC;
 close DST;
 }
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

open TMP, "./sta/$tag.summary" or die;
open DST, "> ./sta/$tag.try" or die;
while(<TMP>) {
 chomp;
 if(/Startpoint/) {
  @clock = (); ##init array
  push @clock , "$_\n";
  $count = 3;
 } elsif($count) {
  push @clock , "$_\n";
  $count--;
  if ( $count == 0 ) {
    print DST "@clock";
  }
  }
 }


close TMP;
close DST;
##check async clock
open TMP, "./sta/$tag.try" or die;
open DST, "> ./sta/$tag.async" or die;
open DST1, "> ./sta/$tag.sync" or die;
while(<TMP>) {
 chomp;
 if(/Startpoint/) {
  @clock = ();
  push @clock , "$_\n";
  $count = 3;
 } elsif($count == 3) {
  push @clock , "$_\n";
  $count--;
 } elsif($count == 2) {
  push @clock , "$_\n";
  $count--;
 } elsif($count == 1) {
  push @clock , "$_\n"; ##push the endclock to startclock lines
  #if ( $clock[1] =~ /.*clocked by(.*)\)/ ) {
  # print "$1\n";
  # if ( $clock[3] =~ /.*clocked by$1\)/ ) {
  #  print DST1 "@clock"; 
  # } else {
  #  print DST "@clock";
  # }
  #} else {
  # print DST "@clock";
  #}
  $joinpoint = "$clock[1]$clock[3]";
  if ($joinpoint =~ /.*clocked by(.*)\n.*clocked by/) {
    print DST1 "@clock"; ##this is sync clock path
  } else {
    print DST "@clock"; ##this is async clock path or input/output path
  }
  $count--;
 }
}

close TMP;
close DST;
close DST1;
##deal with gating element
open TMP , "./sta/$tag.async" or die;
open DST , "> ./sta/$tag.gating.clock" or die;
while(<TMP>) {
 chomp;
 if (/Startpoint:/) {
  $s_flag = 1;
 } elsif ($s_flag && /clocked by (.*)\)/) {
  $s_clcok = $1;
  $s_flag = 0;
 } elsif ($s_flag && /clock source '(.*)'/) {
  $s_clcok = $1;
  $s_flag = 0;
  print "clock source $1\n"
 } elsif (/Endpoint:/) {
  $d_flag = 1;
 } elsif ($d_flag && (/gating element for clock (.*)\'\)/)) {
  $d_clcok = $1;
  $d_flag = 0;
  if ($d_clcok ne $s_clcok) {
  print DST "$s_clcok\t$d_clcok\n"
  }
 }
 }
close TMP;
close DST;

open SRC, "./sta/$tag.gating.clock" or die;
open DST, "> ./sta/$tag.gating_single" or die;
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
##end

open TMP , "./sta/$tag.sync" or die;
open DST , "> ./sta/$tag.clock" or die;
while(<TMP>) {
 chomp;
 #if (/clocked by (.*)\)/) {
 # $1;
 #} elsif
 if (/Startpoint:/) {
  $s_flag = 1;
 } elsif ($s_flag && (/clocked by (.*?)\'?\)/)) {
  $s_clcok = $1;
  $s_flag = 0;
 } elsif (/Endpoint:/) {
  $d_flag = 1;
 } elsif ($d_flag && (/clocked by (.*?)\'?\)/)) {
  $d_clcok = $1;
  $d_flag = 0;
  if ($d_clcok ne $s_clcok) {
  print DST "$s_clcok\t$d_clcok\n"
  }
 }
 }
close TMP;
close DST;

open SRC, "./sta/$tag.clock" or die;
open DST, "> ./sta/$tag.clock_single" or die;
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



open SRC, "./sta/$tag.try" or die;
open DST, "> ./sta/$tag.port" or die;
while (<SRC>) {
 chomp;
 if (/Startpoint: (.*)\s+\(input port/) {
  print DST "input: $1\n";
 } elsif (/input port/) {
  print DST "input: $t\n";
 } elsif  (/Endpoint:(\s)(.*)(\s)\(output port/) {
  print DST "output: $2\n";
 } elsif (/output port/) {
  print DST "output: $t\n";
 }
 $t = $_;
 $t =~ s/Startpoint:(\s+)(.*?)/$2/;
 $t =~ s/Endpoint:(\s+)(.*?)/$2/;
 $t =~ s/(\s)+(.*)/$2/;
}
close SRC;
close DST;

open SRC, "./sta/$tag.port" or die;
open DST, "> ./sta/$tag.port.final" or die;
%ha = ();
while (<SRC>) {
  chomp;
  $ha{$_} = 1;
}

@port= sort keys %ha;
foreach  (@port) {
 print DST "$_\n";
}

close SRC;
close DST;
#unlink "$tag.port","$tag.try","$tag.final";
