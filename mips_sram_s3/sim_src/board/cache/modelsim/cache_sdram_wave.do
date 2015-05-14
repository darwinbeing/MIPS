onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /TestBench/DUT/clk
add wave -noupdate -format Logic -radix hexadecimal /TestBench/DUT/rst
add wave -noupdate -format Logic /TestBench/DUT/DCache/CpuWrite
add wave -noupdate -format Literal /TestBench/DUT/DCache/RamFill
add wave -noupdate -format Literal /TestBench/DUT/DCache/RamWrite
add wave -noupdate -format Logic /TestBench/DUT/DCache/TagWrite
add wave -noupdate -format Logic /TestBench/DUT/Processor/MI/data_read
add wave -noupdate -format Logic /TestBench/DUT/Processor/MI/data_ready
add wave -noupdate -format Logic /TestBench/DUT/Processor/MI/data_write
add wave -noupdate -format Logic /TestBench/DUT/Processor/MI/inst_read
add wave -noupdate -format Logic /TestBench/DUT/Processor/MI/inst_ready
add wave -noupdate -format Logic /TestBench/DUT/Processor/MI/mem_read
add wave -noupdate -format Logic /TestBench/DUT/Processor/MI/memop
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/inst_addr
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/inst
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/Processor/inst_r
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/Processor/data
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/ICache/DataRamDataIn
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/ICache/DataRamDataOut
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/ICache/DataRamDataOut0
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/ICache/DataRamDataOut1
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/ICache/DData
add wave -noupdate -format Logic /TestBench/DUT/ICache/DReady
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/ICache/DataRamWrite
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/ICache/MAddress
add wave -noupdate -format Logic -radix hexadecimal /TestBench/DUT/ICache/MAddrOE
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/ICache/RamWrite
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/ICache/TagWrite
add wave -noupdate -format Literal -radix unsigned /TestBench/DUT/ICache/ICacheControl/State
add wave -noupdate -format Logic -radix hexadecimal /TestBench/DUT/rwbar
add wave -noupdate -format Logic -radix hexadecimal /TestBench/DUT/ic_read
add wave -noupdate -format Logic -radix hexadecimal /TestBench/DUT/ic_read_mem
add wave -noupdate -format Logic -radix hexadecimal /TestBench/DUT/ic_grant_mem
add wave -noupdate -format Logic -radix hexadecimal /TestBench/DUT/ic_ready
add wave -noupdate -format Literal /TestBench/DUT/dc_byte_en
add wave -noupdate -format Logic /TestBench/DUT/dc_grant_mem
add wave -noupdate -format Logic /TestBench/DUT/dc_read
add wave -noupdate -format Logic /TestBench/DUT/dc_read_mem
add wave -noupdate -format Logic /TestBench/DUT/dc_ready
add wave -noupdate -format Literal -radix unsigned /TestBench/DUT/DCache/DCacheControl/State
add wave -noupdate -format Literal /TestBench/DUT/dc_write
add wave -noupdate -format Logic /TestBench/DUT/dc_write_mem
add wave -noupdate -format Logic /TestBench/DUT/Multi_Sdram/mSDR_RD
add wave -noupdate -format Logic /TestBench/DUT/Multi_Sdram/mSDR_WR
add wave -noupdate -format Logic -radix hexadecimal /TestBench/DUT/mSDR_RxD
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/mem_adbus
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/mem_databus
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/sdr_addr
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/Multi_Sdram/Sdram_Controller/command1/bankaddr
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/Multi_Sdram/Sdram_Controller/command1/coladdr
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/Multi_Sdram/Sdram_Controller/command1/rowaddr
add wave -noupdate -format Literal /TestBench/DUT/Multi_Sdram/Sdram_Controller/CMD
add wave -noupdate -format Logic /TestBench/DUT/Multi_Sdram/Sdram_Controller/CMDACK
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/Multi_Sdram/Sdram_Multiplexer/mSDR_DATA
add wave -noupdate -format Literal /TestBench/DUT/Multi_Sdram/mSDR_ADDR
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/Multi_Sdram/iAS1_DATA
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/Multi_Sdram/oAS1_DATA
add wave -noupdate -format Logic /TestBench/DUT/Multi_Sdram/Sdram_Controller/RAS_N
add wave -noupdate -format Logic /TestBench/DUT/Multi_Sdram/Sdram_Controller/CAS_N
add wave -noupdate -format Logic /TestBench/DUT/Multi_Sdram/Sdram_Controller/WE_N
add wave -noupdate -format Literal -radix unsigned /TestBench/DUT/Multi_Sdram/Sdram_Controller/ST
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT/Multi_Sdram/Sdram_Controller/DQ
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {119755 ns} 0}
configure wave -namecolwidth 246
configure wave -valuecolwidth 131
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {119258 ns} {120345 ns}
