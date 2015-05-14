quit -sim

# design path
#set PATH      "C:\Users\Jin\Desktop\CSCE611\mips_sram_s3\syn_src\VGA_course611\VGA_test_pong"
set PATH      "/share/jinz/MIPS/mips_sram_s3/syn_src\VGA_course611\VGA_test_pong"

# precompiled Altera sim lib

# office
#set LIB_PATH      "C:/altera/qshare"

# home
#set LIB_PATH  "D:/altera/SimLib"

# server
set LIB_PATH  "/usr/local/3rdparty/csce611/Altera_Sim_Lib"

set VER_LIB_PATH  "$LIB_PATH/verilog_libs"
set VHD_LIB_PATH  "$LIB_PATH/vhdl_libs"

if {[file exists work]} {
	vdel -lib work -all
}

vlib work
vmap work  work
vmap altera_mf_ver $VER_LIB_PATH/altera_mf_ver
vmap cycloneii_ver $VER_LIB_PATH/cycloneii_ver
vmap lpm_ver       $VER_LIB_PATH/lpm_ver
vmap altera_mf     $VHD_LIB_PATH/altera_mf
vmap cycloneii     $VHD_LIB_PATH/cycloneii
vmap lpm           $VHD_LIB_PATH/lpm

vlog ../Display.v ../VGA_Sync.v ../TestBench.v
vcom ../test_vga_struct.vhd ../display_if_struct.vhd ../vmem8192x15_vmem8192x15.vhd ../VGA_PLL.vhd

vsim -L altera_mf_ver -L cycloneii_ver -L lpm_ver -L altera_mf -L cycloneii -L lpm \
     -t ps -voptargs=+acc work.TestBench

#run 101 us
