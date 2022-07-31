Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD82585F3F
	for <lists+linux-fscrypt@lfdr.de>; Sun, 31 Jul 2022 16:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbiGaOUC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 31 Jul 2022 10:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGaOUB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 31 Jul 2022 10:20:01 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB0CDEC9;
        Sun, 31 Jul 2022 07:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659277201; x=1690813201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n9XikvRIGgkFAzINHprn4Jrr7z3RZCpmyvn50hO7V4o=;
  b=Ivze0YuicqmzCXakfgyifO1fMcDDG1glv+ViUXrXuc5q6rppuY3r0POa
   PJd15835EDbMgbNuOYTIxMKIbO2+ST7nJIzD8QGh0L4yql+2d9SMKtLx0
   uthl6Rq7QX4k8+h1e9s5O3Q0LsMmBr9tdtoOiK2El2j/eyskLkAfRSRT1
   eL9lWEnr/Qo78ovTYbk3fcXV4U2EWkBYTvo0j0I/ourCShkWoeiLbA3ki
   cvSApiR0UtaklME4A7EgvGV9XwgQJAGva1Al2sm3RAzZpNl+JEIczQfuC
   i7cv4NGPulNrP+QBthVNCZOcjpVijY5nT7YdgFGkWuAASL6Fyet3iu2p/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10425"; a="289770578"
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="289770578"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2022 07:20:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="669775337"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jul 2022 07:19:59 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oI9nS-000ECh-1C;
        Sun, 31 Jul 2022 14:19:58 +0000
Date:   Sun, 31 Jul 2022 22:19:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Boris Burkov <boris@bur.io>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH v2] btrfs: send: add support for fs-verity
Message-ID: <202207312226.d2uCDX53-lkp@intel.com>
References: <9bfbf3b43d2c2663d2e3f196810288fd83c0b52e.1659031503.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bfbf3b43d2c2663d2e3f196810288fd83c0b52e.1659031503.git.boris@bur.io>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Boris,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kdave/for-next]
[also build test ERROR on next-20220728]
[cannot apply to fscrypt/fsverity linus/master v5.19-rc8]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Boris-Burkov/btrfs-send-add-support-for-fs-verity/20220729-021228
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
config: arc-randconfig-r025-20220731 (https://download.01.org/0day-ci/archive/20220731/202207312226.d2uCDX53-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/cd0224725d17f6e9ebabdddeea5bc5743a9250ae
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Boris-Burkov/btrfs-send-add-support-for-fs-verity/20220729-021228
        git checkout cd0224725d17f6e9ebabdddeea5bc5743a9250ae
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash fs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/btrfs/send.c: In function 'process_new_verity':
>> fs/btrfs/send.c:4926:28: error: 'struct super_block' has no member named 's_vop'; did you mean 's_op'?
    4926 |         ret = fs_info->sb->s_vop->get_verity_descriptor(inode, NULL, 0);
         |                            ^~~~~
         |                            s_op
   fs/btrfs/send.c:4942:28: error: 'struct super_block' has no member named 's_vop'; did you mean 's_op'?
    4942 |         ret = fs_info->sb->s_vop->get_verity_descriptor(inode, sctx->verity_descriptor, ret);
         |                            ^~~~~
         |                            s_op


vim +4926 fs/btrfs/send.c

  4914	
  4915	static int process_new_verity(struct send_ctx *sctx)
  4916	{
  4917		int ret = 0;
  4918		struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
  4919		struct inode *inode;
  4920		struct fs_path *p;
  4921	
  4922		inode = btrfs_iget(fs_info->sb, sctx->cur_ino, sctx->send_root);
  4923		if (IS_ERR(inode))
  4924			return PTR_ERR(inode);
  4925	
> 4926		ret = fs_info->sb->s_vop->get_verity_descriptor(inode, NULL, 0);
  4927		if (ret < 0)
  4928			goto iput;
  4929	
  4930		if (ret > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
  4931			ret = -EMSGSIZE;
  4932			goto iput;
  4933		}
  4934		if (!sctx->verity_descriptor) {
  4935			sctx->verity_descriptor = kvmalloc(FS_VERITY_MAX_DESCRIPTOR_SIZE, GFP_KERNEL);
  4936			if (!sctx->verity_descriptor) {
  4937				ret = -ENOMEM;
  4938				goto iput;
  4939			}
  4940		}
  4941	
  4942		ret = fs_info->sb->s_vop->get_verity_descriptor(inode, sctx->verity_descriptor, ret);
  4943		if (ret < 0)
  4944			goto iput;
  4945	
  4946		p = fs_path_alloc();
  4947		if (!p) {
  4948			ret = -ENOMEM;
  4949			goto iput;
  4950		}
  4951		ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
  4952		if (ret < 0)
  4953			goto free_path;
  4954	
  4955		ret = send_verity(sctx, p, sctx->verity_descriptor);
  4956		if (ret < 0)
  4957			goto free_path;
  4958	
  4959	free_path:
  4960		fs_path_free(p);
  4961	iput:
  4962		iput(inode);
  4963		return ret;
  4964	}
  4965	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
