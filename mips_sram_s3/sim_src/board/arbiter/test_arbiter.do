if {[file exists test_work]} {
	vdel -lib test_work -all
}

vlib test_work
vmap work test_work
vlog -work work arbiter.v test_arbiter.v
vcom arbitor.vhd

vsim -t ns -voptargs=+acc work.test_arbiter

do wave.do




