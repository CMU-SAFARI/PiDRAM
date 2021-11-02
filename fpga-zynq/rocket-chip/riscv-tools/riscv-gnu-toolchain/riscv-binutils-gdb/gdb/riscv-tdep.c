/* Target-dependent code for the RISC-V architecture, for GDB.

   Copyright (C) 1988-2015 Free Software Foundation, Inc.

   Contributed by Alessandro Forin(af@cs.cmu.edu) at CMU
   and by Per Bothner(bothner@cs.wisc.edu) at U.Wisconsin
   and by Todd Snyder <todd@bluespec.com>
   and by Mike Frysinger <vapier@gentoo.org>.

   This file is part of GDB.

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

#include "defs.h"
#include "frame.h"
#include "inferior.h"
#include "symtab.h"
#include "value.h"
#include "gdbcmd.h"
#include "language.h"
#include "gdbcore.h"
#include "symfile.h"
#include "objfiles.h"
#include "gdbtypes.h"
#include "target.h"
#include "arch-utils.h"
#include "regcache.h"
#include "osabi.h"
#include "riscv-tdep.h"
#include "block.h"
#include "reggroups.h"
#include "opcode/riscv.h"
#include "elf/riscv.h"
#include "elf-bfd.h"
#include "symcat.h"
#include "sim-regno.h"
#include "gdb/sim-riscv.h"
#include "dis-asm.h"
#include "frame-unwind.h"
#include "frame-base.h"
#include "trad-frame.h"
#include "infcall.h"
#include "floatformat.h"
#include "remote.h"
#include "target-descriptions.h"
#include "dwarf2-frame.h"
#include "user-regs.h"
#include "valprint.h"
#include "common-defs.h"
#include "opcode/riscv-opc.h"
#include <algorithm>
#include <map>

#define DECLARE_INSN(INSN_NAME, INSN_MATCH, INSN_MASK) \
static inline bool is_ ## INSN_NAME ## _insn (long insn) \
{ \
  return (insn & INSN_MASK) == INSN_MATCH; \
}
#include "opcode/riscv-opc.h"
#undef DECLARE_INSN

struct riscv_frame_cache
{
  CORE_ADDR base;
  struct trad_frame_saved_reg *saved_regs;
};

struct riscv_reg_info
{
  int number;
  // The first name in this list is the one that is considered the canonical
  // name of the register. This is both the name used internally when possible
  // as well as the name the user sees. (gdb does not have a concept of
  // separating those two.)
  std::vector<const char*> names;
  // We can't debug a target that doesn't have this register.
  bool required;
  // This register must be saved/restored by gdb around function calls.
  bool save_restore;
  const char *feature_name;
  struct reggroup *group;
};

static std::vector<struct riscv_reg_info> riscv_reg_info = {
  {RISCV_ZERO_REGNUM, {"zero", "x0"}, false, false, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_RA_REGNUM, {"ra", "x1"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_SP_REGNUM, {"sp", "x2"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_GP_REGNUM, {"gp", "x3"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_TP_REGNUM, {"tp", "x4"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_T0_REGNUM, {"t0", "x5"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_T1_REGNUM, {"t1", "x6"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_T2_REGNUM, {"t2", "x7"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_FP_REGNUM, {"s0", "x8", "fp"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_S1_REGNUM, {"s1", "x9"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_A0_REGNUM, {"a0", "x10"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_A1_REGNUM, {"a1", "x11"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_A2_REGNUM, {"a2", "x12"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_A3_REGNUM, {"a3", "x13"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_A4_REGNUM, {"a4", "x14"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_A5_REGNUM, {"a5", "x15"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_A6_REGNUM, {"a6", "x16"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_A7_REGNUM, {"a7", "x17"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_S2_REGNUM, {"s2", "x18"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_S3_REGNUM, {"s3", "x19"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_S4_REGNUM, {"s4", "x20"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_S5_REGNUM, {"s5", "x21"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_S6_REGNUM, {"s6", "x22"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_S7_REGNUM, {"s7", "x23"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_S8_REGNUM, {"s8", "x24"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_S9_REGNUM, {"s9", "x25"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_S10_REGNUM, {"s10", "x26"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_S11_REGNUM, {"s11", "x27"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_T3_REGNUM, {"t3", "x28"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_T4_REGNUM, {"t4", "x29"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_T5_REGNUM, {"t5", "x30"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},
  {RISCV_T6_REGNUM, {"t6", "x31"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},

  {RISCV_PC_REGNUM, {"pc"}, true, true, "org.gnu.gdb.riscv.cpu", general_reggroup},

  {RISCV_FT0_REGNUM, {"f0", "ft0"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FT1_REGNUM, {"f1", "ft1"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FT2_REGNUM, {"f2", "ft2"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FT3_REGNUM, {"f3", "ft3"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FT4_REGNUM, {"f4", "ft4"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FT5_REGNUM, {"f5", "ft5"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FT6_REGNUM, {"f6", "ft6"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FT7_REGNUM, {"f7", "ft7"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS0_REGNUM, {"f8", "fs0"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS1_REGNUM, {"f9", "fs1"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FA0_REGNUM, {"f10", "fa0"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FA1_REGNUM, {"f11", "fa1"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FA2_REGNUM, {"f12", "fa2"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FA3_REGNUM, {"f13", "fa3"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FA4_REGNUM, {"f14", "fa4"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FA5_REGNUM, {"f15", "fa5"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FA6_REGNUM, {"f16", "fa6"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FA7_REGNUM, {"f17", "fa7"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS2_REGNUM, {"f18", "fs2"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS3_REGNUM, {"f19", "fs3"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS4_REGNUM, {"f20", "fs4"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS5_REGNUM, {"f21", "fs5"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS6_REGNUM, {"f22", "fs6"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS7_REGNUM, {"f23", "fs7"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS8_REGNUM, {"f24", "fs8"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS9_REGNUM, {"f25", "fs9"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS10_REGNUM, {"f26", "fs10"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FS11_REGNUM, {"f27", "fs11"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FT8_REGNUM, {"f28", "ft8"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FT9_REGNUM, {"f29", "ft9"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FT10_REGNUM, {"f30", "ft10"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},
  {RISCV_FT11_REGNUM, {"f31", "ft11"}, false, true, "org.gnu.gdb.riscv.fpu", float_reggroup},

  {RISCV_PRIV_REGNUM, {"priv"}, false, false, "org.gnu.gdb.riscv.virtual", general_reggroup},
};
// Map from fixed register number to register's info.
static std::map<int, struct riscv_reg_info *> riscv_reg_map;

struct register_alias
{
  const char *name;
  int regnum;
};

static enum auto_boolean use_compressed_breakpoints;
/*
static void
show_use_compressed_breakpoints (struct ui_file *file, int from_tty,
			    struct cmd_list_element *c,
			    const char *value)
{
  fprintf_filtered (file,
		    _("Debugger's behavior regarding "
		      "compressed breakpoints is %s.\n"),
		    value);
}
*/

