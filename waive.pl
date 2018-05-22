#!/usr/bin/perl -w
 $src = $ARGV[0];
 $dst = $ARGV[1];
 open SRC, "$src" or die;
 open DST, ">$dst";
 while (<SRC>) {
  chomp;
  $p_con = '.*';
  $j = 0;
  print "$_\n";
   if($_ =~ /([A-Z]+_[0-9]+)\s\d+ of \d+\s+(.*)/) {
    print "matched";
    $tag = $1;
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
    print DST "GcSynthesizeCheckSdc WAIVE xguo all $tag $p_con\n";
  }
 }
 close SRC;
 close DST;

