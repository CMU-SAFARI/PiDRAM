#include <math_ldbl_opt.h>
#undef weak_alias
#define weak_alias(n,a)
#include <math/w_acosl_compat.c>
long_double_symbol (libm, __acosl, acosl);
