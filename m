Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A87A775238
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 07:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjHIFa3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Aug 2023 01:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjHIFa1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Aug 2023 01:30:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2851BF0;
        Tue,  8 Aug 2023 22:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691559026; x=1723095026;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cPWzYVofjOoJIzEOUur/17QFCj6qfWWt5CL6LmcTrsk=;
  b=W89R4jvCe6R+Wuv5aEVhwqLHBbCdR5xqlLlaHfIkwo+rovX2NRefsOJ8
   9QsadClwyG+R3JR1510fjy1jaMrQZ5rsdxRKRJNzWTeQPz4g0eqFuhAbx
   Iz6B4PPunSt7sn1L/Zzs0W/x6yruXow4sQ0ls9E4G1sF39yq10NOf3PqD
   dZM5Z50WwEQrvGnoR3IW7IaLiqUmxP+X/sNfiwL+ums2YJw389NVyey6t
   M72ggToDmVhWpvVJ8tVblMtGW7oDMP8Hvz4oag7+EdZVkbKuWCw77CxTx
   LZM9fqQwax0BmMB3NgL59pT91V/dyku1ZCgYMAPLOF28rQCyj2lRxZd3s
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="351333510"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="351333510"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 22:30:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="845793717"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="845793717"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 08 Aug 2023 22:30:23 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qTbm2-0005pY-0z;
        Wed, 09 Aug 2023 05:30:22 +0000
Date:   Wed, 9 Aug 2023 13:30:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH v6 5/8] fscrypt: reduce special-casing of IV_INO_LBLK_32
Message-ID: <202308091311.R1mgw8Sk-lkp@intel.com>
References: <542ea134771e2caa3043dfe48c2825d93495c626.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542ea134771e2caa3043dfe48c2825d93495c626.1691505830.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Sweet,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 54d2161835d828a9663f548f61d1d9c3d3482122]

url:    https://github.com/intel-lab-lkp/linux/commits/Sweet-Tea-Dorminy/fscrypt-move-inline-crypt-decision-to-info-setup/20230809-030251
base:   54d2161835d828a9663f548f61d1d9c3d3482122
patch link:    https://lore.kernel.org/r/542ea134771e2caa3043dfe48c2825d93495c626.1691505830.git.sweettea-kernel%40dorminy.me
patch subject: [PATCH v6 5/8] fscrypt: reduce special-casing of IV_INO_LBLK_32
config: hexagon-randconfig-r041-20230808 (https://download.01.org/0day-ci/archive/20230809/202308091311.R1mgw8Sk-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce: (https://download.01.org/0day-ci/archive/20230809/202308091311.R1mgw8Sk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308091311.R1mgw8Sk-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/crypto/keysetup.c:14:
   In file included from fs/crypto/fscrypt_private.h:17:
   In file included from include/linux/blk-crypto.h:72:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
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
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
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
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
>> fs/crypto/keysetup.c:315:6: warning: variable 'err' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (mk->mk_ino_hash_key_initialized)
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/crypto/keysetup.c:328:9: note: uninitialized use occurs here
           return err;
                  ^~~
   fs/crypto/keysetup.c:315:2: note: remove the 'if' if its condition is always false
           if (mk->mk_ino_hash_key_initialized)
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/crypto/keysetup.c:307:9: note: initialize the variable 'err' to silence this warning
           int err;
                  ^
                   = 0
   7 warnings generated.


vim +315 fs/crypto/keysetup.c

a992b20cd4ee36 Eric Biggers      2020-09-16  304  
3d3afe7cb13fb9 Sweet Tea Dorminy 2023-08-08  305  static int fscrypt_setup_ino_hash_key(struct fscrypt_master_key *mk)
e3b1078bedd323 Eric Biggers      2020-05-15  306  {
e3b1078bedd323 Eric Biggers      2020-05-15  307  	int err;
e3b1078bedd323 Eric Biggers      2020-05-15  308  
e3b1078bedd323 Eric Biggers      2020-05-15  309  	/* pairs with smp_store_release() below */
3d3afe7cb13fb9 Sweet Tea Dorminy 2023-08-08  310  	if (smp_load_acquire(&mk->mk_ino_hash_key_initialized))
3d3afe7cb13fb9 Sweet Tea Dorminy 2023-08-08  311  		return 0;
e3b1078bedd323 Eric Biggers      2020-05-15  312  
e3b1078bedd323 Eric Biggers      2020-05-15  313  	mutex_lock(&fscrypt_mode_key_setup_mutex);
e3b1078bedd323 Eric Biggers      2020-05-15  314  
e3b1078bedd323 Eric Biggers      2020-05-15 @315  	if (mk->mk_ino_hash_key_initialized)
e3b1078bedd323 Eric Biggers      2020-05-15  316  		goto unlock;
e3b1078bedd323 Eric Biggers      2020-05-15  317  
2fc2b430f559fd Eric Biggers      2021-06-05  318  	err = fscrypt_derive_siphash_key(mk,
2fc2b430f559fd Eric Biggers      2021-06-05  319  					 HKDF_CONTEXT_INODE_HASH_KEY,
2fc2b430f559fd Eric Biggers      2021-06-05  320  					 NULL, 0, &mk->mk_ino_hash_key);
e3b1078bedd323 Eric Biggers      2020-05-15  321  	if (err)
e3b1078bedd323 Eric Biggers      2020-05-15  322  		goto unlock;
e3b1078bedd323 Eric Biggers      2020-05-15  323  	/* pairs with smp_load_acquire() above */
e3b1078bedd323 Eric Biggers      2020-05-15  324  	smp_store_release(&mk->mk_ino_hash_key_initialized, true);
e3b1078bedd323 Eric Biggers      2020-05-15  325  unlock:
e3b1078bedd323 Eric Biggers      2020-05-15  326  	mutex_unlock(&fscrypt_mode_key_setup_mutex);
e3b1078bedd323 Eric Biggers      2020-05-15  327  
3d3afe7cb13fb9 Sweet Tea Dorminy 2023-08-08  328  	return err;
e3b1078bedd323 Eric Biggers      2020-05-15  329  }
e3b1078bedd323 Eric Biggers      2020-05-15  330  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
