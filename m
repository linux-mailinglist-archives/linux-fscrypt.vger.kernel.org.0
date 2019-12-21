Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED0D5128BEB
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Dec 2019 00:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfLUXoc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 21 Dec 2019 18:44:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfLUXoc (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 21 Dec 2019 18:44:32 -0500
Received: from zzz.localdomain (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D54C6206C3;
        Sat, 21 Dec 2019 23:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576971871;
        bh=/MbmDcTEwVowvKdcdYIrMJXZYMe8rRNFMqhcO4g8FG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xXFAw8dwgY96VEuOfsyirRJGNvEHOYzNRor8af+MUeUJD3sMeqVicuIYD/9yk8B3M
         1YLrJLAssviGzR0mbbbPGAO+47zJl4n4ubsQJ9+RdN5WazYSPVBdguVtcHbMFFXXrY
         DGXOjPAVB5+D6jnBKDE+u5dc8cOrvnD0/KYcBxw0=
Date:   Sat, 21 Dec 2019 17:44:28 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Restore modular support
Message-ID: <20191221234428.GA551@zzz.localdomain>
References: <20191221143020.hbgeixvlmzt7nh54@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191221143020.hbgeixvlmzt7nh54@gondor.apana.org.au>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Dec 21, 2019 at 10:30:20PM +0800, Herbert Xu wrote:
> The commit 643fa9612bf1 ("fscrypt: remove filesystem specific
> build config option") removed modular support for fs/crypto.  This
> causes the Crypto API to be built-in whenever fscrypt is enabled.
> This makes it very difficult for me to test modular builds of
> the Crypto API without disabling fscrypt which is a pain.
> 
> AFAICS there is no reason why fscrypt has to be built-in.  The
> commit above appears to have done this way purely for the sake of
> simplicity.  In fact some simple Kconfig tweaking is sufficient
> to retain a single FS_ENCRYPTION option while maintaining modularity.
> 
> This patch restores modular support to fscrypt by adding a new
> hidden FS_ENCRYPTION_TRI tristate option that is selected by all
> the FS_ENCRYPTION users.
> 
> Subsequent to the above commit, some core code has been introduced
> to fs/buffer.c that makes restoring modular support non-trivial.
> This patch deals with this by adding a function pointer that defaults
> to end_buffer_async_read function until fscrypt is loaded.  When
> fscrypt is loaded it modifies the function pointer to its own
> function which used to be end_buffer_async_read_io but now resides
> in fscrypt.  When it is unloaded the function pointer is restored.
> 
> In order for this to be safe with respect to module removal, the
> check for whether the host inode is encrypted has been moved into
> mark_buffer_async_read.  The assumption is that as long as the
> bh is alive the calling filesystem module will be resident.  The
> calling filesystem would then guarantee that fscrypt is loaded.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

I'm not sure this is a good idea, since there will probably need to be more
places where built-in code calls into fs/crypto/ too.

There's actually already fscrypt_sb_free(), which this patch forgets to handle:

	void fscrypt_sb_free(struct super_block *sb)
	{
		key_put(sb->s_master_keys);
		sb->s_master_keys = NULL;
	}

Though we could make that an inline function.

But there's also a patch under review which adds inline encryption support to
ext4 and f2fs, which requires calling into fs/crypto/ from fs/buffer.c in order
to set an encryption context on bios:

https://lkml.kernel.org/linux-fscrypt/20191218145136.172774-10-satyat@google.com/

If we also add direct I/O support for inline encryption (which is planned), it
would require calling into fs/crypto/ from fs/direct-io.c and
fs/iomap/direct-io.c as well.

Another thing I've been thinking about is adding decryption support to
__block_write_begin(), which would allow us to delete ext4_block_write_begin(),
which was copied from __block_write_begin() to add decryption support.

So more broadly, the issue is that a lot of the filesystem I/O helpers
(fs/buffer.c, fs/iomap/, fs/direct-io.c, fs/mpage.c) are already built-in, and
it can be necessary to call into fs/crypto/ from such places.

Is it really much of an issue to just disable CONFIG_FS_ENCRYPTION when you want
to test building the crypto API as a module?

> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 3719efa546c6..6bf7f05120bd 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -20,6 +20,7 @@
>   * Special Publication 800-38E and IEEE P1619/D16.
>   */
>  
> +#include <linux/buffer_head.h>
>  #include <linux/pagemap.h>
>  #include <linux/mempool.h>
>  #include <linux/module.h>
> @@ -286,6 +287,41 @@ int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page *page,
>  }
>  EXPORT_SYMBOL(fscrypt_decrypt_block_inplace);
>  
> +struct decrypt_bh_ctx {
> +	struct work_struct work;
> +	struct buffer_head *bh;
> +};
> +
> +static void decrypt_bh(struct work_struct *work)
> +{
> +	struct decrypt_bh_ctx *ctx =
> +		container_of(work, struct decrypt_bh_ctx, work);
> +	struct buffer_head *bh = ctx->bh;
> +	int err;
> +
> +	err = fscrypt_decrypt_pagecache_blocks(bh->b_page, bh->b_size,
> +					       bh_offset(bh));
> +	end_buffer_async_read(bh, err == 0);
> +	kfree(ctx);
> +}
> +
> +static void fscrypt_end_buffer_async_read(struct buffer_head *bh, int uptodate)
> +{
> +	/* Decrypt if needed */
> +	if (uptodate) {
> +		struct decrypt_bh_ctx *ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
> +
> +		if (ctx) {
> +			INIT_WORK(&ctx->work, decrypt_bh);
> +			ctx->bh = bh;
> +			fscrypt_enqueue_decrypt_work(&ctx->work);
> +			return;
> +		}
> +		uptodate = 0;
> +	}
> +	end_buffer_async_read(bh, uptodate);
> +}
> +
>  /*
>   * Validate dentries in encrypted directories to make sure we aren't potentially
>   * caching stale dentries after a key has been added.
> @@ -418,6 +454,8 @@ static int __init fscrypt_init(void)
>  	if (err)
>  		goto fail_free_info;
>  
> +	end_buffer_async_read_io = fscrypt_end_buffer_async_read;
> +
>  	return 0;

This code would actually need to go into fs/crypto/bio.c because it depends on
CONFIG_BLOCK.  UBIFS uses fs/crypto/ without CONFIG_BLOCK necessarily being set.

> +/**
> + * fscrypt_exit() - Shutdown the fs encryption system
> + */
> +static void __exit fscrypt_exit(void)
> +{
> +	end_buffer_async_read_io = end_buffer_async_read;
> +
> +	kmem_cache_destroy(fscrypt_info_cachep);
> +	destroy_workqueue(fscrypt_read_workqueue);
> +}
> +module_exit(fscrypt_exit);

There's a bit more that would need to be done here:

	mempool_destroy(fscrypt_bounce_page_pool);

and

	fscrypt_exit_keyring()
		=> unregister_key_type(&key_type_fscrypt);
		=> unregister_key_type(&key_type_fscrypt_user);

- Eric
