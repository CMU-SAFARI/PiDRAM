/*
 * Xilinx DRM DisplayPort encoder driver for Xilinx
 *
 *  Copyright (C) 2014 Xilinx, Inc.
 *
 *  Author: Hyun Woo Kwon <hyunk@xilinx.com>
 *
 * This software is licensed under the terms of the GNU General Public
 * License version 2, as published by the Free Software Foundation, and
 * may be copied, distributed, and modified under those terms.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

#include <drm/drmP.h>
#include <drm/drm_crtc.h>
#include <drm/drm_crtc_helper.h>
#include <drm/drm_dp_helper.h>
#include <drm/drm_encoder_slave.h>

#include <linux/clk.h>
#include <linux/delay.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/mutex.h>
#include <linux/platform_device.h>
#include <linux/pm.h>

#include "xilinx_drm_drv.h"

/* Link configuration registers */
#define XILINX_DP_TX_LINK_BW_SET			0x0
#define XILINX_DP_TX_LANE_CNT_SET			0x4
#define XILINX_DP_TX_ENHANCED_FRAME_EN			0x8
#define XILINX_DP_TX_TRAINING_PATTERN_SET		0xc
#define XILINX_DP_TX_SCRAMBLING_DISABLE			0x14
#define XILINX_DP_TX_SW_RESET				0x1c
#define XILINX_DP_TX_SW_RESET_STREAM1			(1 << 0)
#define XILINX_DP_TX_SW_RESET_STREAM2			(1 << 1)
#define XILINX_DP_TX_SW_RESET_STREAM3			(1 << 2)
#define XILINX_DP_TX_SW_RESET_STREAM4			(1 << 3)
#define XILINX_DP_TX_SW_RESET_AUX			(1 << 7)
#define XILINX_DP_TX_SW_RESET_ALL			(XILINX_DP_TX_SW_RESET_STREAM1 | \
							 XILINX_DP_TX_SW_RESET_STREAM2 | \
							 XILINX_DP_TX_SW_RESET_STREAM3 | \
							 XILINX_DP_TX_SW_RESET_STREAM4 | \
							 XILINX_DP_TX_SW_RESET_AUX)

/* Core enable registers */
#define XILINX_DP_TX_ENABLE				0x80
#define XILINX_DP_TX_ENABLE_MAIN_STREAM			0x84
#define XILINX_DP_TX_FORCE_SCRAMBLER_RESET		0xc0
#define XILINX_DP_TX_VERSION				0xf8
#define XILINX_DP_TX_VERSION_MAJOR_MASK			(0xff << 24)
#define XILINX_DP_TX_VERSION_MAJOR_SHIFT		24
#define XILINX_DP_TX_VERSION_MINOR_MASK			(0xff << 16)
#define XILINX_DP_TX_VERSION_MINOR_SHIFT		16
#define XILINX_DP_TX_VERSION_REVISION_MASK		(0xf << 12)
#define XILINX_DP_TX_VERSION_REVISION_SHIFT		12
#define XILINX_DP_TX_VERSION_PATCH_MASK			(0xf << 8)
#define XILINX_DP_TX_VERSION_PATCH_SHIFT		8
#define XILINX_DP_TX_VERSION_INTERNAL_MASK		(0xff << 0)
#define XILINX_DP_TX_VERSION_INTERNAL_SHIFT		0

/* Core ID registers */
#define XILINX_DP_TX_CORE_ID				0xfc
#define XILINX_DP_TX_CORE_ID_MAJOR_MASK			(0xff << 24)
#define XILINX_DP_TX_CORE_ID_MAJOR_SHIFT		24
#define XILINX_DP_TX_CORE_ID_MINOR_MASK			(0xff << 16)
#define XILINX_DP_TX_CORE_ID_MINOR_SHIFT		16
#define XILINX_DP_TX_CORE_ID_REVISION_MASK		(0xff << 8)
#define XILINX_DP_TX_CORE_ID_REVISION_SHIFT		8
#define XILINX_DP_TX_CORE_ID_DIRECTION			(1 << 0)

/* AUX channel interface registers */
#define XILINX_DP_TX_AUX_COMMAND			0x100
#define XILINX_DP_TX_AUX_COMMAND_CMD_SHIFT		8
#define XILINX_DP_TX_AUX_COMMAND_BYTES_SHIFT		0
#define XILINX_DP_TX_AUX_WRITE_FIFO			0x104
#define XILINX_DP_TX_AUX_ADDRESS			0x108
#define XILINX_DP_TX_CLK_DIVIDER			0x10c
#define XILINX_DP_TX_CLK_DIVIDER_MHZ			1000000
#define XILINX_DP_TX_INTR_SIGNAL_STATE			0x130
#define XILINX_DP_TX_INTR_SIGNAL_STATE_HPD		(1 << 0)
#define XILINX_DP_TX_INTR_SIGNAL_STATE_REQUEST		(1 << 1)
#define XILINX_DP_TX_INTR_SIGNAL_STATE_REPLY		(1 << 2)
#define XILINX_DP_TX_INTR_SIGNAL_STATE_REPLY_TIMEOUT	(1 << 3)
#define XILINX_DP_TX_AUX_REPLY_DATA			0x134
#define XILINX_DP_TX_AUX_REPLY_CODE			0x138
#define XILINX_DP_TX_AUX_REPLY_CODE_AUX_ACK		(0)
#define XILINX_DP_TX_AUX_REPLY_CODE_AUX_NACK		(1 << 0)
#define XILINX_DP_TX_AUX_REPLY_CODE_AUX_DEFER		(1 << 1)
#define XILINX_DP_TX_AUX_REPLY_CODE_I2C_ACK		(0)
#define XILINX_DP_TX_AUX_REPLY_CODE_I2C_NACK		(1 << 2)
#define XILINX_DP_TX_AUX_REPLY_CODE_I2C_DEFER		(1 << 3)
#define XILINX_DP_TX_AUX_REPLY_CNT			0x13c
#define XILINX_DP_TX_AUX_REPLY_CNT_MASK			0xff
#define XILINX_DP_TX_INTR_STATUS			0x140
#define XILINX_DP_TX_INTR_STATUS_HPD_IRQ		(1 << 0)
#define XILINX_DP_TX_INTR_STATUS_HPD_EVENT		(1 << 1)
#define XILINX_DP_TX_INTR_STATUS_REPLY_RECEIVED		(1 << 2)
#define XILINX_DP_TX_INTR_STATUS_REPLY_TIMEOUT		(1 << 3)
#define XILINX_DP_TX_INTR_STATUS_HPD_PULSE_DETECTED	(1 << 4)
#define XILINX_DP_TX_INTR_STATUS_EXT_PKT_TXD		(1 << 5)
#define XILINX_DP_TX_INTR_MASK				0x144
#define XILINX_DP_TX_INTR_MASK_HPD_IRQ			(1 << 0)
#define XILINX_DP_TX_INTR_MASK_HPD_EVENT		(1 << 1)
#define XILINX_DP_TX_INTR_MASK_REPLY_RECV		(1 << 2)
#define XILINX_DP_TX_INTR_MASK_REPLY_TIMEOUT		(1 << 3)
#define XILINX_DP_TX_INTR_MASK_HPD_PULSE		(1 << 4)
#define XILINX_DP_TX_INTR_MASK_EXT_PKT_TXD		(1 << 5)
#define XILINX_DP_TX_INTR_MASK_ALL			(XILINX_DP_TX_INTR_MASK_HPD_IRQ | \
							 XILINX_DP_TX_INTR_MASK_HPD_EVENT | \
							 XILINX_DP_TX_INTR_MASK_REPLY_RECV | \
							 XILINX_DP_TX_INTR_MASK_REPLY_TIMEOUT | \
							 XILINX_DP_TX_INTR_MASK_HPD_PULSE | \
							 XILINX_DP_TX_INTR_MASK_EXT_PKT_TXD)
