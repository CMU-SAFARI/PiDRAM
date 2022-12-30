# PiDRAM

PiDRAM is the first flexible end-to-end framework that enables system integration studies and evaluation of real Processing-using-Memory (PuM) techniques. PiDRAM, at a high level, comprises a RISC-V system and a custom memory controller that can perform PuM operations in real DDR3 chips. This repository contains all sources required to build PiDRAM and develop its prototype on the Xilinx ZC706 FPGA boards. 

# Cite PiDRAM

Please cite the following paper if you find PiDRAM useful:

A. Olgun, J. G. Luna, K. Kanellopoulos, B. Salami, H. Hassan, O. Ergin, O. Mutlu, "[PiDRAM: A Holistic End-to-end FPGA-based Framework for Processing-in-DRAM](https://dl.acm.org/doi/10.1145/3563697)," TACO, 2022

Link to the PDF: https://arxiv.org/pdf/2111.00082.pdf  

Below is bibtex format for citation.

```
@article{olgun2022pidram,
      title={{PiDRAM: A Holistic End-to-end FPGA-based Framework for Processing-in-DRAM}}, 
      author={Ataberk Olgun and Juan Gómez Luna and Konstantinos Kanellopoulos and Behzad Salami and Hasan Hassan and Oğuz Ergin and Onur Mutlu},
      year={2022},
      journal={TACO}
}
```

# Repository File Structure

We expand on and describe the important directories in the repository below.

```
.
+-- README.md
+-- controller-hardware/
|   +-- Vivado_Project/             # Vivado project for PiDRAM's prototype
|   +-- prebuilt/                   # Prebuilt bitfiles (bitstreams)
|   +-- sources/                    # Verilog sources
|       +-- hdl/
|           +-- ...
|           +-- impl/
|               +-- controller/     # Verilog sources of PiDRAM's custom memory controller
+-- fpga-zynq/                      # Rocket chip system and FPGA prototyping sources
```

# Building a PiDRAM Prototype

