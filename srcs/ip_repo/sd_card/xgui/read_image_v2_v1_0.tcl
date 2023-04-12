# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDRESS_OFFSET" -parent ${Page_0}
  ipgui::add_param $IPINST -name "B_BYTE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "G_BYTE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IN_HEADER" -parent ${Page_0}
  ipgui::add_param $IPINST -name "READ_INIT_0" -parent ${Page_0}
  ipgui::add_param $IPINST -name "READ_INIT_1" -parent ${Page_0}
  ipgui::add_param $IPINST -name "READ_STATE_0" -parent ${Page_0}
  ipgui::add_param $IPINST -name "READ_STATE_1" -parent ${Page_0}
  ipgui::add_param $IPINST -name "R_BYTE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SEND_TO_BRAM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WAIT_SLAVE_RESP" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDRESS_OFFSET { PARAM_VALUE.ADDRESS_OFFSET } {
	# Procedure called to update ADDRESS_OFFSET when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDRESS_OFFSET { PARAM_VALUE.ADDRESS_OFFSET } {
	# Procedure called to validate ADDRESS_OFFSET
	return true
}

proc update_PARAM_VALUE.B_BYTE { PARAM_VALUE.B_BYTE } {
	# Procedure called to update B_BYTE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.B_BYTE { PARAM_VALUE.B_BYTE } {
	# Procedure called to validate B_BYTE
	return true
}

proc update_PARAM_VALUE.G_BYTE { PARAM_VALUE.G_BYTE } {
	# Procedure called to update G_BYTE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.G_BYTE { PARAM_VALUE.G_BYTE } {
	# Procedure called to validate G_BYTE
	return true
}

proc update_PARAM_VALUE.IN_HEADER { PARAM_VALUE.IN_HEADER } {
	# Procedure called to update IN_HEADER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IN_HEADER { PARAM_VALUE.IN_HEADER } {
	# Procedure called to validate IN_HEADER
	return true
}

proc update_PARAM_VALUE.READ_INIT_0 { PARAM_VALUE.READ_INIT_0 } {
	# Procedure called to update READ_INIT_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.READ_INIT_0 { PARAM_VALUE.READ_INIT_0 } {
	# Procedure called to validate READ_INIT_0
	return true
}

proc update_PARAM_VALUE.READ_INIT_1 { PARAM_VALUE.READ_INIT_1 } {
	# Procedure called to update READ_INIT_1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.READ_INIT_1 { PARAM_VALUE.READ_INIT_1 } {
	# Procedure called to validate READ_INIT_1
	return true
}

proc update_PARAM_VALUE.READ_STATE_0 { PARAM_VALUE.READ_STATE_0 } {
	# Procedure called to update READ_STATE_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.READ_STATE_0 { PARAM_VALUE.READ_STATE_0 } {
	# Procedure called to validate READ_STATE_0
	return true
}

proc update_PARAM_VALUE.READ_STATE_1 { PARAM_VALUE.READ_STATE_1 } {
	# Procedure called to update READ_STATE_1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.READ_STATE_1 { PARAM_VALUE.READ_STATE_1 } {
	# Procedure called to validate READ_STATE_1
	return true
}

proc update_PARAM_VALUE.R_BYTE { PARAM_VALUE.R_BYTE } {
	# Procedure called to update R_BYTE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.R_BYTE { PARAM_VALUE.R_BYTE } {
	# Procedure called to validate R_BYTE
	return true
}

proc update_PARAM_VALUE.SEND_TO_BRAM { PARAM_VALUE.SEND_TO_BRAM } {
	# Procedure called to update SEND_TO_BRAM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SEND_TO_BRAM { PARAM_VALUE.SEND_TO_BRAM } {
	# Procedure called to validate SEND_TO_BRAM
	return true
}

proc update_PARAM_VALUE.WAIT_SLAVE_RESP { PARAM_VALUE.WAIT_SLAVE_RESP } {
	# Procedure called to update WAIT_SLAVE_RESP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WAIT_SLAVE_RESP { PARAM_VALUE.WAIT_SLAVE_RESP } {
	# Procedure called to validate WAIT_SLAVE_RESP
	return true
}


proc update_MODELPARAM_VALUE.ADDRESS_OFFSET { MODELPARAM_VALUE.ADDRESS_OFFSET PARAM_VALUE.ADDRESS_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDRESS_OFFSET}] ${MODELPARAM_VALUE.ADDRESS_OFFSET}
}

proc update_MODELPARAM_VALUE.READ_INIT_0 { MODELPARAM_VALUE.READ_INIT_0 PARAM_VALUE.READ_INIT_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.READ_INIT_0}] ${MODELPARAM_VALUE.READ_INIT_0}
}

proc update_MODELPARAM_VALUE.READ_INIT_1 { MODELPARAM_VALUE.READ_INIT_1 PARAM_VALUE.READ_INIT_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.READ_INIT_1}] ${MODELPARAM_VALUE.READ_INIT_1}
}

proc update_MODELPARAM_VALUE.READ_STATE_0 { MODELPARAM_VALUE.READ_STATE_0 PARAM_VALUE.READ_STATE_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.READ_STATE_0}] ${MODELPARAM_VALUE.READ_STATE_0}
}

proc update_MODELPARAM_VALUE.READ_STATE_1 { MODELPARAM_VALUE.READ_STATE_1 PARAM_VALUE.READ_STATE_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.READ_STATE_1}] ${MODELPARAM_VALUE.READ_STATE_1}
}

proc update_MODELPARAM_VALUE.IN_HEADER { MODELPARAM_VALUE.IN_HEADER PARAM_VALUE.IN_HEADER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IN_HEADER}] ${MODELPARAM_VALUE.IN_HEADER}
}

proc update_MODELPARAM_VALUE.R_BYTE { MODELPARAM_VALUE.R_BYTE PARAM_VALUE.R_BYTE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.R_BYTE}] ${MODELPARAM_VALUE.R_BYTE}
}

proc update_MODELPARAM_VALUE.G_BYTE { MODELPARAM_VALUE.G_BYTE PARAM_VALUE.G_BYTE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.G_BYTE}] ${MODELPARAM_VALUE.G_BYTE}
}

proc update_MODELPARAM_VALUE.B_BYTE { MODELPARAM_VALUE.B_BYTE PARAM_VALUE.B_BYTE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.B_BYTE}] ${MODELPARAM_VALUE.B_BYTE}
}

proc update_MODELPARAM_VALUE.SEND_TO_BRAM { MODELPARAM_VALUE.SEND_TO_BRAM PARAM_VALUE.SEND_TO_BRAM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SEND_TO_BRAM}] ${MODELPARAM_VALUE.SEND_TO_BRAM}
}

proc update_MODELPARAM_VALUE.WAIT_SLAVE_RESP { MODELPARAM_VALUE.WAIT_SLAVE_RESP PARAM_VALUE.WAIT_SLAVE_RESP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WAIT_SLAVE_RESP}] ${MODELPARAM_VALUE.WAIT_SLAVE_RESP}
}

