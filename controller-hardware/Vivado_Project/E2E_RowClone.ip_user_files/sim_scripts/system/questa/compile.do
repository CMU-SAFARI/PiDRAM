vlib work
vlib msim

vlib msim/xil_defaultlib
vlib msim/xpm
vlib msim/processing_system7_bfm_v2_0_5
vlib msim/lib_cdc_v1_0_2
vlib msim/proc_sys_reset_v5_0_9
vlib msim/generic_baseblocks_v2_1_0
vlib msim/fifo_generator_v13_1_1
vlib msim/axi_data_fifo_v2_1_8
vlib msim/axi_infrastructure_v1_1_0
vlib msim/axi_register_slice_v2_1_9
vlib msim/axi_protocol_converter_v2_1_9

vmap xil_defaultlib msim/xil_defaultlib
vmap xpm msim/xpm
vmap processing_system7_bfm_v2_0_5 msim/processing_system7_bfm_v2_0_5
vmap lib_cdc_v1_0_2 msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_9 msim/proc_sys_reset_v5_0_9
vmap generic_baseblocks_v2_1_0 msim/generic_baseblocks_v2_1_0
vmap fifo_generator_v13_1_1 msim/fifo_generator_v13_1_1
vmap axi_data_fifo_v2_1_8 msim/axi_data_fifo_v2_1_8
vmap axi_infrastructure_v1_1_0 msim/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_9 msim/axi_register_slice_v2_1_9
vmap axi_protocol_converter_v2_1_9 msim/axi_protocol_converter_v2_1_9

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" \
"/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_base.sv" \
"/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_dpdistram.sv" \
"/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_dprom.sv" \
"/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_sdpram.sv" \
"/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_spram.sv" \
"/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_sprom.sv" \
"/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_tdpram.sv" \

vcom -work xpm -64 \
"/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work processing_system7_bfm_v2_0_5 -64 "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_arb_wr.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_arb_rd.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_arb_wr_4.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_arb_rd_4.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_arb_hp2_3.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_arb_hp0_1.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_ssw_hp.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_sparse_mem.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_reg_map.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_ocm_mem.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_intr_wr_mem.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_intr_rd_mem.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_fmsw_gp.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_regc.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_ocmc.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_interconnect_model.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_gen_reset.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_gen_clock.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_ddrc.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_axi_slave.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_axi_master.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_afi_slave.v" \
"../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl/processing_system7_bfm_v2_0_processing_system7_bfm.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" \
"../../../bd/system/ip/system_processing_system7_0_0/sim/system_processing_system7_0_0.v" \

vcom -work lib_cdc_v1_0_2 -64 \
"../../../../../sources/bd/system/ip/system_proc_sys_reset_0_0/lib_cdc_v1_0_2/hdl/src/vhdl/cdc_sync.vhd" \

vcom -work proc_sys_reset_v5_0_9 -64 \
"../../../../../sources/bd/system/ip/system_proc_sys_reset_0_0/proc_sys_reset_v5_0_9/hdl/src/vhdl/upcnt_n.vhd" \
"../../../../../sources/bd/system/ip/system_proc_sys_reset_0_0/proc_sys_reset_v5_0_9/hdl/src/vhdl/sequence_psr.vhd" \
"../../../../../sources/bd/system/ip/system_proc_sys_reset_0_0/proc_sys_reset_v5_0_9/hdl/src/vhdl/lpf.vhd" \
"../../../../../sources/bd/system/ip/system_proc_sys_reset_0_0/proc_sys_reset_v5_0_9/hdl/src/vhdl/proc_sys_reset.vhd" \

vcom -work xil_defaultlib -64 \
"../../../bd/system/ip/system_proc_sys_reset_0_0/sim/system_proc_sys_reset_0_0.vhd" \

vlog -work generic_baseblocks_v2_1_0 -64 "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_carry_and.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_carry_latch_and.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_carry_latch_or.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_carry_or.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_carry.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_command_fifo.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_comparator_mask_static.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_comparator_mask.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_comparator_sel_mask_static.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_comparator_sel_mask.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_comparator_sel_static.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_comparator_sel.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_comparator_static.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_comparator.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_mux_enc.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_mux.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/generic_baseblocks_v2_1_0/hdl/verilog/generic_baseblocks_v2_1_nto1_mux.v" \

vlog -work fifo_generator_v13_1_1 -64 "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/fifo_generator_v13_1_1/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_1_1 -64 \
"../../../../../sources/bd/system/ip/system_auto_pc_0/fifo_generator_v13_1_1/hdl/fifo_generator_v13_1_rfs.vhd" \

vlog -work fifo_generator_v13_1_1 -64 "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/fifo_generator_v13_1_1/hdl/fifo_generator_v13_1_rfs.v" \

vlog -work axi_data_fifo_v2_1_8 -64 "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_data_fifo_v2_1_8/hdl/verilog/axi_data_fifo_v2_1_axic_fifo.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_data_fifo_v2_1_8/hdl/verilog/axi_data_fifo_v2_1_fifo_gen.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_data_fifo_v2_1_8/hdl/verilog/axi_data_fifo_v2_1_axic_srl_fifo.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_data_fifo_v2_1_8/hdl/verilog/axi_data_fifo_v2_1_axic_reg_srl_fifo.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_data_fifo_v2_1_8/hdl/verilog/axi_data_fifo_v2_1_ndeep_srl.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_data_fifo_v2_1_8/hdl/verilog/axi_data_fifo_v2_1_axi_data_fifo.v" \

vlog -work axi_infrastructure_v1_1_0 -64 "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog/axi_infrastructure_v1_1_axi2vector.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog/axi_infrastructure_v1_1_axic_srl_fifo.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog/axi_infrastructure_v1_1_vector2axi.v" \

vlog -work axi_register_slice_v2_1_9 -64 "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_register_slice_v2_1_9/hdl/verilog/axi_register_slice_v2_1_axic_register_slice.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_register_slice_v2_1_9/hdl/verilog/axi_register_slice_v2_1_axi_register_slice.v" \

vlog -work axi_protocol_converter_v2_1_9 -64 "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_a_axi3_conv.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_axi3_conv.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_axilite_conv.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_r_axi3_conv.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_w_axi3_conv.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b_downsizer.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_decerr_slave.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b2s_simple_fifo.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b2s_wrap_cmd.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b2s_incr_cmd.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b2s_wr_cmd_fsm.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b2s_rd_cmd_fsm.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b2s_cmd_translator.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b2s_b_channel.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b2s_r_channel.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b2s_aw_channel.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b2s_ar_channel.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_b2s.v" \
"../../../../../sources/bd/system/ip/system_auto_pc_0/axi_protocol_converter_v2_1_9/hdl/verilog/axi_protocol_converter_v2_1_axi_protocol_converter.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_0/axi_infrastructure_v1_1_0/hdl/verilog" "+incdir+../../../../../sources/bd/system/ip/system_processing_system7_0_0/processing_system7_bfm_v2_0_5/hdl" "+incdir+../../../../../sources/bd/system/ip/system_auto_pc_1/axi_infrastructure_v1_1_0/hdl/verilog" \
"../../../bd/system/ip/system_auto_pc_0/sim/system_auto_pc_0.v" \
"../../../bd/system/ip/system_auto_pc_1/sim/system_auto_pc_1.v" \
"../../../bd/system/hdl/system.v" \

vlog -work xil_defaultlib "glbl.v"

