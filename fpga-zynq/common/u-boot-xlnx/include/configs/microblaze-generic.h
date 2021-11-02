/*
 * (C) Copyright 2007-2010 Michal Simek
 *
 * Michal SIMEK <monstr@monstr.eu>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef __CONFIG_H
#define __CONFIG_H

#include "../board/xilinx/microblaze-generic/xparameters.h"


#define	CONFIG_MICROBLAZE	1	/* MicroBlaze CPU */
#define	MICROBLAZE_V5		1

/* Memory test handling */
#define	CONFIG_SYS_MEMTEST_START	CONFIG_SYS_SDRAM_BASE
#define	CONFIG_SYS_MEMTEST_END		(CONFIG_SYS_SDRAM_BASE + 0x1000)

/* global pointer */
/* start of global data */
#define	CONFIG_SYS_GBL_DATA_OFFSET	(CONFIG_SYS_SDRAM_SIZE - GENERATED_GBL_DATA_SIZE)

/* monitor code */
#define	SIZE			0x40000
#define	CONFIG_SYS_MONITOR_LEN		SIZE
#define	CONFIG_SYS_MONITOR_BASE  (CONFIG_SYS_SDRAM_BASE + CONFIG_SYS_GBL_DATA_OFFSET - CONFIG_SYS_MONITOR_LEN - GENERATED_BD_INFO_SIZE)

#define	CONFIG_SYS_MONITOR_END		(CONFIG_SYS_MONITOR_BASE + CONFIG_SYS_MONITOR_LEN)
#define	CONFIG_SYS_MALLOC_LEN		SIZE
#define	CONFIG_SYS_MALLOC_BASE		(CONFIG_SYS_MONITOR_BASE - CONFIG_SYS_MALLOC_LEN)

/* stack */
#define	CONFIG_SYS_INIT_SP_OFFSET	CONFIG_SYS_MALLOC_BASE

#define   CONFIG_SYS_BOOTMAPSZ	(1 << 31) /* Initial Memory map for Linux */

#undef CONFIG_PHYLIB
#define CONFIG_LMB		1

/* Default cache size if not specified */
#ifndef XILINX_DCACHE_BYTE_SIZE
# define XILINX_DCACHE_BYTE_SIZE	32768
#endif


/* The following table includes the supported baudrates */
#define CONFIG_SYS_BAUDRATE_TABLE  \
	{300, 600, 1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200, 230400}

/* use serial multi for all serial devices */
#define CONFIG_SYS_CONSOLE_IS_IN_ENV 1

#ifdef XILINX_UARTLITE_BASEADDR
# define CONFIG_XILINX_UARTLITE
# if defined(XILINX_UARTLITE_BAUDRATE)
#  define CONFIG_BAUDRATE	XILINX_UARTLITE_BAUDRATE
# endif
#endif

#if XILINX_UART16550_BASEADDR
# define CONFIG_SYS_NS16550	1
# define CONFIG_SYS_NS16550_SERIAL
# define CONFIG_SYS_NS16550_COM1	((XILINX_UART16550_BASEADDR & ~0xF) + 0x1000)
# define CONFIG_SYS_NS16550_CLK		XILINX_UART16550_CLOCK_HZ

# if defined(__MICROBLAZEEL__)
#  define CONFIG_SYS_NS16550_REG_SIZE	-4
# else
#  define CONFIG_SYS_NS16550_REG_SIZE	4
# endif

/* CONS_INDEX for system with uartlite only mustn't define CONFIG_CONS_INDEX
 * u-boot BSP generates CONFIG_CONS_INDEX for system with several uart16550 */
# if !defined(CONFIG_CONS_INDEX)
#  define CONFIG_CONS_INDEX	1
# endif
#endif

#if !defined(CONFIG_BAUDRATE)
	#define CONFIG_BAUDRATE	115200
#endif

#undef CONFIG_SYS_ENET
#ifdef XILINX_EMAC_BASEADDR
	#define CONFIG_XILINX_EMAC	1
	#define CONFIG_SYS_ENET
#endif
#if defined(XILINX_EMACLITE_BASEADDR) || defined(CONFIG_OF_CONTROL)
# define CONFIG_XILINX_EMACLITE	1
# define CONFIG_SYS_ENET
#endif
#if defined(XILINX_LLTEMAC_BASEADDR)
	#define CONFIG_XILINX_LL_TEMAC	1
	#define CONFIG_SYS_ENET
