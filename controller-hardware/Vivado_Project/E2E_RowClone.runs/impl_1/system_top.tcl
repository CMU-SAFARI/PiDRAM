proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  create_project -in_memory -part xc7z045ffg900-2
  set_property board_part xilinx.com:zc706:part0:1.3 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.cache/wt [current_project]
  set_property parent.project_path /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.xpr [current_project]
  set_property ip_repo_paths /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.cache/ip [current_project]
  set_property ip_output_repo /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.cache/ip [current_project]
  set_property XPM_LIBRARIES XPM_MEMORY [current_project]
  add_files -quiet /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.runs/synth_1/system_top.dcp
  add_files -quiet /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rchip_axi4_xbar/rchip_axi4_xbar.dcp
  set_property netlist_only true [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rchip_axi4_xbar/rchip_axi4_xbar.dcp]
  add_files -quiet /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/read_metadata_fifo/read_metadata_fifo.dcp
  set_property netlist_only true [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/read_metadata_fifo/read_metadata_fifo.dcp]
  add_files -quiet /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rng_fifo/rng_fifo.dcp
  set_property netlist_only true [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rng_fifo/rng_fifo.dcp]
  add_files -quiet /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrdata_fifo/wrdata_fifo.dcp
  set_property netlist_only true [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrdata_fifo/wrdata_fifo.dcp]
  add_files -quiet /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrmask_fifo/wrmask_fifo.dcp
  set_property netlist_only true [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrmask_fifo/wrmask_fifo.dcp]
  read_xdc -ref system_processing_system7_0_0 -cells inst /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_processing_system7_0_0/system_processing_system7_0_0.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_processing_system7_0_0/system_processing_system7_0_0.xdc]
  read_xdc -prop_thru_buffers -ref system_proc_sys_reset_0_0 -cells U0 /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_proc_sys_reset_0_0/system_proc_sys_reset_0_0_board.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_proc_sys_reset_0_0/system_proc_sys_reset_0_0_board.xdc]
  read_xdc -ref system_proc_sys_reset_0_0 -cells U0 /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_proc_sys_reset_0_0/system_proc_sys_reset_0_0.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/sources/bd/system/ip/system_proc_sys_reset_0_0/system_proc_sys_reset_0_0.xdc]
  read_xdc -mode out_of_context -ref rchip_axi4_xbar -cells inst /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rchip_axi4_xbar/rchip_axi4_xbar_ooc.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rchip_axi4_xbar/rchip_axi4_xbar_ooc.xdc]
  read_xdc -mode out_of_context -ref read_metadata_fifo -cells U0 /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/read_metadata_fifo/read_metadata_fifo_ooc.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/read_metadata_fifo/read_metadata_fifo_ooc.xdc]
  read_xdc -ref read_metadata_fifo -cells U0 /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/read_metadata_fifo/read_metadata_fifo/read_metadata_fifo.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/read_metadata_fifo/read_metadata_fifo/read_metadata_fifo.xdc]
  read_xdc -mode out_of_context -ref rng_fifo -cells U0 /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rng_fifo/rng_fifo_ooc.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rng_fifo/rng_fifo_ooc.xdc]
  read_xdc -ref rng_fifo -cells U0 /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rng_fifo/rng_fifo/rng_fifo.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rng_fifo/rng_fifo/rng_fifo.xdc]
  read_xdc -mode out_of_context -ref wrdata_fifo -cells U0 /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrdata_fifo/wrdata_fifo_ooc.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrdata_fifo/wrdata_fifo_ooc.xdc]
  read_xdc -ref wrdata_fifo -cells U0 /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrdata_fifo/wrdata_fifo/wrdata_fifo.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrdata_fifo/wrdata_fifo/wrdata_fifo.xdc]
  read_xdc -mode out_of_context -ref wrmask_fifo -cells U0 /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrmask_fifo/wrmask_fifo_ooc.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrmask_fifo/wrmask_fifo_ooc.xdc]
  read_xdc -ref wrmask_fifo -cells U0 /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrmask_fifo/wrmask_fifo/wrmask_fifo.xdc
  set_property processing_order EARLY [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/wrmask_fifo/wrmask_fifo/wrmask_fifo.xdc]
  read_xdc /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/constrs_1/new/fullsystem_ZC706.xdc
  read_xdc -ref rng_fifo -cells U0 /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rng_fifo/rng_fifo/rng_fifo_clocks.xdc
  set_property processing_order LATE [get_files /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rng_fifo/rng_fifo/rng_fifo_clocks.xdc]
  link_design -top system_top -part xc7z045ffg900-2
  write_hwdef -file system_top.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force system_top_opt.dcp
  report_drc -file system_top_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force system_top_placed.dcp
  report_io -file system_top_io_placed.rpt
  report_utilization -file system_top_utilization_placed.rpt -pb system_top_utilization_placed.pb
  report_control_sets -verbose -file system_top_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force system_top_routed.dcp
  report_drc -file system_top_drc_routed.rpt -pb system_top_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file system_top_timing_summary_routed.rpt -rpx system_top_timing_summary_routed.rpx
  report_power -file system_top_power_routed.rpt -pb system_top_power_summary_routed.pb -rpx system_top_power_routed.rpx
  report_route_status -file system_top_route_status.rpt -pb system_top_route_status.pb
  report_clock_utilization -file system_top_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force system_top.mmi }
  write_bitstream -force system_top.bit 
  catch { write_sysdef -hwdef system_top.hwdef -bitfile system_top.bit -meminfo system_top.mmi -file system_top.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

