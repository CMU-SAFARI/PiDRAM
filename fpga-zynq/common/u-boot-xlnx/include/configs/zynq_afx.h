/*
 * (C) Copyright 2012 Xilinx
 *
 * Configuration settings for the Xilinx Zynq AFX board.
 * See zynq-common.h for Zynq common configs
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef __CONFIG_ZYNQ_AFX_H
#define __CONFIG_ZYNQ_AFX_H

#define CONFIG_SYS_SDRAM_SIZE (128 * 1024 * 1024)

#define CONFIG_ZYNQ_SERIAL_UART1

#define CONFIG_SYS_NO_FLASH
#if defined(CONFIG_AFX_NOR)
# undef CONFIG_SYS_NO_FLASH
#elif defined(CONFIG_AFX_QSPI)
# define CONFIG_ZYNQ_QSPI
#elif defined(CONFIG_AFX_NAND)
# define CONFIG_NAND_ZYNQ
#endif

#include <configs/zynq-common.h>

#endif /* __CONFIG_ZYNQ_AFX_H */
