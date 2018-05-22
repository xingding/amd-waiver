#!/bin/csh -f
./script/check_mismatch.pl clocks_usb_t_hc_0.xml clock.list_u0_s0 usb0_s0_t
mv insdc_inxml insdc_notinxml inxml_notinsdc ./u0_s0
./script/check_mismatch.pl clocks_usb_t_hc_0.xml clock.list_u0_phy usb0_phy_t
mv insdc_inxml insdc_notinxml inxml_notinsdc ./u0_phy

./script/check_mismatch.pl clocks_usb_t_hc_1.xml clock.list_u1_s0 usb1_s0_t
mv insdc_inxml insdc_notinxml inxml_notinsdc ./u1_s0
./script/check_mismatch.pl clocks_usb_t_hc_1.xml clock.list_u1_phy usb1_phy_t
mv insdc_inxml insdc_notinxml inxml_notinsdc ./u1_phy
