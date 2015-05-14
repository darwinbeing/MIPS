onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /CheckTwoModels/clk
add wave -noupdate -format Logic /CheckTwoModels/rst
add wave -noupdate -format Logic -radix hexadecimal /CheckTwoModels/run
add wave -noupdate -format Logic -radix hexadecimal /CheckTwoModels/start
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/abus1
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/dbus1
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/abus2
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/mips_rtl/dbus2i
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/mips_rtl/dbus2o
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/mips_rtl/Processor/IF/PC
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/mips_beh/PC
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/mips_beh/instr
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/mips_beh/paddr
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/mips_beh/vaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10203 ns} 0}
configure wave -namecolwidth 427
configure wave -valuecolwidth 313
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
WaveRestoreZoom {11660 ns} {13571 ns}
