# --------------------------------------------------------------
# Extract the 32-bit hexadecimal data from a list file and
# 1. dump the 32-bit data into file "RAM.dat"
# 2. split it into four 1-byte data files:
#      RAM4.dat: bit31 - bit24
#      RAM3.dat: ...
#      RAM2.dat: ...
#      RAM1.dat: bit7 - bit0
# 
# Report bugs: jinz@email.sc.edu
# --------------------------------------------------------------
set word 32
set byte 8
set nbyte [expr {$word / $byte}]

if {$argc < 1} {
  puts "$argv0 list_file_name"
  return
} 

set arg1 [lindex $argv 0]
set input [open $arg1]

# RAM1.dat -- RAM4.dat(x8)
for {set i 1} {$i <= $nbyte} {incr i} {
  set output$i [open RAM$i.dat w]
}
# RAM.dat(x32)
set sim_output [open RAM.dat w] 

while {[gets $input line] >= 0} {
  if {![regexp {\[.+\][\s]+0x([0-9a-z]+)} $line match data]} {
    continue
  } else {
    # debug
    #puts $data 
    puts $sim_output $data;
    
    for {set i 1} {$i <= $nbyte} {incr i} {
      set m$i [string range $data \
              [expr {$byte - 2 * $i}] [expr {$byte + 1 - 2 * $i}]]
      upvar 0 output$i output 
      upvar 0 m$i m 
      puts $output $m
    }
  }
}

# Close files
close $input

for {set i 1} {$i <= $nbyte} {incr i} {
  upvar 0 output$i output 
  close $output
}
close $sim_output