static struct cmd_list_element *setriscvcmdlist = NULL;
static struct cmd_list_element *showriscvcmdlist = NULL;

static void
show_riscv_command (char *args, int from_tty)
{
  help_list (showriscvcmdlist, "show riscv ", all_commands, gdb_stdout);
}

static void
set_riscv_command (char *args, int from_tty)
{
  printf_unfiltered
    ("\"set riscv\" must be followed by an appropriate subcommand.\n");
  help_list (setriscvcmdlist, "set riscv ", all_commands, gdb_stdout);
}

static uint32_t
cached_misa ()
{
  static bool read = false;
  static uint32_t value = 0;

  if (!read) {
    struct frame_info *frame = get_current_frame ();
    TRY
      {
        value = get_frame_register_unsigned (frame, RISCV_CSR_MISA_REGNUM);
      }
    CATCH (ex, RETURN_MASK_ERROR)
      {
        // In old cores, $misa might live at 0xf10
        value = get_frame_register_unsigned (frame,
            RISCV_CSR_MISA_REGNUM - 0x301 + 0xf10);
      }
    END_CATCH
    read = true;
  }

  return value;
}

/* Implement the breakpoint_kind_from_pc gdbarch method.  */

static int
riscv_breakpoint_kind_from_pc (struct gdbarch *gdbarch, CORE_ADDR *pcptr)
{
  if (use_compressed_breakpoints == AUTO_BOOLEAN_AUTO) {
    if (gdbarch_tdep (gdbarch)->supports_compressed_isa == AUTO_BOOLEAN_AUTO)
    {
      /* TODO: Because we try to read misa, it is not possible to set a
         breakpoint before connecting to a live target. A suggested workaround is
         to look at the ELF file in this case.  */
      uint32_t misa = cached_misa();
      if (misa & (1<<2))
        gdbarch_tdep (gdbarch)->supports_compressed_isa = AUTO_BOOLEAN_TRUE;
      else
        gdbarch_tdep (gdbarch)->supports_compressed_isa = AUTO_BOOLEAN_FALSE;
    }

    if (gdbarch_tdep (gdbarch)->supports_compressed_isa == AUTO_BOOLEAN_TRUE)
      return 2;
    else
      return 4;
  } else if (use_compressed_breakpoints == AUTO_BOOLEAN_TRUE) {
    return 2;
  } else {
    return 4;
  }
}

/* Implement the sw_breakpoint_from_kind gdbarch method.  */

static const gdb_byte *
riscv_sw_breakpoint_from_kind (struct gdbarch *gdbarch, int kind, int *size)
{
  static const gdb_byte ebreak[] = { 0x73, 0x00, 0x10, 0x00, };
  static const gdb_byte c_ebreak[] = { 0x02, 0x90 };

  *size = kind;
  switch (kind)
    {
    case 2:
      return c_ebreak;
    case 4:
      return ebreak;
    default:
      gdb_assert(0);
    }
}

static struct value *
value_of_riscv_user_reg (struct frame_info *frame, const void *baton)
{
  const int *reg_p = (const int *)baton;

  return value_of_register (*reg_p, frame);
}

/* Implement the register_name gdbarch method.  */

static const char *
riscv_register_name (struct gdbarch *gdbarch,
		     int regnum)
{
  int i;
  static char buf[20];

  auto match = riscv_reg_map.find(regnum);
  if (match == riscv_reg_map.end())
    return NULL;

  return match->second->names[0];
}

/* Reads a function return value of type TYPE.  */

static void
riscv_extract_return_value (struct type *type,
			    struct regcache *regs,
			    gdb_byte *dst,
			    int regnum)
{
  struct gdbarch *gdbarch = get_regcache_arch (regs);
  enum bfd_endian byte_order = gdbarch_byte_order (gdbarch);
  int regsize = riscv_isa_regsize (gdbarch);
  bfd_byte *valbuf = dst;
  int len = TYPE_LENGTH (type);
  int st_len = std::min (regsize, len);
  ULONGEST tmp;

  gdb_assert (len <= 2 * regsize);

  while (len > 0)
    {
      regcache_cooked_read_unsigned (regs, regnum++, &tmp);
      store_unsigned_integer (valbuf, st_len, byte_order, tmp);
      len -= regsize;
      valbuf += regsize;
    }
}

/* Write into appropriate registers a function return value of type
   TYPE, given in virtual format.  */

static void
riscv_store_return_value (struct type *type,
			  struct regcache *regs,
			  const gdb_byte *src,
			  int regnum)
{
  struct gdbarch *gdbarch = get_regcache_arch (regs);
  int regsize = riscv_isa_regsize (gdbarch);
  const bfd_byte *valbuf = src;

  /* Integral values greater than one word are stored in consecutive
     registers starting with R0.  This will always be a multiple of
     the register size.  */

  int len = TYPE_LENGTH (type);

  gdb_assert (len <= 2 * regsize);

  while (len > 0)
    {
      regcache_cooked_write (regs, regnum++, valbuf);
      len -= regsize;
      valbuf += regsize;
    }
}

/* Implement the return_value gdbarch method.  */

