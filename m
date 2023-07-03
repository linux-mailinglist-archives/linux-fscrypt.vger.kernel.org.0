Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09497454AD
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Jul 2023 06:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjGCEyW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 3 Jul 2023 00:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjGCEyV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 3 Jul 2023 00:54:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E05294;
        Sun,  2 Jul 2023 21:54:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B762460D33;
        Mon,  3 Jul 2023 04:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A88C433C9;
        Mon,  3 Jul 2023 04:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688360059;
        bh=bHw/qBbQtCh4GMYRpoOkmwgoyVn4b1VOpzQDcgXK73w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z6WDvHsa3QGRh7K6Dfd1IXt629KQ9OGqMYzt8ZBC5d5emkFtnR5W9+N82YhyLInjP
         aMLZGEvIU8PxqBiSyK31ifiXa4d8aRfWDPXSmSJGejaXztc1YXlPBFP0aNLUQGiK3X
         kbIhc4W+pfXUA2SUqAW0EXRRNmUvIQUjH6fFIbhGYvivH0pGuNh2E9H/0QzD2X0v5j
         os57T5uMIX160/lHrnCWoxGJsDPOH00vHRPl9HiGSxGRJGRPOluuTJdPLPOJvbLuRz
         pIW8xTHWsqfBu7AnrQBLYTsMnoM+LLjdwIJwhbHjUTusLcTKY5BJVYmuzuosKB+pb2
         w27HOd78HK7HQ==
Date:   Sun, 2 Jul 2023 21:54:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v1 00/12] fscrypt: add extent encryption
Message-ID: <20230703045417.GA3057@sol.localdomain>
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1687988246.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Sweet Tea,

On Wed, Jun 28, 2023 at 08:29:30PM -0400, Sweet Tea Dorminy wrote:
> This changeset adds extent-based data encryption to fscrypt.
> Some filesystems need to encrypt data based on extents, rather than on
> inodes, due to features incompatible with inode-based encryption. For
> instance, btrfs can have multiple inodes referencing a single block of
> data, and moves logical data blocks to different physical locations on
> disk in the background. 
> 
> As per discussion last year in [1] and later in [2], we would like to
> allow the use of fscrypt with btrfs, with authenticated encryption. This
> is the first step of that work, adding extent-based encryption to
> fscrypt; authenticated encryption is the next step. Extent-based
> encryption should be usable by other filesystems which wish to support
> snapshotting or background data rearrangement also, but btrfs is the
> first user. 
> 
> This changeset requires extent encryption to use inlinecrypt, as
> discussed previously. There are two questionable parts: the
> forget_extent_info hook is not yet in use by btrfs, as I haven't yet
> written a test exercising a race where it would be relevant; and saving
> the session key credentials just to enable v1 session-based policies is
> perhaps less good than 
> 
> This applies atop [3], which itself is based on kdave/misc-next. It
> passes most encryption fstests with suitable changes to btrfs-progs, but
> not generic/580 or generic/595 due to different timing involved in
> extent encryption. Tests and btrfs progs updates to follow.
> 
> 
> [1] https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
> [2] https://lore.kernel.org/linux-fscrypt/80496cfe-161d-fb0d-8230-93818b966b1b@dorminy.me/T/#t
> [3]
> https://lore.kernel.org/linux-fscrypt/cover.1687988119.git.sweettea-kernel@dorminy.me/
> 
> Sweet Tea Dorminy (12):
>   fscrypt: factor helper for locking master key
>   fscrypt: factor getting info for a specific block
>   fscrypt: adjust effective lblks based on extents
>   fscrypt: add a super_block pointer to fscrypt_info
>   fscrypt: setup leaf inodes for extent encryption
>   fscrypt: allow infos to be owned by extents
>   fscrypt: notify per-extent infos if master key vanishes
>   fscrypt: use an optional ino equivalent for per-extent infos
>   fscrypt: add creation/usage/freeing of per-extent infos
>   fscrypt: allow load/save of extent contexts
>   fscrypt: save session key credentials for extent infos
>   fscrypt: update documentation for per-extent keys
> 
>  Documentation/filesystems/fscrypt.rst |  38 +++-
>  fs/crypto/crypto.c                    |   6 +-
>  fs/crypto/fscrypt_private.h           |  91 ++++++++++
>  fs/crypto/inline_crypt.c              |  28 ++-
>  fs/crypto/keyring.c                   |  32 +++-
>  fs/crypto/keysetup.c                  | 244 ++++++++++++++++++++++----
>  fs/crypto/keysetup_v1.c               |   7 +-
>  fs/crypto/policy.c                    |  20 +++
>  include/linux/fscrypt.h               |  74 ++++++++
>  9 files changed, 480 insertions(+), 60 deletions(-)
> 
> 
> base-commit: accadeb67609a5a5d088ebde8409c3f6db0b84b4

Thanks for sending this out!

It's going to take me a while to go through everything, so please bear with me.
In general I'd also really like to be seeing more feedback from the other btrfs
developers.  This is a hard project that really needs more eyes on it.

From a brief look through your patchsets, there's one thing I want to bring up
right away.  It seems that one important design choice that you've made that has
impacted much of your patchsets is that you've made each extent a fully
standalone thing, similar to inodes currently.  I.e.,

    (a) Each extent gets a full 'fscrypt_context' stored along with it.  That
        includes not just the nonce, but also the encryption modes and master
        key identifier.

    (b) For runtime caching, each extent gets a full 'struct fscrypt_info'
        object.  It doesn't "belong" to any inode; it's set up in a fully
        standalone way, and the master key lookup and removal logic operates
        directly on the extent's 'struct fscrypt_info'.

I'm not sure this is a good idea.  What I had thought it was going to look like
is that the encryption context/policy and 'struct fscrypt_info' would stay a
property of the inode, and the extents themselves would be much more lightweight
-- both on disk and in the cache.  On-disk, all that should really be needed for
an extent is the nonce for deriving the per-extent key.  And in-memory, all that
should really be needed is a "fscrypt_prepared_key" for the per-extent key, and
a reference to the owning inode.

I think that would avoid many of the problems that it seems you've had to work
around or have had to change user-visible semantics for.  For example the
problems involving master keys being added and removed.  It would also avoid
having to overload 'fscrypt_info' to be either a per-inode or a per-extent key.
And it would save space on disk and in memory.

Can you elaborate on why you went with a more "heavyweight" extents design?

Maybe your motivation is that extents can be referenced by more than one inode
and thus do not have a unique owning inode?  That's true, but I don't think that
really matters.  All the inodes that reference an extent will have the same
encryption policy, right?  Also, it looks like the "struct extent_map" that
you're caching the per-extent key in is already cached on a per-inode basis, in
btrfs_inode::extent_tree, similar to the pagecache which is also per-inode.  So
if the same extent happens to be accessed via multiple inodes, that's still
going to cause the fscrypt key to be set up twice anyway.

- Eric