To build PiDRAM's prototype on Xilinx ZC706 boards, developers need to use the two sub-projects in this directory. `fpga-zynq` is a repository branched off of [UCB-BAR's fpga-zynq](https://github.com/ucb-bar/fpga-zynq) repository. We use `fpga-zynq` to generate rocket chip designs that support end-to-end DRAM PuM execution. `controller-hardware` is where we keep the main Vivado project and Verilog sources for PiDRAM's memory controller and the top level system design. 

## Rebuilding Steps

1. Navigate into `fpga-zynq` and read the README file to understand the overall workflow of the repository
    - Follow the readme in `fpga-zynq/rocket-chip/riscv-tools` to install dependencies 
3. Create the Verilog source of the rocket chip design using the `ZynqCopyFPGAConfig`
    - Navigate into zc706, then run `make rocket CONFIG=ZynqCopyFPGAConfig -j<number of cores>`
4. Copy the generated Verilog file (should be under zc706/src) and overwrite the same file in `controller-hardware/source/hdl/impl/rocket-chip`
5. Open the Vivado project in `controller-hardware/Vivado_Project` using Vivado 2016.2
6. Generate a bitstream
7. Copy the bitstream (system_top.bit) to `fpga-zynq/zc706`
8. Use the `./build_script.sh` to generate the new `boot.bin` under `fpga-images-zc706`, you can use this file to program the FPGA using the SD-Card
    - For details, follow the relevant instructions in `fpga-zynq/README.md`

You can run programs compiled with the RISC-V Toolchain supplied within the `fpga-zynq` repository. To install the toolchain, follow the instructions under `fpga-zynq/rocket-chip/riscv-tools`.

## Generating DDR3 Controller IP sources

We cannot provide the sources for the Xilinx PHY IP we use in PiDRAM's memory controller due to licensing issues. We describe here how to regenerate them using Vivado 2016.2. First, you need to generate the IP RTL files:

1- Open IP Catalog  
2- Find "Memory Interface Generator (MIG 7 Series)" IP and double click  
3- Click next  
4- Change Component Name to "memctl"  
5- Click next three times  
6- Change clock period to 2500 ps  
7- Select SODIMM as memory type  
8- Click next  
9- Select 5000 ps as input clock period  
10- Click next  
11- Select "Use System Clock" option for reference clock  
12- System
12- Select "ACTIVE HIGH" for system reset polarity  
13- Click next until you get to "System Signals Selection"  
14- Choose H9/G9 pins for sys_clk  
15- Navigate the remaining screens by clicking next and accepting the license agreement  

The RTL files are generated in `Vivado_Project/E2E_RowClone.srcs/sources_1/ip/memctl/memctl/user_design/rtl`. You now need to apply one diff patch that we provide to decouple the Xilinx memory controller from the PHY interface, and directly connect the PHY interface signals to PiDRAM. To do so:

1- Navigate to controller-hardware  
2- Enter `patch Vivado_Project/E2E_RowClone.srcs/sources_1/ip/memctl/memctl/user_design/rtl/memctl_mig.v memctl_mig.v.patch` on the command line  
3- Import all sources under `Vivado_Project/E2E_RowClone.srcs/sources_1/ip/memctl/memctl/user_design/rtl/` to the project
4- Remove unused sources to fix potential synthesis errors

You should now be able to generate a bitstream.

## Reproducing Key Results

We describe how to reproduce the system performance results for the RowClone use case in this section. You can watch the tutorial near the end of [this talk](https://youtu.be/s_z_S6FYpC8) to review the steps for executing a binary on our prototype.

### Bare-Metal RowClone

1. Navigate to `fpga-zynq/rocket-chip/riscv-tools/riscv-tests/benchmarks`  
2. Run `make`  
3. Copy the executable `pidram-example.riscv` to the FPGA board via  
    * an SD card:
        ```
        cp pidram-example.riscv ../../../../zc706
        cd ../../../../zc706
        sudo make ramdisk-open 
        cp pidram-example.riscv ramdisk/home/root
        sudo make ramdisk-close
        cp fpga-images-zc706/uramdisk.image.gz /media/<PATH_TO_SD_CARD>
        ```
    * over SSH while the board is powered-on:
        ```
        # By default, the hostname of the board should be 192.168.1.5
        # The password for root is root
        scp pidram-example.riscv root@192.168.1.5:/home/root
        ```
4. Connect to the FPGA board over serial or SSH
5. Run `./fesvr-zynq pidram-example.riscv`

The program will output how many instructions and cycles it took to copy different sizes of arrays using the CPU copy baseline and RowClone operations.

### No-Flush RowClone

1. Build RISC-V proxy kernel (in case you have not done so already)  
    *  Navigate to `fpga-zynq/rocket-chip/riscv-tools`
        ```
        cd fpga-zynq/rocket-chip/riscv-tools
        ./build-pk-only.sh
        ```
2. Copy the PK `cp riscv-pk/build/pk ../../zc706`  
3. Compile the test program `cd progs && ./build.sh`  
3. Copy the executable and the PK to the FPGA board via  
    * an SD card:
        ```
        cd ..
        sudo make ramdisk-open 
        cp progs/compare.riscv pk ramdisk/home/root
        sudo make ramdisk-close
        cp fpga-images-zc706/uramdisk.image.gz /media/<PATH_TO_SD_CARD>
        ```
    * over SSH while the board is powered-on:
        ```
        scp progs/compare.riscv pk root@192.168.1.5:/home/root
        ```
4. Run the executable this time using PK `./fesvr-zynq pk compare.riscv`

The program will output some debug statements from PK and then output the execution time for copying different array sizes using CPU copy and RowClone-Copy operations.
# Acknowledgments & Contact

Please feel free to contact people below in case you need any help building/using PiDRAM and create new issues in the repository.

- Ataberk Olgun (olgunataberk [at] gmail [dot] com)
- Juan Gomez Luna