static enum return_value_convention
riscv_return_value (struct gdbarch  *gdbarch,
		    struct value *function,
		    struct type *type,
		    struct regcache *regcache,
		    gdb_byte *readbuf,
		    const gdb_byte *writebuf)
{
  enum type_code rv_type = TYPE_CODE (type);
  unsigned int rv_size = TYPE_LENGTH (type);
  int fp, regnum;
  ULONGEST tmp;

  /* Paragraph on return values taken from RISC-V specification (post v2.0):

     Values are returned from functions in integer registers a0 and a1 and
     floating-point registers fa0 and fa1.  Floating-point values are returned
     in floating-point registers only if they are primitives or members of a
     struct consisting of only one or two floating-point values.  Other return
     values that fit into two pointer-words are returned in a0 and a1.  Larger
     return values are passed entirely in memory; the caller allocates this
     memory region and passes a pointer to it as an implicit first parameter
     to the callee.  */

  /* Deal with struct/unions first that are passed via memory.  */
  if (rv_size > 2 * riscv_isa_regsize (gdbarch))
    {
      if (readbuf || writebuf)
	regcache_cooked_read_unsigned (regcache, RISCV_A0_REGNUM, &tmp);
      if (readbuf)
	read_memory (tmp, readbuf, rv_size);
      if (writebuf)
	write_memory (tmp, writebuf, rv_size);
      return RETURN_VALUE_ABI_RETURNS_ADDRESS;
    }

  /* Are we dealing with a floating point value?  */
  fp = 0;
  if (rv_type == TYPE_CODE_FLT)
    fp = 1;
  else if (rv_type == TYPE_CODE_STRUCT || rv_type == TYPE_CODE_UNION)
    {
      unsigned int rv_fields = TYPE_NFIELDS (type);

      if (rv_fields == 1)
	{
	  struct type *fieldtype = TYPE_FIELD_TYPE (type, 0);
	  if (TYPE_CODE (check_typedef (fieldtype)) == TYPE_CODE_FLT)
	    fp = 1;
	}
      else if (rv_fields == 2)
	{
	  struct type *fieldtype0 = TYPE_FIELD_TYPE (type, 0);
	  struct type *fieldtype1 = TYPE_FIELD_TYPE (type, 1);

	  if (TYPE_CODE (check_typedef (fieldtype0)) == TYPE_CODE_FLT
	      && TYPE_CODE (check_typedef (fieldtype1)) == TYPE_CODE_FLT)
	    fp = 1;
	}
    }

  /* Handle return value in a register.  */
  regnum = fp ? RISCV_FA0_REGNUM : RISCV_A0_REGNUM;

  if (readbuf)
    riscv_extract_return_value (type, regcache, readbuf, regnum);

  if (writebuf)
    riscv_store_return_value (type, regcache, writebuf, regnum);

  return RETURN_VALUE_REGISTER_CONVENTION;
}

/* Implement the register_type gdbarch method.  */

static struct type *
riscv_register_type (struct gdbarch *gdbarch,
		     int regnum)
{
  int regsize = riscv_isa_regsize (gdbarch);

  if (regnum < RISCV_FIRST_FP_REGNUM)
    {
      /*
       * GPRs and especially the PC are listed as unsigned so that gdb can
       * interpret them as addresses without any problems. Specifically, if a
       * user runs "x/i $pc" then they should see the instruction at the PC.
       * But on a 32-bit system, with a signed PC of eg. 0x8000_0000, gdb will
       * internally sign extend the value and then attempt to read from
       * 0xffff_ffff_8000_0000, which it then concludes it can't read.
       */
      switch (regsize)
	{
	case 4:
	  return builtin_type (gdbarch)->builtin_uint32;
	case 8:
	  return builtin_type (gdbarch)->builtin_uint64;
	case 16:
	  return builtin_type (gdbarch)->builtin_uint128;
	default:
	  internal_error (__FILE__, __LINE__,
			  _("unknown isa regsize %i"), regsize);
	}
    }
  else if (regnum <= RISCV_LAST_FP_REGNUM)
    {
      switch (regsize)
	{
	case 4:
	  return builtin_type (gdbarch)->builtin_float;
	case 8:
	case 16:
	  return builtin_type (gdbarch)->builtin_double;
	default:
	  internal_error (__FILE__, __LINE__,
			  _("unknown isa regsize %i"), regsize);
	}
    }
  else if (regnum == RISCV_PRIV_REGNUM)
    {
      return builtin_type (gdbarch)->builtin_int8;
    }
  else
    {
      if (regnum == RISCV_CSR_FFLAGS_REGNUM
	  || regnum == RISCV_CSR_FRM_REGNUM
	  || regnum == RISCV_CSR_FCSR_REGNUM)
	return builtin_type (gdbarch)->builtin_int32;

      switch (regsize)
	{
	case 4:
	  return builtin_type (gdbarch)->builtin_int32;
	case 8:
	  return builtin_type (gdbarch)->builtin_int64;
	case 16:
	  return builtin_type (gdbarch)->builtin_int128;
	default:
	  internal_error (__FILE__, __LINE__,
			  _("unknown isa regsize %i"), regsize);
	}
    }
}

static void
riscv_print_fp_register (struct ui_file *file, struct frame_info *frame,
			 int regnum)
{
  struct gdbarch *gdbarch = get_frame_arch (frame);
  struct value_print_options opts;
  const char *regname;
  value *val = get_frame_register_value(frame, regnum);

  fprintf_filtered (file, "%-15s", gdbarch_register_name (gdbarch, regnum));

  get_formatted_print_options (&opts, 'f');
  val_print_scalar_formatted (value_type (val),
			      value_embedded_offset (val),
			      val,
			      &opts, 0, file);
}

