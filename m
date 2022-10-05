Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480785F4D6E
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Oct 2022 03:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiJEBj1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 4 Oct 2022 21:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJEBj1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 4 Oct 2022 21:39:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA8B6F549;
        Tue,  4 Oct 2022 18:39:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB6EEB81B58;
        Wed,  5 Oct 2022 01:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31868C433D6;
        Wed,  5 Oct 2022 01:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664933963;
        bh=O7GnV3GZ8sWMiqak8i8Eq13A0JeKTIsLVU3ou5qmmVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZPQubTNEluH0nRBA4Zxp5zowUJv6UFo+Ub4lwbNZrbIjIAe765hKrkILBSXj45HQ
         NvGrt6d/nmG8WFirOJ9dFjDfrUnHL3VHPRBmu5vO5+OWDH7LIjoeczPvlzENdFvMUt
         A5bkEoD8AOaEYvw61GzIKOIGqLANtsMqLTZy1u23nNghb/Dc8hnQRFzVJM7n9llMW3
         P5qGJwsXOxGFwGdKxuQBnKCwxqmrwydgOL1K5vIU1IzbUw/nE8vJRWL1NbriFwCOir
         YIjdE6C2M6m7q372zHJu/sv8PqywaTy4LMuEuNWRXl2WhgcFosO5R5RLLm6GnUYJZB
         OAhXeek33gleQ==
Date:   Tue, 4 Oct 2022 18:39:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Yu Zhao <yuzhao@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: fix lockdep warning
Message-ID: <YzzgSYiCCO8dbms8@sol.localdomain>
References: <20221005001326.157644-1-yuzhao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005001326.157644-1-yuzhao@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 04, 2022 at 06:13:26PM -0600, Yu Zhao wrote:
> fscrypt_initialize() shouldn't allocate memory without GFP_NOFS.
> 
> The problem seems to go back to 2015
> commit 57e5055b0a5e ("f2fs crypto: add f2fs encryption facilities")
> but I have never heard of any complaints, hence not CC'ing stable.
> 
>   ======================================================
>   WARNING: possible circular locking dependency detected
>   6.0.0-lockdep #1 Not tainted
>   ------------------------------------------------------
>   kswapd0/77 is trying to acquire lock:
>   71ffff808b254a18 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x76c/0x8dc
> 
>   but task is already holding lock:
>   ffffffea26533310 (fs_reclaim){+.+.}-{0:0}, at: 0x1
> 
>   which lock already depends on the new lock.
> 
>   <snipped>
> 
>   other info that might help us debug this:
> 
>   Chain exists of:
>     jbd2_handle --> fscrypt_init_mutex --> fs_reclaim
> 
>    Possible unsafe locking scenario:
> 
>          CPU0                    CPU1
>          ----                    ----
>     lock(fs_reclaim);
>                                  lock(fscrypt_init_mutex);
>                                  lock(fs_reclaim);
>     lock(jbd2_handle);
> 
>    *** DEADLOCK ***
> 
>   3 locks held by kswapd0/77:
>    #0: ffffffea26533310 (fs_reclaim){+.+.}-{0:0}, at: 0x1
>    #1: ffffffea26529220 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x54/0x464
>    #2: 6dffff808abe90e8 (&type->s_umount_key#47){++++}-{3:3}, at: trylock_super+0x2c/0x8c
> 
>   <snipped>
> 
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  fs/crypto/crypto.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index e78be66bbf01..e10fc30142a6 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -316,6 +316,7 @@ EXPORT_SYMBOL(fscrypt_decrypt_block_inplace);
>  int fscrypt_initialize(unsigned int cop_flags)
>  {
>  	int err = 0;
> +	unsigned int flags;
>  
>  	/* No need to allocate a bounce page pool if this FS won't use it. */
>  	if (cop_flags & FS_CFLG_OWN_PAGES)
> @@ -326,8 +327,10 @@ int fscrypt_initialize(unsigned int cop_flags)
>  		goto out_unlock;
>  
>  	err = -ENOMEM;
> +	flags = memalloc_nofs_save();
>  	fscrypt_bounce_page_pool =
>  		mempool_create_page_pool(num_prealloc_crypto_pages, 0);
> +	memalloc_nofs_restore(flags);
>  	if (!fscrypt_bounce_page_pool)
>  		goto out_unlock;

Thanks, but this isn't the correct fix.  The real problem is that ext4 is
calling fscrypt_get_encryption_info() from within a jbd2 transaction, which is
fundamentally unsafe.  It's a known regression from commit a80f7fcf1867
("ext4: fixup ext4_fc_track_* functions' signature"), which extended the scope
of the transaction in ext4_unlink() too far.

Sorry for not getting around to fixing this earlier.  Are you interested in
sending a patch for it?  If you do, please make sure to include
"Reported-by: syzbot+1a748d0007eeac3ab079@syzkaller.appspotmail.com",
as there's a syzbot report open already
(https://lore.kernel.org/all/00000000000070395e05dd1fb4d7@google.com/T/#u).

- Eric
