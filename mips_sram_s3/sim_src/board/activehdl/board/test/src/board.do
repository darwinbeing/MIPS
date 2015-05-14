# Active-HDL design settings
set dsnname test
set dsn $curdir
log $dsn/log/vsimsa.log
alib test.lib
set worklib test
# end of Active-HDL design settings

cd $dsn
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/testbench/testbench.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/arbiter/arbiter.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/cache/cache.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/cache/memory.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/pps_top.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/pps_processor.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/memory_interface.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/pps_fetch.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/pps_decode.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/pps_execute.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/pps_memory.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/pps_writeback.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/test_sync.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/regfile.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/decoder.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/processor/alu.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/dma/host.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/dma/addr_decode.v
alog -v2k -dbg -incdir "I:\CSCE611\mips_sram_s3\sim_src\include" I:/CSCE611/mips_sram_s3/sim_src/board/dma/dma_controller.v
asim -advdataflow  -retry 3  TestBench
