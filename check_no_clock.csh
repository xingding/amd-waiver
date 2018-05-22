#!/bin/csh -f
## START config
set is_waive = $1
set sort_by_start_point = $2
#u0_s0 --> u0_phy --> u1_s0 --> u1_phy
set dir0 = $3
set dir1 = $4
set dir2 = $5
set dir3 = $6
set dir4 = $7
set dir5 = $8
set dir6 = $9
set dir7 = $10


if (! -e no_clock) then
 mkdir  no_clock
endif
 set u0_s0 = "$dir0/rpts/DgSynFinalRpt/DgSynFinalRpt.allfanin_of_noclkreg.gz"
 if(-e $u0_s0) then
   zgrep "Warning.*NO_CLOCK\|Start points" $u0_s0 >  ./no_clock/u0_s0.t
 else
   echo "$u0_s0 does not exist..."
 endif

 set u0_phy = "$dir1/rpts/DgSynFinalRpt/DgSynFinalRpt.allfanin_of_noclkreg.gz"
 if(-e $u0_phy) then
   zgrep "Warning.*NO_CLOCK\|Start points" $u0_phy >  ./no_clock/u0_phy.t
 else
   echo "$u0_phy does not exist..."
 endif

 set u1_s0 = "$dir2/rpts/DgSynFinalRpt/DgSynFinalRpt.allfanin_of_noclkreg.gz"
 if(-e $u1_s0) then
   zgrep "Warning.*NO_CLOCK\|Start points" $u1_s0 >  ./no_clock/u1_s0.t
 else
   echo "$u1_s0 does not exist..."
 endif

 set u1_phy = "$dir3/rpts/DgSynFinalRpt/DgSynFinalRpt.allfanin_of_noclkreg.gz"
 if(-e $u1_phy) then
   zgrep "Warning.*NO_CLOCK\|Start points" $u1_phy >  ./no_clock/u1_phy.t
 else
   echo "$u1_phy does not exist..."
 endif

  set u0_s5 = "$dir4/rpts/DgSynFinalRpt/DgSynFinalRpt.allfanin_of_noclkreg.gz"
 if(-e $u0_s0) then
   zgrep "Warning.*NO_CLOCK\|Start points" $u0_s5 >  ./no_clock/u0_s5.t
 else
   echo "$u0_s5 does not exist..."
 endif

 set u0_vdci = "$dir5/rpts/DgSynFinalRpt/DgSynFinalRpt.allfanin_of_noclkreg.gz"
 if(-e $u0_vdci) then
   zgrep "Warning.*NO_CLOCK\|Start points" $u0_vdci >  ./no_clock/u0_vdci.t
 else
   echo "$u0_vdci does not exist..."
 endif

 set u1_s5 = "$dir6/rpts/DgSynFinalRpt/DgSynFinalRpt.allfanin_of_noclkreg.gz"
 if(-e $u1_s5) then
   zgrep "Warning.*NO_CLOCK\|Start points" $u1_s5 >  ./no_clock/u1_s5.t
 else
   echo "$u1_s5 does not exist..."
 endif

 set u1_vdci = "$dir7/rpts/DgSynFinalRpt/DgSynFinalRpt.allfanin_of_noclkreg.gz"
 if(-e $u1_vdci) then
   zgrep "Warning.*NO_CLOCK\|Start points" $u1_vdci >  ./no_clock/u1_vdci.t
 else
   echo "$u1_vdci does not exist..."
 endif

if($is_waive) then
  ./script/waive_no_clock.pl u0_s0.t
  ./script/waive_no_clock.pl u1_s0.t
  ./script/waive_no_clock.pl u0_phy.t
  ./script/waive_no_clock.pl u1_phy.t
  ./script/waive_no_clock.pl u0_s5.t
  ./script/waive_no_clock.pl u1_s5.t
  ./script/waive_no_clock.pl u0_vdci.t
  ./script/waive_no_clock.pl u1_vdci.t
 endif

if($sort_by_start_point) then
  ./script/sort_no_clock_by_startpoint.pl u0_s0.t
  ./script/sort_no_clock_by_startpoint.pl u1_s0.t
  ./script/sort_no_clock_by_startpoint.pl u0_phy.t
  ./script/sort_no_clock_by_startpoint.pl u1_phy.t
  ./script/sort_no_clock_by_startpoint.pl u0_s5.t
  ./script/sort_no_clock_by_startpoint.pl u1_s5.t
  ./script/sort_no_clock_by_startpoint.pl u0_vdci.t
  ./script/sort_no_clock_by_startpoint.pl u1_vdci.t
endif

rm -rf ../no_clock/noclkreg.gz

