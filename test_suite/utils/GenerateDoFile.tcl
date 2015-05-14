if {$argc < 3} {
  puts "Usage: $argv0 DoFilePath DoFileName ld_prog.dis "
  return
} 

set arg1   [lindex $argv 0]
set arg2   [lindex $argv 1]
set arg3   [lindex $argv 2]


#----------------------------------------------------------------------- 
# Search the last executed instruction (i.e. jr ra) of the 
# objdump assembly file(.dis). Then set a breakpoint at the instruction's
# address in the the Modelsim Do file using when command.
#----------------------------------------------------------------------- 
proc SetBreakpoint {filename} {

  set input  [open $filename r]
  
  set hexaddr "00000000"
  set flag 0
  
  # Search the <main> segment
  while {[gets $input line] >= 0} {
    if { [regexp {<(.+)>:} $line match seg] } {
      puts $line
      if { $seg == "main" } {
        set flag 1
      } else {
        set flag 0
      }
    }
    if {$flag} {
      # Find the last occurence of the instruction "jr ra"
      if { [regexp -nocase {([0-9a-z]+):[\s]+[0-9a-z]+[\s]+jr[\s]+ra} \
           $line match hexaddr] } {
        puts "$match : $hexaddr"
      } 
    }
  }
  
  # Pad leading 0's to form an 8-bit address in hexadecimal
  set len [expr {8 - [string length $hexaddr]}]
  set hex [string repeat "0" $len]$hexaddr
  binary scan [binary format H8 $hex] B32 result
  
  # close files
  close $input
  
  return $result
}


#
# Generate breakpoint Do file in the simulation directory
#
set name ""
set result [SetBreakpoint $arg3]
set status [regexp {ld_(.+).dis} $arg3 match name]
if {$status == 0} {
  puts "breakpoint file name not found"
  exit
}
set output [open ${arg1}/${name}_bp.do w]
puts $output "echo \"setting last-instruction breakpoint\""
puts $output "when -label sim:/CheckTwoModels/mips_beh/PC {\"sim:/CheckTwoModels/mips_beh/PC = $result\"} {echo {Break on last instruction} ; stop} ;"
close $output

#
# Generate compile Do file in the simulation directory
#
set output [open $arg1/$arg2 w]

# set Design path
set path [file dirname $arg1]

puts $output "# design path"
puts $output "set PATH      \"$path\""
puts $output "set LIB_PATH  \"/usr/local/3rdparty/csce611/Altera_Sim_Lib/verilog_libs\""
puts $output ""
puts $output "# Altera project"
puts $output "set FPGA_PATH \"\$PATH/proj\""
puts $output ""
puts $output "# simulation source files"
puts $output "set SRC_PATH  \"\$PATH/sim_src\""
puts $output ""
puts $output "# top-level memory module"
puts $output "set MEM_PATH  \"\$SRC_PATH/memory\""
puts $output ""
puts $output "# rtl processor "
puts $output "set RTL_PATH  \"\$SRC_PATH/rtl\""
puts $output ""
puts $output "# behavioral processor"
puts $output "set BEH_PATH  \"\$SRC_PATH/behav\""
puts $output ""
puts $output "# processor and memory parameters and defines"
puts $output "set INC_PATH  \"\$SRC_PATH/include\""
puts $output ""
puts $output "# top-level testbench"
puts $output "set TEST_PATH \"\$SRC_PATH/testbench\""
puts $output ""
puts $output "# test data"
puts $output "set DATA_PATH \"\$SRC_PATH/test_data\""
puts $output ""
puts $output "if {\[file exists test_work\]} {"
puts $output "	vdel -lib test_work -all"
puts $output "}"
puts $output ""
puts $output "vlib test_work"
puts $output "vmap work test_work"
puts $output "vmap altera_mf_ver \$LIB_PATH/altera_mf_ver"
puts $output "vmap cycloneii_ver \$LIB_PATH/cycloneii_ver"
puts $output "vmap lpm_ver       \$LIB_PATH/lpm_ver"
puts $output ""
puts $output "#--------------------------------------------------------- "
puts $output "# single-cycle processor sources"
puts $output "#--------------------------------------------------------- "
puts $output ""
puts $output "vlog -sv -work work +incdir+\$INC_PATH \$TEST_PATH/CheckTwoModels.v +libext+.v \\"
puts $output "      -y \$INC_PATH -y \$BEH_PATH -y \$RTL_PATH -y \$FPGA_PATH -y \$MEM_PATH"
puts $output ""
puts $output "vsim -L altera_mf_ver -L cycloneii_ver -L lpm_ver -t ns -voptargs=+acc work.CheckTwoModels"
puts $output ""
puts $output "source ${name}_bp.do"
puts $output ""
puts $output "run -all"
# quit is not executed after sourcing a breakpoint do file
#puts $output ""
#puts $output "quit -sim"
close $output

