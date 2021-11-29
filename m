Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F89346281A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 00:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhK2XTz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Nov 2021 18:19:55 -0500
Received: from mga05.intel.com ([192.55.52.43]:55138 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231804AbhK2XTp (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Nov 2021 18:19:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="322335310"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="322335310"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 15:16:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="540188850"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 29 Nov 2021 15:16:23 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mrpsl-000CU5-8F; Mon, 29 Nov 2021 23:16:23 +0000
Date:   Tue, 30 Nov 2021 07:16:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 1/4] fs-verity: define a function to return the integrity
 protected file digest
Message-ID: <202111300735.5PPAuPnJ-lkp@intel.com>
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
[also build test ERROR on fscrypt/fsverity jmorris-security/next-testing v5.16-rc3 next-20211129]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Mimi-Zohar/ima-support-fs-verity-signatures-stored-as/20211130-010506
base:   https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git next-integrity
config: i386-randconfig-m021-20211129 (https://download.01.org/0day-ci/archive/20211130/202111300735.5PPAuPnJ-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/305ad3bb36a5bd51fe30b33f623eaf165e2efb13
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Mimi-Zohar/ima-support-fs-verity-signatures-stored-as/20211130-010506
        git checkout 305ad3bb36a5bd51fe30b33f623eaf165e2efb13
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: fs/verity/measure.o: in function `fsverity_measure':
   fs/verity/measure.c:89: undefined reference to `hash_algo_name'
>> ld: fs/verity/measure.c:104: undefined reference to `hash_digest_size'
   ld: fs/verity/measure.c:104: undefined reference to `hash_algo_name'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
