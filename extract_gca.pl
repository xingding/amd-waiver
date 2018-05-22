#!/usr/bin/perl -w 
$now = $ARGV[0];
$org = $ARGV[1];
system "grep comment ./main_0105/$org > com_file";
open COM, "com_file" or die "$!";
open VIO, "$now" or die "$!";
open VIO_COM, "> ${now}.com" or die "$!";
@com = <COM>;
@vio_file = <VIO>;
$vio_len = ($#vio_file - 1)/2;
for($i = 0; $i <= $vio_len; $i++) {
 print VIO_COM "$vio_file[2*$i]";
 print VIO_COM "$vio_file[2*$i + 1]";
 print VIO_COM "$com[$i]";
}
