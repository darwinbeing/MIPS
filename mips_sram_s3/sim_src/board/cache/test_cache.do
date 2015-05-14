if {[file exists test_work]} {
	vdel -lib test_work -all
}

vlib test_work
vmap work test_work

vlog -work work cache_word.v memory.v test_cache.v 
vlog -work work ../arbiter/arbiter.v

vsim -t ns -voptargs=+acc work.test_cache

#do wave.do




