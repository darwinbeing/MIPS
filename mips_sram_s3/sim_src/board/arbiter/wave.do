onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /test_arbiter/clock
add wave -noupdate -format Logic /test_arbiter/rst
add wave -noupdate -format Literal /test_arbiter/read_request
add wave -noupdate -format Literal /test_arbiter/write_request
add wave -noupdate -format Logic /test_arbiter/skip_wait
add wave -noupdate -format Literal /test_arbiter/beh/grant
add wave -noupdate -format Literal /test_arbiter/rtl/grant
add wave -noupdate -format Logic /test_arbiter/beh/memsel
add wave -noupdate -format Logic /test_arbiter/rtl/memsel
add wave -noupdate -format Logic /test_arbiter/beh/rwbar
add wave -noupdate -format Logic /test_arbiter/rtl/rwbar
add wave -noupdate -format Logic /test_arbiter/beh/ready
add wave -noupdate -format Logic /test_arbiter/rtl/ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {720 ns} 0}
configure wave -namecolwidth 309
configure wave -valuecolwidth 186
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
WaveRestoreZoom {515 ns} {1170 ns}
