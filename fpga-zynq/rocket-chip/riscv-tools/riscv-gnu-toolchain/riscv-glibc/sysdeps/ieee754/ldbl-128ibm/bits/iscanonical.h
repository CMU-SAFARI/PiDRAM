/* Define iscanonical macro.  ldbl-128ibm version.
   Copyright (C) 2016-2017 Free Software Foundation, Inc.
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

#ifndef _MATH_H
# error "Never use <bits/iscanonical.h> directly; include <math.h> instead."
#endif

#ifdef __NO_LONG_DOUBLE_MATH
# define iscanonical(x) ((void) (__typeof (x)) (x), 1)
#else
extern int __iscanonicall (long double __x)
     __THROW __attribute__ ((__const__));
# define __iscanonicalf(x) ((void) (__typeof (x)) (x), 1)
# define __iscanonical(x) ((void) (__typeof (x)) (x), 1)
# if __HAVE_DISTINCT_FLOAT128
#  define __iscanonicalf128(x) ((void) (__typeof (x)) (x), 1)
# endif

/* Return nonzero value if X is canonical.  In IEEE interchange binary
   formats, all values are canonical, but the argument must still be
   converted to its semantic type for any exceptions arising from the
   conversion, before being discarded; in IBM long double, there are
   encodings that are not consistently handled as corresponding to any
   particular value of the type, and we return 0 for those.  */
# define iscanonical(x) __MATH_TG ((x), __iscanonical, (x))
#endif
