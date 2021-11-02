/*
 * ASoC simple sound card support
 *
 * Copyright (C) 2012 Renesas Solutions Corp.
 * Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#include <linux/clk.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>
#include <linux/string.h>
#include <sound/simple_card.h>
#include <sound/soc-dai.h>
#include <sound/soc.h>

struct simple_card_data {
	struct snd_soc_card snd_card;
	struct simple_dai_props {
		struct asoc_simple_dai cpu_dai;
		struct asoc_simple_dai codec_dai;
	} *dai_props;
	struct snd_soc_dai_link dai_link[];	/* dynamically allocated */
};

static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
				       struct asoc_simple_dai *set)
{
	int ret;

	if (set->fmt) {
		ret = snd_soc_dai_set_fmt(dai, set->fmt);
		if (ret && ret != -ENOTSUPP) {
			dev_err(dai->dev, "simple-card: set_fmt error\n");
			goto err;
		}
	}

	if (set->sysclk) {
		ret = snd_soc_dai_set_sysclk(dai, 0, set->sysclk, 0);
		if (ret && ret != -ENOTSUPP) {
			dev_err(dai->dev, "simple-card: set_sysclk error\n");
			goto err;
		}
	}

	if (set->slots) {
		ret = snd_soc_dai_set_tdm_slot(dai, 0, 0,
						set->slots,
						set->slot_width);
		if (ret && ret != -ENOTSUPP) {
			dev_err(dai->dev, "simple-card: set_tdm_slot error\n");
			goto err;
		}
	}

	ret = 0;

err:
	return ret;
}

static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
{
	struct simple_card_data *priv =
				snd_soc_card_get_drvdata(rtd->card);
	struct snd_soc_dai *codec = rtd->codec_dai;
	struct snd_soc_dai *cpu = rtd->cpu_dai;
	struct simple_dai_props *dai_props;
	int num, ret;

	num = rtd - rtd->card->rtd;
	dai_props = &priv->dai_props[num];
	ret = __asoc_simple_card_dai_init(codec, &dai_props->codec_dai);
	if (ret < 0)
		return ret;

	ret = __asoc_simple_card_dai_init(cpu, &dai_props->cpu_dai);
	if (ret < 0)
		return ret;

	return 0;
}

static int
asoc_simple_card_sub_parse_of(struct device_node *np,
			      unsigned int daifmt,
			      struct asoc_simple_dai *dai,
			      const struct device_node **p_node,
			      const char **name)
{
	struct device_node *node;
	struct clk *clk;
	int ret;

	/*
	 * get node via "sound-dai = <&phandle port>"
	 * it will be used as xxx_of_node on soc_bind_dai_link()
	 */
	node = of_parse_phandle(np, "sound-dai", 0);
	if (!node)
		return -ENODEV;
	*p_node = node;

	/* get dai->name */
	ret = snd_soc_of_get_dai_name(np, name);
	if (ret < 0)
		return ret;

	/* parse TDM slot */
	ret = snd_soc_of_parse_tdm_slot(np, &dai->slots, &dai->slot_width);
	if (ret)
		return ret;

	/*
	 * bitclock-inversion, frame-inversion
	 * bitclock-master,    frame-master
	 * and specific "format" if it has
	 */
	dai->fmt = snd_soc_of_parse_daifmt(np, NULL);
	dai->fmt |= daifmt;

	/*
	 * dai->sysclk come from
	 *  "clocks = <&xxx>" (if system has common clock)
	 *  or "system-clock-frequency = <xxx>"
	 *  or device's module clock.
	 */
	if (of_property_read_bool(np, "clocks")) {
		clk = of_clk_get(np, 0);
		if (IS_ERR(clk)) {
			ret = PTR_ERR(clk);
			return ret;
		}

		dai->sysclk = clk_get_rate(clk);
	} else if (of_property_read_bool(np, "system-clock-frequency")) {
		of_property_read_u32(np,
				     "system-clock-frequency",
				     &dai->sysclk);
	} else {
		clk = of_clk_get(node, 0);
		if (!IS_ERR(clk))
			dai->sysclk = clk_get_rate(clk);
	}

	return 0;
}

static int simple_card_cpu_codec_of(struct device_node *node,
				int daifmt,
				struct snd_soc_dai_link *dai_link,
				struct simple_dai_props *dai_props)
{
	struct device_node *np;
	int ret;

