#--------------------------------------------------------------
# Extract instruction address and codes from a list file and 
# generate cache valid, tag and RAM data for simulation
# 
# VALID : 1 bit # TAG : binary # RAM : hex
# Assume the PC is initialized to 0xF0000000
#--------------------------------------------------------------

if {$argc < 2} {
  puts "$argv0 list_file_name cache_tag_width"
  return
} 

set arg1 [lindex $argv 0]
set arg2 [lindex $argv 1]
set input [open $arg1]

# Write files
set output1 [open VALID.dat w]
set output2 [open TAG.dat w]
set output3 [open RAM.dat w]

set valid 1

# Assume the first instruction address is F000_0000
set high "F000"
set len [expr {[string length $high] - 1}]

while {[gets $input line] >= 0} {
  if {![regexp {\[(.+)\][\s]+0x([0-9a-z]+)} $line match addr ram]} {
    continue
  } else {
    # Extract low end-len+1 digits of the address
    set low [string range $addr end-$len end]

    # The size of cache is pow2(16) at maximum.
    set ptrace $high$low

    binary scan [binary format H8 $ptrace] B32 binDigits
    set tag [string range $binDigits 0 [expr {$arg2 - 1}]]

    puts $output1 $valid
    puts $output2 $tag
    puts $output3 $ram
  }
}

# Close files
close $input
close $output1
close $output2
close $output3

