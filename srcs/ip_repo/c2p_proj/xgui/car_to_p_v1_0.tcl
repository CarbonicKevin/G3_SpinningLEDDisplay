# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BRAM_ADDR_OFF" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BRAM_BASE_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAP_DIM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAP_ENTRY_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MDIM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MDIM2" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NO_ARM_LED" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NO_DELTA_INTERVALS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OUT_DIM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RGB_SIZE" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to update ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to validate ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.BRAM_ADDR_OFF { PARAM_VALUE.BRAM_ADDR_OFF } {
	# Procedure called to update BRAM_ADDR_OFF when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BRAM_ADDR_OFF { PARAM_VALUE.BRAM_ADDR_OFF } {
	# Procedure called to validate BRAM_ADDR_OFF
	return true
}

proc update_PARAM_VALUE.BRAM_BASE_ADDR { PARAM_VALUE.BRAM_BASE_ADDR } {
	# Procedure called to update BRAM_BASE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BRAM_BASE_ADDR { PARAM_VALUE.BRAM_BASE_ADDR } {
	# Procedure called to validate BRAM_BASE_ADDR
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.MAP_DIM { PARAM_VALUE.MAP_DIM } {
	# Procedure called to update MAP_DIM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAP_DIM { PARAM_VALUE.MAP_DIM } {
	# Procedure called to validate MAP_DIM
	return true
}

proc update_PARAM_VALUE.MAP_ENTRY_SIZE { PARAM_VALUE.MAP_ENTRY_SIZE } {
	# Procedure called to update MAP_ENTRY_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAP_ENTRY_SIZE { PARAM_VALUE.MAP_ENTRY_SIZE } {
	# Procedure called to validate MAP_ENTRY_SIZE
	return true
}

proc update_PARAM_VALUE.MDIM { PARAM_VALUE.MDIM } {
	# Procedure called to update MDIM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MDIM { PARAM_VALUE.MDIM } {
	# Procedure called to validate MDIM
	return true
}

proc update_PARAM_VALUE.MDIM2 { PARAM_VALUE.MDIM2 } {
	# Procedure called to update MDIM2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MDIM2 { PARAM_VALUE.MDIM2 } {
	# Procedure called to validate MDIM2
	return true
}

proc update_PARAM_VALUE.NO_ARM_LED { PARAM_VALUE.NO_ARM_LED } {
	# Procedure called to update NO_ARM_LED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NO_ARM_LED { PARAM_VALUE.NO_ARM_LED } {
	# Procedure called to validate NO_ARM_LED
	return true
}

proc update_PARAM_VALUE.NO_DELTA_INTERVALS { PARAM_VALUE.NO_DELTA_INTERVALS } {
	# Procedure called to update NO_DELTA_INTERVALS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NO_DELTA_INTERVALS { PARAM_VALUE.NO_DELTA_INTERVALS } {
	# Procedure called to validate NO_DELTA_INTERVALS
	return true
}

proc update_PARAM_VALUE.OUT_DIM { PARAM_VALUE.OUT_DIM } {
	# Procedure called to update OUT_DIM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OUT_DIM { PARAM_VALUE.OUT_DIM } {
	# Procedure called to validate OUT_DIM
	return true
}

proc update_PARAM_VALUE.RGB_SIZE { PARAM_VALUE.RGB_SIZE } {
	# Procedure called to update RGB_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RGB_SIZE { PARAM_VALUE.RGB_SIZE } {
	# Procedure called to validate RGB_SIZE
	return true
}


proc update_MODELPARAM_VALUE.NO_ARM_LED { MODELPARAM_VALUE.NO_ARM_LED PARAM_VALUE.NO_ARM_LED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NO_ARM_LED}] ${MODELPARAM_VALUE.NO_ARM_LED}
}

proc update_MODELPARAM_VALUE.NO_DELTA_INTERVALS { MODELPARAM_VALUE.NO_DELTA_INTERVALS PARAM_VALUE.NO_DELTA_INTERVALS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NO_DELTA_INTERVALS}] ${MODELPARAM_VALUE.NO_DELTA_INTERVALS}
}

proc update_MODELPARAM_VALUE.MDIM { MODELPARAM_VALUE.MDIM PARAM_VALUE.MDIM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MDIM}] ${MODELPARAM_VALUE.MDIM}
}

proc update_MODELPARAM_VALUE.MDIM2 { MODELPARAM_VALUE.MDIM2 PARAM_VALUE.MDIM2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MDIM2}] ${MODELPARAM_VALUE.MDIM2}
}

proc update_MODELPARAM_VALUE.MAP_ENTRY_SIZE { MODELPARAM_VALUE.MAP_ENTRY_SIZE PARAM_VALUE.MAP_ENTRY_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAP_ENTRY_SIZE}] ${MODELPARAM_VALUE.MAP_ENTRY_SIZE}
}

proc update_MODELPARAM_VALUE.RGB_SIZE { MODELPARAM_VALUE.RGB_SIZE PARAM_VALUE.RGB_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RGB_SIZE}] ${MODELPARAM_VALUE.RGB_SIZE}
}

proc update_MODELPARAM_VALUE.MAP_DIM { MODELPARAM_VALUE.MAP_DIM PARAM_VALUE.MAP_DIM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAP_DIM}] ${MODELPARAM_VALUE.MAP_DIM}
}

proc update_MODELPARAM_VALUE.OUT_DIM { MODELPARAM_VALUE.OUT_DIM PARAM_VALUE.OUT_DIM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OUT_DIM}] ${MODELPARAM_VALUE.OUT_DIM}
}

proc update_MODELPARAM_VALUE.BRAM_BASE_ADDR { MODELPARAM_VALUE.BRAM_BASE_ADDR PARAM_VALUE.BRAM_BASE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAM_BASE_ADDR}] ${MODELPARAM_VALUE.BRAM_BASE_ADDR}
}

proc update_MODELPARAM_VALUE.BRAM_ADDR_OFF { MODELPARAM_VALUE.BRAM_ADDR_OFF PARAM_VALUE.BRAM_ADDR_OFF } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAM_ADDR_OFF}] ${MODELPARAM_VALUE.BRAM_ADDR_OFF}
}

proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.ADDR_WIDTH { MODELPARAM_VALUE.ADDR_WIDTH PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_WIDTH}] ${MODELPARAM_VALUE.ADDR_WIDTH}
}

