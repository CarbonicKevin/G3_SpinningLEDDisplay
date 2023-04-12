
---

# Spinning LED Display

### University of Toronto | Winter Semester 2023 | ECE532
### Authors : Kevin Kim, Nikoo Givehchian, Spencer Ball, Eddie Tian.

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
    │   └───display_driver: display driver repo
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
        └───integration
```

## 4. Authors

## 5. Acknowledgements