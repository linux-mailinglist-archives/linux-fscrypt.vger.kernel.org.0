Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D4C462865
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 00:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhK2XlL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Nov 2021 18:41:11 -0500
Received: from mga05.intel.com ([192.55.52.43]:56545 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232147AbhK2Xky (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Nov 2021 18:40:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="322337964"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="322337964"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 15:37:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="676571990"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 29 Nov 2021 15:37:24 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mrqD5-000CUd-Bc; Mon, 29 Nov 2021 23:37:23 +0000
Date:   Tue, 30 Nov 2021 07:36:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 1/4] fs-verity: define a function to return the integrity
 protected file digest
Message-ID: <202111300736.Vz00z1Kd-lkp@intel.com>
References: <20211129170057.243127-2-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129170057.243127-2-zohar@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Mimi,

I love your patch! Yet something to improve:

[auto build test ERROR on zohar-integrity/next-integrity]
[also build test ERROR on v5.16-rc3 next-20211129]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Mimi-Zohar/ima-support-fs-verity-signatures-stored-as/20211130-010506
base:   https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git next-integrity
config: arm64-randconfig-r032-20211129 (https://download.01.org/0day-ci/archive/20211130/202111300736.Vz00z1Kd-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/305ad3bb36a5bd51fe30b33f623eaf165e2efb13
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Mimi-Zohar/ima-support-fs-verity-signatures-stored-as/20211130-010506
        git checkout 305ad3bb36a5bd51fe30b33f623eaf165e2efb13
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   aarch64-linux-ld: fs/verity/measure.o: in function `fsverity_measure':
>> (.text+0x968): undefined reference to `hash_algo_name'
   aarch64-linux-ld: fs/verity/measure.o: relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `hash_algo_name' which may bind externally can not be used when making a shared object; recompile with -fPIC
   (.text+0x968): dangerous relocation: unsupported relocation
>> aarch64-linux-ld: (.text+0x96c): undefined reference to `hash_algo_name'
>> aarch64-linux-ld: (.text+0xa8c): undefined reference to `hash_digest_size'
   aarch64-linux-ld: fs/verity/measure.o: relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `hash_digest_size' which may bind externally can not be used when making a shared object; recompile with -fPIC
   (.text+0xa8c): dangerous relocation: unsupported relocation
   aarch64-linux-ld: (.text+0xa9c): undefined reference to `hash_digest_size'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
