# design path
set PATH      "/acct/s1/jinz/CSCE611/MIPS/mips_sram"
set LIB_PATH  "/usr/local/3rdparty/csce611/Altera_Sim_Lib/verilog_libs"

# simulation source files
set SRC_PATH  "$PATH/sim_src"

# behavioral processor hdl
set PROC_PATH "$SRC_PATH/behav"

# processor and memory parameters and defines
set INC_PATH  "$SRC_PATH/include"

if {[file exists behav_work]} {
	vdel -lib behav_work -all
}

vlib behav_work
vmap work behav_work

vlog -work work +incdir+$INC_PATH+$PROC_PATH $PROC_PATH/mips_behav.v

vsim -t ns -voptargs=+acc work.mips_behav

