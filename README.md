
---

# Spinning LED Display

### University of Toronto | Winter Semester 2023 | ECE532
### Authors : Kevin Kim, Nikoo Givehchian, Spencer Ball, Eddie Tian

---

## 1. Description
This project was for ECE532 - Digital Systems Design.
We aimed to create a spinning strip of LEDs to display various images.
When spun fast enough, the LEDs would create a holographic effect.

The device was implemented on the [Digilent Nexys Video board](https://digilent.com/reference/programmable-logic/nexys-video/start). The platform is based on Xilinx's Artix 7 FPGA (XC7A200T-1SBG484C).

The physical components of the device are was mostly custom-made. The spinning core is made of a composite assembly of machined aluminium, copper tubing and 3D printed PLA.

There are 4 discrete digital components implemented onto the FPGA.
1. Image Input Block - Partially Custom    
   *Responsible for reading the input image from an SD card.*  
   The SD card is read using an IP provided by XESSCorp, which can be found [here](https://github.com/xesscorp/VHDL_Lib). They are the `.vhd` files in `srcs/ip_repo/sd_card`. The raw data from the SD card is then checked for compatibility, reformatted, and placed on an AXI bus with a custom IP. This is the `.v` file in the same location.

2. Image Processing - Custom
   *Responsible for transforming the image into radial coordinates*

3. Display Driver - Custom
   *Responsible for selecting which row of the image data to output onto the LEDs at a particular angle*

4. Microblaze  
    *Responsible for controlling and communicating with other blocks* 
    The Microblaze reads angles from the encoder using Xilinx's AXI IIC IP which comes pre-installed in Vivado.
    Additionally, the block diagram contains the PmodDHB1 IP from Digilent, which can be found [here](https://github.com/Digilent/vivado-library). This h-bridge driver ended up not being used in the final demo due to motor controller incompatibility
    issues, but would work with the DHB2 Pmod provided by ECE532 for driving lower power motors.

Included in this repo are the packaged blocks used to display in the project, the tcl files to recreate any project files, as well as presentation files and reports.

## 2. How to Use

Within the intrgration folder, there are 2 folders in which we have the SD card and cartesian to polar mapping block integrated, and also one folder with the LED driver + microblaze integrated. To open each respective project, locate the tcl file and run the following:
`source {filename}.tcl`
For the LED driver + microblaze component, the vitis_src folder contains the scripts to be added to the vitis project.

Vivado version: 2021.1

### SD Card Block

Follow the steps in the `.tcl` file under `$GIT_ROOT/srcs/projects/sd_card`

## 3. Repository Structure

```
├───docs
│   └───device_manuals: contains various manuals for the different devices used
│       │
│       ├───nexys-video_rm.pdf: https://digilent.com/reference/programmable-logic/nexys-video/start
│       │
│       └───WS2812B.pdf: https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf
│
├───test: contains test script for coordinate mapper algorithm
│   ├───test.py: test script to test cartesian to polar mapping algorithm
│   │
│   ├───test.c: script to generate coordinate map, to be integrated with microblaze
│   │
│   ├───test_image2.png: test image for the coordinate mapper
│   │
│   └───test_image2_o.png: output of test for coordinate mapper
│
└───srcs
    ├───ip_repo: exported custom IPs
    │   │
    │   ├───display_driver: display driver repo
    │   │
    │   ├───c2p_proj: cartesian to polar mapping block repo
    │   │
    │   ├───sd_card: sd card reader repo
    │   │
    │   └───digilent_precanned: digilent IP repo for Vivado found [here](https://github.com/Digilent/vivado-library). 
    |
    ├───projects: folders that contain files for various projects
    |   ├───display_driver: projects to test the display driver.
    |   │   │
    |   │   ├───scripts
    |   │   │   │
    |   │   │   └───led_values_gen.py: small script to quickly generate some test LED values
    |   │   │
    |   │   ├───src_microblaze
    |   │   │   │
    |   │   │   ├───main.c: test code to run with the project_microblaze.tcl
    |   │   │   │
    |   │   │   └───microblaze.xdc: constraint for project_microblaze.tcl
    |   │   │
    |   │   ├───src_sim
    |   │   │   ├───dd_sim_behav.wcfg: waveform simulation file for project_vip_sim.tcl
    |   │   │   │
    |   │   │   └───dd_sim.sv: simulation sv file for project_vip_sim.tcl
    |   │   │
    |   │   ├───project_microblaze.tcl: tcl file to recreate the microblaze integration with the display driver.
    |   │   │
    |   │   └───project_vip_sim.tcl: tcl file to recreate the display driver simulation with the axi vip block.
    |   │   
    |   ├───sd_card: project to test the sd card.
    |   |
    |   └───c2p_proj: projects to test the cartesian to polar mapping block
    |       ├───src_sim
    |       │   └───car2pol_sim.sv: test file for car2pol block and axi communications
    |       │ 
    |       └───c2p_sim.tcl: tcl file to recreate cartesian to polar mapping block simulation with the axi vip block
    |       
    └───integration
        │   
        ├───sd_c2p_integration
        │   ├───src_sim: simulation sv file for sd_c2p_integration.tcl
        │   │
        │   └───sd_c2p_integration.tcl: tcl file to recreate image input and image processing blocks
        │ 
        └───display_driver_and_microblaze
            ├───tcl_script: tcl file to recreate display driver integrated with encoder reading block diagram.
            │
            ├───vitis_src: SDK source files (C-code). Start project with 'Hello World' template to be safe.
            │
            └───integration.srcs\constrs_1\new\integration.xdc: Constraints file which binds PMOD port pins for external 
                connection to encoder and h-bridge (if using compatible motor driver).


```               

## 4. Acknowledgements

[XESS Corporation](https://xess.com) for making their [SD Card IP](https://github.com/xesscorp/VHDL_Lib) open source and available for use. 
