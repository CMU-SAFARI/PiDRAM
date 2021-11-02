#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2016.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto cd62c4c9a12246c3a96447a4aff47991 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L xpm -L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0 -L axi_register_slice_v2_1_9 -L fifo_generator_v13_1_1 -L axi_data_fifo_v2_1_8 -L axi_crossbar_v2_1_10 -L processing_system7_bfm_v2_0_5 -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_9 -L axi_protocol_converter_v2_1_9 -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_memctl_top_behav xil_defaultlib.tb_memctl_top xil_defaultlib.glbl -log elaborate.log
