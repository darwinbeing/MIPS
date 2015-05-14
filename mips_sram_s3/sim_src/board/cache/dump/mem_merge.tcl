# four 8-bit dump files for each word
for {set i 0} {$i < 4} {incr i} {
  set arg$i [lindex $argv $i]
  upvar 0 arg$i filein 
  set file$i [open $filein]
}

set arg$i [lindex $argv $i]
upvar 0 arg$i fileout 
set output [open $fileout w]

# Initialize variable b0 ... b7
for {set i 0} {$i < 8} {incr i} {
  set b$i ""
}

# set when executing the "continue" command
set cflag 0

# set when executing the "break" command
set bkflag 0

set linenu 0

# 1. Open each file in turn
# 2. In each file read a line and from which extract 
#    the line number and data
# 3. Combine the corresponding 8-bit data in each file together 
#    to generate a 32-bit data

while {1} {

  for {set i 0} {$i < 4} {incr i} {
    upvar 0 file$i filename 
    set line$i [gets $filename]
    if {[eof $filename]} { set bkflag 1; break }
    upvar 0 line$i line 
    #puts "file $i: $line"

    if [regexp "^//" $line] { set cflag 1 }
  }

  if { $cflag } { set cflag 0; continue }
  if { $bkflag } { break }

  #puts "Interate over four lines with eight columns each"
  for {set k 0} {$k < 8} {incr k} {
    set pos [expr {3 * $k}]
    for {set i 0} {$i < 4} {incr i} {
      upvar 0 line$i fileline 
      #puts "$i: $fileline"
      if {[regexp {([\d]+:)(.+)} $fileline match linenu data]} {
        #puts "$i: $linenu $data"
        upvar 0 b$k byte 
        set byte [string trimleft [string range $data $pos [expr {$pos+2}]]]$byte
      }
    }
  }

  # Print eight 32-bit hexadecimal data per line
  puts -nonewline $output $linenu
  for {set k 0} {$k < 8} {incr k} {
    upvar 0 b$k word  
    puts -nonewline $output " $word"
    # Clear word
    set word ""
  }
    # Add a newline at the end of each line
    puts $output ""
}

# Close files
for {set i 0} {$i < 4} {incr i} {
  upvar 0 file$i filename
  close $filename
}
close $output


