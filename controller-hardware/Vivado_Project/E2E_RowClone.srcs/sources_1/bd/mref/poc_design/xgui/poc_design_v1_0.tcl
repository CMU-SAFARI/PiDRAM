# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BURST_MODE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CA_MIRROR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CLKIN_PERIOD" -parent ${Page_0}
  ipgui::add_param $IPINST -name "COL_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CS_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEBUG_PORT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DM_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DQS_CNT_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DQS_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DQ_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DRAM_TYPE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DRAM_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ECC" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ODT_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RANKS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "REFCLK_FREQ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ROW_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RST_ACT_LOW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SIM_BYPASS_INIT_CAL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TCQ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "nCK_PER_CLK" -parent ${Page_0}
  ipgui::add_param $IPINST -name "tCK" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to update ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to validate ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.BURST_MODE { PARAM_VALUE.BURST_MODE } {
	# Procedure called to update BURST_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BURST_MODE { PARAM_VALUE.BURST_MODE } {
	# Procedure called to validate BURST_MODE
	return true
}

proc update_PARAM_VALUE.CA_MIRROR { PARAM_VALUE.CA_MIRROR } {
	# Procedure called to update CA_MIRROR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CA_MIRROR { PARAM_VALUE.CA_MIRROR } {
	# Procedure called to validate CA_MIRROR
	return true
}

proc update_PARAM_VALUE.CLKIN_PERIOD { PARAM_VALUE.CLKIN_PERIOD } {
	# Procedure called to update CLKIN_PERIOD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLKIN_PERIOD { PARAM_VALUE.CLKIN_PERIOD } {
	# Procedure called to validate CLKIN_PERIOD
	return true
}

proc update_PARAM_VALUE.COL_WIDTH { PARAM_VALUE.COL_WIDTH } {
	# Procedure called to update COL_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COL_WIDTH { PARAM_VALUE.COL_WIDTH } {
	# Procedure called to validate COL_WIDTH
	return true
}

proc update_PARAM_VALUE.CS_WIDTH { PARAM_VALUE.CS_WIDTH } {
	# Procedure called to update CS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CS_WIDTH { PARAM_VALUE.CS_WIDTH } {
	# Procedure called to validate CS_WIDTH
	return true
}

proc update_PARAM_VALUE.DEBUG_PORT { PARAM_VALUE.DEBUG_PORT } {
	# Procedure called to update DEBUG_PORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBUG_PORT { PARAM_VALUE.DEBUG_PORT } {
	# Procedure called to validate DEBUG_PORT
	return true
}

proc update_PARAM_VALUE.DM_WIDTH { PARAM_VALUE.DM_WIDTH } {
	# Procedure called to update DM_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DM_WIDTH { PARAM_VALUE.DM_WIDTH } {
	# Procedure called to validate DM_WIDTH
	return true
}

proc update_PARAM_VALUE.DQS_CNT_WIDTH { PARAM_VALUE.DQS_CNT_WIDTH } {
	# Procedure called to update DQS_CNT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DQS_CNT_WIDTH { PARAM_VALUE.DQS_CNT_WIDTH } {
	# Procedure called to validate DQS_CNT_WIDTH
	return true
}

proc update_PARAM_VALUE.DQS_WIDTH { PARAM_VALUE.DQS_WIDTH } {
	# Procedure called to update DQS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DQS_WIDTH { PARAM_VALUE.DQS_WIDTH } {
	# Procedure called to validate DQS_WIDTH
	return true
}

proc update_PARAM_VALUE.DQ_WIDTH { PARAM_VALUE.DQ_WIDTH } {
	# Procedure called to update DQ_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DQ_WIDTH { PARAM_VALUE.DQ_WIDTH } {
	# Procedure called to validate DQ_WIDTH
	return true
}

proc update_PARAM_VALUE.DRAM_TYPE { PARAM_VALUE.DRAM_TYPE } {
	# Procedure called to update DRAM_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DRAM_TYPE { PARAM_VALUE.DRAM_TYPE } {
	# Procedure called to validate DRAM_TYPE
	return true
}

proc update_PARAM_VALUE.DRAM_WIDTH { PARAM_VALUE.DRAM_WIDTH } {
	# Procedure called to update DRAM_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DRAM_WIDTH { PARAM_VALUE.DRAM_WIDTH } {
	# Procedure called to validate DRAM_WIDTH
	return true
}

