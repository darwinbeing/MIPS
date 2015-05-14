#set DUMP_PATH "C:/Users/Jin/Desktop/CSCE611/mips_sram_s3/sim_src/board/cache/dump"
set DUMP_PATH "/share/jinz/MIPS/mips_sram_s3/sim_src/board/cache/dump"

mem save -outfile "$DUMP_PATH/RF_beh.txt" -addressradix dec -dataradix h -format mti /TestBench/DUT_BEH/Processor/GPR
mem save -outfile $DUMP_PATH/RF_rtl.txt -addressradix dec -dataradix h -format mti /TestBench/DUT_RTL/Processor/ID/RegFile/RF_mem

mem save -outfile $DUMP_PATH/IC_ram1_beh.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_BEH/icache/ram1
mem save -outfile $DUMP_PATH/IC_ram0_beh.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_BEH/icache/ram0
mem save -outfile $DUMP_PATH/IC_tag_beh.txt  -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_BEH/icache/tag
mem save -outfile $DUMP_PATH/IC_val_beh.txt  -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_BEH/icache/valid

mem save -outfile $DUMP_PATH/DC_ram1_beh.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_BEH/dcache/ram1
mem save -outfile $DUMP_PATH/DC_ram0_beh.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_BEH/dcache/ram0
mem save -outfile $DUMP_PATH/DC_tag_beh.txt  -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_BEH/dcache/tag
mem save -outfile $DUMP_PATH/DC_val_beh.txt  -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_BEH/dcache/valid

mem save -outfile $DUMP_PATH/IC_ram00_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/ICache/DataRam_D00/DataRam
mem save -outfile $DUMP_PATH/IC_ram01_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/ICache/DataRam_D01/DataRam
mem save -outfile $DUMP_PATH/IC_ram02_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/ICache/DataRam_D02/DataRam
mem save -outfile $DUMP_PATH/IC_ram03_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/ICache/DataRam_D03/DataRam
mem save -outfile $DUMP_PATH/IC_ram10_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/ICache/DataRam_D10/DataRam
mem save -outfile $DUMP_PATH/IC_ram11_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/ICache/DataRam_D11/DataRam
mem save -outfile $DUMP_PATH/IC_ram12_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/ICache/DataRam_D12/DataRam
mem save -outfile $DUMP_PATH/IC_ram13_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/ICache/DataRam_D13/DataRam
mem save -outfile $DUMP_PATH/IC_tag_rtl.txt   -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/ICache/TagRam/TagRam
mem save -outfile $DUMP_PATH/IC_val_rtl.txt   -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/ICache/ValidRam/ValidBits

mem save -outfile $DUMP_PATH/DC_ram00_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/DCache/DataRam_D00/DataRam
mem save -outfile $DUMP_PATH/DC_ram01_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/DCache/DataRam_D01/DataRam
mem save -outfile $DUMP_PATH/DC_ram02_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/DCache/DataRam_D02/DataRam
mem save -outfile $DUMP_PATH/DC_ram03_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/DCache/DataRam_D03/DataRam
mem save -outfile $DUMP_PATH/DC_ram10_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/DCache/DataRam_D10/DataRam
mem save -outfile $DUMP_PATH/DC_ram11_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/DCache/DataRam_D11/DataRam
mem save -outfile $DUMP_PATH/DC_ram12_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/DCache/DataRam_D12/DataRam
mem save -outfile $DUMP_PATH/DC_ram13_rtl.txt -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/DCache/DataRam_D13/DataRam
mem save -outfile $DUMP_PATH/DC_tag_rtl.txt   -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/DCache/TagRam/TagRam
mem save -outfile $DUMP_PATH/DC_val_rtl.txt   -addressradix dec -dataradix h -format mti -wordsperline 8 /TestBench/DUT_RTL/DCache/ValidRam/ValidBits

mem save -outfile $DUMP_PATH/SDRAM_rtl.txt  -compress -start 0 -end 2097151 -addressradix h -dataradix h -format mti -wordsperline 16 /TestBench/DUT_RTL/m0/Bank0
mem save -outfile $DUMP_PATH/SDRAM_beh.txt  -compress -start 0 -end 2097151 -addressradix h -dataradix h -format mti -wordsperline 16 /TestBench/DUT_BEH/SRAM/sram



