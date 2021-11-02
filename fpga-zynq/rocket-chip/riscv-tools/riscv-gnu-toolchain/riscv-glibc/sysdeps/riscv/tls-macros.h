/* Macros to support TLS testing in times of missing compiler support.  */

#include <sys/cdefs.h>
#include <sys/asm.h>
#include <sysdep.h>

#define LOAD_GP						\
	".option push\n\t"				\
	".option norelax\n\t"				\
	"la gp, __global_pointer$\n\t"			\
	".option pop\n\t"

#define UNLOAD_GP

#define TLS_GD(x)					\
	({ void *__result;				\
	asm (LOAD_GP					\
	     "la.tls.gd %0, " #x "\n\t"			\
	     UNLOAD_GP					\
	     : "=r"(__result));				\
	__tls_get_addr(__result); })

#define TLS_LD(x) TLS_GD(x)

#define TLS_IE(x)					\
	({ void *__result;				\
	asm (LOAD_GP					\
	     "la.tls.ie %0, " #x "\n\t"			\
	     UNLOAD_GP					\
	     : "=r"(__result));				\
	__tls_get_addr(__result); })

#define TLS_LE(x)					\
	({ void *__result;				\
	asm (LOAD_GP					\
	     "lui %0, %%tprel_hi(" #x ")\n\t"		\
	     "add %0, %0, tp, %%tprel_add(" #x ")\n\t"	\
	     "lw %0, %%tprel_lo(" #x ")(%0)\n\t"	\
	     UNLOAD_GP					\
	     : "=r"(__result));				\
	__tls_get_addr(__result); })
