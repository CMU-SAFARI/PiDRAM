onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -pli "/opt/Xilinx/Vivado/2016.2/lib/lnx64.o/libxil_vsim.so" -lib xil_defaultlib wrdata_fifo_opt

do {wave.do}

view wave
view structure
view signals

do {wrdata_fifo.udo}

run -all

quit -force
