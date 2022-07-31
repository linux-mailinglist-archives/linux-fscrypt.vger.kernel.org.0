Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87818585E73
	for <lists+linux-fscrypt@lfdr.de>; Sun, 31 Jul 2022 12:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiGaKgI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 31 Jul 2022 06:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiGaKgH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 31 Jul 2022 06:36:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9FAAE4B;
        Sun, 31 Jul 2022 03:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659263766; x=1690799766;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v8sbxwujtMOWcpWNDzjREhJrtsZvBrGtnFHaaCw5Hfg=;
  b=edzqHgSXt/oFo6D9D8WQhCB1Oe74Xcyz9eMAqycU7fm0Vo0EJ6Q3478O
   1R0mbD23XUfUu5j/TBql71UyH23X5pL37qBcCn3JFBhM25Tr7h9+em5yL
   DcIRPIsxDEpdj/W8AlYrBuEno9U8Lmop9UnQtbVyf+mS8N7h2NfU3vDaE
   DBKRwnppLybK9PJcPquJ5WCUYFT7TbLVzZUUdRKvHmCxAZWhm2gkitt0o
   EnKzCqzk50wt8clQa4PdIZvqt4UIfLM8jPnszvQq/PnSZy7JxeyoP7mIc
   5GDuZFkMzWZ9eTG6sKRnoCqQJr/YRxenQys7N18apaavbMP9jyZ/cWdJ8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10424"; a="375288474"
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="375288474"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2022 03:36:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="629900305"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2022 03:36:04 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oI6Il-000E2h-1d;
        Sun, 31 Jul 2022 10:36:03 +0000
Date:   Sun, 31 Jul 2022 18:35:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Boris Burkov <boris@bur.io>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH v2] btrfs: send: add support for fs-verity
Message-ID: <202207311836.xrPNTFhA-lkp@intel.com>
References: <9bfbf3b43d2c2663d2e3f196810288fd83c0b52e.1659031503.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bfbf3b43d2c2663d2e3f196810288fd83c0b52e.1659031503.git.boris@bur.io>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Boris,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kdave/for-next]
[also build test WARNING on next-20220728]
[cannot apply to fscrypt/fsverity linus/master v5.19-rc8]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Boris-Burkov/btrfs-send-add-support-for-fs-verity/20220729-021228
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20220731/202207311836.xrPNTFhA-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/cd0224725d17f6e9ebabdddeea5bc5743a9250ae
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Boris-Burkov/btrfs-send-add-support-for-fs-verity/20220729-021228
        git checkout cd0224725d17f6e9ebabdddeea5bc5743a9250ae
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash fs/btrfs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> fs/btrfs/send.c:4906:9: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected int len @@     got restricted __le32 [usertype] sig_size @@
   fs/btrfs/send.c:4906:9: sparse:     expected int len
   fs/btrfs/send.c:4906:9: sparse:     got restricted __le32 [usertype] sig_size

vim +4906 fs/btrfs/send.c

  4892	
  4893	static int send_verity(struct send_ctx *sctx, struct fs_path *path,
  4894			       struct fsverity_descriptor *desc)
  4895	{
  4896		int ret;
  4897	
  4898		ret = begin_cmd(sctx, BTRFS_SEND_C_ENABLE_VERITY);
  4899		if (ret < 0)
  4900			goto out;
  4901	
  4902		TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);
  4903		TLV_PUT_U8(sctx, BTRFS_SEND_A_VERITY_ALGORITHM, desc->hash_algorithm);
  4904		TLV_PUT_U32(sctx, BTRFS_SEND_A_VERITY_BLOCK_SIZE, 1U << desc->log_blocksize);
  4905		TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SALT_DATA, desc->salt, desc->salt_size);
> 4906		TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SIG_DATA, desc->signature, desc->sig_size);
  4907	
  4908		ret = send_cmd(sctx);
  4909	
  4910	tlv_put_failure:
  4911	out:
  4912		return ret;
  4913	}
  4914	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
