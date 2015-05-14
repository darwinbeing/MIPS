#
# Split the 32-bit hexadecimal data into four banks of 8-bit data
#

if {$argc < 1} {
  puts "$argv0 list_file_name"
  return
} 

set arg1 [lindex $argv 0]
set input [open $arg1]


# Write files
set output0 [open test.hex0 w]
set output1 [open test.hex1 w]
set output2 [open test.hex2 w]
set output3 [open test.hex3 w]

set i 0
while {[gets $input line] >= 0} {
  if {![regexp {\[.+\][\s]+0x([0-9a-z]+)} $line match data]} {
    continue
  } else {
    #puts $data
    set m3 [string range $data 0 1]
    set m2 [string range $data 2 3]
    set m1 [string range $data 4 5]
    set m0 [string range $data 6 7]

    puts $output0 $m0
    puts $output1 $m1
    puts $output2 $m2
    puts $output3 $m3
  }
}

# Close files
close $input
close $output0
close $output1
close $output2
close $output3