#define XILINX_DP_TX_REPLY_DATA_CNT			0x148

/* Main stream attribute registers */
#define XILINX_DP_TX_MAIN_STREAM_HTOTAL			0x180
#define XILINX_DP_TX_MAIN_STREAM_VTOTAL			0x184
#define XILINX_DP_TX_MAIN_STREAM_POLARITY		0x188
#define XILINX_DP_TX_MAIN_STREAM_POLARITY_HSYNC_SHIFT	0
#define XILINX_DP_TX_MAIN_STREAM_POLARITY_VSYNC_SHIFT	1
#define XILINX_DP_TX_MAIN_STREAM_HSWIDTH		0x18c
#define XILINX_DP_TX_MAIN_STREAM_VSWIDTH		0x190
#define XILINX_DP_TX_MAIN_STREAM_HRES			0x194
#define XILINX_DP_TX_MAIN_STREAM_VRES			0x198
#define XILINX_DP_TX_MAIN_STREAM_HSTART			0x19c
#define XILINX_DP_TX_MAIN_STREAM_VSTART			0x1a0
#define XILINX_DP_TX_MAIN_STREAM_MISC0			0x1a4
#define XILINX_DP_TX_MAIN_STREAM_MISC0_SYNC		(1 << 0)
#define XILINX_DP_TX_MAIN_STREAM_MISC0_FORMAT_SHIFT	1
#define XILINX_DP_TX_MAIN_STREAM_MISC0_DYNAMIC_RANGE	(1 << 3)
#define XILINX_DP_TX_MAIN_STREAM_MISC0_YCBCR_COLRIMETRY	(1 << 4)
#define XILINX_DP_TX_MAIN_STREAM_MISC0_BPC_SHIFT	5
#define XILINX_DP_TX_MAIN_STREAM_MISC1			0x1a8
#define XILINX_DP_TX_MAIN_STREAM_MISC0_INTERLACED_VERT	(1 << 0)
#define XILINX_DP_TX_MAIN_STREAM_MISC0_STEREO_VID_SHIFT	1
#define XILINX_DP_TX_M_VID				0x1ac
#define XILINX_DP_TX_TRANSFER_UNIT_SIZE			0x1b0
#define XILINX_DP_TX_DEF_TRANSFER_UNIT_SIZE		64
#define XILINX_DP_TX_N_VID				0x1b4
#define XILINX_DP_TX_USER_PIXEL_WIDTH			0x1b8
#define XILINX_DP_TX_USER_DATA_CNT_PER_LANE		0x1bc
#define XILINX_DP_TX_MIN_BYTES_PER_TU			0x1c4
#define XILINX_DP_TX_FRAC_BYTES_PER_TU			0x1c8
#define XILINX_DP_TX_INIT_WAIT				0x1cc

/* PHY configuration and status registers */
#define XILINX_DP_TX_PHY_CONFIG				0x200
#define XILINX_DP_TX_PHY_CONFIG_PHY_RESET		(1 << 0)
#define XILINX_DP_TX_PHY_CONFIG_GTTX_RESET		(1 << 1)
#define XILINX_DP_TX_PHY_CONFIG_PHY_PMA_RESET		(1 << 8)
#define XILINX_DP_TX_PHY_CONFIG_PHY_PCS_RESET		(1 << 9)
#define XILINX_DP_TX_PHY_CONFIG_ALL_RESET		(XILINX_DP_TX_PHY_CONFIG_PHY_RESET | \
							 XILINX_DP_TX_PHY_CONFIG_GTTX_RESET | \
							 XILINX_DP_TX_PHY_CONFIG_PHY_PMA_RESET | \
							 XILINX_DP_TX_PHY_CONFIG_PHY_PCS_RESET)
#define XILINX_DP_TX_PHY_PREEMPHASIS_LANE_0		0x210
#define XILINX_DP_TX_PHY_PREEMPHASIS_LANE_1		0x214
#define XILINX_DP_TX_PHY_PREEMPHASIS_LANE_2		0x218
#define XILINX_DP_TX_PHY_PREEMPHASIS_LANE_3		0x21c
#define XILINX_DP_TX_PHY_VOLTAGE_DIFF_LANE_0		0x220
#define XILINX_DP_TX_PHY_VOLTAGE_DIFF_LANE_1		0x224
#define XILINX_DP_TX_PHY_VOLTAGE_DIFF_LANE_2		0x228
#define XILINX_DP_TX_PHY_VOLTAGE_DIFF_LANE_3		0x22c
#define XILINX_DP_TX_PHY_CLOCK_FEEDBACK_SETTING		0x234
#define XILINX_DP_TX_PHY_CLOCK_FEEDBACK_SETTING_162	0x1
#define XILINX_DP_TX_PHY_CLOCK_FEEDBACK_SETTING_270	0x3
#define XILINX_DP_TX_PHY_CLOCK_FEEDBACK_SETTING_540	0x5
#define XILINX_DP_TX_PHY_POWER_DOWN			0x238
#define XILINX_DP_TX_PHY_POWER_DOWN_LANE_0		(1 << 0)
#define XILINX_DP_TX_PHY_POWER_DOWN_LANE_1		(1 << 1)
#define XILINX_DP_TX_PHY_POWER_DOWN_LANE_2		(1 << 2)
#define XILINX_DP_TX_PHY_POWER_DOWN_LANE_3		(1 << 3)
#define XILINX_DP_TX_PHY_POWER_DOWN_ALL			0xf
#define XILINX_DP_TX_PHY_PRECURSOR_LANE_0		0x23c
#define XILINX_DP_TX_PHY_PRECURSOR_LANE_1		0x240
#define XILINX_DP_TX_PHY_PRECURSOR_LANE_2		0x244
#define XILINX_DP_TX_PHY_PRECURSOR_LANE_3		0x248
#define XILINX_DP_TX_PHY_POSTCURSOR_LANE_0		0x24c
#define XILINX_DP_TX_PHY_POSTCURSOR_LANE_1		0x250
#define XILINX_DP_TX_PHY_POSTCURSOR_LANE_2		0x254
#define XILINX_DP_TX_PHY_POSTCURSOR_LANE_3		0x258
#define XILINX_DP_TX_PHY_STATUS				0x280
#define XILINX_DP_TX_PHY_STATUS_READY_MASK		0x4f

#define XILINX_DP_MISC0_RGB				(0)
#define XILINX_DP_MISC0_YCRCB_422			(5 << 1)
#define XILINX_DP_MISC0_YCRCB_444			(6 << 1)
#define XILINX_DP_MISC0_BPC_6				(0 << 5)
#define XILINX_DP_MISC0_BPC_8				(1 << 5)
#define XILINX_DP_MISC0_BPC_10				(2 << 5)
#define XILINX_DP_MISC0_BPC_12				(3 << 5)
#define XILINX_DP_MISC0_BPC_16				(4 << 5)
#define XILINX_DP_MISC1_Y_ONLY				(1 << 7)

#define XILINX_DP_MAX_CLOCK				150000

#define DP_REDUCED_BIT_RATE				162000
#define DP_HIGH_BIT_RATE				270000
#define DP_HIGH_BIT_RATE2				540000
#define DP_MAX_TRAINING_TRIES				5

enum dp_version {
	DP_V1_1A = 0x11,
	DP_V1_2 = 0x12
};

/**
 * struct xilinx_drm_dp_link_config - Common link config between source and sink
 * @max_rate: maximum link rate
 * @max_lanes: maximum number of lanes
 */
struct xilinx_drm_dp_link_config {
	int max_rate;
	u8 max_lanes;
};

/**
 * struct xilinx_drm_dp_mode - Configured mode of DisplayPort
 * @bw_code: code for bandwidth(link rate)
 * @lane_cnt: number of lanes
 */
struct xilinx_drm_dp_mode {
	u8 bw_code;
	u8 lane_cnt;
};