static void
riscv_print_register_formatted (struct ui_file *file, struct frame_info *frame,
				int regnum)
{
  struct gdbarch *gdbarch = get_frame_arch (frame);
  gdb_byte raw_buffer[MAX_REGISTER_SIZE];
  struct value_print_options opts;

  if (regnum >= RISCV_FIRST_FP_REGNUM && regnum <= RISCV_LAST_FP_REGNUM)
    riscv_print_fp_register (file, frame, regnum);
  else
    {
      /* Integer type.  */
      int offset, size;
      unsigned long long d;
      int prefer_alias = regnum >= RISCV_FIRST_CSR_REGNUM;

      if (!deprecated_frame_register_read (frame, regnum, raw_buffer))
	{
	  fprintf_filtered (file, "%-15s[Invalid]\n",
			    gdbarch_register_name (gdbarch, regnum));
	  return;
	}

      fprintf_filtered (file, "%-15s", gdbarch_register_name (gdbarch, regnum));
      if (gdbarch_byte_order (gdbarch) == BFD_ENDIAN_BIG)
	offset = register_size (gdbarch, regnum) - register_size (gdbarch, regnum);
      else
	offset = 0;

      size = register_size (gdbarch, regnum);
      get_formatted_print_options (&opts, 'x');
      print_scalar_formatted (raw_buffer + offset,
			      register_type (gdbarch, regnum), &opts,
			      size == 8 ? 'g' : 'w', file);
      fprintf_filtered (file, "\t");
      if (size == 4 && riscv_isa_regsize (gdbarch) == 8)
	fprintf_filtered (file, "\t");

      if (regnum == RISCV_CSR_MSTATUS_REGNUM)
	{
	  if (size == 4)
	    d = unpack_long (builtin_type (gdbarch)->builtin_uint32, raw_buffer);
	  else if (size == 8)
	    d = unpack_long (builtin_type (gdbarch)->builtin_uint64, raw_buffer);
	  else
	    internal_error (__FILE__, __LINE__, _("unknown size for mstatus"));
	  unsigned xlen = size * 4;
	  fprintf_filtered (file,
			    "SD:%X VM:%02X MXR:%X PUM:%X MPRV:%X XS:%X "
			    "FS:%X MPP:%x HPP:%X SPP:%X MPIE:%X HPIE:%X "
			    "SPIE:%X UPIE:%X MIE:%X HIE:%X SIE:%X UIE:%X",
			    (int)((d >> (xlen-1)) & 0x1),
			    (int)((d >> 24) & 0x1f),
			    (int)((d >> 19) & 0x1),
			    (int)((d >> 18) & 0x1),
			    (int)((d >> 17) & 0x1),
			    (int)((d >> 15) & 0x3),
			    (int)((d >> 13) & 0x3),
			    (int)((d >> 11) & 0x3),
			    (int)((d >> 9) & 0x3),
			    (int)((d >> 8) & 0x1),
			    (int)((d >> 7) & 0x1),
			    (int)((d >> 6) & 0x1),
			    (int)((d >> 5) & 0x1),
			    (int)((d >> 4) & 0x1),
			    (int)((d >> 3) & 0x1),
			    (int)((d >> 2) & 0x1),
			    (int)((d >> 1) & 0x1),
			    (int)((d >> 0) & 0x1));
	}
      else if (regnum == RISCV_CSR_MISA_REGNUM)
        {
          int base;
          if (size == 4) {
            d = unpack_long (builtin_type (gdbarch)->builtin_uint32, raw_buffer);
            base = d >> 30;
          } else if (size == 8) {
            d = unpack_long (builtin_type (gdbarch)->builtin_uint64, raw_buffer);
            base = d >> 62;
          } else {
            internal_error (__FILE__, __LINE__, _("unknown size for misa"));
          }
          unsigned xlen = 16;
          for (; base > 0; base--) {
            xlen *= 2;
          }
	  fprintf_filtered (file, "RV%d", xlen);

          for (unsigned i = 0; i < 26; i++) {
            if (d & (1<<i)) {
              fprintf_filtered (file, "%c", 'A' + i);
            }
          }
        }
      else if (regnum == RISCV_CSR_FCSR_REGNUM
	       || regnum == RISCV_CSR_FFLAGS_REGNUM
	       || regnum == RISCV_CSR_FRM_REGNUM)
	{
	  d = unpack_long (builtin_type (gdbarch)->builtin_int32, raw_buffer);

	  if (regnum != RISCV_CSR_FRM_REGNUM)
	    fprintf_filtered (file, "RD:%01X NV:%d DZ:%d OF:%d UF:%d NX:%d   ",
			      (int)((d >> 5) & 0x7),
			      (int)((d >> 4) & 0x1),
			      (int)((d >> 3) & 0x1),
			      (int)((d >> 2) & 0x1),
			      (int)((d >> 1) & 0x1),
			      (int)((d >> 0) & 0x1));

	  if (regnum != RISCV_CSR_FFLAGS_REGNUM)
	    {
	      static const char * const sfrm[] = {
		"RNE (round to nearest; ties to even)",
		"RTZ (Round towards zero)",
		"RDN (Round down towards -∞)",
		"RUP (Round up towards +∞)",
		"RMM (Round to nearest; tiest to max magnitude)",
		"INVALID[5]",
		"INVALID[6]",
		"dynamic rounding mode",
	      };
	      int frm = ((regnum == RISCV_CSR_FCSR_REGNUM) ? (d >> 5) : d) & 0x3;

	      fprintf_filtered (file, "FRM:%i [%s]", frm, sfrm[frm]);
	    }
	}
      else if (regnum == RISCV_PRIV_REGNUM)
        {
          uint8_t priv = raw_buffer[0];
          if (priv >= 0 && priv < 4)
            {
              static const char * const sprv[] = {
                "User/Application",
                "Supervisor",
                "Hypervisor",
                "Machine"
              };
              fprintf_filtered (file, "prv:%d [%s]", priv, sprv[priv]);
            }
          else
            {
              fprintf_filtered (file, "prv:%d [INVALID]", priv);
            }
        }
      else
	{
	  get_formatted_print_options (&opts, 'd');
	  print_scalar_formatted (raw_buffer + offset,
				  register_type (gdbarch, regnum),
				  &opts, 0, file);
	}
    }
  fprintf_filtered (file, "\n");
}

/* Implement the register_reggroup_p gdbarch method.
 * This is only called when there is no target description. */
static int
riscv_register_reggroup_p (struct gdbarch  *gdbarch,
			   int regnum,
			   struct reggroup *reggroup)
{
  auto match = riscv_reg_map.find(regnum);
  if (match == riscv_reg_map.end())
    return 0;

  struct riscv_reg_info *reg = match->second;

  if (reggroup == all_reggroup)
    return 1;

  if (reggroup == restore_reggroup || reggroup == save_reggroup)
    {
      if (reg->number >= RISCV_FIRST_FP_REGNUM && reg->number
          <= RISCV_LAST_FP_REGNUM)
        return (cached_misa() & ((1<<('F'-'A')) | (1<<('D'-'A')) |
                                 (1<<('Q'-'A')))) ? 1 : 0;

      return reg->save_restore;
    }

  return reg->group == reggroup;
}

/* Implement the print_registers_info gdbarch method.  */

static void
riscv_print_registers_info (struct gdbarch    *gdbarch,
			    struct ui_file    *file,
			    struct frame_info *frame,
			    int                regnum,
			    int                all)
{
  /* Use by 'info all-registers'.  */
  struct reggroup *reggroup;

  if (regnum != -1)
    {
      /* Print one specified register.
       * gdb might ask us to print a register that we don't know about, because
       * it's in the target description. That still works, because we can ask
       * gdb to give us register name and contents by number. */
      if (NULL == gdbarch_register_name (gdbarch, regnum))
        error (_("Not a valid register for the current processor type"));
      riscv_print_register_formatted (file, frame, regnum);
      return;
    }

  if (all)
    reggroup = all_reggroup;
  else
    reggroup = general_reggroup;
  for (regnum = 0; regnum <= RISCV_LAST_REGNUM; ++regnum)
    {
      /* Zero never changes, so might as well hide by default.  */
      if (regnum == RISCV_ZERO_REGNUM && !all)
        continue;
      if (gdbarch_register_reggroup_p(gdbarch, regnum, reggroup))
        riscv_print_register_formatted (file, frame, regnum);
    }
}

