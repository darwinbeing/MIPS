onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /CheckTwoModels/mips_rtl/clk
add wave -noupdate -format Logic -radix hexadecimal /CheckTwoModels/mips_rtl/rst
add wave -noupdate -format Literal -height 25 -radix hexadecimal /CheckTwoModels/mips_rtl/inst_addr
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/abus1
add wave -noupdate -format Literal -height 25 -radix hexadecimal /CheckTwoModels/mips_rtl/inst
add wave -noupdate -format Literal -height 25 -radix hexadecimal /CheckTwoModels/mips_rtl/data_addr
add wave -noupdate -format Literal -radix hexadecimal /CheckTwoModels/abus2
add wave -noupdate -format Literal -height 25 -radix hexadecimal /CheckTwoModels/mips_rtl/data
add wave -noupdate -format Literal -height 25 -radix hexadecimal /CheckTwoModels/mips_rtl/dbus2i
add wave -noupdate -format Literal -height 25 -radix hexadecimal /CheckTwoModels/mips_rtl/bwe
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7198 ns} 0}
configure wave -namecolwidth 151
configure wave -valuecolwidth 156
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
WaveRestoreZoom {7152 ns} {7255 ns}
