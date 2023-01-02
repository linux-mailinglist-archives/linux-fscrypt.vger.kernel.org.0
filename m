Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1963D65B7B4
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Jan 2023 23:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjABWwA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Jan 2023 17:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjABWv7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Jan 2023 17:51:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94479A47D;
        Mon,  2 Jan 2023 14:51:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38EA3B80DDC;
        Mon,  2 Jan 2023 22:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5D9C433D2;
        Mon,  2 Jan 2023 22:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672699913;
        bh=P2feKlNBjYUxT5B/gVMs5gWopO9aAUI0co9I6bp2Ghw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nrmV4vYytBbBZL8dwwZv0k6HDkLO4GCcR9rrNSNGIAXhU0SwRna+h5gfiYdV4lfp0
         RBw9riGbyN/cKFGxHC9WEVNeiQmhc8wa8xfLgHrKRAGp20y4lGBc+WZoRvv9D8m8wZ
         fgzEw9VgNOn9EuU6eHOjmrTraVL9wo6ZAOMmKuJHpqoMm90sCv08QhAG5zEgmmYN5I
         TFNyfhBD2C2prMRi7YChfpX/zaMnjUyua2LHA3cwcw8eA7v72JykzfvlrgMd3SaBzv
         qeKbbL3UICQOXFLDLdL/lnfqtSpOXXZOZ5ql1T5/6XuXshXUnhJLM2ZdEUC/KVUSBU
         kFyHQDUvcamYA==
Date:   Mon, 2 Jan 2023 14:51:52 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     linux-fscrypt@vger.kernel.org, paulcrowley@google.com,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH 15/17] fscrypt: allow load/save of extent contexts
Message-ID: <Y7NgCKPnVybgBaq/@sol.localdomain>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
 <fd5c7a78de125737abe447370fe37f9fe90155d6.1672547582.git.sweettea-kernel@dorminy.me>
 <Y7NQ1CvPyJiGRe00@sol.localdomain>
 <686e2eb9-b218-6b23-472c-b6035bd2186b@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <686e2eb9-b218-6b23-472c-b6035bd2186b@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 02, 2023 at 05:31:02PM -0500, Sweet Tea Dorminy wrote:
> (in which I fail to reply-all the first time)
> 
> > 
> > When is the filesystem going to call fscrypt_load_extent_info()?
> > 
> > My concern (which we've discussed, but probably I didn't explain clearly enough)
> > is that the two "naive" solutions don't really work:
> > 
> > Option 1: Set up during the I/O to the extent.  I think this is not feasible
> > because the full fscrypt_setup_encryption_info() is not safe to do doing I/O.
> > For example, it allocates memory under GFP_KERNEL, and it uses
> > crypto_alloc_skcipher() which can involve loading kernel modules.
> > 
> memalloc_nofs_save()/memalloc_nofs_restore() could do the job of making sure
> allocations use GFP_NOFS, I think? I guess those calls should be in
> fscrypt_load_extent_info() instead of just in the doc...
> > 
> > That leaves the option I suggested, which probably I didn't explain clearly
> > enough: split up key setup so that part can be done when opening the file, and
> > part can be done during I/O.  Specifically, when opening the file, preallocate
> > some number of crypto_skcipher objects.  This would be limited to a fixed
> > number, like 128, even if the file has thousands of extents.  Then, when doing
> > I/O to an extent, temporarily take a crypto_skcipher from the cache, derive the
> > extent's key using fscrypt_hkdf_expand(), and set it in the crypto_skcipher
> > using crypto_skcipher_setkey().
> 
> I didn't elaborate why it wasn't here and should have. With just this
> patchset, I thought a file only ever has extents with the same encryption
> mode, since an inode can't change encryption mode/key past creation at
> present . So loading the parent dir's fscrypt_info should be enough to
> ensure the module is loaded for the mode of all the extents. I suppose I'd
> need to ensure that reflinks also only reflink extents sharing the same
> encryption mode.
> 
> In the future patchset which allows changing the key being used for new
> extents (naming that is hard), I had envisioned requiring the filesystem to
> provide a list of enc modes used by an inode when opening, and then
> fscrypt_file_open() could make sure all the necessary modules are loaded for
> those modes.

"Loading the parent dir's fscrypt_info" isn't relevant here, since the filenames
encryption mode can be different from the contents encryption mode.  It's also
possible for an encrypted file to be located in an unencrypted directory.  Maybe
you meant to be talking about the file itself being opened?

Anyway, crypto_alloc_skcipher() takes a lock (crypto_alg_sem) under which memory
is allocated with GFP_KERNEL.  So neither preloading kernel modules nor
memalloc_nofs_save() helps for it; it's still not GFP_NOFS-safe.

I don't think we should allow files to have extents with different encryption
modes.  Encryption policies will still be a property of files.

> > That way, during I/O only fscrypt_hkdf_expand() and crypto_skcipher_setkey()
> > would be needed.  Those are fairly safe to call during I/O, in contrast to
> > crypto_alloc_skcipher() which is really problematic to call during I/O.
> 
> Could we use a mempool of skciphers for all of fscrypt, or should it only be
> for extents and be on a per-file basis?

It probably should be global, or at least per-master-key, as it would be a
massive overhead to allocate (e.g.) 128 crypto_skcipher objects for every file.
blk-crypto-fallback uses a global cache.

It does introduce a bottleneck and memory that can't be reclaimed, though.  I'd
appreciate any thoughts about other solutions.  Maybe the number of objects in
the cache could be scaled up and down as the number of in-core inodes changes.

> > Of course, it will still be somewhat expensive to derive and set a key.  So it
> > might also make sense to maintain a map that maps (master key, extent nonce,
> > encryption mode) to the corresponding cached crypto_skcipher, if any, so that an
> > already-prepared one can be used when possible.
> Same question: just for extent infos, or can this be generalized to all
> infos?

I think that we should definitely still cache the per-file key in
inode::i_crypt_info and not in some global cache.

- Eric
