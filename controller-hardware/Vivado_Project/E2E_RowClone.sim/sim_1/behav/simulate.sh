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
ExecStep $xv_path/bin/xsim tb_memctl_top_behav -key {Behavioral:sim_1:Functional:tb_memctl_top} -tclbatch tb_memctl_top.tcl -view /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/tb_memctl_mig_behav.wcfg -log simulate.log