#endif
#if defined(XILINX_AXIEMAC_BASEADDR)
	#define CONFIG_XILINX_AXIEMAC   1
	#define CONFIG_SYS_ENET
#endif

#undef ET_DEBUG

/* gpio */
#ifdef XILINX_GPIO_BASEADDR
# define CONFIG_XILINX_GPIO
# define CONFIG_SYS_GPIO_0_ADDR		XILINX_GPIO_BASEADDR
#endif

/* interrupt controller */
#ifdef XILINX_INTC_BASEADDR
	#define	CONFIG_SYS_INTC_0		1
	#define	CONFIG_SYS_INTC_0_ADDR		XILINX_INTC_BASEADDR
	#define	CONFIG_SYS_INTC_0_NUM		XILINX_INTC_NUM_INTR_INPUTS
#endif

/* timer */
#ifdef XILINX_TIMER_BASEADDR
	#if (XILINX_TIMER_IRQ != -1)
		#define	CONFIG_SYS_TIMER_0		1
		#define	CONFIG_SYS_TIMER_0_ADDR	XILINX_TIMER_BASEADDR
		#define	CONFIG_SYS_TIMER_0_IRQ		XILINX_TIMER_IRQ
		#define	FREQUENCE		XILINX_CLOCK_FREQ
		#define	CONFIG_SYS_TIMER_0_PRELOAD	( FREQUENCE/1000 )
	#endif
#else
# error Please setup TIMER in BSP
#endif

#if defined(XILINX_WATCHDOG_BASEADDR) && defined(XILINX_WATCHDOG_IRQ)
# define CONFIG_WATCHDOG_BASEADDR	XILINX_WATCHDOG_BASEADDR
# define CONFIG_WATCHDOG_IRQ		XILINX_WATCHDOG_IRQ
# define CONFIG_HW_WATCHDOG		1
# define CONFIG_XILINX_TB_WATCHDOG	1
#endif

/*
 * memory layout - Example
 * TEXT_BASE = 0x1200_0000;
 * CONFIG_SYS_SRAM_BASE = 0x1000_0000;
 * CONFIG_SYS_SRAM_SIZE = 0x0400_0000;
 *
 * CONFIG_SYS_GBL_DATA_OFFSET = 0x1000_0000 + 0x0400_0000 - 0x1000 = 0x13FF_F000
 * CONFIG_SYS_MONITOR_BASE = 0x13FF_F000 - 0x40000 = 0x13FB_F000
 * CONFIG_SYS_MALLOC_BASE = 0x13FB_F000 - 0x40000 = 0x13F7_F000
 *
 * 0x1000_0000	CONFIG_SYS_SDRAM_BASE
 *					FREE
 * 0x1200_0000	TEXT_BASE
 *		U-BOOT code
 * 0x1202_0000
 *					FREE
 *
 *					STACK
 * 0x13F7_F000	CONFIG_SYS_MALLOC_BASE
 *					MALLOC_AREA	256kB	Alloc
 * 0x11FB_F000	CONFIG_SYS_MONITOR_BASE
 *					MONITOR_CODE	256kB	Env
 * 0x13FF_F000	CONFIG_SYS_GBL_DATA_OFFSET
 *					GLOBAL_DATA	4kB	bd, gd
 * 0x1400_0000	CONFIG_SYS_SDRAM_BASE + CONFIG_SYS_SDRAM_SIZE
 */

/* ddr sdram - main memory */
#define	CONFIG_SYS_SDRAM_BASE		XILINX_RAM_START
#define	CONFIG_SYS_SDRAM_SIZE		XILINX_RAM_SIZE

#if defined(XILINX_FLASH_START) /* Parallel Flash */
	#define	FLASH
	#define	CONFIG_SYS_FLASH_BASE		XILINX_FLASH_START
	#define	CONFIG_SYS_FLASH_SIZE		XILINX_FLASH_SIZE
	#define	CONFIG_SYS_FLASH_CFI		1
	#define	CONFIG_FLASH_CFI_DRIVER	1
	#define	CONFIG_SYS_FLASH_EMPTY_INFO	1	/* ?empty sector */
	#define	CONFIG_SYS_MAX_FLASH_BANKS	1	/* max number of memory banks */
	#define	CONFIG_SYS_MAX_FLASH_SECT	2048	/* max number of sectors on one chip */

	/* Assume env is in flash, this may be undone lower down */
	#define	CONFIG_ENV_IS_IN_FLASH	1
	#define	CONFIG_ENV_SECT_SIZE	0x20000	/* 128K(one sector) for env */

	#define	CONFIG_SYS_FLASH_PROTECTION

	#define	CONFIG_ENV_ADDR		XILINX_FLASH_START
	#define	CONFIG_ENV_SIZE		CONFIG_ENV_SECT_SIZE
	/* use buffered writes (20x faster) */
	#define	CONFIG_SYS_FLASH_USE_BUFFER_WRITE	1
