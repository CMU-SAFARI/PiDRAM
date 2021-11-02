onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+rchip_axi4_xbar -pli "/opt/Xilinx/Vivado/2016.2/lib/lnx64.o/libxil_vsim.so" -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0 -L axi_register_slice_v2_1_9 -L fifo_generator_v13_1_1 -L axi_data_fifo_v2_1_8 -L axi_crossbar_v2_1_10 -O5 xil_defaultlib.rchip_axi4_xbar xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {rchip_axi4_xbar.udo}

run -all

endsim

quit -force