/**
 * struct xilinx_drm_dp_config - Configuration of DisplayPort from DTS
 * @dp_version: DisplayPort protocol version
 * @max_lanes: max number of lanes
 * @max_link_rate: max link rate
 * @max_bpc: maximum bits-per-color
 * @enable_yonly: enable yonly color space logic
 * @enable_ycrcb: enable ycrcb color space logic
 * @misc0: misc0 configuration (per DP v1.2 spec)
 * @misc1: misc1 configuration (per DP v1.2 spec)
 * @bpp: bits per pixel
 */
struct xilinx_drm_dp_config {
	enum dp_version dp_version;
	u32 max_lanes;
	u32 max_link_rate;
	u32 max_bpc;
	bool enable_yonly;
	bool enable_ycrcb;

	u8 misc0;
	u8 misc1;
	u8 bpp;
};

/**
 * struct xilinx_drm_dp_i2c - i2c interface of DisplayPort Aux
 * @adapter: i2c adapter
 * @algo: i2c algorithm
 */
struct xilinx_drm_dp_i2c {
	struct i2c_adapter adapter;
	struct i2c_algo_dp_aux_data algo;
};

/**
 * struct xilinx_drm_dp - Xilinx DisplayPort core
 * @encoder: pointer to the drm encoder structure
 * @dev: device structure
 * @iomem: device I/O memory for register access
 * @config: IP core configuration from DTS
 * @i2c: i2c interface structure for aux
 * @aclk: clock source device for internal axi4-lite clock
 * @dpms: current dpms state
 * @dpcd: DP configuration data from currently connected sink device
 * @link_config: common link configuration between IP core and sink device
 * @mode: current mode between IP core and sink device
 * @train_set: set of training data
 * @aux_lock: mutex to protect atomicity of xilinx_drm_dp_aux_cmd_submit()
 */
struct xilinx_drm_dp {
	struct drm_encoder *encoder;
	struct device *dev;
	void __iomem *iomem;

	struct xilinx_drm_dp_config config;
	struct xilinx_drm_dp_i2c i2c;
	struct clk *aclk;

	int dpms;
	u8 dpcd[DP_RECEIVER_CAP_SIZE];
	struct xilinx_drm_dp_link_config link_config;
	struct xilinx_drm_dp_mode mode;
	u8 train_set[4];

	struct mutex aux_lock;
};

static inline struct xilinx_drm_dp *to_dp(struct drm_encoder *encoder)
{
	return to_encoder_slave(encoder)->slave_priv;
}

#define AUX_READ_BIT	0x1

/**
 * xilinx_drm_dp_aux_cmd_submit - Submit aux command
 * @dp: DisplayPort IP core structure
 * @cmd: aux command
 * @addr: aux address
 * @buf: buffer for command data
 * @bytes: number of bytes for @buf
 *
 * Submit an aux command. All aux related commands, native or i2c aux
 * read/write, are submitted through this function. This function involves in
 * multiple register reads/writes, thus the synchronization needs to be done
 * by holding @aux_lock if multi-thread access is possible. The calling thread
 * goes into sleep if there's no immediate reply to the command submission.
 *
 * Return: 0 if the command is submitted properly, or corresponding error code:
 * -EBUSY when there is any request already being processed
 * -ETIMEDOUT when receiving reply is timed out
 * -EAGAIN when the command is deferred
 * -EIO when the command is NACKed, or received data is less than requested
 */
static int xilinx_drm_dp_aux_cmd_submit(struct xilinx_drm_dp *dp, u32 cmd,
					u16 addr, u8 *buf, u8 bytes)
{
	bool is_read = (cmd & AUX_READ_BIT) ? true : false;
	void __iomem *iomem = dp->iomem;
	u32 reg, i;

	reg = xilinx_drm_readl(iomem, XILINX_DP_TX_INTR_SIGNAL_STATE);
	if (reg & XILINX_DP_TX_INTR_SIGNAL_STATE_REQUEST)
		return -EBUSY;

	xilinx_drm_writel(iomem, XILINX_DP_TX_AUX_ADDRESS, addr);

	if (!buf)
		return 0;

	if (!is_read)
		for (i = 0; i < bytes; i++)
			xilinx_drm_writel(iomem, XILINX_DP_TX_AUX_WRITE_FIFO,
					  buf[i]);

	xilinx_drm_writel(iomem, XILINX_DP_TX_AUX_COMMAND,
			  (cmd << XILINX_DP_TX_AUX_COMMAND_CMD_SHIFT) |
			  (bytes - 1) << XILINX_DP_TX_AUX_COMMAND_BYTES_SHIFT);

	/* Wait for reply to be delivered upto 2ms */
	for (i = 0; ; i++) {
		reg = xilinx_drm_readl(iomem, XILINX_DP_TX_INTR_SIGNAL_STATE);

		if (reg & XILINX_DP_TX_INTR_SIGNAL_STATE_REPLY)
			break;

		if (reg & XILINX_DP_TX_INTR_SIGNAL_STATE_REPLY_TIMEOUT ||
		    i == 2)
			return -ETIMEDOUT;

		usleep_range(1000, 1100);
	}

	reg = xilinx_drm_readl(iomem, XILINX_DP_TX_AUX_REPLY_CODE);
	if (reg == XILINX_DP_TX_AUX_REPLY_CODE_AUX_NACK ||
	    reg == XILINX_DP_TX_AUX_REPLY_CODE_I2C_NACK)
		return -EIO;

	if (reg == XILINX_DP_TX_AUX_REPLY_CODE_AUX_DEFER ||
	    reg == XILINX_DP_TX_AUX_REPLY_CODE_I2C_DEFER)
		return -EAGAIN;

	if (is_read) {
		reg = xilinx_drm_readl(iomem, XILINX_DP_TX_REPLY_DATA_CNT);
		if ((reg & XILINX_DP_TX_AUX_REPLY_CNT_MASK) != bytes)
			return -EIO;

		for (i = 0; i < bytes; i++)
			buf[i] = xilinx_drm_readl(iomem,
						  XILINX_DP_TX_AUX_REPLY_DATA);
	}

	return 0;
}

/**
 * xilinx_drm_dp_aux_cmd - Submit aux command and retry if needed
 * @dp: DisplayPort IP core structure
 * @cmd: aux command
 * @addr: aux address
 * @buf: buffer for command data
 * @bytes: number of bytes for @buf
 *
 * Return: the value returned from xilinx_drm_dp_aux_cmd_submit()
 */
static int xilinx_drm_dp_aux_cmd(struct xilinx_drm_dp *dp, u32 cmd, u16 addr,
				 u8 *buf, u8 bytes)
{
	int tries, ret;

	/* Retry at least 3 times per DP spec */
	for (tries = 0; tries < 5; tries++) {
		mutex_lock(&dp->aux_lock);
		ret = xilinx_drm_dp_aux_cmd_submit(dp, cmd, addr, buf, bytes);
		mutex_unlock(&dp->aux_lock);
		if (!ret || ret == -EIO)
			break;

		/* Wait for 400us per DP spec */
		udelay(400);
	}

	return ret;
}

/**
 * xilinx_drm_dp_aux_cmd_byte - Submit aux command byte
 * @dp: DisplayPort IP core structure
 * @cmd: aux command
 * @addr: aux address
 * @byte: a byte for aux command
 *
 * Return: the value returned from xilinx_drm_dp_aux_cmd()
 */
static inline int xilinx_drm_dp_aux_cmd_byte(struct xilinx_drm_dp *dp, u32 cmd,
					     u16 addr, u8 *byte)
{
	return xilinx_drm_dp_aux_cmd(dp, cmd, addr, byte, 1);
}

/**
 * xilinx_drm_dp_aux_cmd_write - Submit write aux command
 * @dp: DisplayPort IP core structure
 * @addr: aux address
 * @buf: buffer for write command data
 * @bytes: number of bytes for @buf
 *
 * Return: the value returned from xilinx_drm_dp_aux_cmd()
 */
