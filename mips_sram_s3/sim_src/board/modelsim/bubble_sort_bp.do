echo "setting last-instruction breakpoint"
when -label sim:/TestBench/mips_beh/PC {"sim:/TestBench/mips_beh/PC = 00000000000000000000000100000100"} {echo {Break on last instruction} ; stop} ;
