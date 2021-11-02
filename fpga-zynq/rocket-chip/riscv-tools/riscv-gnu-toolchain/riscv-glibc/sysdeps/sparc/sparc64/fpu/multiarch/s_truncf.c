/* Float trunc function, sparc64 version.
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

#ifdef HAVE_AS_VIS3_SUPPORT
# include <sparc-ifunc.h>
# include <math.h>

extern float __truncf_vis3 (float);
extern float __truncf_generic (float);

sparc_libm_ifunc(__truncf, hwcap & HWCAP_SPARC_VIS3 ? __truncf_vis3 : __truncf_generic);
weak_alias (__truncf, truncf)

# define __truncf __truncf_generic
#endif

#include <sysdeps/ieee754/flt-32/s_truncf.c>
