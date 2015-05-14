#!/bin/sh
tclsh mem_merge.tcl IC_ram00_rtl.txt IC_ram01_rtl.txt IC_ram02_rtl.txt IC_ram03_rtl.txt  IC_ram0_rtl.txt
tclsh mem_merge.tcl IC_ram10_rtl.txt IC_ram11_rtl.txt IC_ram12_rtl.txt IC_ram13_rtl.txt  IC_ram1_rtl.txt
tclsh mem_merge.tcl DC_ram00_rtl.txt DC_ram01_rtl.txt DC_ram02_rtl.txt DC_ram03_rtl.txt  DC_ram0_rtl.txt
tclsh mem_merge.tcl DC_ram10_rtl.txt DC_ram11_rtl.txt DC_ram12_rtl.txt DC_ram13_rtl.txt  DC_ram1_rtl.txt

diff IC_ram0_rtl.txt IC_ram0_beh.txt > memory.log
diff IC_ram1_rtl.txt IC_ram1_beh.txt > memory.log

diff DC_ram0_rtl.txt DC_ram0_beh.txt > memory.log
diff DC_ram1_rtl.txt DC_ram1_beh.txt > memory.log

diff IC_tag_rtl.txt IC_tag_beh.txt > memory.log
diff DC_tag_rtl.txt DC_tag_beh.txt > memory.log

diff IC_val_rtl.txt IC_val_beh.txt > memory.log
diff DC_val_rtl.txt DC_val_beh.txt > memory.log

diff SDRAM_rtl.txt SDRAM_beh.txt > memory.log
