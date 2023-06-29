Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31052741E76
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 04:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjF2CpP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 22:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjF2CpP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 22:45:15 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EBA107;
        Wed, 28 Jun 2023 19:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688006713; x=1719542713;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Sz3uHkV84E6YZD5QJn6+OgayMM+VzvSDNs3af7bLUJo=;
  b=n/QyZYeF7QPy6YQjPqqfu//KHarjjD+h9M/TYFR8O9m4KyIFGSkK+Y7u
   9Iy4hF8qfdTvs22cN4KhoPwu9grbSGAC3kLDq8kaHkYm1z+zPFBCGrF+a
   pKpaU7MhbURR/waZ0egWt3Fcqlr8CM9hv39CLC8LKOpBmWHSFdTezv7sT
   1ObyT6tEqCmznzT59PDeOJ1Eki5Vz9J0qzJ1qqNo7msyAVavJ+93Ok/HS
   vP7mqBjN4QdK+S2HSBTe7T4ASz7VQUBkjUjLH7usigqieX7iykKP6EDuy
   5ZbJSRi5yiM1yfNhVqKgIPUVG6UDBmI8LrHAVNI5iUWDNg7L6O5AmbsTd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="351806333"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="351806333"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 19:45:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="787232211"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="787232211"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jun 2023 19:45:06 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qEheb-000DiD-03;
        Thu, 29 Jun 2023 02:45:05 +0000
Date:   Thu, 29 Jun 2023 10:44:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH v4 3/8] fscrypt: split setup_per_mode_enc_key()
Message-ID: <202306291013.yc7R9Rb7-lkp@intel.com>
References: <0ba2cb228aa367aea1442b8f1433f229040fe8dd.1687988119.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ba2cb228aa367aea1442b8f1433f229040fe8dd.1687988119.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Sweet,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 00bc86ea26ac88043f48916c273afc9fbb40c73f]

url:    https://github.com/intel-lab-lkp/linux/commits/Sweet-Tea-Dorminy/fscrypt-move-inline-crypt-decision-to-info-setup/20230629-083929
base:   00bc86ea26ac88043f48916c273afc9fbb40c73f
patch link:    https://lore.kernel.org/r/0ba2cb228aa367aea1442b8f1433f229040fe8dd.1687988119.git.sweettea-kernel%40dorminy.me
patch subject: [PATCH v4 3/8] fscrypt: split setup_per_mode_enc_key()
config: um-randconfig-r014-20230628 (https://download.01.org/0day-ci/archive/20230629/202306291013.yc7R9Rb7-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce: (https://download.01.org/0day-ci/archive/20230629/202306291013.yc7R9Rb7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306291013.yc7R9Rb7-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/crypto/keysetup.c:14:
   In file included from fs/crypto/fscrypt_private.h:17:
   In file included from include/linux/blk-crypto.h:72:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from fs/crypto/keysetup.c:14:
   In file included from fs/crypto/fscrypt_private.h:17:
   In file included from include/linux/blk-crypto.h:72:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from fs/crypto/keysetup.c:14:
   In file included from fs/crypto/fscrypt_private.h:17:
   In file included from include/linux/blk-crypto.h:72:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> fs/crypto/keysetup.c:203:2: warning: variable 'err' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (fscrypt_is_key_prepared(prep_key, ci))
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:55:28: note: expanded from macro 'if'
   #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:57:30: note: expanded from macro '__trace_if_var'
   #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/crypto/keysetup.c:225:9: note: uninitialized use occurs here
           return err;
                  ^~~
   fs/crypto/keysetup.c:203:2: note: remove the 'if' if its condition is always false
           if (fscrypt_is_key_prepared(prep_key, ci))
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:55:23: note: expanded from macro 'if'
   #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                         ^
   fs/crypto/keysetup.c:199:9: note: initialize the variable 'err' to silence this warning
           int err;
                  ^
                   = 0
   13 warnings generated.


vim +203 fs/crypto/keysetup.c

8094c3ceb21ad93 fs/crypto/keyinfo.c  Eric Biggers      2019-01-06  186  
7b4d2231643f5a9 fs/crypto/keysetup.c Sweet Tea Dorminy 2023-06-28  187  static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
7b4d2231643f5a9 fs/crypto/keysetup.c Sweet Tea Dorminy 2023-06-28  188  				       struct fscrypt_prepared_key *prep_key,
7b4d2231643f5a9 fs/crypto/keysetup.c Sweet Tea Dorminy 2023-06-28  189  				       const struct fscrypt_info *ci,
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  190  				       u8 hkdf_context, bool include_fs_uuid)
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  191  {
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  192  	const struct inode *inode = ci->ci_inode;
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  193  	const struct super_block *sb = inode->i_sb;
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  194  	struct fscrypt_mode *mode = ci->ci_mode;
85af90e57ce9697 fs/crypto/keysetup.c Eric Biggers      2019-12-09  195  	const u8 mode_num = mode - fscrypt_modes;
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  196  	u8 mode_key[FSCRYPT_MAX_KEY_SIZE];
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  197  	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  198  	unsigned int hkdf_infolen = 0;
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  199  	int err;
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  200  
e3b1078bedd323d fs/crypto/keysetup.c Eric Biggers      2020-05-15  201  	mutex_lock(&fscrypt_mode_key_setup_mutex);
e3b1078bedd323d fs/crypto/keysetup.c Eric Biggers      2020-05-15  202  
5fee36095cda45d fs/crypto/keysetup.c Satya Tangirala   2020-07-02 @203  	if (fscrypt_is_key_prepared(prep_key, ci))
7b4d2231643f5a9 fs/crypto/keysetup.c Sweet Tea Dorminy 2023-06-28  204  		goto out_unlock;
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  205  
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  206  	BUILD_BUG_ON(sizeof(mode_num) != 1);
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  207  	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  208  	BUILD_BUG_ON(sizeof(hkdf_info) != 17);
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  209  	hkdf_info[hkdf_infolen++] = mode_num;
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  210  	if (include_fs_uuid) {
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  211  		memcpy(&hkdf_info[hkdf_infolen], &sb->s_uuid,
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  212  		       sizeof(sb->s_uuid));
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  213  		hkdf_infolen += sizeof(sb->s_uuid);
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  214  	}
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  215  	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
b103fb7653fff09 fs/crypto/keysetup.c Eric Biggers      2019-10-24  216  				  hkdf_context, hkdf_info, hkdf_infolen,
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  217  				  mode_key, mode->keysize);
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  218  	if (err)
e3b1078bedd323d fs/crypto/keysetup.c Eric Biggers      2020-05-15  219  		goto out_unlock;
5fee36095cda45d fs/crypto/keysetup.c Satya Tangirala   2020-07-02  220  	err = fscrypt_prepare_key(prep_key, mode_key, ci);
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  221  	memzero_explicit(mode_key, mode->keysize);
7b4d2231643f5a9 fs/crypto/keysetup.c Sweet Tea Dorminy 2023-06-28  222  
e3b1078bedd323d fs/crypto/keysetup.c Eric Biggers      2020-05-15  223  out_unlock:
e3b1078bedd323d fs/crypto/keysetup.c Eric Biggers      2020-05-15  224  	mutex_unlock(&fscrypt_mode_key_setup_mutex);
e3b1078bedd323d fs/crypto/keysetup.c Eric Biggers      2020-05-15  225  	return err;
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  226  }
5dae460c2292dbb fs/crypto/keysetup.c Eric Biggers      2019-08-04  227  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
