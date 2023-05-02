Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0426F3C7B
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 May 2023 05:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjEBDrl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 1 May 2023 23:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjEBDrk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 1 May 2023 23:47:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618891BD4
        for <linux-fscrypt@vger.kernel.org>; Mon,  1 May 2023 20:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F192260DFA
        for <linux-fscrypt@vger.kernel.org>; Tue,  2 May 2023 03:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22077C433D2;
        Tue,  2 May 2023 03:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682999258;
        bh=/9r7VwQBJ3pG2nPtv6+jGFNwBfwom3m3d9/YFUSZFcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oaFitp5pj1Zwujcy1E95Pz2NlWxdAKXSwAh2iSHuPR/urudHCcvG7p5greVpQbOQG
         0EgwocLV9IjlS4Py8YGjku6AsRwRZR+pN1DDvhUfNM1gAttkVwP9hDWjYjBEWmfHRw
         7paHLKTmX4vOVoobGdUgDAJXCTvMOzrM9r8NZqeYWhqHx8xzR9WsK7sw5433WX/6Vh
         a8fpNzBzdlj5LRvbqYNxSk0krqPdEkQ9YuqruYXXTCNOr3xaWD3K60L/V9XnIBn52v
         6Zi2f/gT9Oy95Djd2uHqM0hmt4hL+XL3LNQMFUMkV+SpKhnZpBcha8BiMp8sYuG55E
         61JqwFo0gnvNA==
Date:   Mon, 1 May 2023 20:47:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v1 0/7] fscrypt: add pooled prepared keys facility
Message-ID: <20230502034736.GA1131@sol.localdomain>
References: <cover.1681871298.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1681871298.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Sweet Tea,

On Tue, Apr 18, 2023 at 10:42:09PM -0400, Sweet Tea Dorminy wrote:
> This is part two of two of preliminaries to extent-based encryption,
> adding a facility to pool pre-allocated prepared keys and use them at IO
> time.
> 
> While arguably one structure within the feature, and not actually used
> in this changeset at that, it's a disjoint piece that has various taste
> questions so I've put it in its own changeset here for good or ill.
> 
> The change has been tested by switching a false to true so as to use it
> for leaf inodes which are doing contents encryption, and then running
> the standard tests. Such a thing changes the timing of when the prepared
> key is set up, obviously, so that IO which begins after a master key
> secret is removed no longer succeeds; this fails generic/{580,581,593}
> which don't have that expectation. However, this code has no impact on
> tests if disabled.
> 
> Known suboptimalities:
> -right now at the end nothing calls fscrypt_shrink_key_pool() and it
> throws an unused function warning.
> -right now it's hooked up to be used by leaf inodes not using inline
> encryption only. I don't know if there's any interest in pooling inode
> keys -- it could reduce memory usage on memory-constrained platforms --
> and if so using it for filename encryption also might make sense. On the
> other hand, if there's no interest, the code allowing use of it in the normal
> inode-info path is unnecessary.
> -right now it doesn't pool inline encryption objects either.
> -the initialization of a key pool for each mode spams the log with
> "Missing crypto API support" messages. Maybe the init of key pools
> should be the first time an info using pooled prepared keys is observed?
> 
> Some questions:
> 
> -does the pooling mechanism need to be extended to mode keys, which can
> easily be pre-allocated if needed?
> -does it need to be extended to v1 policies?
> -does it need to be behind a config option, perhaps with extent
> encryption?
> -should it be in its own, new file, since it adds a decent chunk of code
> to keysetup.c most of which is arguably key-agnostic?
> 
> This changeset should apply atop the previous one, entitled
> 'fscrypt: rearrangements preliminary to extent encryption'
> lore.kernel.org/r/cover.1681837335.git.sweettea-kernel@dorminy.me

Sorry for the slow response; I've been catching up after being on vacation.
I've also been having trouble understanding out what this patchset is doing and
what the next part is likely to be after it.

I'm worried that this may be going down a path of something much more complex
than needed.  It's hard to follow the new logic with the new data structures and
locks, keys being "stolen" from one file to another, etc.  I'm also confused by
how the pooled keys are being assigned to a field in fscrypt_info, given that
fscrypt_info is for an inode, not an extent.  So it's a bit unclear (at least to
me) how this proposal will lead to extent-based encryption.

As I mentioned earlier
(https://lore.kernel.org/r/Y7NQ1CvPyJiGRe00@sol.localdomain),
blk-crypto-fallback actually already solved the problem of caching
crypto_skcipher objects for I/O.  And, it's possible for a filesystem to *only*
support blk-crypto, not filesystem-layer contents encryption.  You'd just need
to put btrfs encryption behind a new kconfig option that is automatically
selected by CONFIG_FS_ENCRYPTION_INLINE_CRYPT && CONFIG_BLK_ENCRYPTION_FALLBACK.

(BTW, I'm thinking of simplifying the kconfig options by removing
CONFIG_FS_ENCRYPTION_INLINE_CRYPT.  Then, the blk-crypto code in fs/crypto/ will
be built if CONFIG_FS_ENCRYPTION && CONFIG_BLK_INLINE_ENCRYPTION.)

Indeed, filesystem-layer contents encryption is a bit redundant these days now
that blk-crypto-fallback exists.  I'm even tempted to make ext4 and f2fs support
blk-crypto only someday.  That was sort of the original plan, actually...

So, I'm wondering if you've considered going the blk-crypto-fallback route?

I expect that it would be a lot easier than what you seem to be trying.

The main thing to consider would be exactly how to handle the key derivation.
In the long run, it might make sense to add key derivation support to
blk-crypto, as there is actually inline encryption hardware that supports
per-file key derivation in hardware already and it would be nice to support that
someday.  But for now, maybe just have the filesystem derive the key for each
extent, upon first access to that extent, and cache the resulting blk_crypto_key
in the appropriate btrfs data structure for the extent ('struct extent_state'
maybe)?  Can you think of any reason why that wouldn't work?

There is also the issue of authenticated encryption (which I understand you're
going to add after unauthenticated encryption is working).  That will take some
work to add support to blk-crypto.  However, the same would be true for
filesystem-layer contents encryption too.  So I'm not sure that would be an
argument for filesystem-layer contents encryption over blk-crypto...

- Eric
