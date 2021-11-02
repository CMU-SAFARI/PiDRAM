/* Optimized string copy implementation for RISC-V.
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

#undef strcpy

char* strcpy(char* dst, const char* src)
{
  char* dst0 = dst;

  int misaligned = ((uintptr_t)dst | (uintptr_t)src) & (sizeof(long)-1);
  if (__builtin_expect(!misaligned, 1))
  {
    long* ldst = (long*)dst;
    const long* lsrc = (const long*)src;

    while (!detect_null_byte(*lsrc))
      *ldst++ = *lsrc++;

    dst = (char*)ldst;
    src = (const char*)lsrc;

    char c0 = src[0];
    char c1 = src[1];
    char c2 = src[2];
    if (!(*dst++ = c0)) return dst0;
    if (!(*dst++ = c1)) return dst0;
    char c3 = src[3];
    if (!(*dst++ = c2)) return dst0;
    if (sizeof(long) == 4) goto out;
    char c4 = src[4];
    if (!(*dst++ = c3)) return dst0;
    char c5 = src[5];
    if (!(*dst++ = c4)) return dst0;
    char c6 = src[6];
    if (!(*dst++ = c5)) return dst0;
    if (!(*dst++ = c6)) return dst0;

out:
    *dst++ = 0;
    return dst0;
  }

  char ch;
  do
  {
    ch = *src;
    src++;
    dst++;
    *(dst-1) = ch;
  } while(ch);

  return dst0;
}
libc_hidden_def(strcpy)
