quit -sim

# design path
#set PATH      "C:/Users/Jin/Desktop/CSCE611/mips_sram_s3/sim_src"
#set PATH      "I:/CSCE611/mips_sram_s3/sim_src"
set PATH      "/share/jinz/MIPS/mips_sram_s3/sim_src"

# precompiled Altera sim lib

# office
#set LIB_PATH  "C:/altera/qshare/verilog_libs"

# home
#set LIB_PATH  "D:/altera/SimLib/verilog_libs"

# server
set LIB_PATH  "/usr/local/3rdparty/csce611/Altera_Sim_Lib/verilog_libs"

# Altera project 
#set FPGA_PATH "$PATH/proj"

# beh processor 
set BEH_PATH "$PATH/behav"

# processor and memory parameters and defines
set INC_PATH  "$PATH/include"

# simulation source files
set SRC_PATH  "$PATH/board"

# cache_beh 
set CACHE_BEH_PATH  "$SRC_PATH/cache"

# cache rtl 
set CACHE_RTL_PATH  "$SRC_PATH/cache/rtl"

# SDRAM
set SDR_PATH  "$SRC_PATH/Multi_Sdram"

# arbiter module
set ARB_PATH  "$SRC_PATH/arbiter"

# rtl processor 
set RTL_PATH "$SRC_PATH/processor"

# top-level testbench
set TEST_PATH "$CACHE_BEH_PATH/testbench"

if {[file exists test_two_models_work]} {
	vdel -lib test_two_models_work -all
}

vlib test_two_models_work
vmap work  test_two_models_work
vmap altera_mf_ver $LIB_PATH/altera_mf_ver
vmap cycloneii_ver $LIB_PATH/cycloneii_ver
vmap lpm_ver       $LIB_PATH/lpm_ver

vlog -incr -sv -work work +incdir+$INC_PATH+$SDR_PATH+$CACHE_RTL_PATH $TEST_PATH/test_two_models.v +libext+.v \
      -y $TEST_PATH -y $CACHE_BEH_PATH -y $CACHE_RTL_PATH -y $ARB_PATH -y $RTL_PATH -y $BEH_PATH -y $SDR_PATH 

# different RAMs are put in the same file
vlog -incr -work work +incdir+$CACHE_RTL_PATH $CACHE_RTL_PATH/ram.v $CACHE_RTL_PATH/misc.v
vlog -incr -work work +incdir+$INC_PATH+$CACHE_RTL_PATH $CACHE_RTL_PATH/WriteBuffer.v

vsim -l sim.log -L altera_mf_ver -L cycloneii_ver -L lpm_ver -t ns -voptargs=+acc work.TestBench

do two_models_wave.do

#do set_dis_bp.do

#onbreak {}

run -all
