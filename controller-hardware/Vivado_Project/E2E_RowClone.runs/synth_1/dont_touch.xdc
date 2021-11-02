# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: new/fullsystem_ZC706.xdc

# Block Designs: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/system.bd
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==system || ORIG_REF_NAME==system}]

# IP: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_processing_system7_0_0/system_processing_system7_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==system_processing_system7_0_0 || ORIG_REF_NAME==system_processing_system7_0_0}]

# IP: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_axi_interconnect_0_0/system_axi_interconnect_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==system_axi_interconnect_0_0 || ORIG_REF_NAME==system_axi_interconnect_0_0}]

# IP: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_proc_sys_reset_0_0/system_proc_sys_reset_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==system_proc_sys_reset_0_0 || ORIG_REF_NAME==system_proc_sys_reset_0_0}]

# IP: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_axi_interconnect_1_0/system_axi_interconnect_1_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==system_axi_interconnect_1_0 || ORIG_REF_NAME==system_axi_interconnect_1_0}]

# IP: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_auto_pc_0/system_auto_pc_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==system_auto_pc_0 || ORIG_REF_NAME==system_auto_pc_0}]

# IP: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_auto_pc_1/system_auto_pc_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==system_auto_pc_1 || ORIG_REF_NAME==system_auto_pc_1}]

# XDC: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_processing_system7_0_0/system_processing_system7_0_0.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==system_processing_system7_0_0 || ORIG_REF_NAME==system_processing_system7_0_0}] {/inst }]/inst ]]

# XDC: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_proc_sys_reset_0_0/system_proc_sys_reset_0_0_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==system_proc_sys_reset_0_0 || ORIG_REF_NAME==system_proc_sys_reset_0_0}] {/U0 }]/U0 ]]

# XDC: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_proc_sys_reset_0_0/system_proc_sys_reset_0_0.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==system_proc_sys_reset_0_0 || ORIG_REF_NAME==system_proc_sys_reset_0_0}] {/U0 }]/U0 ]]

# XDC: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_proc_sys_reset_0_0/system_proc_sys_reset_0_0_ooc.xdc

# XDC: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_auto_pc_0/system_auto_pc_0_ooc.xdc

# XDC: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_auto_pc_1/system_auto_pc_1_ooc.xdc

# XDC: /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/system_ooc.xdc