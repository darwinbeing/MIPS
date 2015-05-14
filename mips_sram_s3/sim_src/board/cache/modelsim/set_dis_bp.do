# set breakpoint in the MIPS disassembly program
echo "setting instruction breakpoint"
when -label sim:/TestBench/DUT_BEH/Processor/PC {"sim:/TestBench/DUT_BEH/Processor/PC = 00000000000000000000000000010100"} {echo {Break on instruction @ 0x14} ; stop} ;