	/* CPU sub-node */
	ret = -EINVAL;
	np = of_get_child_by_name(node, "simple-audio-card,cpu");
	if (np) {
		ret = asoc_simple_card_sub_parse_of(np, daifmt,
						&dai_props->cpu_dai,
						&dai_link->cpu_of_node,
						&dai_link->cpu_dai_name);
		of_node_put(np);
	}
	if (ret < 0)
		return ret;

	/* CODEC sub-node */
	ret = -EINVAL;
	np = of_get_child_by_name(node, "simple-audio-card,codec");
	if (np) {
		ret = asoc_simple_card_sub_parse_of(np, daifmt,
						&dai_props->codec_dai,
						&dai_link->codec_of_node,
						&dai_link->codec_dai_name);
		of_node_put(np);
	}
	return ret;
}

static int asoc_simple_card_parse_of(struct device_node *node,
				     struct simple_card_data *priv,
				     struct device *dev,
				     int multi)
{
	struct snd_soc_dai_link *dai_link = priv->snd_card.dai_link;
	struct simple_dai_props *dai_props = priv->dai_props;
	struct device_node *np;
	char *name;
	unsigned int daifmt;
	int ret;

	/* parsing the card name from DT */
	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");

	/* get CPU/CODEC common format via simple-audio-card,format */
	daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
		(SND_SOC_DAIFMT_FORMAT_MASK | SND_SOC_DAIFMT_INV_MASK);

	/* off-codec widgets */
	if (of_property_read_bool(node, "simple-audio-card,widgets")) {
		ret = snd_soc_of_parse_audio_simple_widgets(&priv->snd_card,
					"simple-audio-card,widgets");
		if (ret)
			return ret;
	}

	/* DAPM routes */
	if (of_property_read_bool(node, "simple-audio-card,routing")) {
		ret = snd_soc_of_parse_audio_routing(&priv->snd_card,
					"simple-audio-card,routing");
		if (ret)
			return ret;
	}

	/* loop on the DAI links */
	np = NULL;
	for (;;) {
		if (multi) {
			np = of_get_next_child(node, np);
			if (!np)
				break;
		}

		ret = simple_card_cpu_codec_of(multi ? np : node,
					daifmt, dai_link, dai_props);
		if (ret < 0)
			goto err;

		/*
		 * overwrite cpu_dai->fmt as its DAIFMT_MASTER bit is based on CODEC
		 * while the other bits should be identical unless buggy SW/HW design.
		 */
		dai_props->cpu_dai.fmt = dai_props->codec_dai.fmt;

		if (!dai_link->cpu_dai_name || !dai_link->codec_dai_name) {
			ret = -EINVAL;
			goto err;
		}

		/* simple-card assumes platform == cpu */
		dai_link->platform_of_node = dai_link->cpu_of_node;

		name = devm_kzalloc(dev,
				    strlen(dai_link->cpu_dai_name)   +
				    strlen(dai_link->codec_dai_name) + 2,
				    GFP_KERNEL);
		sprintf(name, "%s-%s", dai_link->cpu_dai_name,
					dai_link->codec_dai_name);
		dai_link->name = dai_link->stream_name = name;

		if (!multi)
			break;

		dai_link++;
		dai_props++;
	}

	/* card name is created from CPU/CODEC dai name */
	dai_link = priv->snd_card.dai_link;
	if (!priv->snd_card.name)
		priv->snd_card.name = dai_link->name;

	dev_dbg(dev, "card-name : %s\n", priv->snd_card.name);
	dev_dbg(dev, "platform : %04x\n", daifmt);
	dai_props = priv->dai_props;
	dev_dbg(dev, "cpu : %s / %04x / %d\n",
		dai_link->cpu_dai_name,
		dai_props->cpu_dai.fmt,
		dai_props->cpu_dai.sysclk);
	dev_dbg(dev, "codec : %s / %04x / %d\n",
		dai_link->codec_dai_name,
		dai_props->codec_dai.fmt,
		dai_props->codec_dai.sysclk);

	return 0;

err:
	of_node_put(np);
	return ret;
}

/* update the reference count of the devices nodes at end of probe */
static int asoc_simple_card_unref(struct platform_device *pdev)
{
	struct snd_soc_card *card = platform_get_drvdata(pdev);
	struct snd_soc_dai_link *dai_link;
	struct device_node *np;
	int num_links;

	for (num_links = 0, dai_link = card->dai_link;
	     num_links < card->num_links;
	     num_links++, dai_link++) {
		np = (struct device_node *) dai_link->cpu_of_node;
		if (np)
			of_node_put(np);
		np = (struct device_node *) dai_link->codec_of_node;
		if (np)
			of_node_put(np);
	}
	return 0;
}

