#----------------------------------------------------------------------- 
# Search the last executed instruction (i.e. jr ra) of the 
# objdump assembly file(.dis). Then set a breakpoint at the instruction's
# address in the the Modelsim Do file using when command.
#
# jinz@email.sc.edu
#----------------------------------------------------------------------- 

#if {$argc < 2} {
#  puts "Usage: $argv0 ld_prog.dis do_file_path"
#  return
#} 

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


