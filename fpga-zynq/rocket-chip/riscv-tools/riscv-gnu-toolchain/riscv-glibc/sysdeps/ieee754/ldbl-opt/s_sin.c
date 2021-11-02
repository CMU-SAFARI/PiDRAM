/* dbl-64/s_sin.c uses NAN and sincos identifiers internally.  */
#define sincos sincos_disable
/* These definitions needed for proper unfolding of __MATHDECL_VEC.  */
#define __DECL_SIMD_sincos_disable
#define __DECL_SIMD_sincos_disablef
#define __DECL_SIMD_sincos_disablel
#define __DECL_SIMD_sincos_disablef128
#include <math_ldbl_opt.h>
#undef NAN
#undef sincos
#include <sysdeps/ieee754/dbl-64/s_sin.c>
#if LONG_DOUBLE_COMPAT(libm, GLIBC_2_0)
compat_symbol (libm, __sin, sinl, GLIBC_2_0);
compat_symbol (libm, __cos, cosl, GLIBC_2_0);
#endif