static ULONGEST
riscv_fetch_instruction (struct gdbarch *gdbarch, CORE_ADDR addr)
{
  enum bfd_endian byte_order = gdbarch_byte_order_for_code (gdbarch);
  gdb_byte buf[8];
  int instlen, status;

  /* All insns are at least 16 bits.  */
  status = target_read_memory (addr, buf, 2);
  if (status)
    memory_error (TARGET_XFER_E_IO, addr);

  /* If we need more, grab it now.  */
  instlen = riscv_insn_length (buf[0]);
  if (instlen > sizeof (buf))
    internal_error (__FILE__, __LINE__, _("%s: riscv_insn_length returned %i"),
		    __func__, instlen);
  else if (instlen > 2)
    {
      status = target_read_memory (addr + 2, buf + 2, instlen - 2);
      if (status)
	memory_error (TARGET_XFER_E_IO, addr + 2);
    }

  return extract_unsigned_integer (buf, instlen, byte_order);
}

static void
set_reg_offset (struct gdbarch *gdbarch, struct riscv_frame_cache *this_cache,
		int regnum, CORE_ADDR offset)
{
  if (this_cache != NULL && this_cache->saved_regs[regnum].addr == -1)
    this_cache->saved_regs[regnum].addr = offset;
}

static void
reset_saved_regs (struct gdbarch *gdbarch, struct riscv_frame_cache *this_cache)
{
  const int num_regs = gdbarch_num_regs (gdbarch);
  int i;

  if (this_cache == NULL || this_cache->saved_regs == NULL)
    return;

  for (i = 0; i < num_regs; ++i)
    this_cache->saved_regs[i].addr = 0;
}

static int riscv_decode_register_index(unsigned long opcode, int offset)
{
    return (opcode >> offset) & 0x1F;
}

static CORE_ADDR
riscv_scan_prologue (struct gdbarch *gdbarch,
		     CORE_ADDR start_pc, CORE_ADDR limit_pc,
		     struct frame_info *this_frame,
		     struct riscv_frame_cache *this_cache)
{
  CORE_ADDR cur_pc;
  CORE_ADDR frame_addr = 0;
  CORE_ADDR sp;
  long frame_offset;
  int frame_reg = RISCV_SP_REGNUM;

  CORE_ADDR end_prologue_addr = 0;
  int seen_sp_adjust = 0;
  int load_immediate_bytes = 0;

  /* Can be called when there's no process, and hence when there's no THIS_FRAME.  */
  if (this_frame != NULL)
    sp = get_frame_register_signed (this_frame, RISCV_SP_REGNUM);
  else
    sp = 0;

  if (limit_pc > start_pc + 200)
    limit_pc = start_pc + 200;

 restart:

  frame_offset = 0;
  /* TODO: Handle compressed extensions.  */
  for (cur_pc = start_pc; cur_pc < limit_pc; cur_pc += 4)
    {
      ULONGEST inst;
      unsigned long opcode;
      int reg, rs1, imm12, rs2, offset12, funct3;

      /* Fetch the instruction.  */
      inst = riscv_fetch_instruction (gdbarch, cur_pc);

      /* Decode the instruction.  These offsets are defined in the RISC-V ISA
       * manual.  */
      reg = riscv_decode_register_index(inst, 7);
      rs1 = riscv_decode_register_index(inst, 15);
      rs2 = riscv_decode_register_index(inst, 20);
      imm12 = (inst >> 20) & 0xFFF;
      offset12 = (((inst >> 25) & 0x7F) << 5) + ((inst >> 7) & 0x1F);

      /* Look for common stack adjustment insns.  */
      if ((is_addi_insn(inst) || is_addiw_insn(inst))
	  && reg == RISCV_SP_REGNUM && rs1 == RISCV_SP_REGNUM)
	{
	  /* addi sp, sp, -i */
	  /* addiw sp, sp, -i */
	  if (imm12 & 0x800)
	    frame_offset += 0x1000 - imm12;
	  else
	    break;
	  seen_sp_adjust = 1;
	}
      else if (is_sw_insn(inst) && rs1 == RISCV_SP_REGNUM)
	{
	  /* sw reg, offset(sp) */
	  set_reg_offset (gdbarch, this_cache, rs1, sp + offset12);
	}
      else if (is_sd_insn(inst) && rs1 == RISCV_SP_REGNUM)
	{
	  /* sd reg, offset(sp) */
	  set_reg_offset (gdbarch, this_cache, rs1, sp + offset12);
	}
      else if (is_addi_insn(inst) && reg == RISCV_FP_REGNUM
	       && rs1 == RISCV_SP_REGNUM)
	{
	  /* addi s0, sp, size */
	  if ((long)imm12 != frame_offset)
	    frame_addr = sp + imm12;
	}
      else if (this_frame && frame_reg == RISCV_SP_REGNUM)
	{
	  unsigned alloca_adjust;

	  frame_reg = RISCV_FP_REGNUM;
	  frame_addr = get_frame_register_signed (this_frame, RISCV_FP_REGNUM);

	  alloca_adjust = (unsigned)(frame_addr - (sp - imm12));
	  if (alloca_adjust > 0)
	    {
	      sp += alloca_adjust;
	      reset_saved_regs (gdbarch, this_cache);
	      goto restart;
	    }
	}
      else if ((is_add_insn(inst) || is_addw_insn(inst))
	       && reg == RISCV_FP_REGNUM && rs1 == RISCV_SP_REGNUM
               && rs2 == RISCV_ZERO_REGNUM)
	{
	  /* add s0, sp, 0 */
	  /* addw s0, sp, 0 */
	  if (this_frame && frame_reg == RISCV_SP_REGNUM)
	    {
	      unsigned alloca_adjust;
	      frame_reg = RISCV_FP_REGNUM;
	      frame_addr = get_frame_register_signed (this_frame,
						      RISCV_FP_REGNUM);

	      alloca_adjust = (unsigned)(frame_addr - sp);
	      if (alloca_adjust > 0)
		{
		  sp = frame_addr;
		  reset_saved_regs (gdbarch, this_cache);
		  goto restart;
		}
	    }
	}
      else if (is_sw_insn(inst) && rs1 == RISCV_FP_REGNUM)
	{
	  /* sw reg, offset(s0) */
	  set_reg_offset (gdbarch, this_cache, rs1, frame_addr + offset12);
	}
      else if (reg == RISCV_GP_REGNUM
	       && (is_auipc_insn(inst)
                   || is_lui_insn(inst)
		   || (is_addi_insn(inst) && rs1 == RISCV_GP_REGNUM)
		   || (is_add_insn(inst) && (rs1 == RISCV_GP_REGNUM
					  || rs2 == RISCV_GP_REGNUM))))
	{
	  /* auipc gp, n */
	  /* addi gp, gp, n */
	  /* add gp, gp, reg */
	  /* add gp, reg, gp */
	  /* lui gp, n */
	  /* These instructions are part of the prologue, but we don't need to
	     do anything special to handle them.  */
	}
      else
	{
	  if (end_prologue_addr == 0)
	    end_prologue_addr = cur_pc;
	}
    }

