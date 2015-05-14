echo "setting last-instruction breakpoint"
when -label sim:/CheckTwoModels/mips_beh/PC {"sim:/CheckTwoModels/mips_beh/PC = 00000000000000000000001011100100"} {echo {Break on last instruction} ; stop} ;
