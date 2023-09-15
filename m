Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73637A13C8
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Sep 2023 04:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjIOCXS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 14 Sep 2023 22:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjIOCXS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 14 Sep 2023 22:23:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024A0268A;
        Thu, 14 Sep 2023 19:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694744594; x=1726280594;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LkRtX4xDjrzbuJ0zUvHlNe5UHFdTBTOSsQKpr/EQiEo=;
  b=gHPqTPoSFfzlToHB1FlPvqCPdW5065A+ThxM3h8glO4GKRxmw8ukFEOF
   1hCyHfGtOMnSSORqNHLnGDKL5IZSsAfWjC1EYLWoxoXXaAMxIQl2UcdDe
   n+g+1AOLtj4kiu7vCmODpYsFCLI+IDe63YxIyhcFfciShciuanKGrrhZv
   ++9hky9j3R2iTd9lNUIjZXCKJy1XiWKPRCgyzegx/avjbLKnjm/B6rxtl
   RVJRnj9AsO+PMTjptffXCtjmrM8cQaO4tmKGeq8n0Fe0vgqEmbYbuxv5o
   5ukPacNV/kqBfrZYM2bsscHP/BJIj71DL3AMpwpvF5tsRBoHQtoOpmHj1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="381865738"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="381865738"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 19:23:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="744790536"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="744790536"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 14 Sep 2023 19:23:11 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qgyU8-0002Jb-2g;
        Fri, 15 Sep 2023 02:23:08 +0000
Date:   Fri, 15 Sep 2023 10:22:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, clm@fb.com, ebiggers@kernel.org,
        ngompa13@gmail.com, sweettea-kernel@dorminy.me,
        kernel-team@meta.com
Cc:     oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 2/4] fscrypt: add per-extent encryption support
Message-ID: <202309151037.zysaiWNO-lkp@intel.com>
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
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230915/202309151037.zysaiWNO-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230915/202309151037.zysaiWNO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309151037.zysaiWNO-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/string.h:20,
                    from include/linux/bitmap.h:11,
                    from include/linux/cpumask.h:12,
                    from include/linux/smp.h:13,
                    from include/linux/lockdep.h:14,
                    from include/linux/spinlock.h:63,
                    from include/linux/swait.h:7,
                    from include/linux/completion.h:12,
                    from include/linux/crypto.h:15,
                    from include/crypto/skcipher.h:13,
                    from fs/crypto/keysetup.c:11:
   fs/crypto/keysetup.c: In function 'fscrypt_load_extent_info':
>> fs/crypto/keysetup.c:904:40: warning: argument to 'sizeof' in '__builtin_memcpy' call is the same expression as the source; did you mean to provide an explicit length? [-Wsizeof-pointer-memaccess]
     904 |         memcpy(&extent_ctx, ctx, sizeof(ctx));
         |                                        ^
   arch/m68k/include/asm/string.h:53:48: note: in definition of macro 'memcpy'
      53 | #define memcpy(d, s, n) __builtin_memcpy(d, s, n)
         |                                                ^
--
>> fs/crypto/inline_crypt.c:302: warning: expecting prototype for fscrypt_set_bio_crypt_ctx(). Prototype was for fscrypt_set_bio_crypt_ctx_from_extent() instead


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