  if (this_cache != NULL)
    {
      this_cache->base = get_frame_register_signed (this_frame, frame_reg)
	+ frame_offset;
      this_cache->saved_regs[RISCV_PC_REGNUM] =
	this_cache->saved_regs[RISCV_RA_REGNUM];
    }

  if (end_prologue_addr == 0)
    end_prologue_addr = cur_pc;

  if (load_immediate_bytes && !seen_sp_adjust)
    end_prologue_addr -= load_immediate_bytes;

  return end_prologue_addr;
}

/* Implement the riscv_skip_prologue gdbarch method.  */

static CORE_ADDR
riscv_skip_prologue (struct gdbarch *gdbarch,
		     CORE_ADDR       pc)
{
  CORE_ADDR limit_pc;
  CORE_ADDR func_addr;

  /* See if we can determine the end of the prologue via the symbol table.
     If so, then return either PC, or the PC after the prologue, whichever
     is greater.  */
  if (find_pc_partial_function (pc, NULL, &func_addr, NULL))
    {
      CORE_ADDR post_prologue_pc = skip_prologue_using_sal (gdbarch, func_addr);
      if (post_prologue_pc != 0)
	return std::max (pc, post_prologue_pc);
    }

  /* Can't determine prologue from the symbol table, need to examine
     instructions.  */

  /* Find an upper limit on the function prologue using the debug information.
     If the debug information could not be used to provide that bound, then use
     an arbitrary large number as the upper bound.  */
  limit_pc = skip_prologue_using_sal (gdbarch, pc);
  if (limit_pc == 0)
    limit_pc = pc + 100;   /* MAGIC! */

  return riscv_scan_prologue (gdbarch, pc, limit_pc, NULL, NULL);
}

static CORE_ADDR
riscv_push_dummy_code (struct gdbarch *gdbarch, CORE_ADDR sp, CORE_ADDR funaddr,
		       struct value **args, int nargs, struct type *value_type,
		       CORE_ADDR *real_pc, CORE_ADDR *bp_addr,
		       struct regcache *regcache)
{
  *bp_addr = sp;
  *real_pc = funaddr;

  /* Keep the stack aligned.  */
  return sp - 16;
}

static CORE_ADDR
riscv_push_dummy_call (struct gdbarch *gdbarch,
		       struct value *function,
		       struct regcache *regcache,
		       CORE_ADDR bp_addr,
		       int nargs,
		       struct value **args,
		       CORE_ADDR sp,
		       int struct_return,
		       CORE_ADDR struct_addr)
{
  enum bfd_endian byte_order = gdbarch_byte_order (gdbarch);
  struct gdbarch_tdep *tdep = gdbarch_tdep (gdbarch);
  gdb_byte buf[4];
  int i;
  CORE_ADDR func_addr = find_function_addr (function, NULL);

  /* Push excess arguments in reverse order.  */

  for (i = nargs; i >= 8; --i)
    {
      struct type *value_type = value_enclosing_type (args[i]);
      int container_len = align_up (TYPE_LENGTH (value_type), 3);

      sp -= container_len;
      write_memory (sp, value_contents_writeable (args[i]), container_len);
    }

  /* Initialize argument registers.  */

  for (i = 0; i < nargs && i < 8; ++i)
    {
      struct type *value_type = value_enclosing_type (args[i]);
      const gdb_byte *arg_bits = value_contents_all (args[i]);
      int regnum = (TYPE_CODE (value_type) == TYPE_CODE_FLT
		    ? RISCV_FA0_REGNUM : RISCV_A0_REGNUM);

      regcache_cooked_write_unsigned
	(regcache, regnum + i,
	 extract_unsigned_integer
	   (arg_bits, riscv_isa_regsize(gdbarch), byte_order));
    }

  /* Store struct value address.  */

  if (struct_return)
    regcache_cooked_write_unsigned (regcache, RISCV_A0_REGNUM, struct_addr);

  /* Set the dummy return value to bp_addr.
     A dummy breakpoint will be setup to execute the call.  */

  regcache_cooked_write_unsigned (regcache, RISCV_RA_REGNUM, bp_addr);

  /* Finally, update the stack pointer.  */

  regcache_cooked_write_unsigned (regcache, RISCV_SP_REGNUM, sp);

  return sp;
}

/* Implement the frame_align gdbarch method.  */

static CORE_ADDR
riscv_frame_align (struct gdbarch *gdbarch, CORE_ADDR addr)
{
  return align_down (addr, 16);
}

/* Implement the unwind_pc gdbarch method.  */

static CORE_ADDR
riscv_unwind_pc (struct gdbarch *gdbarch, struct frame_info *next_frame)
{
  return frame_unwind_register_unsigned (next_frame, RISCV_PC_REGNUM);
}

/* Implement the unwind_sp gdbarch method.  */

static CORE_ADDR
riscv_unwind_sp (struct gdbarch *gdbarch, struct frame_info *next_frame)
{
  return frame_unwind_register_unsigned (next_frame, RISCV_SP_REGNUM);
}

/* Implement the dummy_id gdbarch method.  */

static struct frame_id
riscv_dummy_id (struct gdbarch *gdbarch, struct frame_info *this_frame)
{
  return frame_id_build (get_frame_register_signed (this_frame, RISCV_SP_REGNUM),
			 get_frame_pc (this_frame));
}

