onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+rng_fifo -pli "/opt/Xilinx/Vivado/2016.2/lib/lnx64.o/libxil_vsim.so" -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -L fifo_generator_v13_1_1 -O5 xil_defaultlib.rng_fifo xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {rng_fifo.udo}

run -all

endsim

quit -force
