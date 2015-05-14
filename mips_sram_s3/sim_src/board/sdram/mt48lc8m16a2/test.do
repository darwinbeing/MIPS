vlog mt48lc8m16a2.v
vlog test.v
vsim -t ps -voptargs=+acc test
do wave.do
run -all
