
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
   *Responsible for reading the input image from an SD card*
   The SD card is read using an IP provided by XESSCorp, which can be found [here](https://github.com/xesscorp/VHDL_Lib). They are the `.vhd` files in `srcs/ip_repo/sd_card`. The raw data from the SD card is then checked for compatibility, reformatted, and placed on an AXI bus with a custom IP. This is the `.v` file in the same location.

2. Image Processing - Custom
   *Responsible for transforming the image into radial coordinates*

3. Display Driver - Custom  
   *Responsible for selecting which row of the image data to output onto the LEDs at a particular angle*

4. Microblaze   
    *Responsible for controlling and communicating with other blocks*

Included in this repo are the packaged blocks used to display in the project, the tcl files to recreate any project files, as well as presentation files and reports.

## 2. How to Use
...

## 3. Repository Structure

```
├───docs
│   └───device_manuals: contains various manuals for the different devices used
│       │
│       ├───nexys-video_rm.pdf: https://digilent.com/reference/programmable-logic/nexys-video/start
│       │
│       └───WS2812B.pdf: https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf
└───srcs
    ├───ip_repo: exported custom IPs
    │   │
    │   ├───display_driver: display driver repo
    │   │
    │   ├───c2p_proj: cartesian to polar mapping block repo
    │   │
    │   └───sd_card: sd card reader repo
    │   
    └───projects: folders that contain files for various projects
        ├───display_driver: projects to test the display driver.
        │   │
        │   ├───scripts
        │   │   │
        │   │   └───led_values_gen.py: small script to quickly generate some test LED values
        │   │
        │   ├───src_microblaze
        │   │   │
        │   │   ├───main.c: test code to run with the project_microblaze.tcl
        │   │   │
        │   │   └───microblaze.xdc: constraint for project_microblaze.tcl
        │   │
        │   ├───src_sim
        │   │   ├───dd_sim_behav.wcfg: waveform simulation file for project_vip_sim.tcl
        │   │   │
        │   │   └───dd_sim.sv: simulation sv file for project_vip_sim.tcl
        │   │
        │   ├───project_microblaze.tcl: tcl file to recreate the microblaze integration with the display driver.
        │   │
        │   └───project_vip_sim.tcl: tcl file to recreate the display driver simulation with the axi vip block.
        │   
        ├───c2p_proj: projects to test the cartesian to polar mapping block
        │   │   │
        │   ├───src_sim
        │   │   └───car2pol_sim.sv: test file for car2pol block and axi communications
        │   │ 
        │   └───c2p_sim.tcl: tcl file to recreate cartesian to polar mapping block simulation with the axi vip block
        │   
        └───integration
```

## 4. Authors

## 5. Acknowledgements