proc update_PARAM_VALUE.ECC { PARAM_VALUE.ECC } {
	# Procedure called to update ECC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ECC { PARAM_VALUE.ECC } {
	# Procedure called to validate ECC
	return true
}

proc update_PARAM_VALUE.ODT_WIDTH { PARAM_VALUE.ODT_WIDTH } {
	# Procedure called to update ODT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ODT_WIDTH { PARAM_VALUE.ODT_WIDTH } {
	# Procedure called to validate ODT_WIDTH
	return true
}

proc update_PARAM_VALUE.RANKS { PARAM_VALUE.RANKS } {
	# Procedure called to update RANKS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RANKS { PARAM_VALUE.RANKS } {
	# Procedure called to validate RANKS
	return true
}

proc update_PARAM_VALUE.REFCLK_FREQ { PARAM_VALUE.REFCLK_FREQ } {
	# Procedure called to update REFCLK_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REFCLK_FREQ { PARAM_VALUE.REFCLK_FREQ } {
	# Procedure called to validate REFCLK_FREQ
	return true
}

proc update_PARAM_VALUE.ROW_WIDTH { PARAM_VALUE.ROW_WIDTH } {
	# Procedure called to update ROW_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ROW_WIDTH { PARAM_VALUE.ROW_WIDTH } {
	# Procedure called to validate ROW_WIDTH
	return true
}

proc update_PARAM_VALUE.RST_ACT_LOW { PARAM_VALUE.RST_ACT_LOW } {
	# Procedure called to update RST_ACT_LOW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RST_ACT_LOW { PARAM_VALUE.RST_ACT_LOW } {
	# Procedure called to validate RST_ACT_LOW
	return true
}

proc update_PARAM_VALUE.SIM_BYPASS_INIT_CAL { PARAM_VALUE.SIM_BYPASS_INIT_CAL } {
	# Procedure called to update SIM_BYPASS_INIT_CAL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIM_BYPASS_INIT_CAL { PARAM_VALUE.SIM_BYPASS_INIT_CAL } {
	# Procedure called to validate SIM_BYPASS_INIT_CAL
	return true
}

proc update_PARAM_VALUE.TCQ { PARAM_VALUE.TCQ } {
	# Procedure called to update TCQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TCQ { PARAM_VALUE.TCQ } {
	# Procedure called to validate TCQ
	return true
}

proc update_PARAM_VALUE.nCK_PER_CLK { PARAM_VALUE.nCK_PER_CLK } {
	# Procedure called to update nCK_PER_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.nCK_PER_CLK { PARAM_VALUE.nCK_PER_CLK } {
	# Procedure called to validate nCK_PER_CLK
	return true
}

proc update_PARAM_VALUE.tCK { PARAM_VALUE.tCK } {
	# Procedure called to update tCK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tCK { PARAM_VALUE.tCK } {
	# Procedure called to validate tCK
	return true
}


proc update_MODELPARAM_VALUE.COL_WIDTH { MODELPARAM_VALUE.COL_WIDTH PARAM_VALUE.COL_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COL_WIDTH}] ${MODELPARAM_VALUE.COL_WIDTH}
}

proc update_MODELPARAM_VALUE.CS_WIDTH { MODELPARAM_VALUE.CS_WIDTH PARAM_VALUE.CS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CS_WIDTH}] ${MODELPARAM_VALUE.CS_WIDTH}
}

proc update_MODELPARAM_VALUE.DM_WIDTH { MODELPARAM_VALUE.DM_WIDTH PARAM_VALUE.DM_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DM_WIDTH}] ${MODELPARAM_VALUE.DM_WIDTH}
}

proc update_MODELPARAM_VALUE.DQ_WIDTH { MODELPARAM_VALUE.DQ_WIDTH PARAM_VALUE.DQ_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DQ_WIDTH}] ${MODELPARAM_VALUE.DQ_WIDTH}
}

proc update_MODELPARAM_VALUE.DQS_WIDTH { MODELPARAM_VALUE.DQS_WIDTH PARAM_VALUE.DQS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DQS_WIDTH}] ${MODELPARAM_VALUE.DQS_WIDTH}
}

proc update_MODELPARAM_VALUE.DQS_CNT_WIDTH { MODELPARAM_VALUE.DQS_CNT_WIDTH PARAM_VALUE.DQS_CNT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DQS_CNT_WIDTH}] ${MODELPARAM_VALUE.DQS_CNT_WIDTH}
}