#else /* No flash memory at all */
	/* ENV in RAM */
	#define RAMENV
	#define	CONFIG_SYS_NO_FLASH		1

	#define	CONFIG_ENV_IS_NOWHERE	1
	#undef CONFIG_ENV_IS_IN_FLASH
	#undef CONFIG_ENV_IS_IN_SPI_FLASH
	#define	CONFIG_ENV_SIZE		0x1000
	#define	CONFIG_ENV_ADDR		(CONFIG_SYS_MONITOR_BASE - CONFIG_ENV_SIZE)
	#define	CONFIG_SYS_FLASH_PROTECTION		/* hardware flash protection */
#endif

#if defined(XILINX_USE_ICACHE)
	#define CONFIG_ICACHE
#else
	#undef CONFIG_ICACHE
#endif

#if defined(XILINX_USE_DCACHE)
	#define CONFIG_DCACHE
#else
	#undef CONFIG_DCACHE
#endif

#ifndef XILINX_DCACHE_BYTE_SIZE
#define XILINX_DCACHE_BYTE_SIZE	32768
#endif

/*
 * BOOTP options
 */
#define CONFIG_BOOTP_BOOTFILESIZE
#define CONFIG_BOOTP_BOOTPATH
#define CONFIG_BOOTP_GATEWAY
#define CONFIG_BOOTP_HOSTNAME

/*
 * Command line configuration.
 */
#include <config_cmd_default.h>

#define CONFIG_CMD_ASKENV
/* FIXME: hack for zynq */
#define CONFIG_CMD_IRQ
#define CONFIG_CMD_ECHO

#ifdef XILINX_GPIO_BASEADDR
# define CONFIG_CMD_GPIO
#endif

#undef CONFIG_CMD_NFS
#undef CONFIG_CMD_JFFS2
#ifndef CONFIG_SYS_ENET
	#undef CONFIG_CMD_NET
	#undef CONFIG_NET_MULTI
#else
	#define CONFIG_CMD_PING
	#define CONFIG_NET_MULTI
#endif

#if defined(FLASH)
	#define CONFIG_CMD_FLASH
	#define CONFIG_CMD_IMLS
#else
	#undef CONFIG_CMD_IMLS
	#undef CONFIG_CMD_FLASH
	#undef CONFIG_CMD_SAVEENV
	#undef CONFIG_CMD_SAVES
#endif

#if !defined(RAMENV)
	#define CONFIG_CMD_SAVEENV
	#define CONFIG_CMD_SAVES
#endif

/* Miscellaneous configurable options */
#define	CONFIG_SYS_PROMPT	"U-Boot> "
#define CONFIG_SYS_CBSIZE		256/* Console I/O Buffer Size      */
#define CONFIG_SYS_PBSIZE		(CONFIG_SYS_CBSIZE +\
					sizeof(CONFIG_SYS_PROMPT) + 16)
#define CONFIG_SYS_BARGSIZE		CONFIG_SYS_CBSIZE
					/* Boot Argument Buffer Size */
#define	CONFIG_SYS_MAXARGS	15	/* max number of command args */
#define	CONFIG_SYS_LONGHELP
#define	CONFIG_SYS_LOAD_ADDR	XILINX_RAM_START /* default load address */

#define	CONFIG_BOOTDELAY	4
/* Don't define BOOTARGS, we get it from the DTB chosen fragment */
#undef CONFIG_BOOTARGS
#define	CONFIG_HOSTNAME		XILINX_BOARD_NAME

#define	CONFIG_BOOTCOMMAND	""

/* architecture dependent code */
#define	CONFIG_SYS_USR_EXCEP	/* user exception */

#define	CONFIG_PREBOOT	"echo U-BOOT for ${hostname};setenv preboot;echo"

#define CONFIG_ENV_OVERWRITE	/* Allow to overwrite the u-boot environment variables */
#define	CONFIG_IPADDR		192.168.0.90
#define	CONFIG_SERVERIP		192.168.0.101
#define	CONFIG_ETHADDR		00:0a:35:00:92:d4
#define CONFIG_BOOTP_SERVERIP