static inline int xilinx_drm_dp_aux_write(struct xilinx_drm_dp *dp, u16 addr,
					  u8 *buf, u8 bytes)
{
	return xilinx_drm_dp_aux_cmd(dp, DP_AUX_NATIVE_WRITE, addr, buf, bytes);
}

/**
 * xilinx_drm_dp_aux_cmd_write_byte - Submit write aux command for a byte
 * @dp: DisplayPort IP core structure
 * @addr: aux address
 * @byte: a byte for aux command
 *
 * Return: the value returned from xilinx_drm_dp_aux_cmd()
 */
static inline int xilinx_drm_dp_aux_write_byte(struct xilinx_drm_dp *dp,
					       u16 addr, u8 byte)
{
	return xilinx_drm_dp_aux_cmd_byte(dp, DP_AUX_NATIVE_WRITE, addr, &byte);
}

/**
 * xilinx_drm_dp_aux_cmd_read - Submit read aux command
 * @dp: DisplayPort IP core structure
 * @addr: aux address
 * @buf: buffer for read command data
 * @bytes: number of bytes for @buf
 *
 * Return: the value returned from xilinx_drm_dp_aux_cmd()
 */
static inline int xilinx_drm_dp_aux_read(struct xilinx_drm_dp *dp, u16 addr,
					 u8 *buf, u8 bytes)
{
	return xilinx_drm_dp_aux_cmd(dp, DP_AUX_NATIVE_READ, addr, buf, bytes);
}

/**
 * xilinx_drm_dp_phy_ready - Check if PHY is ready
 * @dp: DisplayPort IP core structure
 *
 * Check if PHY is ready. If PHY is not ready, wait 1ms to check for 100 times.
 * This amount of delay was suggested by IP designer.
 *
 * Return: 0 if PHY is ready, or -ENODEV if PHY is not ready.
 */
static int xilinx_drm_dp_phy_ready(struct xilinx_drm_dp *dp)
{
	u32 i, reg;

	/* Wait for 100 * 1ms. This should be enough time for PHY to be ready */
	for (i = 0; ; i++) {
		reg = xilinx_drm_readl(dp->iomem, XILINX_DP_TX_PHY_STATUS);
		if ((reg & XILINX_DP_TX_PHY_STATUS_READY_MASK) ==
		    XILINX_DP_TX_PHY_STATUS_READY_MASK)
			return 0;

		if (i == 100) {
			DRM_ERROR("PHY isn't ready\n");
			return -ENODEV;
		}

		usleep_range(1000, 1100);
	}
}

/**
 * xilinx_drm_dp_adjust_train - Adjust train values
 * @dp: DisplayPort IP core structure
 * @link_status: link status from sink which contains requested training values
 */
static void xilinx_drm_dp_adjust_train(struct xilinx_drm_dp *dp,
				       u8 link_status[DP_LINK_STATUS_SIZE])
{
	u8 *train_set = dp->train_set;
	u8 voltage = 0, preemphasis = 0;
	u8 i;

	for (i = 0; i < dp->mode.lane_cnt; i++) {
		u8 v = drm_dp_get_adjust_request_voltage(link_status, i);
		u8 p = drm_dp_get_adjust_request_pre_emphasis(link_status, i);

		if (v > voltage)
			voltage = v;

		if (p > preemphasis)
			preemphasis = p;
	}

	if (voltage >= DP_TRAIN_VOLTAGE_SWING_1200)
		voltage |= DP_TRAIN_MAX_SWING_REACHED;

	if (preemphasis >= DP_TRAIN_PRE_EMPHASIS_9_5)
		preemphasis |= DP_TRAIN_MAX_PRE_EMPHASIS_REACHED;

	for (i = 0; i < dp->mode.lane_cnt; i++)
		train_set[i] = voltage | preemphasis;
}

/**
 * xilinx_drm_dp_update_vs_emph - Update the training values
 * @dp: DisplayPort IP core structure
 *
 * Update the training values based on the request from sink. The mapped values
 * are predefined, and values(vs, pe, pc) are from the reference codes.
 *
 * Return: 0 if vs and emph are updated successfully, or the error code returned
 * by xilinx_drm_dp_aux_write().
 */
static int xilinx_drm_dp_update_vs_emph(struct xilinx_drm_dp *dp)
{
	u8 *train_set = dp->train_set;
	u8 i, level;
	int ret;
	u8 vs[4] = { 0x3, 0x7, 0xb, 0xf };
	u8 pe[4] = { 0x0, 0x3, 0x5, 0x6 };
	u8 pc[4] = { 0x0, 0xe, 0x14, 0x1b };

	ret = xilinx_drm_dp_aux_write(dp, DP_TRAINING_LANE0_SET, train_set,
				      dp->mode.lane_cnt);
	if (ret)
		return ret;

	for (i = 0; i < dp->mode.lane_cnt; i++) {
		level = (train_set[i] & DP_TRAIN_VOLTAGE_SWING_MASK) >>
			DP_TRAIN_VOLTAGE_SWING_SHIFT;
		xilinx_drm_writel(dp->iomem,
				  XILINX_DP_TX_PHY_VOLTAGE_DIFF_LANE_0 + i * 4,
				  vs[level]);

		level = (train_set[i] & DP_TRAIN_PRE_EMPHASIS_MASK) >>
			DP_TRAIN_PRE_EMPHASIS_SHIFT;
		xilinx_drm_writel(dp->iomem,
				  XILINX_DP_TX_PHY_PREEMPHASIS_LANE_0 + i * 4,
				  pe[level]);
	}

	for (i = 0; i < dp->mode.lane_cnt; i++) {
		level = (train_set[i] & DP_TRAIN_PRE_EMPHASIS_MASK) >>
			DP_TRAIN_PRE_EMPHASIS_SHIFT;
		xilinx_drm_writel(dp->iomem,
				  XILINX_DP_TX_PHY_POSTCURSOR_LANE_0 + i * 4,
				  pc[level]);

		xilinx_drm_writel(dp->iomem,
				  XILINX_DP_TX_PHY_PRECURSOR_LANE_0 + i * 4, 0);
	}

	return 0;
}

/**
 * xilinx_drm_dp_link_train_cr - Train clock recovery
 * @dp: DisplayPort IP core structure
 *
 * Return: 0 if clock recovery train is done successfully, or corresponding
 * error code.
 */
static int xilinx_drm_dp_link_train_cr(struct xilinx_drm_dp *dp)
{
	u8 link_status[DP_LINK_STATUS_SIZE];
	u8 lane_cnt = dp->mode.lane_cnt;
	u8 vs = 0, tries = 0;
	u16 max_tries, i;
	bool cr_done;
	int ret;

	ret = xilinx_drm_dp_aux_write_byte(dp, DP_TRAINING_PATTERN_SET,
					   DP_TRAINING_PATTERN_1 |
					   DP_LINK_SCRAMBLING_DISABLE);
	if (ret)
		return ret;

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_TRAINING_PATTERN_SET,
			  DP_TRAINING_PATTERN_1);

	/* 256 loops should be maximum iterations for 4 lanes and 4 values.
	 * So, This loop should exit before 512 iterations */
	for (max_tries = 0; max_tries < 512; max_tries++) {
		ret = xilinx_drm_dp_update_vs_emph(dp);
		if (ret)
			return ret;

		drm_dp_link_train_clock_recovery_delay(dp->dpcd);

		ret = xilinx_drm_dp_aux_read(dp, DP_LANE0_1_STATUS, link_status,
					     DP_LINK_STATUS_SIZE);
		if (ret)
			return ret;

		cr_done = drm_dp_clock_recovery_ok(link_status, lane_cnt);
		if (cr_done)
			break;

		for (i = 0; i < lane_cnt; i++)
			if (!(dp->train_set[i] & DP_TRAIN_MAX_SWING_REACHED))
				break;

		if (i == lane_cnt)
			break;

		if ((dp->train_set[0] & DP_TRAIN_VOLTAGE_SWING_MASK) == vs)
			tries++;
		else
			tries = 0;

		if (tries == DP_MAX_TRAINING_TRIES)
			break;

		vs = dp->train_set[0] & DP_TRAIN_VOLTAGE_SWING_MASK;

		xilinx_drm_dp_adjust_train(dp, link_status);
	}

	if (!cr_done)
		ret = -EIO;

	return ret;
}

