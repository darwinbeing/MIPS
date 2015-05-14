onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TestBench/DUT_RTL/DCache/DCacheControl/wb_full
add wave -noupdate /TestBench/DUT_RTL/DCache/DCacheControl/wb_flush
add wave -noupdate /TestBench/DUT_RTL/DCache/DCacheControl/wb_flush_cnt
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v7/wb_val
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v6/wb_val
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v5/wb_val
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v4/wb_val
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v3/wb_val
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v2/wb_val
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v1/wb_val
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v0/wb_val
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/Processor/ID/RegFile/RF_mem
add wave -noupdate /TestBench/DUT_RTL/DCache/ValidRam/ValidBits
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/DataRam_D00/DataRam
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/DataRam_D01/DataRam
add wave -noupdate -radix hexadecimal /TestBench/clk
add wave -noupdate -radix hexadecimal /TestBench/rst
add wave -noupdate /TestBench/rfbuf_h
add wave -noupdate /TestBench/rfbuf_t
add wave -noupdate /TestBench/rf_addr
add wave -noupdate /TestBench/rf_data
add wave -noupdate /TestBench/rf_warf
add wave -noupdate /TestBench/DUT_BEH/Processor/werf
add wave -noupdate /TestBench/DUT_BEH/Processor/warf
add wave -noupdate -radix hexadecimal /TestBench/sdram_rst
add wave -noupdate -radix hexadecimal /TestBench/run_data
add wave -noupdate -radix hexadecimal /TestBench/run_inst
add wave -noupdate -radix unsigned /TestBench/DUT_RTL/DCache/Count
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/dq
add wave -noupdate /TestBench/DUT_RTL/dqm
add wave -noupdate /TestBench/DUT_RTL/Multi_Sdram/iMBE
add wave -noupdate /TestBench/DUT_RTL/Multi_Sdram/mSDR_DM
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/DData
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/MDataOE
add wave -noupdate /TestBench/DUT_RTL/DCache/mSDR_RxD
add wave -noupdate /TestBench/DUT_RTL/DCache/mSDR_TxD
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/data_addr
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/inst_addr
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/inst
add wave -noupdate /TestBench/DUT_RTL/dc_read
add wave -noupdate /TestBench/DUT_RTL/dc_ready
add wave -noupdate -format Literal -radix hexadecimal /TestBench/DUT_RTL/dc_write
add wave -noupdate /TestBench/DUT_RTL/ic_read
add wave -noupdate /TestBench/DUT_RTL/ic_ready
add wave -noupdate /TestBench/DUT_RTL/DCache/wb_valid
add wave -noupdate /TestBench/DUT_RTL/DCache/wb_data_valid
add wave -noupdate /TestBench/DUT_RTL/DCache/wb_qread
add wave -noupdate /TestBench/DUT_RTL/DCache/Hit
add wave -noupdate -radix unsigned /TestBench/DUT_RTL/DCache/DCacheControl/State
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/valid_out
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/line_sel
add wave -noupdate -format Literal /TestBench/DUT_RTL/DCache/WriteBuffer/word_sel
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/valid_in
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_read
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_write
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_full
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_tag_match
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_t/wb_tag
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_tv/wb_val
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_tag_match
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_tagval_in
add wave -noupdate /TestBench/DUT_RTL/DCache/WriteBuffer/wb_tagval_out
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_data
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_data0
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_data1
add wave -noupdate /TestBench/DUT_RTL/DCache/MergeData
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/MergeDataIn
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/RamDataIn
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/wb_addr
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/wb_addr_mask
add wave -noupdate /TestBench/DUT_RTL/DCache/DCacheControl/wb_flush_cnt
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/DCache/wb_mem_addr
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/mem_adbus
add wave -noupdate -radix hexadecimal /TestBench/DUT_RTL/mem_databus
add wave -noupdate /TestBench/DUT_RTL/Processor/data_ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {113875 ns} 0}
configure wave -namecolwidth 379
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {111921 ns} {115801 ns}
