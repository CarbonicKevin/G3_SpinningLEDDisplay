#This tcl file runs in Vivado batch mode to create a project and bitstream for the Nexys Video Board.
#The project requires an SD card to be inserted, and will display the last byte of the first sector (address 0x1ff) on the LEDs. 
#For use with AXI, refer to the prepackaged IPs in ../../ip_repo

#From the command line, run the following to run this tcl file in vivado's batch script mode (refer to Tutorial 1 for details)
# `vivado –mode batch –source test_sd_card.tcl`

#Please set line 7 to where the project directory should go.

set project_dir /groups/tgbkgrp/sd_card_test
set sources ./srcs

create_project test_sd_card $project_dir -force -part xc7a200tsbg484-1
add_files -force -norecurse $sources/SDCard.vhd
add_files -force -norecurse $sources/common.vhd
add_files -force -norecurse $sources/sd_card_test.v

import_files -fileset constrs_1 -force -norecurse $sources/sd_constrs.xdc
update_compile_order -fileset sources_1

synth_design -rtl -name rtl_1

launch_runs synth_1
wait_on_run synth_1
launch_runs impl_1
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
