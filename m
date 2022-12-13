Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6060664BC70
	for <lists+linux-fscrypt@lfdr.de>; Tue, 13 Dec 2022 19:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbiLMSzB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 13 Dec 2022 13:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbiLMSzA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 13 Dec 2022 13:55:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D1D1DDEC;
        Tue, 13 Dec 2022 10:54:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 911E5CE1784;
        Tue, 13 Dec 2022 18:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8011C433EF;
        Tue, 13 Dec 2022 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670957695;
        bh=dW7PxafR2nLb4Pz9N7biRBiffrpy3fpNqnmPXg08GNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tqyXUFemEIUFlf7GAGVOknNCyIZCjHflkzJr/CaRA2vINWL13+uhUUce3sPqfP2kh
         Go7pKpQBgHol+bZ0PBPiEbp2w2CmpNDc0varO1C7AmmB71u93Z8eD62Ddaxm9LOCO/
         QezKvAhy41MVaLF5MgSlBmvzDgHzjraCToC+11A1kZKHcd2h+ogeXzPA/ttww9eYOW
         hbZIui7GZc4IsIOEaVQoBMDLPJrMQiy7CQvsFqYN2HqwO0pEwzI5cN4C8vf2L/1llt
         Uphqun7gySrXBWalvtssaxmyqljUNCpIKS1a3aTVNZePRde1Gpzt/p3aPguNyYZOTV
         IOEL113enzpXA==
Date:   Tue, 13 Dec 2022 10:54:53 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jun Nie <jun.nie@linaro.org>
Cc:     tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Fix null pointer when defer i_crypt_info
Message-ID: <Y5jKfdDrJkdKtEbC@sol.localdomain>
References: <20221213081103.2182231-1-jun.nie@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213081103.2182231-1-jun.nie@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 13, 2022 at 04:11:03PM +0800, Jun Nie wrote:
> syzbot report below bug[1]. Fix it with checking null pointer before
> deferring i_crypt_info.
> 
> [1]
> general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 3 PID: 456 Comm: repro Not tainted 6.1.0+gc0daf896 #169
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:fscrypt_limit_io_blocks+0xfa/0x2c0
> Call Trace:
>  <TASK>
>  ext4_iomap_begin+0x6c5/0x7e0
>  ? asym_cpu_capacity_scan+0x6b0/0x6b0
>  ? ext4_iomap_begin_report+0x6b0/0x6b0
>  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
>  ? ext4_commit_super+0x3c1/0x560
>  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
>  ? ext4_handle_error+0x3bf/0x6b0
>  ? ext4_iomap_begin_report+0x6b0/0x6b0
>  iomap_iter+0x538/0xc80
>  iomap_bmap+0x1ed/0x2d0
>  ? iomap_to_fiemap+0x220/0x220
>  ? rwsem_down_read_slowpath+0xc00/0xc00
>  ? __ext4_iget+0x19c/0x4370
>  ext4_bmap+0x288/0x470
>  ? mpage_prepare_extent_to_map+0xd80/0xd80
>  bmap+0xb1/0x120
>  jbd2_journal_init_inode+0x7d/0x3f0
>  ? up_write+0x6c/0xb0
>  ? jbd2_journal_init_dev+0x130/0x130
>  ? register_shrinker+0x33/0x160
>  ext4_fill_super+0xa467/0xc650
>  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
>  ? ext4_reconfigure+0x2ad0/0x2ad0
>  ? snprintf+0xbb/0xf0
>  ? vsprintf+0x40/0x40
>  ? up_write+0x6c/0xb0
>  ? __sanitizer_cov_trace_cmp4+0x16/0x20
>  ? set_blocksize+0x2f0/0x380
>  get_tree_bdev+0x438/0x740
>  ? get_tree_bdev+0x438/0x740
>  ? ext4_reconfigure+0x2ad0/0x2ad0
>  ext4_get_tree+0x1d/0x30
>  vfs_get_tree+0x88/0x2e0
>  path_mount+0x6ca/0x1ec0
>  ? putname+0x110/0x150
>  ? finish_automount+0x790/0x790
>  ? putname+0x115/0x150
>  __x64_sys_mount+0x2aa/0x340
>  ? copy_mnt_ns+0xab0/0xab0
>  ? __sanitizer_cov_trace_cmp4+0x16/0x20
>  ? exit_to_user_mode_prepare+0x40/0x120
>  do_syscall_64+0x35/0x80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Fixes: 5fee36095cda ("fscrypt: add inline encryption support")
> Reported-by: syzbot+ba9dac45bc76c490b7c3@syzkaller.appspotmail.com
> Signed-off-by: Jun Nie <jun.nie@linaro.org>
> ---
>  fs/crypto/inline_crypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
> index cea8b14007e6..fec859e83774 100644
> --- a/fs/crypto/inline_crypt.c
> +++ b/fs/crypto/inline_crypt.c
> @@ -232,7 +232,7 @@ void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
>  
>  bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
>  {
> -	return inode->i_crypt_info->ci_inlinecrypt;
> +	return inode->i_crypt_info && inode->i_crypt_info->ci_inlinecrypt;
>  }
>  EXPORT_SYMBOL_GPL(__fscrypt_inode_uses_inline_crypto);

Thanks, but this has already been fixed upstream by commit 105c78e12468
("ext4: don't allow journal inode to have encrypt flag").

Also, I don't think adding a NULL check to __fscrypt_inode_uses_inline_crypto()
is a good idea because it is only meant to be called when the inode's encryption
key has already been set up.  Instead of making the function return a
potentially-incorrect result, it was better to address the root cause of why it
was being called at an inappropriate time in the first place.

- Eric