static int asoc_simple_card_probe(struct platform_device *pdev)
{
	struct simple_card_data *priv;
	struct snd_soc_dai_link *dai_link;
	struct device_node *np = pdev->dev.of_node;
	struct device *dev = &pdev->dev;
	int num_links, multi, ret;

	/* get the number of DAI links */
	if (np && of_get_child_by_name(np, "simple-audio-card,dai-link")) {
		num_links = of_get_child_count(np);
		multi = 1;
	} else {
		num_links = 1;
		multi = 0;
	}

	/* allocate the private data and the DAI link array */
	priv = devm_kzalloc(dev,
			sizeof(*priv) + sizeof(*dai_link) * num_links,
			GFP_KERNEL);
	if (!priv)
		return -ENOMEM;

	/*
	 * init snd_soc_card
	 */
	priv->snd_card.owner = THIS_MODULE;
	priv->snd_card.dev = dev;
	dai_link = priv->dai_link;
	priv->snd_card.dai_link = dai_link;
	priv->snd_card.num_links = num_links;

	/* get room for the other properties */
	priv->dai_props = devm_kzalloc(dev,
			sizeof(*priv->dai_props) * num_links,
			GFP_KERNEL);
	if (!priv->dai_props)
		return -ENOMEM;

	if (np && of_device_is_available(np)) {

		ret = asoc_simple_card_parse_of(np, priv, dev, multi);
		if (ret < 0) {
			if (ret != -EPROBE_DEFER)
				dev_err(dev, "parse error %d\n", ret);
			goto err;
		}

		/*
		 * soc_bind_dai_link() will check cpu name
		 * after of_node matching if dai_link has cpu_dai_name.
		 * but, it will never match if name was created by fmt_single_name()
		 * remove cpu_dai_name to escape name matching.
		 * see
		 *	fmt_single_name()
		 *	fmt_multiple_name()
		 */
		if (num_links == 1)
			dai_link->cpu_dai_name = NULL;

	} else {
		struct asoc_simple_card_info *cinfo;

		cinfo = dev->platform_data;
		if (!cinfo) {
			dev_err(dev, "no info for asoc-simple-card\n");
			return -EINVAL;
		}

		if (!cinfo->name	||
		    !cinfo->codec_dai.name	||
		    !cinfo->codec	||
		    !cinfo->platform	||
		    !cinfo->cpu_dai.name) {
			dev_err(dev, "insufficient asoc_simple_card_info settings\n");
			return -EINVAL;
		}

		priv->snd_card.name	= (cinfo->card) ? cinfo->card : cinfo->name;
		dai_link->name		= cinfo->name;
		dai_link->stream_name	= cinfo->name;
		dai_link->platform_name	= cinfo->platform;
		dai_link->codec_name	= cinfo->codec;
		dai_link->cpu_dai_name	= cinfo->cpu_dai.name;
		dai_link->codec_dai_name = cinfo->codec_dai.name;
		memcpy(&priv->dai_props->cpu_dai, &cinfo->cpu_dai,
					sizeof(priv->dai_props->cpu_dai));
		memcpy(&priv->dai_props->codec_dai, &cinfo->codec_dai,
					sizeof(priv->dai_props->codec_dai));

		priv->dai_props->cpu_dai.fmt	|= cinfo->daifmt;
		priv->dai_props->codec_dai.fmt	|= cinfo->daifmt;
	}

	/*
	 * init snd_soc_dai_link
	 */
	dai_link->init = asoc_simple_card_dai_init;

	snd_soc_card_set_drvdata(&priv->snd_card, priv);

	ret = devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);

err:
	asoc_simple_card_unref(pdev);
	return ret;
}

static const struct of_device_id asoc_simple_of_match[] = {
	{ .compatible = "simple-audio-card", },
	{},
};
MODULE_DEVICE_TABLE(of, asoc_simple_of_match);

static struct platform_driver asoc_simple_card = {
	.driver = {
		.name	= "asoc-simple-card",
		.owner = THIS_MODULE,
		.of_match_table = asoc_simple_of_match,
	},
	.probe		= asoc_simple_card_probe,
};

module_platform_driver(asoc_simple_card);

MODULE_ALIAS("platform:asoc-simple-card");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("ASoC Simple Sound Card");
MODULE_AUTHOR("Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>");
