echo "setting last-instruction breakpoint"
when -label sim:/CheckTwoModels/mips_beh/PC {"sim:/CheckTwoModels/mips_beh/PC = 00000000000000000000011100101100"} {echo {Break on last instruction} ; stop} ;
