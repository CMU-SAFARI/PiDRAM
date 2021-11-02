/* Facilitate pthread initialization using init_array.  */

#include <sys/asm.h>

#ifdef PREINIT_FUNCTION

#if PREINIT_FUNCTION_WEAK
# error PREINIT_FUNCTION_WEAK is unsupported
#endif

	.section .init_array, "aw"
	.dc.a PREINIT_FUNCTION

#endif