/**
 * xilinx_drm_dp_link_train_ce - Train channel equalization
 * @dp: DisplayPort IP core structure
 *
 * Return: 0 if channel equalization train is done successfully, or
 * corresponding error code.
 */
static int xilinx_drm_dp_link_train_ce(struct xilinx_drm_dp *dp)
{
	u8 link_status[DP_LINK_STATUS_SIZE];
	u8 lane_cnt = dp->mode.lane_cnt;
	u32 pat, tries;
	int ret;
	bool ce_done;

	if (dp->config.dp_version == DP_V1_2 &&
	    dp->dpcd[DP_DPCD_REV] >= DP_V1_2 &&
	    dp->dpcd[DP_MAX_LANE_COUNT] & DP_TPS3_SUPPORTED)
		pat = DP_TRAINING_PATTERN_3;
	else
		pat = DP_TRAINING_PATTERN_2;

	ret = xilinx_drm_dp_aux_write_byte(dp, DP_TRAINING_PATTERN_SET,
					   pat | DP_LINK_SCRAMBLING_DISABLE);
	if (ret)
		return ret;

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_TRAINING_PATTERN_SET, pat);

	for (tries = 0; tries < DP_MAX_TRAINING_TRIES; tries++) {
		ret = xilinx_drm_dp_update_vs_emph(dp);
		if (ret)
			return ret;

		drm_dp_link_train_channel_eq_delay(dp->dpcd);

		ret = xilinx_drm_dp_aux_read(dp, DP_LANE0_1_STATUS, link_status,
					     DP_LINK_STATUS_SIZE);
		if (ret)
			return ret;

		ce_done = drm_dp_channel_eq_ok(link_status, lane_cnt);
		if (ce_done)
			break;

		xilinx_drm_dp_adjust_train(dp, link_status);
	}

	if (!ce_done)
		ret = -EIO;

	return ret;
}

/**
 * xilinx_drm_dp_link_train - Train the link
 * @dp: DisplayPort IP core structure
 *
 * Return: 0 if all trains are done successfully, or corresponding error code.
 */
static int xilinx_drm_dp_train(struct xilinx_drm_dp *dp)
{
	u32 reg;
	u8 bw_code = dp->mode.bw_code;
	u8 lane_cnt = dp->mode.lane_cnt;
	u8 aux_lane_cnt;
	bool enhanced;
	int ret;

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_LANE_CNT_SET, lane_cnt);

	enhanced = drm_dp_enhanced_frame_cap(dp->dpcd);
	if (enhanced) {
		xilinx_drm_writel(dp->iomem, XILINX_DP_TX_ENHANCED_FRAME_EN, 1);
		aux_lane_cnt = lane_cnt | DP_LANE_COUNT_ENHANCED_FRAME_EN;
	}

	ret = xilinx_drm_dp_aux_write_byte(dp, DP_LANE_COUNT_SET, aux_lane_cnt);
	if (ret) {
		DRM_ERROR("failed to set lane count\n");
		return ret;
	}

	ret = xilinx_drm_dp_aux_write_byte(dp, DP_LINK_BW_SET, bw_code);
	if (ret) {
		DRM_ERROR("failed to set DP bandwidth\n");
		return ret;
	}

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_LINK_BW_SET, bw_code);

	switch (bw_code) {
	case DP_LINK_BW_1_62:
		reg = XILINX_DP_TX_PHY_CLOCK_FEEDBACK_SETTING_162;
		break;
	case DP_LINK_BW_2_7:
		reg = XILINX_DP_TX_PHY_CLOCK_FEEDBACK_SETTING_270;
		break;
	case DP_LINK_BW_5_4:
		reg = XILINX_DP_TX_PHY_CLOCK_FEEDBACK_SETTING_540;
		break;
	}

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_PHY_CLOCK_FEEDBACK_SETTING,
			  reg);
	ret = xilinx_drm_dp_phy_ready(dp);
	if (ret < 0)
		return ret;

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_SCRAMBLING_DISABLE, 1);

	memset(dp->train_set, 0, 4);

	ret = xilinx_drm_dp_link_train_cr(dp);
	if (ret) {
		DRM_ERROR("failed to train clock recovery\n");
		reg = xilinx_drm_readl(dp->iomem, XILINX_DP_TX_PHY_STATUS);
		return ret;
	}

	ret = xilinx_drm_dp_link_train_ce(dp);
	if (ret) {
		DRM_ERROR("failed to train channel eq\n");
		reg = xilinx_drm_readl(dp->iomem, XILINX_DP_TX_PHY_STATUS);
		return ret;
	}

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_TRAINING_PATTERN_SET,
			  DP_TRAINING_PATTERN_DISABLE);
	ret = xilinx_drm_dp_aux_write_byte(dp, DP_TRAINING_PATTERN_SET,
					   DP_TRAINING_PATTERN_DISABLE);
	if (ret) {
		DRM_ERROR("failed to disable training pattern\n");
		return ret;
	}

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_SCRAMBLING_DISABLE, 0);

	return 0;
}

static void xilinx_drm_dp_dpms(struct drm_encoder *encoder, int dpms)
{
	struct xilinx_drm_dp *dp = to_dp(encoder);
	void __iomem *iomem = dp->iomem;

	if (dp->dpms == dpms)
		return;

	dp->dpms = dpms;

	switch (dpms) {
	case DRM_MODE_DPMS_ON:
		xilinx_drm_writel(iomem, XILINX_DP_TX_PHY_POWER_DOWN, 0);
		xilinx_drm_dp_aux_write_byte(dp, DP_SET_POWER, DP_SET_POWER_D0);
		xilinx_drm_dp_train(dp);
		xilinx_drm_writel(iomem, XILINX_DP_TX_ENABLE_MAIN_STREAM, 1);
		return;
	default:
		xilinx_drm_writel(iomem, XILINX_DP_TX_ENABLE_MAIN_STREAM, 0);
		xilinx_drm_dp_aux_write_byte(dp, DP_SET_POWER, DP_SET_POWER_D3);
		xilinx_drm_writel(iomem, XILINX_DP_TX_PHY_POWER_DOWN,
				  XILINX_DP_TX_PHY_POWER_DOWN_ALL);
		return;
	}
}

static void xilinx_drm_dp_save(struct drm_encoder *encoder)
{
	/* no op */
}

static void xilinx_drm_dp_restore(struct drm_encoder *encoder)
{
	/* no op */
}

static bool xilinx_drm_dp_mode_fixup(struct drm_encoder *encoder,
				     const struct drm_display_mode *mode,
				     struct drm_display_mode *adjusted_mode)
{
	return true;
}

/**
 * xilinx_drm_dp_max_rate - Calculate and return available max pixel clock
 * @link_rate: link rate (Kilo-bytes / sec)
 * @lane_num: number of lanes
 * @bpp: bits per pixel
 *
 * Return: max pixel clock (KHz) supported by current link config.
 */
static inline int xilinx_drm_dp_max_rate(int link_rate, u8 lane_num, u8 bpp)
{
	return link_rate * lane_num * 8 / bpp;
}

static int xilinx_drm_dp_mode_valid(struct drm_encoder *encoder,
				    struct drm_display_mode *mode)
{
	struct xilinx_drm_dp *dp = to_dp(encoder);
	u8 max_lanes = dp->link_config.max_lanes;
	u8 bpp = dp->config.bpp;
	int max_rate = dp->link_config.max_rate;
	int rate;

