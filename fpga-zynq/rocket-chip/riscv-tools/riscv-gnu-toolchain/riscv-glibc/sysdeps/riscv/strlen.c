/* Determine the length of a string.  RISC-V version.
   Copyright (C) 2011-2017 Free Software Foundation, Inc.
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
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

#include <string.h>
#include <stdint.h>
#include "detect_null_byte.h"

#undef strlen

size_t strlen(const char* str)
{
  const char* start = str;

  if (__builtin_expect((uintptr_t)str & (sizeof(long)-1), 0)) do
  {
    char ch = *str;
    str++;
    if (!ch)
      return str - start - 1;
  } while ((uintptr_t)str & (sizeof(long)-1));

  unsigned long* ls = (unsigned long*)str;
  while (!detect_null_byte(*ls++))
    ;
  asm volatile ("" : "+r"(ls)); /* prevent "optimization" */

  str = (const char*)ls;
  size_t ret = str - start, sl = sizeof(long);

  char c0 = str[0-sl], c1 = str[1-sl], c2 = str[2-sl], c3 = str[3-sl];
  if (c0 == 0)            return ret + 0 - sl;
  if (c1 == 0)            return ret + 1 - sl;
  if (c2 == 0)            return ret + 2 - sl;
  if (sl == 4 || c3 == 0) return ret + 3 - sl;

  c0 = str[4-sl], c1 = str[5-sl], c2 = str[6-sl], c3 = str[7-sl];
  if (c0 == 0)            return ret + 4 - sl;
  if (c1 == 0)            return ret + 5 - sl;
  if (c2 == 0)            return ret + 6 - sl;

  return ret + 7 - sl;
}
libc_hidden_def(strlen)
