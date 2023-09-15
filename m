Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837077A1441
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Sep 2023 05:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjIODRn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 14 Sep 2023 23:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjIODRm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 14 Sep 2023 23:17:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725CC1FC8;
        Thu, 14 Sep 2023 20:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694747858; x=1726283858;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MaDiuZtp6V5mUHTfROEW8D4uVOrgIeTR86RAYSCnNeY=;
  b=Ci3sDpLJCXsjk84hp8UvZVPOed/wUUrAhq+JE2nAHYc9ANcNmU+sqMWW
   MkQJoU0yzWHDHFnr4Hp1B0v9Zc7boOrB5WxvbTYQ3Pvh+MyqYfrmcym3v
   XDpk0Oj2DuX+vAZ4EZ6rhkcrjnpJZgOTsiZdUeUvw29cCsdMhT/KdV5E5
   TLu29RtZ2Y6LCfqifXMPNfLxf9qBXFZHnv2Tpq1g1PZ+8M32aanZDIdSo
   2HbzEelVIEl7lRpxtZRBQ8B76uKFIygMNFdvc9e3rN89SBmbBBZ942+Jn
   /2DHsU7dohm9l9wf/iq7f1aul3jqntwkuzND4MbTJYzLwCQuunQIgzEcW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="378059564"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="378059564"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 20:17:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="744799511"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="744799511"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 14 Sep 2023 20:17:35 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qgzKm-0002N7-2z;
        Fri, 15 Sep 2023 03:17:32 +0000
Date:   Fri, 15 Sep 2023 11:17:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, clm@fb.com, ebiggers@kernel.org,
        ngompa13@gmail.com, sweettea-kernel@dorminy.me,
        kernel-team@meta.com
Cc:     oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 2/4] fscrypt: add per-extent encryption support
Message-ID: <202309151147.DmtmoJbq-lkp@intel.com>
References: <29b2303463c3b4978d17a6a257e7a8aa3da23de4.1694738282.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29b2303463c3b4978d17a6a257e7a8aa3da23de4.1694738282.git.josef@toxicpanda.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Josef,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.6-rc1 next-20230914]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Josef-Bacik/fscrypt-rename-fscrypt_info-fscrypt_inode_info/20230915-085013
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/29b2303463c3b4978d17a6a257e7a8aa3da23de4.1694738282.git.josef%40toxicpanda.com
patch subject: [PATCH 2/4] fscrypt: add per-extent encryption support
config: parisc-allyesconfig (https://download.01.org/0day-ci/archive/20230915/202309151147.DmtmoJbq-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230915/202309151147.DmtmoJbq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309151147.DmtmoJbq-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/crypto/keysetup.c: In function 'fscrypt_load_extent_info':
>> fs/crypto/keysetup.c:904:40: warning: argument to 'sizeof' in 'memcpy' call is the same expression as the source; did you mean to provide an explicit length? [-Wsizeof-pointer-memaccess]
     904 |         memcpy(&extent_ctx, ctx, sizeof(ctx));
         |                                        ^


vim +904 fs/crypto/keysetup.c

   881	
   882	/**
   883	 * fscrypt_load_extent_info() - create an fscrypt_extent_info from the context
   884	 * @inode: the inode
   885	 * @ctx: the context buffer
   886	 * @ctx_size: the size of the context buffer
   887	 *
   888	 * Create the file_extent_info and derive the key based on the
   889	 * fscrypt_extent_context buffer that is probided.
   890	 *
   891	 * Return: The newly allocated fscrypt_extent_info on success, -EOPNOTSUPP if
   892	 *	   we're not encrypted, or another -errno code
   893	 */
   894	struct fscrypt_extent_info *fscrypt_load_extent_info(struct inode *inode,
   895							     u8 *ctx, size_t ctx_size)
   896	{
   897		struct fscrypt_extent_context extent_ctx;
   898	
   899		if (!fscrypt_inode_uses_inline_crypto(inode))
   900			return ERR_PTR(-EOPNOTSUPP);
   901		if (ctx_size < sizeof(extent_ctx))
   902			return ERR_PTR(-EINVAL);
   903	
 > 904		memcpy(&extent_ctx, ctx, sizeof(ctx));
   905		return setup_extent_info(inode, extent_ctx.nonce);
   906	}
   907	EXPORT_SYMBOL(fscrypt_load_extent_info);
   908	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
