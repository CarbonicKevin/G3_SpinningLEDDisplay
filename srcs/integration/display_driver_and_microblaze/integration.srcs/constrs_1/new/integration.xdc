# Constraining pins for the LED Driver IP
set_property -dict { PACKAGE_PIN AA21   IOSTANDARD LVCMOS33 } [get_ports {led_gpio_0_tri_o[1]}]; # JA7 (bottom right)     
set_property -dict { PACKAGE_PIN Y21   IOSTANDARD LVCMOS33 } [get_ports {led_gpio_0_tri_o[0]}];  # JA8 (one left of JA7)


# Constraining pins for the I2C Driver IP
set_property -dict { PACKAGE_PIN AB22   IOSTANDARD LVCMOS33 } [get_ports { iic_to_encoder_scl_io }]; # JA1
set_property -dict { PACKAGE_PIN AB21   IOSTANDARD LVCMOS33 } [get_ports { iic_to_encoder_sda_io }]; # JA2


# Constraining pins for the HBridge IP
set_property -dict { PACKAGE_PIN V9   IOSTANDARD LVCMOS33 } [get_ports { jb_pin1_io }]; # JB1
set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports { jb_pin2_io }]; # JB2
set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS33 } [get_ports { jb_pin3_io }]; # JB3
set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports { jb_pin4_io }]; # JB4
set_property -dict { PACKAGE_PIN W9   IOSTANDARD LVCMOS33 } [get_ports { jb_pin7_io }]; # JB7
set_property -dict { PACKAGE_PIN Y9   IOSTANDARD LVCMOS33 } [get_ports { jb_pin8_io }]; # JB8
set_property -dict { PACKAGE_PIN Y8   IOSTANDARD LVCMOS33 } [get_ports { jb_pin9_io }]; # JB9
set_property -dict { PACKAGE_PIN Y7   IOSTANDARD LVCMOS33 } [get_ports { jb_pin10_io }]; # JB10