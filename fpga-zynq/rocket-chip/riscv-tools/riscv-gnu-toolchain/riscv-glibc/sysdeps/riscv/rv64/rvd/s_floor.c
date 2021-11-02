/* floor().  RISC-V version.
   Copyright (C) 2017 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

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

#include <math.h>
#include <math_private.h>

double
__floor (double x)
{
  int flags = riscv_getflags ();
  int nan = isnan (x);
  double mag = fabs (x);

  if (nan)
    return x + x;

  if (mag < (1ULL << __DBL_MANT_DIG__))
    {
      long i;
      double new_x;

      asm volatile ("fcvt.l.d %0, %1, rdn" : "=r" (i) : "f" (x));
      asm volatile ("fcvt.d.l %0, %1, rdn" : "=f" (new_x) : "r" (i));

      /* floor(-0) == -0, and in general we'll always have the same
	 sign as our input.  */
      x = copysign (new_x, x);

      riscv_setflags (flags);
    }

  return x;
}

weak_alias (__floor, floor)