static struct trad_frame_cache *
riscv_frame_cache (struct frame_info *this_frame, void **this_cache)
{
  CORE_ADDR pc;
  CORE_ADDR start_addr;
  CORE_ADDR stack_addr;
  struct trad_frame_cache *this_trad_cache;
  struct gdbarch *gdbarch = get_frame_arch (this_frame);

  if ((*this_cache) != NULL)
    return (struct trad_frame_cache *) *this_cache;
  this_trad_cache = trad_frame_cache_zalloc (this_frame);
  (*this_cache) = this_trad_cache;

  trad_frame_set_reg_realreg (this_trad_cache, gdbarch_pc_regnum (gdbarch),
			      RISCV_RA_REGNUM);

  pc = get_frame_pc (this_frame);
  find_pc_partial_function (pc, NULL, &start_addr, NULL);
  stack_addr = get_frame_register_signed (this_frame, RISCV_SP_REGNUM);
  trad_frame_set_id (this_trad_cache, frame_id_build (stack_addr, start_addr));

  trad_frame_set_this_base (this_trad_cache, stack_addr);

  return this_trad_cache;
}

static void
riscv_frame_this_id (struct frame_info *this_frame,
		     void              **prologue_cache,
		     struct frame_id   *this_id)
{
  struct trad_frame_cache *info = riscv_frame_cache (this_frame, prologue_cache);
  trad_frame_get_id (info, this_id);
}

static struct value *
riscv_frame_prev_register (struct frame_info *this_frame,
			   void              **prologue_cache,
			   int                regnum)
{
  struct trad_frame_cache *info = riscv_frame_cache (this_frame, prologue_cache);
  return trad_frame_get_register (info, this_frame, regnum);
}

static const struct frame_unwind riscv_frame_unwind =
{
  /*.type          =*/ NORMAL_FRAME,
  /*.stop_reason   =*/ default_frame_unwind_stop_reason,
  /*.this_id       =*/ riscv_frame_this_id,
  /*.prev_register =*/ riscv_frame_prev_register,
  /*.unwind_data   =*/ NULL,
  /*.sniffer       =*/ default_frame_sniffer,
  /*.dealloc_cache =*/ NULL,
  /*.prev_arch     =*/ NULL,
};

static bool
registers_init (struct gdbarch *gdbarch, struct gdbarch_info info)
{
  /* We support two ways of dealing with registers:
   * 1. The server sends gdb an XML description of its registers. This is what
   * gdb calls tdesc. This way the server can also let us know what registers
   * actually exist on the target.
   * 2. Communicate with the target using register numbers only.
   */

  // First, for our own records, build a structure with all relevant
  // information about registers.
  // riscv_reg_info statically gets info about all registers except for the
  // CSRs. We add those programmatically because there are many of them.
  struct {
      const char *name;
      unsigned num;
  } named_csr[] = {
#define DECLARE_CSR(name, num) {#name, RISCV_ ## num ## _REGNUM},
#include "opcode/riscv-opc.h"
#undef DECLARE_CSR
  };

  static bool reg_info_built = false;
  if (!reg_info_built)
    {
      for (unsigned i = 0; i < sizeof(named_csr) / sizeof(*named_csr); i++)
        {
          char *generic_name = (char*) malloc(8);
          gdb_assert(named_csr[i].num < 10000);
          sprintf(generic_name, "csr%d", named_csr[i].num - RISCV_FIRST_CSR_REGNUM);
          struct riscv_reg_info reg = {
              named_csr[i].num,
              {named_csr[i].name, generic_name},
              false,
              false,
              "org.gnu.gdb.riscv.csr",
              all_reggroup
          };

          riscv_reg_info.push_back(reg);
        }
      for (auto reg_info = riscv_reg_info.begin();
           reg_info != riscv_reg_info.end(); ++reg_info)
        riscv_reg_map[reg_info->number] = &(*reg_info);
      reg_info_built = true;
    }

  set_gdbarch_num_regs (gdbarch, RISCV_NUM_REGS);

  bool use_tdesc_registers = false;
  if (tdesc_has_registers (info.target_desc))
    {
      use_tdesc_registers = true;

      struct tdesc_arch_data *tdesc_data = tdesc_data_alloc ();

      std::map<int, const char*> found;

      for (auto reg_info = riscv_reg_info.begin();
           reg_info != riscv_reg_info.end(); ++reg_info)
        {
          const struct tdesc_feature *feature =
            tdesc_find_feature (info.target_desc, reg_info->feature_name);
          int success = 0;
          if (feature)
            // Look for this register by any of its names.
            for (auto name = reg_info->names.begin();
                 name != reg_info->names.end(); ++name)
              {
                success = tdesc_numbered_register (feature, tdesc_data,
                                                   reg_info->number, *name);
                if (success)
                  {
                    found[reg_info->number] = *name;
                    break;
                  }
              }

          if (!success && reg_info->required)
            {
              use_tdesc_registers = false;
              break;
            }
        }

      if (use_tdesc_registers)
        {
          // This is going to call set_gdbarch_register_reggroup_p (and a few
          // others; see the end of tdesc_use_registers()).
          tdesc_use_registers (gdbarch, info.target_desc, tdesc_data);

          // Now go through again, adding aliases.
          for (auto reg_info = riscv_reg_info.begin();
               reg_info != riscv_reg_info.end(); ++reg_info)
            {
              auto match = found.find(reg_info->number);
              if (match == found.end())
                continue;
              for (auto name = reg_info->names.begin();
                   name != reg_info->names.end(); ++name)
                {
                  if (*name != match->second)
                    user_reg_add (gdbarch, *name, value_of_riscv_user_reg,
                                  &reg_info->number);
                }
            }
        }
      else
        tdesc_data_cleanup (tdesc_data);
    }

  if (!use_tdesc_registers)
    {
      // Using the built-in list. Just need to add aliases.
      for (auto reg_info = riscv_reg_info.begin();
           reg_info != riscv_reg_info.end(); ++reg_info)
        {
          for (auto name = reg_info->names.begin() + 1;
               name != reg_info->names.end(); ++name)
            user_reg_add (gdbarch, *name,
                          value_of_riscv_user_reg, &reg_info->number);
        }
    }

  return use_tdesc_registers;
}

static struct gdbarch *
riscv_gdbarch_init (struct gdbarch_info info,
		    struct gdbarch_list *arches)
{
  /*
   * Note that this function is called for different purposes: Some gdbarchs
   * are used just to inspect files. Others are used to interact with a live
   * target. gdb will create at least one of each in a typical debug session.
   */

  struct gdbarch_tdep *tdep;
  const struct bfd_arch_info *binfo = info.bfd_arch_info;

