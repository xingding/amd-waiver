#!/usr/bin/perl -w
$tile_path = $ARGV[1];
$tile_name = $ARGV[0];
##start run
system "cp -rf $tile_path/rpts/DgSynthesize/DgSynthesize.postwaived.rpt.gz ./syn_pw/$tile_name.postwaived.rpt.gz";
open (SRC, "gzip -cd ./syn_pw/$tile_name.postwaived.rpt.gz |") or die;
open DST, "> ./syn_pw/$tile_name.xls" or die;
open DST1, ">> ./syn_pw/err.list" or die;
#print DST "name,'w/r',number,waiveed\n";
while (<SRC>) {
 chomp;
 if (/^(\S+): Severity: (\w+)\s*.*\(Occurrence: (\d+) Remaining, (\d+) Waived Out of (\d+)/) {
 $next_line = 1;
 $name = $1;
 $ser = $2;
 $number = $5;
 $waive = $4;
 if ($name =~ /(VO)|(ELAB)|(LINT)|(VER)-/) {
 print DST "Robby\t$name\t$ser\t$number\t$waive\t";
 print DST1 "Robby,$name,$ser\n";
 } elsif ($name =~ /(MV)|(MW)|(UPF)-/) {
 print DST "Haiping\t$name\t$ser\t$number\t$waive\t";
 } elsif ($name =~ /(TIM)-/) {
 print DST "Jack\t$name\t$ser\t$number\t$waive\t";
 print DST1 "Jack,$name,$ser\n";
 } elsif ($name =~ /(CMD)-/) {
 print DST "Dean\t$name\t$ser\t$number\t$waive\t";
 print DST1 "Dean,$name,$ser\n";
 } else {
 print DST "SOC\t$name\t$ser\t$number\t$waive\t";
 print DST1 "SOC,$name,$ser\n";
 }
 } elsif ($next_line == 1) {
 print DST "$_\n";
 $next_line = 0;
 } 
}

close SRC;
close DST;
close DST1;

&remove_rebundant("./syn_pw/err.list", "./syn_pw/err.list.csv");
open SRC, "./syn_pw/$tile_name.xls" or die;
open DST, "> ./syn_pw/$tile_name.final.xls" or die;
@lines = <SRC>;
@lines = sort @lines;
print DST "owner\tname\t'w/r'\tnumber\twaiveed\n";
foreach $line (@lines) {
 print DST "$line";
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

#unlink "./syn_pw/$tile_name.postwaived.rpt.gz";
unlink "./syn_pw/$tile_name.xls";
&waive ("./syn_pw/$tile_name.postwaived.rpt.gz", "./syn_pw/$tile_name.waive");
system "sort -u ./syn_pw/$tile_name.waive > ./syn_pw/$tile_name.tmp.waive";
#unlink "./syn_pw/$tile_name.waive";
open TMP, "./syn_pw/$tile_name.tmp.waive";
open TMP1, ">./syn_pw/$tile_name.tmp1.waive";
while (<TMP>) {
 chomp;
 $line  = $_;
 $line =~ s/([\.\w]+)\///g;
 $line =~ s/\.\*\./\.\*/g;
 $line =~ s/\.vh//g;
 $line =~ s/\.v//g;
 $line =~ s/\.sv//g;
# $line =~ g/\.sv//;
 print TMP1 "$line\n";
}
close TMP;
close TMP1;
system "sort -u ./syn_pw/$tile_name.tmp1.waive > ./syn_pw/$tile_name.final.waive";
#unlink "./syn_pw/$tile_name.tmp.waive";
#unlink "./syn_pw/$tile_name.tmp1.waive";

sub waive {
 $src = $_[0];
 $dst = $_[1];
 open (SRC, "gzip -cd $src |") or die;;
 open DST, ">$dst";
 while (<SRC>) {
  chomp;
  $p_con = '.*';
  $j = 0;
  $line = $_;
  if($line =~ /^\s+(LINT-\d+):(.*)/) {
    $tag1 = $1;
    $content = $2;
    $content =~ s/\[\d+\]/\.\*/g;
    @content = split /\'/, $content;
    foreach $key (@content) {
     if ($j%2) {
      $p_con = "$p_con"."$key".'.*';
     }
     $j++;
    }
    $p_con =~ s/\.\*\.\*/\.\*/g;
    $p_con =~ s/\.\*input//g;
    $p_con =~ s/\.\*output//g;
    $p_con =~ s/\.\*port//g;
     print DST "dc WAIVE dixi all $tag1 $p_con\n";
    } elsif ($line =~ /^\s+(VER-\d+):(\S+?):/) {
    $tag1 = $1;
    $content = $2;
    print DST "dc WAIVE dixi all $tag1 .*$content.*\n";
    } elsif ($line =~ /^\s+(ELAB-\d+):(\S+?):/) {
    $tag1 = $1;
    $content = $2;
    print DST "dc WAIVE dixi all $tag1 .*$content.*\n";
    } elsif ($line =~ /^\s+(VO-\d+)/) {
    $tag1 = $1;
    print DST "dc WAIVE dixi all $tag1 \.\*\n";
    } elsif ($line =~ /^\s+(\w+-\d+)/){ 
    $tag1 = $1;
    print DST "dc WAIVE dixi all $tag1 \.\*\n";
    }
    
 }
 close SRC;
 close DST;
}
