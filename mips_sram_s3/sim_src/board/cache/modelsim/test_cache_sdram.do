quit -sim

# design path
set PATH      "C:/Users/Jin/Desktop/CSCE611/mips_sram_s3/sim_src"
#set PATH      "/share/jinz/MIPS/mips_sram_s3/sim_src"
#set PATH      "I:/CSCE611/mips_sram_s3/sim_src"

# Altera project 
#set FPGA_PATH "$PATH/proj"

# beh processor 
set BEH_PATH "$PATH/behav"

# processor and memory parameters and defines
set INC_PATH  "$PATH/include"

# simulation source files
set SRC_PATH  "$PATH/board"

# cache 
set CACHE_PATH  "$SRC_PATH/cache"

# cache rtl 
set CACHE_RTL_PATH  "$SRC_PATH/cache/rtl"

# SDRAM
set SDR_PATH  "$SRC_PATH/Multi_Sdram"

# dma module
set DMA_PATH  "$SRC_PATH/dma"

# arbiter module
set ARB_PATH  "$SRC_PATH/arbiter"

# rtl processor 
set RTL_PATH "$SRC_PATH/processor"

# top-level testbench
set TEST_PATH "$SRC_PATH/testbench"

# precompiled Altera sim lib
set LIB_PATH  "C:/altera/qshare/verilog_libs"
#set LIB_PATH  "/usr/local/3rdparty/csce611/Altera_Sim_Lib/verilog_libs"

if {[file exists test_work]} {
	vdel -lib test_cache_sdram_work -all
}

vlib test_cache_sdram_work
vmap work test_cache_sdram_work
vmap altera_mf_ver $LIB_PATH/altera_mf_ver
vmap cycloneii_ver $LIB_PATH/cycloneii_ver
vmap lpm_ver       $LIB_PATH/lpm_ver

#--------------------------------------------------------- 
# single-cycle processor sources
#--------------------------------------------------------- 

vlog -work work +incdir+$INC_PATH+$SDR_PATH+$CACHE_RTL_PATH $CACHE_PATH/test_cache_sdram.v +libext+.v \
      -y $CACHE_PATH -y $SDR_PATH -y $CACHE_RTL_PATH -y $ARB_PATH -y $RTL_PATH 
# -y $BEH_PATH 
vlog -work work +incdir+$CACHE_RTL_PATH $CACHE_RTL_PATH/ram.v 
vlog -work work +incdir+$CACHE_RTL_PATH $CACHE_RTL_PATH/misc.v

vsim -L altera_mf_ver -L cycloneii_ver -L lpm_ver -t ns -voptargs=+acc work.TestBench

do cache_sdram_wave.do

#run 105 us
