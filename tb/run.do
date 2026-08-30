vlib work
vlog *.*v
vsim -voptargs=+acc work.ClkDiv_test
do wave.do
run -all