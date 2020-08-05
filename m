Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0ED523C334
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Aug 2020 03:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgHEBye (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 4 Aug 2020 21:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgHEByd (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 4 Aug 2020 21:54:33 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C25952070A;
        Wed,  5 Aug 2020 01:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596592473;
        bh=6WuUaY2tobi7XDMfQxUO1QCMtPwFMpcnoqYaKtUHEIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jxOU7qJip+BIptS9IAJPVXLxIqwsbv6rQlx3hYKXA4nFpt2I11g1koq1zW58tuqEm
         Z7ehSFoTnx4WXRGZzm/ASvj7k1z0M66kpQiFbCP73xyhgNS55qbyGgCFwm07FdygsY
         7r24unP3i462r+a+GMj1mCbf6lWNQGo6v1wghWdM=
Date:   Tue, 4 Aug 2020 18:54:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, linux-fscrypt@vger.kernel.org
Subject: Re: include/asm-generic/mmiowb.h:56:9: sparse: sparse: context
 imbalance in 'fscrypt_put_direct_key' - unexpected unlock
Message-ID: <20200805015431.GA1136@sol.localdomain>
References: <202008050849.sZpPDokm%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008050849.sZpPDokm%lkp@intel.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 05, 2020 at 08:28:53AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   4f30a60aa78410496e5ffe632a371c00f0d83a8d
> commit: 0109ce76dd6e9e69559e56ea9f10d1e12ca4a50b fscrypt: move v1 policy key setup to keysetup_v1.c
> date:   12 months ago
> config: powerpc64-randconfig-s031-20200805 (attached as .config)
> compiler: powerpc64-linux-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.2-117-g8c7aee71-dirty
>         git checkout 0109ce76dd6e9e69559e56ea9f10d1e12ca4a50b
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=powerpc64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
>    fs/crypto/keysetup_v1.c: note: in included file (through arch/powerpc/include/asm/mmiowb.h, include/linux/spinlock.h, include/linux/mmzone.h, ...):
> >> include/asm-generic/mmiowb.h:56:9: sparse: sparse: context imbalance in 'fscrypt_put_direct_key' - unexpected unlock
> 
> vim +/fscrypt_put_direct_key +56 include/asm-generic/mmiowb.h
> 
> d1be6a28b13ce6d Will Deacon 2019-02-22  46  
> d1be6a28b13ce6d Will Deacon 2019-02-22  47  static inline void mmiowb_spin_unlock(void)
> d1be6a28b13ce6d Will Deacon 2019-02-22  48  {
> d1be6a28b13ce6d Will Deacon 2019-02-22  49  	struct mmiowb_state *ms = __mmiowb_state();
> d1be6a28b13ce6d Will Deacon 2019-02-22  50  
> d1be6a28b13ce6d Will Deacon 2019-02-22  51  	if (unlikely(ms->mmiowb_pending)) {
> d1be6a28b13ce6d Will Deacon 2019-02-22  52  		ms->mmiowb_pending = 0;
> d1be6a28b13ce6d Will Deacon 2019-02-22  53  		mmiowb();
> d1be6a28b13ce6d Will Deacon 2019-02-22  54  	}
> d1be6a28b13ce6d Will Deacon 2019-02-22  55  
> d1be6a28b13ce6d Will Deacon 2019-02-22 @56  	ms->nesting_count--;
> 
> :::::: The code at line 56 was first introduced by commit
> :::::: d1be6a28b13ce6d1bc42bf9b6a9454c65839225b asm-generic/mmiowb: Add generic implementation of mmiowb() tracking
> 
> :::::: TO: Will Deacon <will.deacon@arm.com>
> :::::: CC: Will Deacon <will.deacon@arm.com>
> 

False positive because refcount_dec_and_lock() is missing a sparse annotation.
I tried to add one to make it match atomic_dec_and_lock(), but the patch was
rejected: https://lkml.kernel.org/lkml/20191226152922.2034-1-ebiggers@kernel.org/T/#u
