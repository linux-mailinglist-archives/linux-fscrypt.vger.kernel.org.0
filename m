Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EBE588877
	for <lists+linux-fscrypt@lfdr.de>; Wed,  3 Aug 2022 10:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbiHCIIB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 3 Aug 2022 04:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiHCIIA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 3 Aug 2022 04:08:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A412181C;
        Wed,  3 Aug 2022 01:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659514079; x=1691050079;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bN+iGNKBmewghUZbv5zf9l2jDbuQeSJS/vMS1thbQP0=;
  b=gvCXACCsO4ktt1lcpm1Fr/oUYnUh6j3auu+fDY5rVw3ducjOucj+I8/J
   6D5n2lbOX393zBZ2WogYexpOF3seYDd4ktyel304hDwPSS3jkz6sDrtEL
   +XB3pj6HOiu7IJdzaKRBY7/p9b8GmLtfUi2jodGbEaUEkZYtxGON2jcnb
   Kn6Ts+YzsE9ReIr4gmWZP1MTWd6efAZxn97J41frUsLv38BxMQPuI2+8O
   ImQgEbedyhsnYlExy8gju7WLX5kptAR0Y/I6WZasXDAMDrT5VzQh4kDjZ
   uyHnENhfvH2c69V+Zqo5g1jnR43++0Qwx2LOFA7kSSGpxumjeyVQKRtNT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="351328251"
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="351328251"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 01:07:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="635597437"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2022 01:07:57 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oJ9Q4-000H1d-05;
        Wed, 03 Aug 2022 08:07:56 +0000
Date:   Wed, 3 Aug 2022 16:07:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Boris Burkov <boris@bur.io>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH v3] btrfs: send: add support for fs-verity
Message-ID: <202208031528.55Suyci3-lkp@intel.com>
References: <7ac3a01572a872f8779f357598215e0e07d191bd.1659379913.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ac3a01572a872f8779f357598215e0e07d191bd.1659379913.git.boris@bur.io>
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
[also build test WARNING on next-20220802]
[cannot apply to fscrypt/fsverity linus/master v5.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Boris-Burkov/btrfs-send-add-support-for-fs-verity/20220802-025522
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
config: loongarch-randconfig-s042-20220803 (https://download.01.org/0day-ci/archive/20220803/202208031528.55Suyci3-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/7edb074602581840675f2c1d8fafb6a16f4a1f47
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Boris-Burkov/btrfs-send-add-support-for-fs-verity/20220802-025522
        git checkout 7edb074602581840675f2c1d8fafb6a16f4a1f47
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=loongarch SHELL=/bin/bash fs/btrfs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> fs/btrfs/send.c:4907:9: sparse: sparse: cast from restricted __le32
   fs/btrfs/send.c: note: in included file (through include/linux/uaccess.h, include/linux/sched/task.h, include/linux/sched/signal.h, ...):
   arch/loongarch/include/asm/uaccess.h:232:32: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void const *from @@     got void const [noderef] __user *from @@
   arch/loongarch/include/asm/uaccess.h:232:32: sparse:     expected void const *from
   arch/loongarch/include/asm/uaccess.h:232:32: sparse:     got void const [noderef] __user *from

vim +4907 fs/btrfs/send.c

  4892	
  4893	#ifdef CONFIG_FS_VERITY
  4894	static int send_verity(struct send_ctx *sctx, struct fs_path *path,
  4895			       struct fsverity_descriptor *desc)
  4896	{
  4897		int ret;
  4898	
  4899		ret = begin_cmd(sctx, BTRFS_SEND_C_ENABLE_VERITY);
  4900		if (ret < 0)
  4901			goto out;
  4902	
  4903		TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);
  4904		TLV_PUT_U8(sctx, BTRFS_SEND_A_VERITY_ALGORITHM, desc->hash_algorithm);
  4905		TLV_PUT_U32(sctx, BTRFS_SEND_A_VERITY_BLOCK_SIZE, 1U << desc->log_blocksize);
  4906		TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SALT_DATA, desc->salt, desc->salt_size);
> 4907		TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SIG_DATA, desc->signature, (int)desc->sig_size);
  4908	
  4909		ret = send_cmd(sctx);
  4910	
  4911	tlv_put_failure:
  4912	out:
  4913		return ret;
  4914	}
  4915	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
