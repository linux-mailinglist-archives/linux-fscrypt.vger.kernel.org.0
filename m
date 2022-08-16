Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8265957B2
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Aug 2022 12:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiHPKLv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 16 Aug 2022 06:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiHPKL0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 16 Aug 2022 06:11:26 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3766A326D8;
        Tue, 16 Aug 2022 02:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660641054; x=1692177054;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZtSrh9C0lgdgBWQ5yjV5+/6+DtYvBCZy2ZJIkPl3zfs=;
  b=JwiXphuWRAuS6XfaV/viPJ2htJ2aM17O4OqNwOQP0rMcR+15BS04Bb+n
   lqJKgtpdU4zrlO9qO9zzN9wspJgW96+Uwull9vKnSrgtJ6iIUBpKCi2Af
   v8wDTuO/fkwBxTt1+Oaw4TKixMrR3y7GnakmBg7qjz1LUWCT6+87pwyuN
   9UVIPB6CHPQSxRkUwT+CSZuNQJeIh3U+u4EyHqx7pb9yQJyTbziObF5BX
   gO90vglUhEr6ywVt9ypzu0ZIZOg1zXstGXfWYBQXNFVWgsNb9P9XrQMgz
   PuQpkTy5xX+NEOQeKoeGHJZ/Y9/2CdRcfmpPLNtiKFfWmhJ+1wfxENyZx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="275223216"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="275223216"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 02:10:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="934830021"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 16 Aug 2022 02:10:51 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNsb5-0001fV-1J;
        Tue, 16 Aug 2022 09:10:51 +0000
Date:   Tue, 16 Aug 2022 17:09:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-fscrypt@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH v4] btrfs: send: add support for fs-verity
Message-ID: <202208161755.1c2WmPnn-lkp@intel.com>
References: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Boris,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kdave/for-next]
[also build test WARNING on linus/master v6.0-rc1 next-20220816]
[cannot apply to fscrypt/fsverity]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Boris-Burkov/btrfs-send-add-support-for-fs-verity/20220816-130051
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
config: sparc-randconfig-c003-20220815 (https://download.01.org/0day-ci/archive/20220816/202208161755.1c2WmPnn-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

cocci warnings: (new ones prefixed by >>)
>> fs/btrfs/send.c:6874:5-8: Unneeded variable: "ret". Return "0" on line 6880

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
