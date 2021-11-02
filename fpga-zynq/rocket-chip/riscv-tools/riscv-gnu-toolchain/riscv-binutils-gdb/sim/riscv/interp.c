/* RISC-V simulator.

   Copyright (C) 2005-2015 Free Software Foundation, Inc.
   Contributed by Mike Frysinger.

   This file is part of simulators.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* This file contains the main glue logic between the sim core and the target
   specific simulator.  Normally this file will be kept small and the target
   details will live in other files.

   For more specific details on these functions, see the gdb/remote-sim.h
   header file.  */

#include "config.h"

#include "libiberty.h"
#include "bfd.h"
#include "elf-bfd.h"

#include "sim-main.h"
#include "sim-options.h"

/* This function is the main loop.  It should process ticks and decode+execute
   a single instruction.

   Usually you do not need to change things here.  */

void
sim_engine_run (SIM_DESC sd,
		int next_cpu_nr, /* ignore  */
		int nr_cpus, /* ignore  */
		int siggnal) /* ignore  */
{
  SIM_CPU *cpu;

  SIM_ASSERT (STATE_MAGIC (sd) == SIM_MAGIC_NUMBER);

  cpu = STATE_CPU (sd, 0);

  while (1)
    {
      step_once (cpu);
      if (sim_events_tick (sd))
	sim_events_process (sd);
    }
}

/* Initialize the simulator from scratch.  This is called once per lifetime of
   the simulation.  Think of it as a processor reset.

   Usually all cpu-specific setup is handled in the initialize_cpu callback.
   If you want to do cpu-independent stuff, then it should go at the end (see
   where memory is initialized).  */

static void
free_state (SIM_DESC sd)
{
  if (STATE_MODULES (sd) != NULL)
    sim_module_uninstall (sd);
  sim_cpu_free_all (sd);
  sim_state_free (sd);
}

SIM_DESC
sim_open (SIM_OPEN_KIND kind, host_callback *callback,
	  struct bfd *abfd, char * const *argv)
{
  char c;
  int i;
  SIM_DESC sd = sim_state_alloc (kind, callback);

  /* The cpu data is kept in a separately allocated chunk of memory.  */
  if (sim_cpu_alloc_all (sd, 1, /*cgen_cpu_max_extra_bytes ()*/0) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  if (sim_pre_argv_init (sd, argv[0]) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  /* XXX: Default to the Virtual environment.  */
  if (STATE_ENVIRONMENT (sd) == ALL_ENVIRONMENT)
    STATE_ENVIRONMENT (sd) = VIRTUAL_ENVIRONMENT;

  /* getopt will print the error message so we just have to exit if this fails.
     FIXME: Hmmm...  in the case of gdb we need getopt to call
     print_filtered.  */
  if (sim_parse_args (sd, argv) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  /* Check for/establish the a reference program image.  */
  if (sim_analyze_program (sd,
			   (STATE_PROG_ARGV (sd) != NULL
			    ? *STATE_PROG_ARGV (sd)
			    : NULL), abfd) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  /* Establish any remaining configuration options.  */
  if (sim_config (sd) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  if (sim_post_argv_init (sd) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  /* CPU specific initialization.  */
  for (i = 0; i < MAX_NR_PROCESSORS; ++i)
    {
      SIM_CPU *cpu = STATE_CPU (sd, i);

      initialize_cpu (sd, cpu, i);
    }

  /* Allocate external memory if none specified by user.
     Use address 4 here in case the user wanted address 0 unmapped.  */
  if (sim_core_read_buffer (sd, NULL, read_map, &c, 4, 1) == 0)
    sim_do_commandf (sd, "memory-size %#x", DEFAULT_MEM_SIZE);

  return sd;
}

static bfd_vma
riscv_get_symbol (SIM_DESC sd, const char *sym)
{
  long symcount = STATE_PROG_SYMS_COUNT (sd);
  asymbol **symtab = STATE_PROG_SYMS (sd);
  int i;

  for (i = 0;i < symcount; ++i)
    {
      if (strcmp (sym, bfd_asymbol_name (symtab[i])) == 0)
	{
	  bfd_vma sa;
	  sa = bfd_asymbol_value (symtab[i]);
	  return sa;
	}
    }

  /* Symbol not found.  */
  return 0;
}

/* Prepare to run a program that has already been loaded into memory.

   Usually you do not need to change things here.  */

SIM_RC
sim_create_inferior (SIM_DESC sd, struct bfd *abfd,
		     char * const *argv, char * const *env)
{
  SIM_CPU *cpu = STATE_CPU (sd, 0);
  sim_cia addr;
  Elf_Internal_Phdr *phdr;
  int i, phnum;

  /* Set the PC.  */
  if (abfd != NULL)
    addr = bfd_get_start_address (abfd);
  else
    addr = 0;
  sim_pc_set (cpu, addr);
  phdr = elf_tdata (abfd)->phdr;
  phnum = elf_elfheader (abfd)->e_phnum;

  /* Try to find _end symbol, and set it to the end of brk.  */
  trace_load_symbols (sd);
  cpu->endbrk = riscv_get_symbol (sd, "_end");

  /* If not found, set end of brk to end of all section.  */
  if (cpu->endbrk == 0)
    {
      for (i = 0; i < phnum; i++)
	{
	  if (phdr[i].p_paddr + phdr[i].p_memsz > cpu->endbrk)
	    cpu->endbrk = phdr[i].p_paddr + phdr[i].p_memsz;
	}
    }

  /* Standalone mode (i.e. `run`) will take care of the argv for us in
     sim_open() -> sim_parse_args().  But in debug mode (i.e. 'target sim'
     with `gdb`), we need to handle it.  */
  if (STATE_OPEN_KIND (sd) == SIM_OPEN_DEBUG)
    {
      freeargv (STATE_PROG_ARGV (sd));
      STATE_PROG_ARGV (sd) = dupargv (argv);
    }

  initialize_env (sd, (void *)argv, (void *)env);

  return SIM_RC_OK;
}