proc update_MODELPARAM_VALUE.DRAM_WIDTH { MODELPARAM_VALUE.DRAM_WIDTH PARAM_VALUE.DRAM_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DRAM_WIDTH}] ${MODELPARAM_VALUE.DRAM_WIDTH}
}

proc update_MODELPARAM_VALUE.ECC { MODELPARAM_VALUE.ECC PARAM_VALUE.ECC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ECC}] ${MODELPARAM_VALUE.ECC}
}

proc update_MODELPARAM_VALUE.RANKS { MODELPARAM_VALUE.RANKS PARAM_VALUE.RANKS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RANKS}] ${MODELPARAM_VALUE.RANKS}
}

proc update_MODELPARAM_VALUE.ODT_WIDTH { MODELPARAM_VALUE.ODT_WIDTH PARAM_VALUE.ODT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ODT_WIDTH}] ${MODELPARAM_VALUE.ODT_WIDTH}
}

proc update_MODELPARAM_VALUE.ROW_WIDTH { MODELPARAM_VALUE.ROW_WIDTH PARAM_VALUE.ROW_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ROW_WIDTH}] ${MODELPARAM_VALUE.ROW_WIDTH}
}

proc update_MODELPARAM_VALUE.ADDR_WIDTH { MODELPARAM_VALUE.ADDR_WIDTH PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_WIDTH}] ${MODELPARAM_VALUE.ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.BURST_MODE { MODELPARAM_VALUE.BURST_MODE PARAM_VALUE.BURST_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BURST_MODE}] ${MODELPARAM_VALUE.BURST_MODE}
}

proc update_MODELPARAM_VALUE.CA_MIRROR { MODELPARAM_VALUE.CA_MIRROR PARAM_VALUE.CA_MIRROR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CA_MIRROR}] ${MODELPARAM_VALUE.CA_MIRROR}
}

proc update_MODELPARAM_VALUE.CLKIN_PERIOD { MODELPARAM_VALUE.CLKIN_PERIOD PARAM_VALUE.CLKIN_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLKIN_PERIOD}] ${MODELPARAM_VALUE.CLKIN_PERIOD}
}

proc update_MODELPARAM_VALUE.SIM_BYPASS_INIT_CAL { MODELPARAM_VALUE.SIM_BYPASS_INIT_CAL PARAM_VALUE.SIM_BYPASS_INIT_CAL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIM_BYPASS_INIT_CAL}] ${MODELPARAM_VALUE.SIM_BYPASS_INIT_CAL}
}

proc update_MODELPARAM_VALUE.TCQ { MODELPARAM_VALUE.TCQ PARAM_VALUE.TCQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TCQ}] ${MODELPARAM_VALUE.TCQ}
}

proc update_MODELPARAM_VALUE.RST_ACT_LOW { MODELPARAM_VALUE.RST_ACT_LOW PARAM_VALUE.RST_ACT_LOW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RST_ACT_LOW}] ${MODELPARAM_VALUE.RST_ACT_LOW}
}

proc update_MODELPARAM_VALUE.REFCLK_FREQ { MODELPARAM_VALUE.REFCLK_FREQ PARAM_VALUE.REFCLK_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REFCLK_FREQ}] ${MODELPARAM_VALUE.REFCLK_FREQ}
}

proc update_MODELPARAM_VALUE.tCK { MODELPARAM_VALUE.tCK PARAM_VALUE.tCK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tCK}] ${MODELPARAM_VALUE.tCK}
}

proc update_MODELPARAM_VALUE.nCK_PER_CLK { MODELPARAM_VALUE.nCK_PER_CLK PARAM_VALUE.nCK_PER_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.nCK_PER_CLK}] ${MODELPARAM_VALUE.nCK_PER_CLK}
}

proc update_MODELPARAM_VALUE.DEBUG_PORT { MODELPARAM_VALUE.DEBUG_PORT PARAM_VALUE.DEBUG_PORT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEBUG_PORT}] ${MODELPARAM_VALUE.DEBUG_PORT}
}

proc update_MODELPARAM_VALUE.DRAM_TYPE { MODELPARAM_VALUE.DRAM_TYPE PARAM_VALUE.DRAM_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DRAM_TYPE}] ${MODELPARAM_VALUE.DRAM_TYPE}
}

