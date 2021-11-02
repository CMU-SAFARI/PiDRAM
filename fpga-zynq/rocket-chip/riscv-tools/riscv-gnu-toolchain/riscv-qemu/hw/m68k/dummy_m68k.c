/*
 * Dummy board with just RAM and CPU for use as an ISS.
 *
 * Copyright (c) 2007 CodeSourcery.
 *
 * This code is licensed under the GPL
 */

#include "qemu/osdep.h"
#include "qemu-common.h"
#include "cpu.h"
#include "hw/hw.h"
#include "hw/boards.h"
#include "hw/loader.h"
#include "elf.h"
#include "exec/address-spaces.h"

#define KERNEL_LOAD_ADDR 0x10000

/* Board init.  */

static void dummy_m68k_init(MachineState *machine)
{
    ram_addr_t ram_size = machine->ram_size;
    const char *cpu_model = machine->cpu_model;
    const char *kernel_filename = machine->kernel_filename;
    M68kCPU *cpu;
    CPUM68KState *env;
    MemoryRegion *address_space_mem =  get_system_memory();
    MemoryRegion *ram = g_new(MemoryRegion, 1);
    int kernel_size;
    uint64_t elf_entry;
    hwaddr entry;

    if (!cpu_model)
        cpu_model = "cfv4e";
    cpu = cpu_m68k_init(cpu_model);
    if (!cpu) {
        fprintf(stderr, "Unable to find m68k CPU definition\n");
        exit(1);
    }
    env = &cpu->env;

    /* Initialize CPU registers.  */
    env->vbr = 0;

    /* RAM at address zero */
    memory_region_allocate_system_memory(ram, NULL, "dummy_m68k.ram",
                                         ram_size);
    memory_region_add_subregion(address_space_mem, 0, ram);

    /* Load kernel.  */
    if (kernel_filename) {
        kernel_size = load_elf(kernel_filename, NULL, NULL, &elf_entry,
                               NULL, NULL, 1, EM_68K, 0, 0);
        entry = elf_entry;
        if (kernel_size < 0) {
            kernel_size = load_uimage(kernel_filename, &entry, NULL, NULL,
                                      NULL, NULL);
        }
        if (kernel_size < 0) {
            kernel_size = load_image_targphys(kernel_filename,
                                              KERNEL_LOAD_ADDR,
                                              ram_size - KERNEL_LOAD_ADDR);
            entry = KERNEL_LOAD_ADDR;
        }
        if (kernel_size < 0) {
            fprintf(stderr, "qemu: could not load kernel '%s'\n",
                    kernel_filename);
            exit(1);
        }
    } else {
        entry = 0;
    }
    env->pc = entry;
}

static void dummy_m68k_machine_init(MachineClass *mc)
{
    mc->desc = "Dummy board";
    mc->init = dummy_m68k_init;
}

DEFINE_MACHINE("dummy", dummy_m68k_machine_init)