	if (mode->clock > XILINX_DP_MAX_CLOCK)
		return MODE_CLOCK_HIGH;

	rate = xilinx_drm_dp_max_rate(max_rate, max_lanes, bpp);
	if (mode->clock > rate)
		return MODE_CLOCK_HIGH;

	return MODE_OK;
}

/**
 * xilinx_drm_dp_mode_set_transfer_unit - Set the transfer unit values
 * @dp: DisplayPort IP core structure
 * @mode: requested display mode
 *
 * Set the transfer unit, and caculate all transfer unit size related values.
 * Calculation is based on DP and IP core specification.
 */
static void xilinx_drm_dp_mode_set_transfer_unit(struct xilinx_drm_dp *dp,
						 struct drm_display_mode *mode)
{
	u32 tu = XILINX_DP_TX_DEF_TRANSFER_UNIT_SIZE;
	u32 bw, vid_kbytes, avg_bytes_per_tu, init_wait;

	/* Use the max transfer unit size (default) */
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_TRANSFER_UNIT_SIZE, tu);

	vid_kbytes = mode->clock * (dp->config.bpp / 8);
	bw = drm_dp_bw_code_to_link_rate(dp->mode.bw_code);
	avg_bytes_per_tu = vid_kbytes * tu / (dp->mode.lane_cnt * bw / 1000);

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MIN_BYTES_PER_TU,
			  avg_bytes_per_tu / 1000);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_FRAC_BYTES_PER_TU,
			  avg_bytes_per_tu % 1000);

	/* Configure the initial wait cycle based on transfer unit size */
	if (tu < (avg_bytes_per_tu / 1000))
		init_wait = 0;
	else if ((avg_bytes_per_tu / 1000) <= 4)
		init_wait = tu;
	else
		init_wait = tu - avg_bytes_per_tu / 1000;

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_INIT_WAIT, init_wait);
}

/**
 * xilinx_drm_dp_mode_set_stream - Configure the main stream
 * @dp: DisplayPort IP core structure
 * @mode: requested display mode
 *
 * Configure the main stream based on the requested mode @mode. Calculation is
 * based on IP core specification.
 */
static void xilinx_drm_dp_mode_set_stream(struct xilinx_drm_dp *dp,
					  struct drm_display_mode *mode)
{
	u8 lane_cnt = dp->mode.lane_cnt;
	u32 reg, wpl;

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MAIN_STREAM_HTOTAL,
			  mode->htotal);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MAIN_STREAM_VTOTAL,
			  mode->vtotal);

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MAIN_STREAM_POLARITY,
			  (!!(mode->flags & DRM_MODE_FLAG_PVSYNC) <<
			   XILINX_DP_TX_MAIN_STREAM_POLARITY_VSYNC_SHIFT) |
			  (!!(mode->flags & DRM_MODE_FLAG_PHSYNC) <<
			   XILINX_DP_TX_MAIN_STREAM_POLARITY_HSYNC_SHIFT));

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MAIN_STREAM_HSWIDTH,
			  mode->hsync_end - mode->hsync_start);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MAIN_STREAM_VSWIDTH,
			  mode->vsync_end - mode->vsync_start);

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MAIN_STREAM_HRES,
			  mode->hdisplay);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MAIN_STREAM_VRES,
			  mode->vdisplay);

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MAIN_STREAM_HSTART,
			  mode->htotal - mode->hsync_start);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MAIN_STREAM_VSTART,
			  mode->vtotal - mode->vsync_start);

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MAIN_STREAM_MISC0,
			  dp->config.misc0);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_MAIN_STREAM_MISC1,
			  dp->config.misc1);

	/* In synchronous mode, set the diviers */
	if (dp->config.misc0 & XILINX_DP_TX_MAIN_STREAM_MISC0_SYNC) {
		reg = drm_dp_bw_code_to_link_rate(dp->mode.bw_code);
		xilinx_drm_writel(dp->iomem, XILINX_DP_TX_N_VID, reg);
		xilinx_drm_writel(dp->iomem, XILINX_DP_TX_M_VID, mode->clock);
	}

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_USER_PIXEL_WIDTH, 1);

	/* Translate to the native 16 bit datapath based on IP core spec */
	wpl = (mode->hdisplay * dp->config.bpp + 15) / 16;
	reg = wpl + wpl % lane_cnt - lane_cnt;
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_USER_DATA_CNT_PER_LANE, reg);
}

/**
 * xilinx_drm_dp_mode_configure - Configure the link values
 * @dp: DisplayPort IP core structure
 * @pclock: pixel clock for requested display mode
 *
 * Find the link configuration values, rate and lane count for requested pixel
 * clock @pclock.
 */
static void xilinx_drm_dp_mode_configure(struct xilinx_drm_dp *dp, int pclock)
{
	int max_rate = dp->link_config.max_rate;
	u8 bws[3] = { DP_LINK_BW_1_62, DP_LINK_BW_2_7, DP_LINK_BW_5_4 };
	u8 max_lanes = dp->link_config.max_lanes;
	u8 max_link_rate_code = drm_dp_link_rate_to_bw_code(max_rate);
	u8 bpp = dp->config.bpp;
	u8 lane_cnt, i;
	s8 clock;

	for (i = 0; i < ARRAY_SIZE(bws); i++)
		if (bws[i] == max_link_rate_code)
			break;

	for (lane_cnt = 1; lane_cnt <= max_lanes; lane_cnt <<= 1)
		for (clock = i; clock >= 0; clock--) {
			int bw;
			u32 rate;

			bw = drm_dp_bw_code_to_link_rate(bws[clock]);
			rate = xilinx_drm_dp_max_rate(bw, lane_cnt, bpp);
			if (pclock <= rate) {
				dp->mode.bw_code = bws[clock];
				dp->mode.lane_cnt = lane_cnt;
				return;
			}
		}
}

static void xilinx_drm_dp_mode_set(struct drm_encoder *encoder,
				   struct drm_display_mode *mode,
				   struct drm_display_mode *adjusted_mode)
{
	struct xilinx_drm_dp *dp = to_dp(encoder);

	xilinx_drm_dp_mode_configure(dp, adjusted_mode->clock);
	xilinx_drm_dp_mode_set_stream(dp, adjusted_mode);
	xilinx_drm_dp_mode_set_transfer_unit(dp, adjusted_mode);
}

static enum drm_connector_status
xilinx_drm_dp_detect(struct drm_encoder *encoder,
		     struct drm_connector *connector)
{
	struct xilinx_drm_dp *dp = to_dp(encoder);
	struct xilinx_drm_dp_link_config *link_config = &dp->link_config;
	u32 state;
	int ret;

	state = xilinx_drm_readl(dp->iomem, XILINX_DP_TX_INTR_SIGNAL_STATE);
	if (state & XILINX_DP_TX_INTR_SIGNAL_STATE_HPD) {
		ret = xilinx_drm_dp_aux_read(dp, 0x0, dp->dpcd,
					     sizeof(dp->dpcd));
		if (ret)
			return connector_status_disconnected;

		link_config->max_rate = min_t(int,
					      drm_dp_max_link_rate(dp->dpcd),
					      dp->config.max_link_rate);
		link_config->max_lanes = min_t(u8,
					       drm_dp_max_lane_count(dp->dpcd),
					       dp->config.max_lanes);

		return connector_status_connected;
	}

	return connector_status_disconnected;
}

static int xilinx_drm_dp_get_modes(struct drm_encoder *encoder,
				   struct drm_connector *connector)
{
	struct xilinx_drm_dp *dp = to_dp(encoder);
	struct edid *edid;
	int ret;

	edid = drm_get_edid(connector, &dp->i2c.adapter);
	if (!edid)
		return 0;

	drm_mode_connector_update_edid_property(connector, edid);
	ret = drm_add_edid_modes(connector, edid);

	kfree(edid);

	return ret;
}

