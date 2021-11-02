/*
 * (C) Copyright 2013 Xilinx.
 *
 * Configuration settings for the Xilinx Zynq CSE board.
 * See zynq-common.h for Zynq common configs
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __CONFIG_ZYNQ_CSE_H
#define __CONFIG_ZYNQ_CSE_H

#define CONFIG_SYS_NO_FLASH
#define CONFIG_ZYNQ_DCC
#define _CONFIG_CMD_DEFAULT_H
#define CONFIG_SKIP_LOWLEVEL_INIT
#define CONFIG_ENV_IS_NOWHERE
#define CONFIG_SYS_DCACHE_OFF

#if defined(CONFIG_CSE_QSPI)
# define CONFIG_ZYNQ_QSPI

#elif defined(CONFIG_CSE_NAND)
# define CONFIG_NAND_ZYNQ

#elif defined(CONFIG_CSE_NOR)
#undef CONFIG_SYS_NO_FLASH

#endif

#include <configs/zynq-common.h>

/* Undef unneeded configs */
#undef CONFIG_SYS_SDRAM_BASE
#undef CONFIG_OF_LIBFDT
#undef CONFIG_EXTRA_ENV_SETTINGS
#undef CONFIG_BOARD_LATE_INIT
#undef CONFIG_FPGA
#undef CONFIG_FPGA_XILINX
#undef CONFIG_FPGA_ZYNQPL
#undef CONFIG_CMD_FPGA
#undef CONFIG_FIT
#undef CONFIG_FIT_VERBOSE
#undef CONFIG_CMD_GO
#undef CONFIG_CMD_BOOTM
#undef CONFIG_CMD_BOOTZ
#undef CONFIG_BOOTCOMMAND
#undef CONFIG_SYS_HUSH_PARSER
#undef CONFIG_SYS_PROMPT_HUSH_PS2
#undef CONFIG_BOOTDELAY
#undef CONFIG_SYS_MALLOC_LEN
#undef CONFIG_ENV_SIZE
#undef CONFIG_CMDLINE_EDITING
#undef CONFIG_AUTO_COMPLETE
#undef CONFIG_ZLIB
#undef CONFIG_GZIP
#undef CONFIG_CMD_SPL

/* Define needed configs */
#define CONFIG_CMD_MEMORY
#define CONFIG_BOOTDELAY	-1 /* -1 to Disable autoboot */
#define CONFIG_SYS_MALLOC_LEN	0x4000

#if defined(CONFIG_CSE_QSPI)
# define CONFIG_SYS_SDRAM_SIZE		(256 * 1024)
# define CONFIG_SYS_SDRAM_BASE		0xFFFD0000
# define CONFIG_ENV_SIZE		1400

#elif defined(CONFIG_CSE_NAND)
# define CONFIG_SYS_SDRAM_SIZE		(4 * 1024 * 1024)
# define CONFIG_SYS_SDRAM_BASE		0
# define CONFIG_ENV_SIZE		0x10000

#elif defined(CONFIG_CSE_NOR)
# define CONFIG_SYS_SDRAM_SIZE		(256 * 1024)
# define CONFIG_SYS_SDRAM_BASE		0xFFFD0000
# define CONFIG_ENV_SIZE		1400

#endif

#endif /* __CONFIG_ZYNQ_CSE_H */
