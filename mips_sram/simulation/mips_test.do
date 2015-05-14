# design path
set PATH      "/share/jinz/MIPS/mips_sram"
set LIB_PATH  "/usr/local/3rdparty/csce611/Altera_Sim_Lib/verilog_libs"

# Altera project
set FPGA_PATH "$PATH/proj"

# simulation source files
set SRC_PATH  "$PATH/sim_src"

# top-level memory module
set MEM_PATH  "$SRC_PATH/memory"

# rtl processor 
set RTL_PATH  "$SRC_PATH/rtl"

# behavioral processor
set BEH_PATH  "$SRC_PATH/behav"

# processor and memory parameters and defines
set INC_PATH  "$SRC_PATH/include"

# top-level testbench
set TEST_PATH "$SRC_PATH/testbench"

# test data
set DATA_PATH "$SRC_PATH/test_data"

if {[file exists test_work]} {
	vdel -lib test_work -all
}

vlib test_work
vmap work test_work
vmap altera_mf_ver $LIB_PATH/altera_mf_ver
vmap cycloneii_ver $LIB_PATH/cycloneii_ver
vmap lpm_ver       $LIB_PATH/lpm_ver

#--------------------------------------------------------- 
# single-cycle processor sources
#--------------------------------------------------------- 

vlog -work work +incdir+$INC_PATH $TEST_PATH/CheckTwoModels.v +libext+.v \
      -y $INC_PATH -y $BEH_PATH -y $RTL_PATH -y $FPGA_PATH -y $MEM_PATH

vsim -L altera_mf_ver -L cycloneii_ver -L lpm_ver -t ns -voptargs=+acc work.CheckTwoModels

source shang_bp.do

run -all