static struct drm_encoder_slave_funcs xilinx_drm_dp_encoder_funcs = {
	.dpms			= xilinx_drm_dp_dpms,
	.save			= xilinx_drm_dp_save,
	.restore		= xilinx_drm_dp_restore,
	.mode_fixup		= xilinx_drm_dp_mode_fixup,
	.mode_valid		= xilinx_drm_dp_mode_valid,
	.mode_set		= xilinx_drm_dp_mode_set,
	.detect			= xilinx_drm_dp_detect,
	.get_modes		= xilinx_drm_dp_get_modes,
};

static int xilinx_drm_dp_encoder_init(struct platform_device *pdev,
				      struct drm_device *dev,
				      struct drm_encoder_slave *encoder)
{
	struct xilinx_drm_dp *dp = platform_get_drvdata(pdev);
	int clock_rate, ret;

	encoder->slave_priv = dp;
	encoder->slave_funcs = &xilinx_drm_dp_encoder_funcs;

	dp->encoder = &encoder->base;

	/* Get aclk rate */
	clock_rate = clk_get_rate(dp->aclk);
	if (clock_rate < XILINX_DP_TX_CLK_DIVIDER_MHZ) {
		DRM_ERROR("aclk should be higher than 1MHz\n");
		return -EINVAL;
	}

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_CLK_DIVIDER,
			  clock_rate / XILINX_DP_TX_CLK_DIVIDER_MHZ);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_PHY_CONFIG, 0);
	ret = xilinx_drm_dp_phy_ready(dp);
	if (ret < 0)
		return ret;

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_INTR_MASK,
			  ~XILINX_DP_TX_INTR_MASK_ALL);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_ENABLE, 1);

	return 0;
}

static int __maybe_unused xilinx_drm_dp_pm_suspend(struct device *dev)
{
	struct xilinx_drm_dp *dp = dev_get_drvdata(dev);

	xilinx_drm_dp_dpms(dp->encoder, DRM_MODE_DPMS_OFF);

	return 0;
}

static int __maybe_unused xilinx_drm_dp_pm_resume(struct device *dev)
{
	struct xilinx_drm_dp *dp = dev_get_drvdata(dev);

	xilinx_drm_dp_dpms(dp->encoder, DRM_MODE_DPMS_ON);

	return 0;
}

static SIMPLE_DEV_PM_OPS(xilinx_drm_dp_pm_ops, xilinx_drm_dp_pm_suspend,
			 xilinx_drm_dp_pm_resume);

static irqreturn_t xilinx_drm_dp_irq_handler(int irq, void *data)
{
	struct xilinx_drm_dp *dp = (struct xilinx_drm_dp *)data;
	u32 status;

	status = xilinx_drm_readl(dp->iomem, XILINX_DP_TX_INTR_STATUS);
	if (!status)
		return IRQ_NONE;

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_INTR_STATUS, status);

	if (status & XILINX_DP_TX_INTR_STATUS_HPD_EVENT)
		drm_helper_hpd_irq_event(dp->encoder->dev);

	return IRQ_HANDLED;
}

/**
 * xilinx_drm_dp_i2c_aux_ch - i2c algorithm for aux channel
 * @adapter: i2c adapter
 * @mode: mode of command
 * @write_byte: a byte to write
 * @read_byte: a byte to read
 *
 * Return: 0 if successful, or corresponding error code from
 * xilinx_drm_dp_aux_cmd_byte().
 */
static int xilinx_drm_dp_i2c_aux_ch(struct i2c_adapter *adapter, int mode,
				    uint8_t write_byte, uint8_t *read_byte)
{
	struct i2c_algo_dp_aux_data *algo_data = adapter->algo_data;
	struct xilinx_drm_dp_i2c *i2c = container_of(adapter,
						     struct xilinx_drm_dp_i2c,
						     adapter);
	struct xilinx_drm_dp *dp = container_of(i2c, struct xilinx_drm_dp, i2c);
	u32 cmd;
	u8 *buf;
	int ret;

	/* Set up the command byte */
	if (mode & MODE_I2C_READ) {
		cmd = DP_AUX_I2C_READ;
		buf = read_byte;
	} else {
		cmd = DP_AUX_I2C_WRITE;
		buf = &write_byte;
	}

	if (!(mode & MODE_I2C_STOP))
		cmd |= DP_AUX_I2C_MOT;

	ret = xilinx_drm_dp_aux_cmd_byte(dp, cmd, algo_data->address, buf);
	if (ret < 0)
		DRM_DEBUG_DRIVER("failed to submit DP aux command\n");

	return ret;
}

/**
 * xilinx_drm_dp_i2c_init - Initialize the i2c interface
 * @dp: DisplayPort IP core structure
 *
 * Return: 0 if successful, or corresponding error code from
 * i2c_dp_aux_add_bus().
 */
static int xilinx_drm_dp_i2c_init(struct xilinx_drm_dp *dp)
{
	dp->i2c.algo.running = false;
	dp->i2c.algo.address = 0;
	dp->i2c.algo.aux_ch = xilinx_drm_dp_i2c_aux_ch;

	memset(&dp->i2c.adapter, 0, sizeof(dp->i2c.adapter));

	dp->i2c.adapter.owner = THIS_MODULE;
	dp->i2c.adapter.class = I2C_CLASS_DDC;
	strncpy(dp->i2c.adapter.name, "Xilinx DP I2C Aux",
		 sizeof(dp->i2c.adapter.name) - 1);
	dp->i2c.adapter.name[sizeof(dp->i2c.adapter.name) - 1] = '\0';
	dp->i2c.adapter.algo_data = &dp->i2c.algo;
	dp->i2c.adapter.dev.parent = dp->dev;
	dp->i2c.adapter.dev.of_node = dp->dev->of_node;

	return i2c_dp_aux_add_bus(&dp->i2c.adapter);
}

