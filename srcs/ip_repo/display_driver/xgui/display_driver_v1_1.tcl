# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "N_ARMS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N_ANGLES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N_LEDS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LED_BRIGHTNESS_0" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LED_BRIGHTNESS_1" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LED_BRIGHTNESS_2" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LED_BRIGHTNESS_3" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to update ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to validate ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.LED_BRIGHTNESS_0 { PARAM_VALUE.LED_BRIGHTNESS_0 } {
	# Procedure called to update LED_BRIGHTNESS_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LED_BRIGHTNESS_0 { PARAM_VALUE.LED_BRIGHTNESS_0 } {
	# Procedure called to validate LED_BRIGHTNESS_0
	return true
}

proc update_PARAM_VALUE.LED_BRIGHTNESS_1 { PARAM_VALUE.LED_BRIGHTNESS_1 } {
	# Procedure called to update LED_BRIGHTNESS_1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LED_BRIGHTNESS_1 { PARAM_VALUE.LED_BRIGHTNESS_1 } {
	# Procedure called to validate LED_BRIGHTNESS_1
	return true
}

proc update_PARAM_VALUE.LED_BRIGHTNESS_2 { PARAM_VALUE.LED_BRIGHTNESS_2 } {
	# Procedure called to update LED_BRIGHTNESS_2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LED_BRIGHTNESS_2 { PARAM_VALUE.LED_BRIGHTNESS_2 } {
	# Procedure called to validate LED_BRIGHTNESS_2
	return true
}

proc update_PARAM_VALUE.LED_BRIGHTNESS_3 { PARAM_VALUE.LED_BRIGHTNESS_3 } {
	# Procedure called to update LED_BRIGHTNESS_3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LED_BRIGHTNESS_3 { PARAM_VALUE.LED_BRIGHTNESS_3 } {
	# Procedure called to validate LED_BRIGHTNESS_3
	return true
}

proc update_PARAM_VALUE.N_ANGLES { PARAM_VALUE.N_ANGLES } {
	# Procedure called to update N_ANGLES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_ANGLES { PARAM_VALUE.N_ANGLES } {
	# Procedure called to validate N_ANGLES
	return true
}

proc update_PARAM_VALUE.N_ARMS { PARAM_VALUE.N_ARMS } {
	# Procedure called to update N_ARMS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_ARMS { PARAM_VALUE.N_ARMS } {
	# Procedure called to validate N_ARMS
	return true
}

proc update_PARAM_VALUE.N_LEDS { PARAM_VALUE.N_LEDS } {
	# Procedure called to update N_LEDS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_LEDS { PARAM_VALUE.N_LEDS } {
	# Procedure called to validate N_LEDS
	return true
}


proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.ADDR_WIDTH { MODELPARAM_VALUE.ADDR_WIDTH PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_WIDTH}] ${MODELPARAM_VALUE.ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.N_ARMS { MODELPARAM_VALUE.N_ARMS PARAM_VALUE.N_ARMS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_ARMS}] ${MODELPARAM_VALUE.N_ARMS}
}

proc update_MODELPARAM_VALUE.N_ANGLES { MODELPARAM_VALUE.N_ANGLES PARAM_VALUE.N_ANGLES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_ANGLES}] ${MODELPARAM_VALUE.N_ANGLES}
}

proc update_MODELPARAM_VALUE.N_LEDS { MODELPARAM_VALUE.N_LEDS PARAM_VALUE.N_LEDS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_LEDS}] ${MODELPARAM_VALUE.N_LEDS}
}

proc update_MODELPARAM_VALUE.LED_BRIGHTNESS_0 { MODELPARAM_VALUE.LED_BRIGHTNESS_0 PARAM_VALUE.LED_BRIGHTNESS_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LED_BRIGHTNESS_0}] ${MODELPARAM_VALUE.LED_BRIGHTNESS_0}
}

proc update_MODELPARAM_VALUE.LED_BRIGHTNESS_1 { MODELPARAM_VALUE.LED_BRIGHTNESS_1 PARAM_VALUE.LED_BRIGHTNESS_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LED_BRIGHTNESS_1}] ${MODELPARAM_VALUE.LED_BRIGHTNESS_1}
}

proc update_MODELPARAM_VALUE.LED_BRIGHTNESS_2 { MODELPARAM_VALUE.LED_BRIGHTNESS_2 PARAM_VALUE.LED_BRIGHTNESS_2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LED_BRIGHTNESS_2}] ${MODELPARAM_VALUE.LED_BRIGHTNESS_2}
}

proc update_MODELPARAM_VALUE.LED_BRIGHTNESS_3 { MODELPARAM_VALUE.LED_BRIGHTNESS_3 PARAM_VALUE.LED_BRIGHTNESS_3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LED_BRIGHTNESS_3}] ${MODELPARAM_VALUE.LED_BRIGHTNESS_3}
}

