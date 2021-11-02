/* Round float value to long long int.  RISC-V version.
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

long long
__llroundf (float x)
{
  long long res;
  asm ("fcvt.l.s %0, %1, rmm" : "=r" (res) : "f" (x));
  return res;
}

weak_alias (__llroundf, llroundf)
#ifdef __LP64__
strong_alias (__llroundf, __lroundf)
weak_alias (__llroundf, lroundf)
#endif