static int xilinx_drm_dp_parse_of(struct xilinx_drm_dp *dp)
{
	struct device_node *node = dp->dev->of_node;
	struct xilinx_drm_dp_config *config = &dp->config;
	const char *string;
	u32 num_colors, bpc;
	bool sync;
	int ret;

	ret = of_property_read_string(node, "xlnx,dp-version", &string);
	if (ret < 0) {
		dev_err(dp->dev, "No DP version in DT\n");
		return ret;
	}

	if (strcmp(string, "v1.1a") == 0) {
		config->dp_version = DP_V1_1A;
	} else if (strcmp(string, "v1.2") == 0) {
		config->dp_version = DP_V1_2;
	} else {
		dev_err(dp->dev, "Invalid DP version in DT\n");
		return -EINVAL;
	}

	ret = of_property_read_u32(node, "xlnx,max-lanes", &config->max_lanes);
	if (ret < 0) {
		dev_err(dp->dev, "No lane count in DT\n");
		return ret;
	}

	if (config->max_lanes != 1 && config->max_lanes != 2 &&
	    config->max_lanes != 4) {
		dev_err(dp->dev, "Invalid max lanes in DT\n");
		return -EINVAL;
	}

	ret = of_property_read_u32(node, "xlnx,max-link-rate",
				   &config->max_link_rate);
	if (ret < 0) {
		dev_err(dp->dev, "No link rate in DT\n");
		return ret;
	}

	if (config->max_link_rate != DP_REDUCED_BIT_RATE &&
	    config->max_link_rate != DP_HIGH_BIT_RATE &&
	    config->max_link_rate != DP_HIGH_BIT_RATE2) {
		dev_err(dp->dev, "Invalid link rate in DT\n");
		return -EINVAL;
	}

	config->enable_yonly = of_property_read_bool(node, "xlnx,enable-yonly");
	config->enable_ycrcb = of_property_read_bool(node, "xlnx,enable-ycrcb");

	sync = of_property_read_bool(node, "xlnx,sync");
	if (sync)
		config->misc0 |= XILINX_DP_TX_MAIN_STREAM_MISC0_SYNC;

	ret = of_property_read_string(node, "xlnx,colormetry", &string);
	if (ret < 0) {
		dev_err(dp->dev, "No colormetry in DT\n");
		return ret;
	}

	if (strcmp(string, "rgb") == 0) {
		config->misc0 |= XILINX_DP_MISC0_RGB;
		num_colors = 3;
	} else if (config->enable_ycrcb && strcmp(string, "ycrcb422") == 0) {
		config->misc0 |= XILINX_DP_MISC0_YCRCB_422;
		num_colors = 3;
	} else if (config->enable_ycrcb && strcmp(string, "ycrcb444") == 0) {
		config->misc0 |= XILINX_DP_MISC0_YCRCB_444;
		num_colors = 3;
	} else if (config->enable_yonly && strcmp(string, "yonly") == 0) {
		config->misc1 |= XILINX_DP_MISC1_Y_ONLY;
		num_colors = 1;
	} else {
		dev_err(dp->dev, "Invalid colormetry in DT\n");
		return -EINVAL;
	}

	ret = of_property_read_u32(node, "xlnx,max-bpc", &config->max_bpc);
	if (ret < 0) {
		dev_err(dp->dev, "No max bpc in DT\n");
		return ret;
	}

	if (config->max_bpc != 8 && config->max_bpc != 10 &&
	    config->max_bpc != 12 && config->max_bpc != 16) {
		dev_err(dp->dev, "Invalid max bpc in DT\n");
		return -EINVAL;
	}

	ret = of_property_read_u32(node, "xlnx,bpc", &bpc);
	if (ret < 0) {
		dev_err(dp->dev, "No color depth(bpc) in DT\n");
		return ret;
	}

	if (bpc > config->max_bpc) {
		dev_err(dp->dev, "Invalid color depth(bpc) in DT\n");
		return -EINVAL;
	}

	switch (bpc) {
	case 6:
		config->misc0 |= XILINX_DP_MISC0_BPC_6;
		break;
	case 8:
		config->misc0 |= XILINX_DP_MISC0_BPC_8;
		break;
	case 10:
		config->misc0 |= XILINX_DP_MISC0_BPC_10;
		break;
	case 12:
		config->misc0 |= XILINX_DP_MISC0_BPC_12;
		break;
	case 16:
		config->misc0 |= XILINX_DP_MISC0_BPC_16;
		break;
	default:
		dev_err(dp->dev, "Not supported color depth in DT\n");
		return -EINVAL;
	}

	config->bpp = num_colors * bpc;

	return 0;
}

static int xilinx_drm_dp_probe(struct platform_device *pdev)
{
	struct xilinx_drm_dp *dp;
	struct resource *res;
	u32 version;
	int irq, ret;

	dp = devm_kzalloc(&pdev->dev, sizeof(*dp), GFP_KERNEL);
	if (!dp)
		return -ENOMEM;

	dp->dpms = DRM_MODE_DPMS_OFF;
	dp->dev = &pdev->dev;

	ret = xilinx_drm_dp_parse_of(dp);
	if (ret < 0)
		return ret;

	dp->aclk = devm_clk_get(dp->dev, NULL);
	if (IS_ERR(dp->aclk))
		return -EPROBE_DEFER;

	ret = clk_prepare_enable(dp->aclk);
	if (ret) {
		dev_err(dp->dev, "failed to enable the aclk\n");
		return ret;
	}

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	dp->iomem = devm_ioremap_resource(dp->dev, res);
	if (IS_ERR(dp->iomem))
		return PTR_ERR(dp->iomem);

	mutex_init(&dp->aux_lock);

	platform_set_drvdata(pdev, dp);

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_SW_RESET,
			  XILINX_DP_TX_SW_RESET_ALL);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_PHY_CONFIG,
			  XILINX_DP_TX_PHY_CONFIG_ALL_RESET);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_FORCE_SCRAMBLER_RESET, 1);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_ENABLE, 0);
	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_INTR_MASK,
			  XILINX_DP_TX_INTR_MASK_ALL);

	ret = xilinx_drm_dp_i2c_init(dp);
	if (ret < 0) {
		dev_err(dp->dev, "failed to initialize DP i2c\n");
		goto error;
	}

	irq = platform_get_irq(pdev, 0);
	if (irq < 0) {
		ret = irq;
		goto error;
	}

	ret = devm_request_threaded_irq(dp->dev, irq, NULL,
					xilinx_drm_dp_irq_handler, IRQF_ONESHOT,
					dev_name(dp->dev), dp);
	if (ret < 0)
		goto error;

	version = xilinx_drm_readl(dp->iomem, XILINX_DP_TX_VERSION);

	dev_info(dp->dev, "device found, version %u.%02x%x\n",
		 ((version & XILINX_DP_TX_VERSION_MAJOR_MASK) >>
		  XILINX_DP_TX_VERSION_MAJOR_SHIFT),
		 ((version & XILINX_DP_TX_VERSION_MINOR_MASK) >>
		  XILINX_DP_TX_VERSION_MINOR_SHIFT),
		 ((version & XILINX_DP_TX_VERSION_REVISION_MASK) >>
		  XILINX_DP_TX_VERSION_REVISION_SHIFT));

	version = xilinx_drm_readl(dp->iomem, XILINX_DP_TX_CORE_ID);
	if (version & XILINX_DP_TX_CORE_ID_DIRECTION) {
		dev_err(dp->dev, "Receiver is not supported\n");
		ret = -ENODEV;
		goto error;
	}

	dev_info(dp->dev, "Display Port, version %u.%02x%02x (tx)\n",
		 ((version & XILINX_DP_TX_CORE_ID_MAJOR_MASK) >>
		  XILINX_DP_TX_CORE_ID_MAJOR_SHIFT),
		 ((version & XILINX_DP_TX_CORE_ID_MINOR_MASK) >>
		  XILINX_DP_TX_CORE_ID_MINOR_SHIFT),
		 ((version & XILINX_DP_TX_CORE_ID_REVISION_MASK) >>
		  XILINX_DP_TX_CORE_ID_REVISION_SHIFT));

	return 0;

error:
	mutex_destroy(&dp->aux_lock);
	return ret;
}

static int xilinx_drm_dp_remove(struct platform_device *pdev)
{
	struct xilinx_drm_dp *dp = platform_get_drvdata(pdev);

	clk_disable_unprepare(dp->aclk);

	xilinx_drm_writel(dp->iomem, XILINX_DP_TX_ENABLE, 0);

	mutex_destroy(&dp->aux_lock);

	return 0;
}

static const struct of_device_id xilinx_drm_dp_of_match[] = {
	{ .compatible = "xlnx,v-dp-4.2", },
	{ /* end of table */ },
};
MODULE_DEVICE_TABLE(of, xilinx_drm_dp_of_match);

static struct drm_platform_encoder_driver xilinx_drm_dp_driver = {
	.platform_driver = {
		.probe			= xilinx_drm_dp_probe,
		.remove			= xilinx_drm_dp_remove,
		.driver			= {
			.owner		= THIS_MODULE,
			.name		= "xilinx-drm-dp",
			.pm		= &xilinx_drm_dp_pm_ops,
			.of_match_table	= xilinx_drm_dp_of_match,
		},
	},

	.encoder_init = xilinx_drm_dp_encoder_init,
};

static int __init xilinx_drm_dp_init(void)
{
	return platform_driver_register(&xilinx_drm_dp_driver.platform_driver);
}

static void __exit xilinx_drm_dp_exit(void)
{
	platform_driver_unregister(&xilinx_drm_dp_driver.platform_driver);
}

module_init(xilinx_drm_dp_init);
module_exit(xilinx_drm_dp_exit);

MODULE_AUTHOR("Xilinx, Inc.");
MODULE_DESCRIPTION("Xilinx DRM KMS DiplayPort Driver");
MODULE_LICENSE("GPL v2");
