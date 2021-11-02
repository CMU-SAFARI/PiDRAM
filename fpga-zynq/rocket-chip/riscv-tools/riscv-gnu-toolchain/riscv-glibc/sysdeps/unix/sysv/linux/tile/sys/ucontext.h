/* Copyright (C) 2011-2017 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Chris Metcalf <cmetcalf@tilera.com>, 2011.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library.  If not, see
   <http://www.gnu.org/licenses/>.  */

#ifndef _SYS_UCONTEXT_H
#define _SYS_UCONTEXT_H	1

#include <features.h>

#include <bits/types/sigset_t.h>
#include <bits/sigcontext.h>
#include <bits/types/stack_t.h>

#ifdef __USE_MISC
/* Get register type and register names. */
# include <arch/abi.h>


/* Type for general register.  */
typedef uint_reg_t greg_t;

/* Number of general registers.  Must agree with <asm/ptrace.h>. */
# define NGREG	64

/* Container for all general registers.  */
typedef greg_t gregset_t[NGREG];
#endif

#ifdef __USE_GNU
/* Names for interesting registers in the `gregset_t' array.  */
enum
{
  /* ... r0 through r51 are just 0 through 51 ... */
  REG_FP = TREG_FP,
# define REG_FP		REG_FP
  REG_TP = TREG_TP,
# define REG_TP		REG_TP
  REG_SP = TREG_SP,
# define REG_SP		REG_SP
  REG_LR = TREG_LR,
# define REG_LR		REG_LR
};
#endif

/* A machine context is exactly a sigcontext.  */
typedef struct sigcontext mcontext_t;

/* Userlevel context.  */
typedef struct ucontext_t
  {
    unsigned long int uc_flags;
    struct ucontext_t *uc_link;
    stack_t uc_stack;
    mcontext_t uc_mcontext;
    sigset_t uc_sigmask;
  } ucontext_t;

#endif /* sys/ucontext.h */