#define CONFIG_CMDLINE_EDITING

/* Use the HUSH parser */
#define CONFIG_SYS_PROMPT_HUSH_PS2 "> "

#define CONFIG_FIT		1
#define CONFIG_OF_LIBFDT	1

#if defined(CONFIG_XILINX_LL_TEMAC) || defined(CONFIG_XILINX_AXIEMAC)
# define CONFIG_MII            1
# define CONFIG_CMD_MII                1
# define CONFIG_PHY_GIGE       1
# define CONFIG_SYS_FAULT_ECHO_LINK_DOWN       1
# define CONFIG_PHYLIB         1
# define CONFIG_PHY_ATHEROS    1
# define CONFIG_PHY_BROADCOM   1
# define CONFIG_PHY_DAVICOM    1
# define CONFIG_PHY_LXT                1
# define CONFIG_PHY_MARVELL    1
# define CONFIG_PHY_MICREL     1
# define CONFIG_PHY_NATSEMI    1
# define CONFIG_PHY_REALTEK    1
# define CONFIG_PHY_VITESSE    1
#else
# undef CONFIG_MII
# undef CONFIG_CMD_MII
# undef CONFIG_PHYLIB
#endif

/* SPL part */
#define CONFIG_SPL
#define CONFIG_CMD_SPL
#define CONFIG_SPL_FRAMEWORK
#define CONFIG_SPL_LIBCOMMON_SUPPORT
#define CONFIG_SPL_LIBGENERIC_SUPPORT
#define CONFIG_SPL_SERIAL_SUPPORT
#define CONFIG_SPL_BOARD_INIT

#define CONFIG_SPL_LDSCRIPT	"arch/microblaze/cpu/u-boot-spl.lds"

#define CONFIG_SPL_RAM_DEVICE
#define CONFIG_SPL_NOR_SUPPORT

/* for booting directly linux */
#define CONFIG_SPL_OS_BOOT

#define CONFIG_SYS_OS_BASE		(CONFIG_SYS_FLASH_BASE + \
					 0x60000)
#define CONFIG_SYS_FDT_BASE		(CONFIG_SYS_FLASH_BASE + \
					 0x40000)
#define CONFIG_SYS_SPL_ARGS_ADDR	(CONFIG_SYS_TEXT_BASE + \
					 0x1000000)

/* SP location before relocation, must use scratch RAM */
/* BRAM start */
#define CONFIG_SYS_INIT_RAM_ADDR	0x0
/* BRAM size - will be generated */
#define CONFIG_SYS_INIT_RAM_SIZE	0x10000
/* Stack pointer prior relocation, must situated at on-chip RAM */
#define CONFIG_SYS_SPL_MALLOC_END	(CONFIG_SYS_INIT_RAM_ADDR + \
					 CONFIG_SYS_INIT_RAM_SIZE - \
					 GENERATED_GBL_DATA_SIZE)

#define CONFIG_SYS_SPL_MALLOC_SIZE	0x100

/*
 * The main reason to do it in this way is that MALLOC_START
 * can't be defined - common/spl/spl.c
 */
#if (CONFIG_SYS_SPL_MALLOC_SIZE != 0)
# define CONFIG_SYS_SPL_MALLOC_START	(CONFIG_SYS_SPL_MALLOC_END - \
					 CONFIG_SYS_SPL_MALLOC_SIZE)
# define CONFIG_SPL_STACK_ADDR		CONFIG_SYS_SPL_MALLOC_START
#else
# define CONFIG_SPL_STACK_ADDR		CONFIG_SYS_SPL_MALLOC_END
#endif

/* Just for sure that there is a space for stack */
#define CONFIG_SPL_STACK_SIZE		0x100

#define CONFIG_SYS_UBOOT_BASE		CONFIG_SYS_FLASH_BASE
#define CONFIG_SYS_UBOOT_START		CONFIG_SYS_TEXT_BASE

#define CONFIG_SPL_MAX_FOOTPRINT	(CONFIG_SYS_INIT_RAM_SIZE - \
					 CONFIG_SYS_INIT_RAM_ADDR - \
					 GENERATED_GBL_DATA_SIZE - \
					 CONFIG_SYS_SPL_MALLOC_SIZE - \
					 CONFIG_SPL_STACK_SIZE)

#endif	/* __CONFIG_H */
