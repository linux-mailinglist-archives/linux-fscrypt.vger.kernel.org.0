Return-Path: <linux-fscrypt+bounces-595-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73412A2D86F
	for <lists+linux-fscrypt@lfdr.de>; Sat,  8 Feb 2025 21:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 253D53A71E4
	for <lists+linux-fscrypt@lfdr.de>; Sat,  8 Feb 2025 20:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F3718FDD2;
	Sat,  8 Feb 2025 20:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IwWj1TZ9"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51485674E;
	Sat,  8 Feb 2025 20:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739044978; cv=none; b=f/hDg/ruLLKeuHSZE2d7K9cTpD/tA7kietFcbxgOyPZBsxFTxK7IwHzP+F4aWMCdzP5DiqpHH12cnITAUkcdxhse/n5853o8Z+J98paFYT9lA5VKfVkzkj0+O19rYF/ADh/Kugn2IRNRx8D9SWmo940mekbQGSlNWoX4wce2Rk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739044978; c=relaxed/simple;
	bh=Pl9mvMnThYGort8HlHxwSrnmS+mzJ/kO38p+F19JrX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t0x2L+jc2RF2CqIKqJ8thhf2iTgCdrILkTlyHVzpnoF47Y1iLRjemXBOzrBXKT4yUAl07XkBIfmNAoN2o44dXrIEf0OGX/DOQ6vGncYi5rmmLHDttlwPfu71gY4CI9PPJRAwlzkR2/siXrEUXyneOYILAk9LD1UvO37ewSrysAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IwWj1TZ9; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739044977; x=1770580977;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Pl9mvMnThYGort8HlHxwSrnmS+mzJ/kO38p+F19JrX8=;
  b=IwWj1TZ9lPD6CiX8JPuJBOhqr1FdLDwNSDfDNM8ovXM0Tgv6eZjEnIjG
   +2p55C1oz+ueFNueTx1givzJB+KS1gZYwDUQtyBgQd1UVwZUxy8hFfoGF
   vLoveuYCNQPxTWerlRJia1/Ft7bOFajVGofh8miwv7LfCQqSRN2Ih0z03
   z/54mTO3vG0c0Gfn/Z8Y8FMqzaPd2KIwakQDUq+y8wE6Tm4MxrDVCec1q
   QfdMBu9VEX9Lkl3tFDcpeMk0hverQYIYDRhTfAv6zdUyKYXPZHFJHP7u2
   YNj8IIzkW3gQPUmAYnKh+avTg9BFpNrAAyAkhR7q31qISHFBvAM19qlVO
   w==;
X-CSE-ConnectionGUID: OeF5nnJYQPC4PTg8ru/Itw==
X-CSE-MsgGUID: W22HQT5MRiOBdl44QrIhmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11339"; a="57083274"
X-IronPort-AV: E=Sophos;i="6.13,270,1732608000"; 
   d="scan'208";a="57083274"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 12:02:56 -0800
X-CSE-ConnectionGUID: p/gmGRl4T8SbOYVMUVGDOA==
X-CSE-MsgGUID: lNe6Q+VkTOuQqTixirSBsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="115898498"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 08 Feb 2025 12:02:52 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tgr2Q-0010ZP-1S;
	Sat, 08 Feb 2025 20:02:50 +0000
Date: Sun, 9 Feb 2025 04:01:55 +0800
From: kernel test robot <lkp@intel.com>
To: Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: Re: [PATCH v11 6/7] soc: qcom: ice: add HWKM support to the ICE
 driver
Message-ID: <202502090302.znlTCbTa-lkp@intel.com>
References: <20250204060041.409950-7-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204060041.409950-7-ebiggers@kernel.org>

Hi Eric,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 2014c95afecee3e76ca4a56956a936e23283f05b]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Biggers/blk-crypto-add-basic-hardware-wrapped-key-support/20250204-140702
base:   2014c95afecee3e76ca4a56956a936e23283f05b
patch link:    https://lore.kernel.org/r/20250204060041.409950-7-ebiggers%40kernel.org
patch subject: [PATCH v11 6/7] soc: qcom: ice: add HWKM support to the ICE driver
config: openrisc-randconfig-r111-20250208 (https://download.01.org/0day-ci/archive/20250209/202502090302.znlTCbTa-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 14.2.0
reproduce: (https://download.01.org/0day-ci/archive/20250209/202502090302.znlTCbTa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502090302.znlTCbTa-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/soc/qcom/ice.c:337:9: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] regval @@
   drivers/soc/qcom/ice.c:337:9: sparse:     expected unsigned int [usertype] value
   drivers/soc/qcom/ice.c:337:9: sparse:     got restricted __le32 [usertype] regval

vim +337 drivers/soc/qcom/ice.c

   302	
   303	static int qcom_ice_program_wrapped_key(struct qcom_ice *ice, unsigned int slot,
   304						const struct blk_crypto_key *bkey)
   305	{
   306		struct device *dev = ice->dev;
   307		union crypto_cfg cfg = {
   308			.dusize = bkey->crypto_cfg.data_unit_size / 512,
   309			.capidx = QCOM_SCM_ICE_CIPHER_AES_256_XTS,
   310			.cfge = QCOM_ICE_HWKM_CFG_ENABLE_VAL,
   311		};
   312		int err;
   313	
   314		if (!ice->use_hwkm) {
   315			dev_err_ratelimited(dev, "Got wrapped key when not using HWKM\n");
   316			return -EINVAL;
   317		}
   318		if (!ice->hwkm_init_complete) {
   319			dev_err_ratelimited(dev, "HWKM not yet initialized\n");
   320			return -EINVAL;
   321		}
   322	
   323		/* Clear CFGE before programming the key. */
   324		qcom_ice_writel(ice, 0x0, QCOM_ICE_REG_CRYPTOCFG(slot));
   325	
   326		/* Call into TrustZone to program the wrapped key using HWKM. */
   327		err = qcom_scm_ice_set_key(translate_hwkm_slot(ice, slot), bkey->bytes,
   328					   bkey->size, cfg.capidx, cfg.dusize);
   329		if (err) {
   330			dev_err_ratelimited(dev,
   331					    "qcom_scm_ice_set_key failed; err=%d, slot=%u\n",
   332					    err, slot);
   333			return err;
   334		}
   335	
   336		/* Set CFGE after programming the key. */
 > 337		qcom_ice_writel(ice, cfg.regval, QCOM_ICE_REG_CRYPTOCFG(slot));
   338		return 0;
   339	}
   340	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

