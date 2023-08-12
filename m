Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E19877A39F
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Aug 2023 00:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjHLWPP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 12 Aug 2023 18:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjHLWPO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 12 Aug 2023 18:15:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4EE1709;
        Sat, 12 Aug 2023 15:15:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1394E60C17;
        Sat, 12 Aug 2023 22:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C1DC433C7;
        Sat, 12 Aug 2023 22:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691878516;
        bh=RdolWAptVncJ/oKDFS2RnFdXnHJ0I2EaNK11bGNeM3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eKi6/MeGM2pb5MJOA0QsS0kGtV5KGTVwDUyy2uFoWdgCzyqFJNVlAkphpPTa5YWMi
         nE+xqtaxlmO9pBklvmqR/B/SlpKlaa+Ml6eW4OHHiDfFEu3wAN0/0jq7jX9eUzXfp4
         jmzxQwjjl28boK7N8uccYoP1n/Ov3xgKvHls3XFFFHBsIPL6quNccXrD139TkTNWMh
         /R/tkf+uO6+wspPGPBfxhQlZTUAL4HhkU5pZkWiWU2SiMIt+RCHsMi2koqmm8DL4L9
         XR12lBUwzRQcnZAD9zItdeS0bmXYG0oKJmfB/nqx4hWAGblSJGVYW7Am6e8Ge0cIaU
         gFxBc80vs1blA==
Date:   Sat, 12 Aug 2023 15:15:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 00/16] fscrypt: add extent encryption
Message-ID: <20230812221514.GA2207@sol.localdomain>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Sweet Tea,

On Tue, Aug 08, 2023 at 01:08:17PM -0400, Sweet Tea Dorminy wrote:
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
> discussed previously. 
> 
> This applies atop [3], which itself is based on kdave/misc-next. It
> passes encryption fstests with suitable changes to btrfs-progs.
> 
> Changelog:
> v3:
>  - Added four additional changes:
>    - soft-deleting keys that extent infos might later need to use, so
>      the behavior of an open file after key removal matches inode-based
>      fscrypt.
>    - a set of changes to allow asynchronous info freeing for extents,
>      necessary due to locking constraints in btrfs.
> 
> v2: 
>  - https://lore.kernel.org/linux-fscrypt/cover.1688927487.git.sweettea-kernel@dorminy.me/T/#t
> 
> 
> [1] https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
> [2] https://lore.kernel.org/linux-fscrypt/80496cfe-161d-fb0d-8230-93818b966b1b@dorminy.me/T/#t
> [3] https://lore.kernel.org/linux-fscrypt/cover.1691505830.git.sweettea-kernel@dorminy.me/
> 
> Sweet Tea Dorminy (16):
>   fscrypt: factor helper for locking master key
>   fscrypt: factor getting info for a specific block
>   fscrypt: adjust effective lblks based on extents
>   fscrypt: add a super_block pointer to fscrypt_info
>   fscrypt: setup leaf inodes for extent encryption
>   fscrypt: allow infos to be owned by extents
>   fscrypt: use an optional ino equivalent for per-extent infos
>   fscrypt: move function call warning of busy inodes
>   fscrypt: revamp key removal for extent encryption
>   fscrypt: add creation/usage/freeing of per-extent infos
>   fscrypt: allow load/save of extent contexts
>   fscrypt: save session key credentials for extent infos
>   fscrypt: allow multiple extents to reference one info
>   fscrypt: cache list of inlinecrypt devices
>   fscrypt: allow asynchronous info freeing
>   fscrypt: update documentation for per-extent keys
> 
>  Documentation/filesystems/fscrypt.rst |  43 +++-
>  fs/crypto/crypto.c                    |   6 +-
>  fs/crypto/fscrypt_private.h           | 158 +++++++++++-
>  fs/crypto/inline_crypt.c              |  49 ++--
>  fs/crypto/keyring.c                   |  78 +++---
>  fs/crypto/keysetup.c                  | 336 ++++++++++++++++++++++----
>  fs/crypto/keysetup_v1.c               |  10 +-
>  fs/crypto/policy.c                    |  20 ++
>  include/linux/fscrypt.h               |  67 +++++
>  9 files changed, 654 insertions(+), 113 deletions(-)

I'm taking a look at this, but I don't think it's really reviewable in its
current state.  The main problem is how the new functionality is reusing struct
fscrypt_info.  Before an fscrypt_info was the information (key, policy, inode
back-pointer, master key link, etc.) associated with an inode.  But now it can
be any of the following:

- Information for an inode
- Cached policy (?) for a "leaf inode"
- Information for an extent

Everything just seems kind of mixed together.  It's not clear which fields of
fscrypt_info apply to which scenario, and which scenario(s) is being handled
when code works with fscrypt_info.  There seem to be bugs caused by these
scenarios being mixed up.  Comments are also inconsistent; a huge number of them
still refer only to "inode" or "file" when that is no longer correct.  So it's
quite hard to understand the code now.

I think there really needs to be some work on designing and documenting the data
structures for what you are trying to accomplish.  That really ought to have
been the first step before getting deep into coding the actual functionality.

Have you considered creating a new struct like fscrypt_extent_info, instead of
reusing fscrypt_info?  I think that would make things much clearer.  I suppose
there is code that needs to operate on the shared fields of both, but that could
be done by putting the shared fields in a sub-struct like 'struct
fscrypt_common_info common;', and passing around a pointer to that where needed.

I'd also like to reiterate the concern I raised last month
(https://lore.kernel.org/linux-fscrypt/20230703045417.GA3057@sol.localdomain/):
a lot of this complexity seems to have been contributed to by the "heavyweight
extents" design choice.  I was hoping to see a detailed design for the "change a
directory's tree encryption policy" feature you are planning to use this for, in
order to get some confidence that it will actually be implemented.  Otherwise, I
fear we'll end up building in a lot of complexity for something that never gets
implemented.

- Eric
