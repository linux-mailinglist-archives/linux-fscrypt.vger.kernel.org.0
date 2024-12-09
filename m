Return-Path: <linux-fscrypt+bounces-545-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F4F9E958E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 14:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F181016701D
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 13:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CCD233D6A;
	Mon,  9 Dec 2024 12:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oJfzU7Ih"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056F6231CA5;
	Mon,  9 Dec 2024 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733749064; cv=none; b=hedwEkDhZemLJxtd37h0jSHfT4NARKSE0ckdgMrmDUmcTZF6rOSegU7F4MUkHvdsJB6peH72Owau0KeeOJP50x4Dsne48H1z9TWwrUwQU1Hy+M2isaLw5sN4xz+EFesfJIBJ3J/AJQXnoPw/BeveskVvCsqzS7CyiPSESmFDS1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733749064; c=relaxed/simple;
	bh=EbuJhA4qQx4XDk7llJVA7OD1EXIiE7sPMPIq2v+X2vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BfRxd1/Fto0AfWjObp1gaqJyo7EgpTiqH2635miTi8qbdWuNZt0elzmhYfQCOQSLXYh4sUGhALP+50eDaSImClxtafQaw8Fy69y6/rC9hCAQH5xSlm3ruO/Co5zI3bs/+WmcN15DsALOCfEIn1/hpT5+JrP87c98102ltfoV5Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oJfzU7Ih; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733749062; x=1765285062;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EbuJhA4qQx4XDk7llJVA7OD1EXIiE7sPMPIq2v+X2vY=;
  b=oJfzU7IhXwkVAVrBqi5Wf4krzSXzxq46HlunoS+q2IZSmnJ264VKJq8W
   6fodg63iP38eeJrblN52iDSb+8MrrImgiclEJIjHAHOiYjYfeZjKZPaZC
   lfKz4LbWweFc3fxsfEH09kYpWcFD05L3q6vFhi0aszyhyX9/q2zL/fLjO
   7vrhKJgj9te9pPsU5jjcwJkgLJkQlRSv508b8V9KH8XluJ/4wwPw7Grcz
   z1tRG2acHJjhh/Xd42qmEmHXd/Nk+IcwOeFVEvxCkkrUDENBHz9k7L6qM
   zkafjOaXtAjggJAuSwWfYyuNVs9EUiN3IUJ8oiTxshqXm259P2qse7uw+
   Q==;
X-CSE-ConnectionGUID: 0u/8TbIoTDOuLLmReWyEvA==
X-CSE-MsgGUID: 2HlJ2vTyRWa7B7KRxZnerg==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="21632660"
X-IronPort-AV: E=Sophos;i="6.12,219,1728975600"; 
   d="scan'208";a="21632660"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 04:57:37 -0800
X-CSE-ConnectionGUID: U8+Nfyd1TY6n08jUrXsG2Q==
X-CSE-MsgGUID: Ptj6aMXxQvqLGUEjw6vqGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,219,1728975600"; 
   d="scan'208";a="100023631"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 09 Dec 2024 04:57:32 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tKdKL-0004LJ-0i;
	Mon, 09 Dec 2024 12:57:29 +0000
Date: Mon, 9 Dec 2024 20:57:06 +0800
From: kernel test robot <lkp@intel.com>
To: Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 04/12] mmc: sdhci-msm: convert to use custom crypto
 profile
Message-ID: <202412092047.I2fWyclK-lkp@intel.com>
References: <20241209045530.507833-5-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209045530.507833-5-ebiggers@kernel.org>

Hi Eric,

kernel test robot noticed the following build warnings:

[auto build test WARNING on f486c8aa16b8172f63bddc70116a0c897a7f3f02]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Biggers/ufs-crypto-add-ufs_hba_from_crypto_profile/20241209-130301
base:   f486c8aa16b8172f63bddc70116a0c897a7f3f02
patch link:    https://lore.kernel.org/r/20241209045530.507833-5-ebiggers%40kernel.org
patch subject: [PATCH v9 04/12] mmc: sdhci-msm: convert to use custom crypto profile
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20241209/202412092047.I2fWyclK-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241209/202412092047.I2fWyclK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412092047.I2fWyclK-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/mmc/host/cqhci-crypto.c:8:
   In file included from include/linux/blk-crypto.h:72:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:10:
   In file included from include/linux/mm.h:2223:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/mmc/host/cqhci-crypto.c:176:6: warning: variable 'num_keyslots' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     176 |         if (cq_host->ops->uses_custom_crypto_profile)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/mmc/host/cqhci-crypto.c:230:24: note: uninitialized use occurs here
     230 |         for (slot = 0; slot < num_keyslots; slot++)
         |                               ^~~~~~~~~~~~
   drivers/mmc/host/cqhci-crypto.c:176:2: note: remove the 'if' if its condition is always false
     176 |         if (cq_host->ops->uses_custom_crypto_profile)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     177 |                 goto profile_initialized;
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/mmc/host/cqhci-crypto.c:166:27: note: initialize the variable 'num_keyslots' to silence this warning
     166 |         unsigned int num_keyslots;
         |                                  ^
         |                                   = 0
   5 warnings generated.


vim +176 drivers/mmc/host/cqhci-crypto.c

   147	
   148	/**
   149	 * cqhci_crypto_init - initialize CQHCI crypto support
   150	 * @cq_host: a cqhci host
   151	 *
   152	 * If the driver previously set MMC_CAP2_CRYPTO and the CQE declares
   153	 * CQHCI_CAP_CS, initialize the crypto support.  This involves reading the
   154	 * crypto capability registers, initializing the blk_crypto_profile, clearing
   155	 * all keyslots, and enabling 128-bit task descriptors.
   156	 *
   157	 * Return: 0 if crypto was initialized or isn't supported; whether
   158	 *	   MMC_CAP2_CRYPTO remains set indicates which one of those cases it is.
   159	 *	   Also can return a negative errno value on unexpected error.
   160	 */
   161	int cqhci_crypto_init(struct cqhci_host *cq_host)
   162	{
   163		struct mmc_host *mmc = cq_host->mmc;
   164		struct device *dev = mmc_dev(mmc);
   165		struct blk_crypto_profile *profile = &mmc->crypto_profile;
   166		unsigned int num_keyslots;
   167		unsigned int cap_idx;
   168		enum blk_crypto_mode_num blk_mode_num;
   169		unsigned int slot;
   170		int err = 0;
   171	
   172		if (!(mmc->caps2 & MMC_CAP2_CRYPTO) ||
   173		    !(cqhci_readl(cq_host, CQHCI_CAP) & CQHCI_CAP_CS))
   174			goto out;
   175	
 > 176		if (cq_host->ops->uses_custom_crypto_profile)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

