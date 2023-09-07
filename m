Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079957977E4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Sep 2023 18:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjIGQgi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 Sep 2023 12:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241628AbjIGQgP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 Sep 2023 12:36:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1BC7ABB;
        Thu,  7 Sep 2023 09:22:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B226EC433C8;
        Thu,  7 Sep 2023 05:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694065955;
        bh=UbB/H1o92oUgiYA1+Db8O40zgKvPxC38MTY+KZQFJTY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sbBz3uPm6SK37neGXax7l5JK/fYT55jKW17SnuBRXNqcTNg3OATCkjhQ3PvAK7ovS
         IifQqEWcW00J+Xr11GRNO/D53kvftlckIjOQBAh0cGCREuxTSVa6uSW1lAVKz2/uQn
         Qr52gBtyIY/g5MhIJQGUu1xdQfdOdAfcFuUq/G9pKsN5MqngVQU9003dmKAU9J5GA/
         8zFF2M3+FjSAQboJVCVWEOFKc8AFlrsQpE9W8eCAjJ2kteieReX9ulUDmgtu8Eo/W2
         2u0e5oaFkEN4uOEKyUBWkv6OKNKoqHY5rVqHag/iUQ3+K50Zn5chjIPlPBxPWVkWGH
         sva0gC/MNtw5w==
Date:   Wed, 6 Sep 2023 22:52:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: Re: [RFC PATCH 00/13] fscrypt: add extent encryption
Message-ID: <20230907055233.GB37146@sol.localdomain>
References: <cover.1693630890.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1693630890.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Sep 02, 2023 at 01:54:18AM -0400, Sweet Tea Dorminy wrote:
> This is a replacement for the former changeset (previously v3). This
> doesn't reflect all the smaller feedback on v3: it's an attempt to address
> the major points of giving extents and inodes different objects, and to
> clearly define lightweight and heavyweight extent contexts.

In general it would be helpful if more of the feedback I've already given was
addressed, e.g.
https://lore.kernel.org/r/20230812223408.GA41642@sol.localdomain
https://lore.kernel.org/r/20230812224144.GB41642@sol.localdomain
https://lore.kernel.org/r/20230812224301.GC41642@sol.localdomain.
It's hard to review this when things that are being proposed "for real" are
mixed in with things that just haven't had time to be fixed yet, and it's
not obvious which are which.
https://lore.kernel.org/r/20230812223408.GA41642@sol.localdomain in particular
is important and would affect the parts which it seems I'm being asked to
review.

> Changelog:
> RFC:
>  - Split fscrypt_info into a general fscrypt_common_info, an
>    inode-specific fscrypt_info, and an extent-specific
>    fscrypt_extent_info. All external interfaces use either an inode or
>    extent specific structure; most internal functions handle the common
>    structure.

If we indeed go this route, the inode one should be called fscrypt_inode_info,
right?  Also, this could be done in 3 patches to make it easier to review: (1)
rename fscrypt_info => fscrypt_inode_info, (2) add fscrypt_common_info and put
it in fscrypt_inode_info, and (3) add fscrypt_extent_info.

>  - Tried to fix up more places to refer to infos instead of inodes and
>    files.

I don't think the things that are being encrypted should be called "infos".
"Info" is just what fs/crypto/ happens to the call the data structure that holds
the key, encryption settings, etc. for an object (inode or extent) subject to FS
encryption.  It's not a great name, and in any case it's not the same as the
object itself.  When we're not literally talking about the data structure
itself, code comments should say something like "object represented by the info
@ci" or "file or extent for the info @ci".  Other suggestions appreciated, of
course.  But we should not refer to the things being encrypted as "infos".
"Info" is the C struct that the code happens to use, nothing more.

>  - Changed to use lightweight extent contexts containing just a nonce,
>    and then a following change to do heavyweight extent contexts
>    identical to inode contexts, so they're easily comparable.

This seems to be referring to "fscrypt: store full fscrypt_contexts for each
extent".  But, that just changes what is stored for each extent.  The rest of
this patchset still very much assumes the heavyweight design, and it brings in
the complexity from that.  E.g., the proposed fscrypt_extent_info has a lot of
fields which are not necessary if there was an associated per-inode struct that
the policy, mode, master key, etc. could be pulled from.  Also the master key
link, since only inodes really need to be in the master key's list, right?

I understand that you want to be able to assign an encryption policy to an
unencrypted file and have new extents be encrypted using that policy.  I never
received a real answer to my question about what the plan is to recursively
change a whole directory tree, but sure, let's assume this will be supported by
iterating through every file and directory and setting something on them (for
directories it would have to be a new kind of inherit-only policy; also for this
to work at all you'd have to relax the current fscrypt semantics described in
https://www.kernel.org/doc/html/next/filesystems/fscrypt.html#encryption-policy-enforcement).
This still means that the encryption policy for each extent, if it has one, will
match the file that contains it.  So I don't see why it's necessary to have all
complexity of setting up everything completely independently for each extent.

It does sound like you still want to store the full information for each extent
anyway.  In that case, how about doing that but just making the kernel validate
at runtime that it matches the corresponding inode's?  (Yes, extent => inode is
a one-to-many relationship on-disk, but in the cache it's one-to-one I think.)
I think that would be a good middle ground.  It would allow the implementation
to be simple for now, with lightweight "struct fscrypt_extent_info", but all the
information for each extent would be stored on-disk for futureproofing.

- Eric
