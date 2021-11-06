# PiDRAM

PiDRAM is the first flexible end-to-end framework that enables system integration studies and evaluation of real Processing-using-Memory (PuM) techniques. PiDRAM, at a high level, comprises a RISC-V system and a custom memory controller that can perform PuM operations in real DDR3 chips. This repository contains all sources required to build PiDRAM and develop its prototype on the Xilinx ZC706 FPGA boards. 

# Cite PiDRAM

Please cite the following paper if you find PiDRAM useful:

A. Olgun, J. G. Luna, K. Kanellopoulos, B. Salami, H. Hassan, O. Ergin, O. Mutlu, "PiDRAM: A Holistic End-to-end FPGA-based Framework for Processing-in-DRAM," arXiv:2111.00082, Nov 2021

Link to the PDF: https://arxiv.org/pdf/2111.00082.pdf  
Link to the abstract: https://arxiv.org/abs/2111.00082

Below is bibtex format for citation.

```
@misc{olgun2021pidram,
      title={PiDRAM: A Holistic End-to-end FPGA-based Framework for Processing-in-DRAM}, 
      author={Ataberk Olgun and Juan Gómez Luna and Konstantinos Kanellopoulos and Behzad Salami and Hasan Hassan and Oğuz Ergin and Onur Mutlu},
      year={2021},
      eprint={2111.00082},
      archivePrefix={arXiv},
      primaryClass={cs.AR}
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

## Notes

We cannot provide the sources for the Xilinx PHY IP we use in PiDRAM's memory controller due to licensing issues. Please reach out to us using the contact information below so that we can confirm you have access to the same IP sources we do and provide you with the modified PHY files.

# Acknowledgments & Contact

Please feel free to contact people below in case you need any help building/using PiDRAM and create new issues in the repository.

- Ataberk Olgun (olgunataberk [at] gmail [dot] com)
- Juan Gomez Luna

