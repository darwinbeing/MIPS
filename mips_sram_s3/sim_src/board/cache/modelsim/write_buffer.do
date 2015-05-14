onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /TestBench/DUT_RTL/DCache/DCacheControl/FlushCount
add wave -noupdate -format Logic /TestBench/DUT_RTL/DCache/DCacheControl/wb_full
add wave -noupdate -format Logic /TestBench/DUT_RTL/DCache/DCacheControl/wb_flush
add wave -noupdate -format Literal /TestBench/DUT_RTL/DCache/DCacheControl/wb_flush_cnt
add wave -noupdate -format Literal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v7/wb_val
add wave -noupdate -format Literal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v6/wb_val
add wave -noupdate -format Literal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v5/wb_val
add wave -noupdate -format Literal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v4/wb_val
add wave -noupdate -format Literal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v3/wb_val
add wave -noupdate -format Literal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v2/wb_val
add wave -noupdate -format Literal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v1/wb_val
add wave -noupdate -format Literal /TestBench/DUT_RTL/DCache/WriteBuffer/wb_v0/wb_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 522
configure wave -valuecolwidth 123
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
WaveRestoreZoom {101309 ns} {102633 ns}
