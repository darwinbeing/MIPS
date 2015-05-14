echo "setting last-instruction breakpoint"
when -label sim:/CheckTwoModels/mips_beh/PC {"sim:/CheckTwoModels/mips_beh/PC = 00000000000000000000000100000100"} {echo {Break on last instruction} ; stop} ;
