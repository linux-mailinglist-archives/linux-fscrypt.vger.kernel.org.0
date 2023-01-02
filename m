Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBBD65B7A6
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Jan 2023 23:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjABWbK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Jan 2023 17:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjABWbJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Jan 2023 17:31:09 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3ECB69;
        Mon,  2 Jan 2023 14:31:04 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 10C308029A;
        Mon,  2 Jan 2023 17:31:02 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672698663; bh=HhRQq6EpIcmN0H8bRn5tCkHLH4nDeM4Xm+XTHA6MmcI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=EwA32MmfhH43+d3Qx8DoCEkNCA31+xizJPfgBJtNMg3liB0PO6SdjsrtABpqmYrs6
         +JYw14Zmvvupfm9jjKKpGs+rPbSOy0bRDJD4n2Evseph5AwNw/syKm1MPa3Erzco7c
         /zpaQ1/WEZ83xvyaIJBNrXIydEQo3+3ILPeS5O2Ofu863O4RsMBj+vgWFcQDqrhQef
         bz/jcGEHyXSelj2iZufDktqIxPpAASYHTPHxnzCHikq1PbVbXUDJBNpc4gepqJ9daT
         7oJ9kMW26UurJFW01Y9xcrIJzGMT+d1d2R6dkmYN1506tvGzc43JOqJSTu593/y3tU
         JO1eH7uhSRY1w==
Message-ID: <686e2eb9-b218-6b23-472c-b6035bd2186b@dorminy.me>
Date:   Mon, 2 Jan 2023 17:31:02 -0500
MIME-Version: 1.0
Subject: Re: [RFC PATCH 15/17] fscrypt: allow load/save of extent contexts
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, paulcrowley@google.com,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
 <fd5c7a78de125737abe447370fe37f9fe90155d6.1672547582.git.sweettea-kernel@dorminy.me>
 <Y7NQ1CvPyJiGRe00@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <Y7NQ1CvPyJiGRe00@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

(in which I fail to reply-all the first time)

> 
> When is the filesystem going to call fscrypt_load_extent_info()?
> 
> My concern (which we've discussed, but probably I didn't explain clearly enough)
> is that the two "naive" solutions don't really work:
> 
> Option 1: Set up during the I/O to the extent.  I think this is not feasible
> because the full fscrypt_setup_encryption_info() is not safe to do doing I/O.
> For example, it allocates memory under GFP_KERNEL, and it uses
> crypto_alloc_skcipher() which can involve loading kernel modules.
> 
memalloc_nofs_save()/memalloc_nofs_restore() could do the job of making 
sure allocations use GFP_NOFS, I think? I guess those calls should be in 
fscrypt_load_extent_info() instead of just in the doc...
> 
> That leaves the option I suggested, which probably I didn't explain clearly
> enough: split up key setup so that part can be done when opening the file, and
> part can be done during I/O.  Specifically, when opening the file, preallocate
> some number of crypto_skcipher objects.  This would be limited to a fixed
> number, like 128, even if the file has thousands of extents.  Then, when doing
> I/O to an extent, temporarily take a crypto_skcipher from the cache, derive the
> extent's key using fscrypt_hkdf_expand(), and set it in the crypto_skcipher
> using crypto_skcipher_setkey().

I didn't elaborate why it wasn't here and should have. With just this 
patchset, I thought a file only ever has extents with the same 
encryption mode, since an inode can't change encryption mode/key past 
creation at present . So loading the parent dir's fscrypt_info should be 
enough to ensure the module is loaded for the mode of all the extents. I 
suppose I'd need to ensure that reflinks also only reflink extents 
sharing the same encryption mode.

In the future patchset which allows changing the key being used for new 
extents (naming that is hard), I had envisioned requiring the filesystem 
to provide a list of enc modes used by an inode when opening, and then 
fscrypt_file_open() could make sure all the necessary modules are loaded 
for those modes.

> 
> That way, during I/O only fscrypt_hkdf_expand() and crypto_skcipher_setkey()
> would be needed.  Those are fairly safe to call during I/O, in contrast to
> crypto_alloc_skcipher() which is really problematic to call during I/O.

Could we use a mempool of skciphers for all of fscrypt, or should it 
only be for extents and be on a per-file basis?

> 
> Of course, it will still be somewhat expensive to derive and set a key.  So it
> might also make sense to maintain a map that maps (master key, extent nonce,
> encryption mode) to the corresponding cached crypto_skcipher, if any, so that an
> already-prepared one can be used when possible.
Same question: just for extent infos, or can this be generalized to all 
infos?


> 
> By the way, blk-crypto-fallback (block/blk-crypto-fallback.c) does something
> similar, as it had to solve a similar problem.  The way it was solved is to
> require that blk_crypto_fallback_start_using_mode() be called to preallocate the
> crypto_skcipher objects for a given encryption mode.
> 
> You actually could just use blk-crypto-fallback to do the en/decryption for you,
> if you wanted to.  I.e., you could use the blk-crypto API for en/decryption,
> instead of going directly through crypto_skcipher.  (Note that currently
> blk-crypto is opt-in via the "inlinecrypt" mount option; it's not used by
> default.  But it doesn't *have* to be that way; it could just be always used.
> It would be necessary to ensure that CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK gets
> selected.)  That would save having to reimplement the caching of crypto_skcipher
> objects.  However, key derivation would still need to be done at the filesystem
> level, so it probably would still make sense to cache derived keys.
> 
> - Eric


Interesting. I will have to study that more, thanks for the pointer.

Thank you!

Sweet Tea
