echo "setting last-instruction breakpoint"
when -label sim:/TestBench/mips_beh/PC {"sim:/TestBench/mips_beh/PC = 00000000000000000000000010000000"} {echo {Break on last instruction} ; stop} ;
