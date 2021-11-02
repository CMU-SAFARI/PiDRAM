tests_dir = ../../riscv-tools/riscv-tests/benchmarks
 
RISCV_PREFIX ?= riscv64-unknown-elf-
RISCV_GCC ?= $(RISCV_PREFIX)gcc
RISCV_GCC_OPTS ?= -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf
RISCV_LINK ?= $(RISCV_GCC) -T $(tests_dir)/common/test.ld $(incs)
RISCV_LINK_OPTS ?= -static -nostdlib -nostartfiles -lm -lgcc -T $(tests_dir)/common/test.ld
RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.data

incs  += -I$(tests_dir)/../env -I$(tests_dir)/common

flush.riscv:
	$(RISCV_GCC) $(incs) $(RISCV_GCC_OPTS) -o $@ flush.c $(tests_dir)/common/syscalls.c $(tests_dir)/common/crt.S $(RISCV_LINK_OPTS)


