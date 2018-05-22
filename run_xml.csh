#!/bin/csh -f
rm -rf  FCH_USB_vD.5_usb_t_hc_0_clocks_filtered.xml FCH_USB_vD.5_usb_t_hc_1_clocks_filtered.xml \
FCH_USB_vD.5_usb_t_hc_1_clocks_filtered.xml.expanded.xml FCH_USB_vD.5_usb_t_hc_0_clocks_filtered.xml.expanded.xml
clock_xml_filter.pl -xml FCH_USB_vD.5_usb_t_hc_0_clocks.xml
clock_xml_filter.pl -xml FCH_USB_vD.5_usb_t_hc_1_clocks.xml

clock_xml_scale.pl -ipv usb_d5 -ctl usb0 -xml FCH_USB_vD.5_usb_t_hc_0_clocks_filtered.xml
clock_xml_scale.pl -ipv usb_d5 -ctl usb1 -xml FCH_USB_vD.5_usb_t_hc_1_clocks_filtered.xml
