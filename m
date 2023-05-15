Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5DD702507
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 May 2023 08:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbjEOGkw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 May 2023 02:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbjEOGkw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 May 2023 02:40:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5D0E54
        for <linux-fscrypt@vger.kernel.org>; Sun, 14 May 2023 23:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E5A3612EC
        for <linux-fscrypt@vger.kernel.org>; Mon, 15 May 2023 06:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6143BC433D2;
        Mon, 15 May 2023 06:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684132849;
        bh=QdiHnysBKSnSgt0hoFvVmfmRKgIfAcyJA3bFCEmz7T0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QFwQcBKKy3hYZU2tpPTXeyfWnQixGKodymzPk8s80NNzXxHJy6nWOWIKax+lRZ7Sf
         Bw344nMYKhyzPLY3SdDycap0qUvXhb5qu3Eu6FzDt+QbBsVdp5iXqhzedBVn9PWJDV
         fVMTrCPVzl84CJgh9NTN99DqmvexmV7+dU0x4UexDkbLEvfqDVsay59pcDaebn29sk
         orNjGf/Lo9mURm7y4IF8T1OkeerX0V8+0iEKxFm5nkaGfalT4orGCSxt8P1HZ0qTDt
         T5ULLJF3NDuO2lB1I+BoS94qQAyltqYSVB4xj+ThK4LsIYFaEGAZH/E5hxwNNLWnmZ
         Ex+U2cHoGifCA==
Date:   Sun, 14 May 2023 23:40:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v1 0/7] fscrypt: add pooled prepared keys facility
Message-ID: <20230515064047.GC15871@sol.localdomain>
References: <cover.1681871298.git.sweettea-kernel@dorminy.me>
 <20230502034736.GA1131@sol.localdomain>
 <e7ee1491-e67c-6461-8825-6f39bf723c86@dorminy.me>
 <ZFWFzUE6r30yVPB+@gmail.com>
 <6f860e67-c998-0066-5f04-bc394164c5ba@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f860e67-c998-0066-5f04-bc394164c5ba@dorminy.me>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Sweet Tea,

On Fri, May 05, 2023 at 08:35:53PM -0400, Sweet Tea Dorminy wrote:
> 
> 
> On 5/5/23 18:40, Eric Biggers wrote:
> > On Fri, May 05, 2023 at 08:15:44AM -0400, Sweet Tea Dorminy wrote:
> > > 
> > > > As I mentioned earlier
> > > > (https://lore.kernel.org/r/Y7NQ1CvPyJiGRe00@sol.localdomain),
> > > > blk-crypto-fallback actually already solved the problem of caching
> > > > crypto_skcipher objects for I/O.  And, it's possible for a filesystem to *only*
> > > > support blk-crypto, not filesystem-layer contents encryption.  You'd just need
> > > > to put btrfs encryption behind a new kconfig option that is automatically
> > > > selected by CONFIG_FS_ENCRYPTION_INLINE_CRYPT && CONFIG_BLK_ENCRYPTION_FALLBACK.
> > > > 
> > > > (BTW, I'm thinking of simplifying the kconfig options by removing
> > > > CONFIG_FS_ENCRYPTION_INLINE_CRYPT.  Then, the blk-crypto code in fs/crypto/ will
> > > > be built if CONFIG_FS_ENCRYPTION && CONFIG_BLK_INLINE_ENCRYPTION.)
> > > > 
> > > > Indeed, filesystem-layer contents encryption is a bit redundant these days now
> > > > that blk-crypto-fallback exists.  I'm even tempted to make ext4 and f2fs support
> > > > blk-crypto only someday.  That was sort of the original plan, actually...
> > > > 
> > > > So, I'm wondering if you've considered going the blk-crypto-fallback route?
> > > 
> > > I did, and gave it a shot, but ran into problems because as far as I can
> > > tell it requires having a bio to crypt. For verity data and inline extents,
> > > there's no obvious bio, and even if we tried to construct a bio pointing at
> > > the relevant data, it's not necessarily sector- sized or aligned. I couldn't
> > > figure out a good way to make it work, but maybe it's better to special-case
> > > those or there's something I'm not seeing.
> > 
> > ext4 and f2fs just don't use inline data on encrypted files.  I.e. when an encrypted file is
> > created, it always uses non-inline data.  Is that an option for btrfs?
> 
> It's not impossible (though it's been viewed as a fair deficiency in last
> year's changesets), but it's not the only user of data needing encryption
> stored inline instead of separately:
> > 
> > For the verity metadata, how are you thinking of encrypting it, exactly?  Verity metadata is
> > immutable once written, so surely it avoids many of the issues you are dealing with for extents?  It
> > should just need one key, and that key could be set up at file open time.  So I don't think it will
> > need the key pool at all?
> 
> Yes, it should be able to use whatever the interface is for extent
> encryption, whether that uses pooled keys or something else. However, btrfs
> stores verity data in 2k chunks in the tree, similar to inline data, so it
> has the same difficulties.
> 
> (I realized after sending that we also want to encrypt xattrs, which are
> similarly stored as items in the tree instead of blocks on disk.)
> 
> We could have separate pools for inline and non-inline prepared keys (or not
> pool inline keys at all?)
> 

To clarify my suggestion, blk-crypto could be used for file contents
en/decryption at the same time that filesystem-layer crypto is used for verity
metadata en/decryption.  blk-crypto and filesystem-layer crypto don't need to be
mutually exclusive, even on the same file.

Also, I'm glad that you're interested in xattr encryption, but unfortunately
it's a tough problem, and all the other filesystems that implement fscrypt have
left it out.  You have enough other things to worry about, so I think leaving
xattr encryption out for now is the right call.  Similarly, the other
filesystems that implement fscrypt have left out encryption of inline data,
instead opting to disable inline data on encrypted files.

Anyway, the main reason I'm sending this email is actually that I wanted to
mention another possible solution to the per-extent key problem that I just
became aware of.  In v6.4-rc1, the crypto API added a new function
crypto_clone_tfm() which allocates a new tfm object, given an existing one.
Unlike crypto_alloc_tfm(), crypto_clone_tfm() doesn't take any locks.  See:
https://lore.kernel.org/linux-crypto/ZDefxOq6Ax0JeTRH@gondor.apana.org.au/T/#u

For now, only shash and ahash tfms can be cloned.  However, it looks like
support for cloning skcipher tfms could be added.

With "cloning" skcipher tfms, there could just be a crypto_skcipher per extent,
allocated on the I/O path.  That would solve the problem we've been trying to
solve, without having to bring in the complexity of "pooled prepared keys".

I think we should go either with that or with the blk-crypto-fallback solution.

- Eric
