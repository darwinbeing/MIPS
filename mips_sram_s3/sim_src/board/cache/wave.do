onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /test_cache/clock
add wave -noupdate -format Logic /test_cache/rst
add wave -noupdate -format Literal -radix hexadecimal /test_cache/dut/set
add wave -noupdate -format Literal -radix hexadecimal /test_cache/adbus
add wave -noupdate -format Literal -radix hexadecimal /test_cache/cpubus
add wave -noupdate -format Literal -radix hexadecimal /test_cache/dut/databus_txd
add wave -noupdate -format Literal -radix hexadecimal /test_cache/dut/mem_databus_txd
add wave -noupdate -format Literal -radix hexadecimal /test_cache/cpu_databus
add wave -noupdate -format Literal -radix hexadecimal /test_cache/cache_databus
add wave -noupdate -format Literal -radix hexadecimal /test_cache/mem_adbus
add wave -noupdate -format Logic /test_cache/dut/hit
add wave -noupdate -color Coral -format Logic /test_cache/read
add wave -noupdate -color Coral -format Logic /test_cache/read_mem
add wave -noupdate -color Orchid -format Logic /test_cache/write
add wave -noupdate -color Orchid -format Logic /test_cache/write_mem
add wave -noupdate -format Logic /test_cache/grant_mem
add wave -noupdate -format Logic /test_cache/ready_mem
add wave -noupdate -format Logic /test_cache/ready_cache
add wave -noupdate -color Pink -format Logic /test_cache/cs
add wave -noupdate -color Pink -format Logic /test_cache/rwbar
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {2749 ns} 0}
configure wave -namecolwidth 347
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
WaveRestoreZoom {0 ns} {7328 ns}
