Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC6465B771
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Jan 2023 22:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjABVrH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Jan 2023 16:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjABVrH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Jan 2023 16:47:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E6FDCA;
        Mon,  2 Jan 2023 13:47:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D0CEB80D75;
        Mon,  2 Jan 2023 21:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C30C433EF;
        Mon,  2 Jan 2023 21:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672696021;
        bh=PSXKk4PVKyh1BroEW4gko8wVuvq5tiMkNwz5i6FzOTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eIXTCiGNvgI3mb9k6ylRcIXcRBadSjLU72Vb3QkB/+ogrXvTu1N/rBIa3JIQBQCwn
         KkibC3fZh29vCmQU8VXh9NHilGypLaiQhv91jmGoto8u/ELSqeOSI6LKqMTPDCQQPh
         B2pS2pXUAFy61qbt8P0vOhpFkHMJ8NX41LF0hAUFMgu/H2LdzRr/xLvMVehrY9/Gpd
         LT4hLUIpqGq4KpXTG71e8wY348BOOzcN/lpEm0cMnq88SMTKN9rUKPLocxq8FSSl+4
         cd8E8Na3xG0JzqIviA4J26ocXy01uIpjN+Ie0e90m/6mPK/tFfV8P8hf/NGhx9nMlV
         c40vMNKk9dMUA==
Date:   Mon, 2 Jan 2023 13:47:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     linux-fscrypt@vger.kernel.org, paulcrowley@google.com,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH 15/17] fscrypt: allow load/save of extent contexts
Message-ID: <Y7NQ1CvPyJiGRe00@sol.localdomain>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
 <fd5c7a78de125737abe447370fe37f9fe90155d6.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd5c7a78de125737abe447370fe37f9fe90155d6.1672547582.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 01, 2023 at 12:06:19AM -0500, Sweet Tea Dorminy wrote:
> The other half of using per-extent infos is saving and loading them from
> disk.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/keysetup.c    | 50 +++++++++++++++++++++++++++++++++++++++++
>  fs/crypto/policy.c      | 20 +++++++++++++++++
>  include/linux/fscrypt.h | 17 ++++++++++++++
>  3 files changed, 87 insertions(+)
> 
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index 136156487e8f..82439fb73dd9 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -799,6 +799,56 @@ void fscrypt_free_extent_info(struct fscrypt_info **info_ptr)
>  }
>  EXPORT_SYMBOL_GPL(fscrypt_free_extent_info);
>  
> +/**
> + * fscrypt_load_extent_info() - set up a preexisting extent's fscrypt_info
> + * @inode: the inode to which the extent belongs. Must be encrypted.
> + * @buf: a buffer containing the extent's stored context
> + * @len: the length of the @ctx buffer
> + * @info_ptr: a pointer to return the extent's fscrypt_info into. Should be
> + *	      a pointer to a member of the extent struct, as it will be passed
> + *	      back to the filesystem if key removal demands removal of the
> + *	      info from the extent
> + *
> + * This is not %GFP_NOFS safe, so the caller is expected to call
> + * memalloc_nofs_save/restore() if appropriate.
> + *
> + * Return: 0 if successful, or -errno if it fails.
> + */
> +int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
> +			     struct fscrypt_info **info_ptr)
> +{

When is the filesystem going to call fscrypt_load_extent_info()?

My concern (which we've discussed, but probably I didn't explain clearly enough)
is that the two "naive" solutions don't really work:

Option 1: Set up during the I/O to the extent.  I think this is not feasible
because the full fscrypt_setup_encryption_info() is not safe to do doing I/O.
For example, it allocates memory under GFP_KERNEL, and it uses
crypto_alloc_skcipher() which can involve loading kernel modules.

Option 2: Set up for *all* extents when the file is opened.  I expect that this
would not be feasible either, since a file can have a huge number of extents.

This patchset seems to be assuming one of those options.  (It's not clear
whether it's Option 1 or Option 2, since the caller of
fscrypt_load_extent_info() is not included in the patchset.)

That leaves the option I suggested, which probably I didn't explain clearly
enough: split up key setup so that part can be done when opening the file, and
part can be done during I/O.  Specifically, when opening the file, preallocate
some number of crypto_skcipher objects.  This would be limited to a fixed
number, like 128, even if the file has thousands of extents.  Then, when doing
I/O to an extent, temporarily take a crypto_skcipher from the cache, derive the
extent's key using fscrypt_hkdf_expand(), and set it in the crypto_skcipher
using crypto_skcipher_setkey().

That way, during I/O only fscrypt_hkdf_expand() and crypto_skcipher_setkey()
would be needed.  Those are fairly safe to call during I/O, in contrast to
crypto_alloc_skcipher() which is really problematic to call during I/O.

Of course, it will still be somewhat expensive to derive and set a key.  So it
might also make sense to maintain a map that maps (master key, extent nonce,
encryption mode) to the corresponding cached crypto_skcipher, if any, so that an
already-prepared one can be used when possible.

By the way, blk-crypto-fallback (block/blk-crypto-fallback.c) does something
similar, as it had to solve a similar problem.  The way it was solved is to
require that blk_crypto_fallback_start_using_mode() be called to preallocate the
crypto_skcipher objects for a given encryption mode.

You actually could just use blk-crypto-fallback to do the en/decryption for you,
if you wanted to.  I.e., you could use the blk-crypto API for en/decryption,
instead of going directly through crypto_skcipher.  (Note that currently
blk-crypto is opt-in via the "inlinecrypt" mount option; it's not used by
default.  But it doesn't *have* to be that way; it could just be always used.
It would be necessary to ensure that CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK gets
selected.)  That would save having to reimplement the caching of crypto_skcipher
objects.  However, key derivation would still need to be done at the filesystem
level, so it probably would still make sense to cache derived keys.

- Eric
