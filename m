Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF5774272E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 15:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjF2NU6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Jun 2023 09:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjF2NU4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Jun 2023 09:20:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BE230C4;
        Thu, 29 Jun 2023 06:20:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BFC5C1FD64;
        Thu, 29 Jun 2023 13:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1688044853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QvTDCa/uhtEM7XquLdIc5NNG9cp3ML/WUAmMuXWtKVc=;
        b=fPtNxQQ3BiMU4MjokGTENT8uo/fUA2ZGg8k4S/NwJU1RAexg+xDL1b6Hy9GfVJ9rhw1+5h
        0uUmZ9NpkECgXtMqVP/q91OlFrkmEKe75aq+gUYZ8pQCkGDUNMpmKL+Rq5fudZbxpL/4pd
        QjBZNyaFjxQRUDQ++SL5w3h/NyuED7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1688044853;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QvTDCa/uhtEM7XquLdIc5NNG9cp3ML/WUAmMuXWtKVc=;
        b=xwGf+uFBhqNMui08S6cth/XJKxlAuYTLBfMM2U2rc77KmGe3cYlFTpClvNftsv5a1AyLVa
        TUgNpPoeJwZP+oBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 237E4139FF;
        Thu, 29 Jun 2023 13:20:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id laF7BTWFnWTcdAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 29 Jun 2023 13:20:53 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 254e65c1;
        Thu, 29 Jun 2023 13:20:52 +0000 (UTC)
Date:   Thu, 29 Jun 2023 14:20:52 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v1 11/17] btrfs: add get_devices hook for fscrypt
Message-ID: <ZJ2FNJaVwDOLl6yG@suse.de>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
 <2a8b091cdb0993ad1cc618643e6df49d1aac9045.1687988380.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a8b091cdb0993ad1cc618643e6df49d1aac9045.1687988380.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi!

On Wed, Jun 28, 2023 at 08:35:34PM -0400, Sweet Tea Dorminy wrote:
> Since extent encryption requires inline encryption, even though we
> expect to use the inlinecrypt software fallback most of the time, we
> need to enumerate all the devices in use by btrfs.
> 
> I'm not sure this is the correct list of active devices and it isn't
> tested with any multi-device test yet.

To be honest, I can't say whether this is the correct list either (sorry,
I'm new here!).  However, a quick test shows me there's something wrong
with this code because I'm seeing the lockdep splat bellow: mutex_lock()
can't be called here.

It's very easy to reproduce with the fscrypt userspace tool, simply doing
an 'fscrypt lock' in an encrypted directory.

Cheers,
--
Luís

> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/fscrypt.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> index 20727d920841..658a67856de6 100644
> --- a/fs/btrfs/fscrypt.c
> +++ b/fs/btrfs/fscrypt.c
> @@ -11,7 +11,9 @@
>  #include "ioctl.h"
>  #include "messages.h"
>  #include "root-tree.h"
> +#include "super.h"
>  #include "transaction.h"
> +#include "volumes.h"
>  #include "xattr.h"
>  
>  /*
> @@ -162,9 +164,37 @@ static bool btrfs_fscrypt_empty_dir(struct inode *inode)
>  	return inode->i_size == BTRFS_EMPTY_DIR_SIZE;
>  }
>  
> +static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
> +						       unsigned int *num_devs)
> +{
> +	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
> +	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> +	struct block_device **devs;
> +	struct btrfs_device *device;
> +	int i;
> +
> +	devs = kmalloc_array(fs_devices->num_devices, sizeof(*devs),
> +		GFP_KERNEL);
> +	if (!devs)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mutex_lock(&fs_devices->device_list_mutex);
> +	i = 0;
> +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
> +		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
> +			continue;
> +
> +		devs[i++] = device->bdev;
> +	}
> +	mutex_unlock(&fs_devices->device_list_mutex);
> +	*num_devs = i;
> +	return devs;
> +}
> +
>  const struct fscrypt_operations btrfs_fscrypt_ops = {
>  	.get_context = btrfs_fscrypt_get_context,
>  	.set_context = btrfs_fscrypt_set_context,
>  	.empty_dir = btrfs_fscrypt_empty_dir,
> +	.get_devices = btrfs_fscrypt_get_devices,
>  	.key_prefix = "btrfs:"
>  };
> -- 
> 2.40.1
> 
[   79.809077] =============================
[   79.810268] [ BUG: Invalid wait context ]
[   79.811370] 6.4.0-rc7+ #6 Not tainted
[   79.812451] -----------------------------
[   79.813561] fscrypt/233 is trying to lock:
[   79.814576] ffff88812e7b78d8 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: btrfs_fscrypt_get_devices+0x8a/0x140 [btrfs]
[   79.817937] other info that might help us debug this:
[   79.819436] context-{4:4}
[   79.820227] 1 lock held by fscrypt/233:
[   79.821335]  #0: ffff888111afb7b8 (&tree->lock){++++}-{2:2}, at: btrfs_drop_extent_map_range+0x9f9/0xac0 [btrfs]
[   79.824674] stack backtrace:
[   79.825478] CPU: 0 PID: 233 Comm: fscrypt Not tainted 6.4.0-rc7+ #6
[   79.827186] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
[   79.829975] Call Trace:
[   79.830562]  <TASK>
[   79.831051]  dump_stack_lvl+0x46/0x80
[   79.831832]  __lock_acquire+0xd05/0x3320
[   79.832636]  ? _raw_spin_unlock_irqrestore+0x2b/0x50
[   79.833642]  ? __stack_depot_save+0x207/0x440
[   79.834537]  ? __pfx___lock_acquire+0x10/0x10
[   79.835442]  ? btrfs_fscrypt_get_devices+0x65/0x140 [btrfs]
[   79.836836]  ? kasan_save_stack+0x2b/0x40
[   79.837751]  ? kasan_save_stack+0x1c/0x40
[   79.838643]  lock_acquire+0x14f/0x390
[   79.839498]  ? btrfs_fscrypt_get_devices+0x8a/0x140 [btrfs]
[   79.841052]  ? __pfx_lock_acquire+0x10/0x10
[   79.841965]  ? entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   79.843106]  ? lock_acquire+0x14f/0x390
[   79.843928]  ? __create_object+0x250/0x620
[   79.844786]  ? __pfx_lock_acquire+0x10/0x10
[   79.845691]  __mutex_lock+0xf2/0x1210
[   79.846457]  ? btrfs_fscrypt_get_devices+0x8a/0x140 [btrfs]
[   79.847883]  ? __kmem_cache_alloc_node+0x154/0x250
[   79.848822]  ? btrfs_fscrypt_get_devices+0x8a/0x140 [btrfs]
[   79.850214]  ? mark_held_locks+0x65/0x90
[   79.851007]  ? __pfx___mutex_lock+0x10/0x10
[   79.851800]  ? lockdep_hardirqs_on_prepare+0x132/0x200
[   79.852746]  ? _raw_spin_unlock_irqrestore+0x2b/0x50
[   79.853625]  ? kasan_set_track+0x21/0x30
[   79.854366]  ? __kasan_kmalloc+0x8b/0x90
[   79.855109]  ? btrfs_fscrypt_get_devices+0x8a/0x140 [btrfs]
[   79.856319]  btrfs_fscrypt_get_devices+0x8a/0x140 [btrfs]
[   79.857458]  fscrypt_get_devices+0x3a/0xc0
[   79.858137]  fscrypt_destroy_inline_crypt_key+0x6c/0xe0
[   79.859006]  ? __pfx_fscrypt_destroy_inline_crypt_key+0x10/0x10
[   79.860016]  ? __pfx_truncate_inode_pages_range+0x10/0x10
[   79.860849]  put_crypt_info+0x13b/0x180
[   79.861435]  fscrypt_free_extent_info+0x11/0x30
[   79.862175]  free_extent_map+0x5a/0xf0 [btrfs]
[   79.863145]  btrfs_drop_extent_map_range+0xa66/0xac0 [btrfs]
[   79.864221]  ? __lockdep_reset_lock+0x80/0xb0
[   79.864878]  ? truncate_inode_pages_final+0x42/0x60
[   79.865637]  ? __pfx_lock_release+0x10/0x10
[   79.866285]  ? do_raw_spin_lock+0x104/0x180
[   79.866935]  ? __pfx_btrfs_drop_extent_map_range+0x10/0x10 [btrfs]
[   79.868066]  ? lockdep_hardirqs_on_prepare+0x132/0x200
[   79.868798]  btrfs_evict_inode+0x14b/0x660 [btrfs]
[   79.869738]  ? __pfx_btrfs_evict_inode+0x10/0x10 [btrfs]
[   79.870707]  ? lock_release+0x1c5/0x380
[   79.871297]  ? evict+0x137/0x2a0
[   79.871793]  ? __pfx_lock_release+0x10/0x10
[   79.872386]  ? __pfx_wake_bit_function+0x10/0x10
[   79.873070]  evict+0x155/0x2a0
[   79.873532]  try_to_lock_encrypted_files+0x211/0x4b0
[   79.874244]  ? __pfx_try_to_lock_encrypted_files+0x10/0x10
[   79.874981]  ? do_remove_key.isra.0+0x2da/0x3e0
[   79.875636]  ? lockdep_hardirqs_on_prepare+0x132/0x200
[   79.876368]  ? up_write+0xfb/0x2d0
[   79.876833]  do_remove_key.isra.0+0x36a/0x3e0
[   79.877441]  ? __pfx_do_remove_key.isra.0+0x10/0x10
[   79.878111]  btrfs_ioctl+0x1cf1/0x4000 [btrfs]
[   79.878919]  ? __pfx_btrfs_ioctl+0x10/0x10 [btrfs]
[   79.879805]  ? __pfx___lock_acquire+0x10/0x10
[   79.880381]  ? mark_held_locks+0x24/0x90
[   79.880928]  ? do_sys_openat2+0xce/0x240
[   79.881441]  ? do_vfs_ioctl+0xb2f/0xca0
[   79.881948]  ? __pfx_do_vfs_ioctl+0x10/0x10
[   79.882483]  ? lock_acquire+0x14f/0x390
[   79.883007]  ? __pfx___fget_files+0x10/0x10
[   79.883566]  ? find_held_lock+0x83/0xa0
[   79.884062]  ? lock_release+0x1c5/0x380
[   79.884551]  ? __fget_files+0x129/0x200
[   79.885051]  ? __pfx_lock_release+0x10/0x10
[   79.885598]  ? map_id_up+0xd7/0x150
[   79.886037]  ? __pfx_map_id_up+0x10/0x10
[   79.886532]  ? __fget_files+0x141/0x200
[   79.887049]  __x64_sys_ioctl+0xc1/0xe0
[   79.887537]  do_syscall_64+0x42/0x90
[   79.887965]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   79.888587] RIP: 0033:0x405e8e
[   79.888976] Code: 48 89 6c 24 38 48 8d 6c 24 38 e8 0d 00 00 00 48 8b 6c 24 38 48 83 c4 40 c3 cc cc cc 49 89 f2 48 89 fa 48 89 ce 48 89 df 0f 05 <48> 3d 01 f0 ff ff 76 158
[   79.891248] RSP: 002b:000000c0000ed3f8 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[   79.892146] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000405e8e
[   79.892967] RDX: 000000c0000ed540 RSI: 00000000c0406618 RDI: 0000000000000003
[   79.893829] RBP: 000000c0000ed438 R08: 0000000000000000 R09: 0000000000000000
[   79.894677] R10: 0000000000000000 R11: 0000000000000206 R12: 000000c0000b2b90
[   79.895503] R13: 0000000000000000 R14: 000000c0000061a0 R15: ffffffffffffffff
[   79.896329]  </TASK>
