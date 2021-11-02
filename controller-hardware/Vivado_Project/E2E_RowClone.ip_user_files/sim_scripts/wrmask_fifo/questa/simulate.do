onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -pli "/opt/Xilinx/Vivado/2016.2/lib/lnx64.o/libxil_vsim.so" -lib xil_defaultlib wrmask_fifo_opt

do {wave.do}

view wave
view structure
view signals

do {wrmask_fifo.udo}

run -all

quit -force
