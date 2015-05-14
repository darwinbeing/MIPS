# --------------------------------------------------------------
# Convert an 8-bit data(RAMx.dat) into MIF format(RAMx.mif)
#
# Report bugs: jinz@email.sc.edu
# --------------------------------------------------------------
proc PutHeader {output} {
puts $output \
{-- Copyright (C) 1991-2010 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- Quartus II generated Memory Initialization File (.mif)

WIDTH=8;
DEPTH=128;

ADDRESS_RADIX=UNS;
DATA_RADIX=HEX;

CONTENT BEGIN}
}

set word 32
set byte 8
set nbyte [expr {$word / $byte}]

# Write files
for {set i 1} {$i <= $nbyte} {incr i} {
  set input    [open RAM$i.dat r]
  set output$i [open RAM$i.mif w]
  upvar 0 output$i output 
  PutHeader $output
  set addr 0
  while {[gets $input line] >= 0} {
    puts $output "$addr : $line;"
    incr addr;
  }
  puts $output "END;"

  # Close files
  close $input
  close $output
}