  int abi;
  if (info.abfd && bfd_get_flavour (info.abfd) == bfd_target_elf_flavour)
    {
      unsigned char eclass = elf_elfheader (info.abfd)->e_ident[EI_CLASS];

      if (eclass == ELFCLASS32)
	abi = RISCV_ABI_FLAG_RV32I;
      else if (eclass == ELFCLASS64)
	abi = RISCV_ABI_FLAG_RV64I;
      else
        internal_error (__FILE__, __LINE__, _("unknown ELF header class %d"), eclass);
    }
  else if (tdesc_has_registers (info.target_desc))
    {
      // Look for x1. x0 might not exist since it's fixed.
      const struct tdesc_feature *feature =
        tdesc_find_feature (info.target_desc, riscv_reg_info[1].feature_name);
      if (!feature)
        internal_error (__FILE__, __LINE__,
                        _("feature %s missing from target description"),
                        riscv_reg_info[1].feature_name);

      int size = 0;
      for (auto name = riscv_reg_info[1].names.begin();
           size <= 0 && name != riscv_reg_info[1].names.end(); ++name)
        {
          if (tdesc_unnumbered_register (feature, *name))
            size = tdesc_register_size (feature, *name);
        }

      switch (size) {
        case 32:
          abi = RISCV_ABI_FLAG_RV32I;
          break;
        case 64:
          abi = RISCV_ABI_FLAG_RV64I;
          break;
        default:
          internal_error (__FILE__, __LINE__,
                          _("target description for %s has unsupported size %d"),
                          riscv_reg_info[1].names[0], size);
      }
    }
  else
    {
      if (binfo->bits_per_word == 32)
        abi = RISCV_ABI_FLAG_RV32I;
      else if (binfo->bits_per_word == 64)
        abi = RISCV_ABI_FLAG_RV64I;
      else
        internal_error (__FILE__, __LINE__, _("unknown bits_per_word %d"),
            binfo->bits_per_word);
    }

  /* Find a candidate among the list of pre-declared architectures.  */
  for (arches = gdbarch_list_lookup_by_info (arches, &info);
       arches != NULL;
       arches = gdbarch_list_lookup_by_info (arches->next, &info))
    {
      if (gdbarch_tdep (arches->gdbarch)->riscv_abi == abi)
        return arches->gdbarch;
    }

  /* None found, so create a new architecture from the information provided.
     Can't initialize all the target dependencies until we actually know which
     target we are talking to, but put in some defaults for now.  */

  tdep = (struct gdbarch_tdep *) xmalloc (sizeof *tdep);
  struct gdbarch *gdbarch = gdbarch_alloc (&info, tdep);

  tdep->riscv_abi = abi;
  tdep->supports_compressed_isa = AUTO_BOOLEAN_AUTO;

  /* Target data types.  */
  set_gdbarch_short_bit (gdbarch, 16);
  set_gdbarch_int_bit (gdbarch, 32);
  set_gdbarch_long_bit (gdbarch, riscv_isa_regsize (gdbarch) * 8);
  set_gdbarch_float_bit (gdbarch, 32);
  set_gdbarch_double_bit (gdbarch, 64);
  set_gdbarch_long_double_bit (gdbarch, 128);
  set_gdbarch_ptr_bit (gdbarch, riscv_isa_regsize (gdbarch) * 8);
  set_gdbarch_char_signed (gdbarch, 1);

  /* Information about the target architecture.  */
  set_gdbarch_return_value (gdbarch, riscv_return_value);
  set_gdbarch_breakpoint_kind_from_pc (gdbarch, riscv_breakpoint_kind_from_pc);
  set_gdbarch_sw_breakpoint_from_kind (gdbarch, riscv_sw_breakpoint_from_kind);

  /* Functions to supply register information.  */
  set_gdbarch_register_name (gdbarch, riscv_register_name);
  set_gdbarch_register_type (gdbarch, riscv_register_type);
  set_gdbarch_print_registers_info (gdbarch, riscv_print_registers_info);
  set_gdbarch_register_reggroup_p (gdbarch, riscv_register_reggroup_p);

  /* Functions to analyze frames.  */
  set_gdbarch_skip_prologue (gdbarch, riscv_skip_prologue);
  set_gdbarch_inner_than (gdbarch, core_addr_lessthan);
  set_gdbarch_frame_align (gdbarch, riscv_frame_align);

  /* Functions to access frame data.  */
  set_gdbarch_unwind_pc (gdbarch, riscv_unwind_pc);
  set_gdbarch_unwind_sp (gdbarch, riscv_unwind_sp);

  /* Functions handling dummy frames.  */
  set_gdbarch_call_dummy_location (gdbarch, ON_STACK);
  set_gdbarch_push_dummy_code (gdbarch, riscv_push_dummy_code);
  set_gdbarch_push_dummy_call (gdbarch, riscv_push_dummy_call);
  set_gdbarch_dummy_id (gdbarch, riscv_dummy_id);

  /* Frame unwinders.  Use DWARF debug info if available, otherwise use our own
     unwinder.  */
  dwarf2_append_unwinders (gdbarch);
  frame_unwind_append_unwinder (gdbarch, &riscv_frame_unwind);

  set_gdbarch_sp_regnum (gdbarch, RISCV_SP_REGNUM);
  set_gdbarch_pc_regnum (gdbarch, RISCV_PC_REGNUM);
  set_gdbarch_ps_regnum (gdbarch, RISCV_FP_REGNUM);
  set_gdbarch_deprecated_fp_regnum (gdbarch, RISCV_FP_REGNUM);

  registers_init (gdbarch, info);

  return gdbarch;
}

extern initialize_file_ftype _initialize_riscv_tdep; /* -Wmissing-prototypes */

void
_initialize_riscv_tdep (void)
{
  gdbarch_register (bfd_arch_riscv, riscv_gdbarch_init, NULL);

  /* Add root prefix command for all "set riscv"/"show riscv" commands.  */
  add_prefix_cmd ("riscv", no_class, set_riscv_command,
      _("RISC-V specific commands."),
      &setriscvcmdlist, "set riscv ", 0, &setlist);

  add_prefix_cmd ("riscv", no_class, show_riscv_command,
      _("RISC-V specific commands."),
      &showriscvcmdlist, "show riscv ", 0, &showlist);

  use_compressed_breakpoints = AUTO_BOOLEAN_AUTO;
  add_setshow_auto_boolean_cmd ("use_compressed_breakpoints", no_class,
      &use_compressed_breakpoints,
      _("Configure whether to use compressed breakpoints."),
      _("Show whether to use compressed breakpoints."),
      _("\
Debugging compressed code requires compressed breakpoints to be used. If left\n\
to 'auto' then gdb will use them if $misa indicates the C extension is\n\
supported. If that doesn't give the correct behavior, then this option can be\n\
used."),
      NULL,
      NULL,
      &setriscvcmdlist,
      &showriscvcmdlist);
}
