# Active-HDL design settings
set dsnname sdram
set dsn $curdir
log $dsn/log/vsimsa.log
alib sdram.lib
set worklib sdram
# end of Active-HDL design settings

cd $dsn
alog -v2k -dbg +incdir+I:\CSCE611\mips_sram_s3\sim_src\board\sdram\source+I:\CSCE611\mips_sram_s3\sim_src\board\sdram\simulation+I:\CSCE611\mips_sram_s3\sim_src\board\sdram\mt48lc8m16a2 I:/CSCE611/mips_sram_s3/sim_src/board/sdram/source/compile_all.v
