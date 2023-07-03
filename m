Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2055C746121
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Jul 2023 19:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjGCRGX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 3 Jul 2023 13:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjGCRGW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 3 Jul 2023 13:06:22 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C613E58;
        Mon,  3 Jul 2023 10:06:20 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 23CC380393;
        Mon,  3 Jul 2023 13:06:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688403979; bh=mMdAARksaz/mxT3qP3p6Iftqlg9w4LLJTf4O0LgobJg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rRghQQyAIve602IcgIljMe2VwNeHB3UnEm2JUj7cfpvBiXM88Gnqhgel0TT1HGEfb
         RO5/PmOl3//ChK+uhuaeZ6t7xmlh65BfqXuXYy/0agurR4JH+COUzEBDe4oKzBAljy
         S6GTbAeQo7YxvjXTzHIwDMm0dRjohKbS6L4vSXBKPs4tElOkl2k8291uAnXopUNtjK
         f/2p4lgdzU16bySfnRMnJ5vzhgQpBhOPkGP+8l4QY0Mptp+bNXA/nCONyAswM1KISG
         p95SdK4QiZOAMN81NwisT3DFCXt2d0NU7vMlf6r9lp7k4LK1o6SSgOnk2R6Ls2+5xC
         dDkcPWjjR4zWQ==
Message-ID: <712d5490-8f36-f41d-4488-91e86e694cad@dorminy.me>
Date:   Mon, 3 Jul 2023 13:06:17 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v1 00/12] fscrypt: add extent encryption
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
 <20230703045417.GA3057@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <20230703045417.GA3057@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



>> base-commit: accadeb67609a5a5d088ebde8409c3f6db0b84b4
> 
> Thanks for sending this out!
> 
> It's going to take me a while to go through everything, so please bear with me.
> In general I'd also really like to be seeing more feedback from the other btrfs
> developers.  This is a hard project that really needs more eyes on it.

I appreciate your time on it!
> 
>  From a brief look through your patchsets, there's one thing I want to bring up
> right away.  It seems that one important design choice that you've made that has
> impacted much of your patchsets is that you've made each extent a fully
> standalone thing, similar to inodes currently.  I.e.,
> 
>      (a) Each extent gets a full 'fscrypt_context' stored along with it.  That
>          includes not just the nonce, but also the encryption modes and master
>          key identifier.
> 
>      (b) For runtime caching, each extent gets a full 'struct fscrypt_info'
>          object.  It doesn't "belong" to any inode; it's set up in a fully
>          standalone way, and the master key lookup and removal logic operates
>          directly on the extent's 'struct fscrypt_info'.
> 
> I'm not sure this is a good idea.  What I had thought it was going to look like
> is that the encryption context/policy and 'struct fscrypt_info' would stay a
> property of the inode, and the extents themselves would be much more lightweight
> -- both on disk and in the cache.  On-disk, all that should really be needed for
> an extent is the nonce for deriving the per-extent key.  And in-memory, all that
> should really be needed is a "fscrypt_prepared_key" for the per-extent key, and
> a reference to the owning inode.
 >

The in memory reduction is plausible. For extents that are in memory but 
not yet written to disk, we need some way to keep track of the context, 
but we could drop the nonce/policy after that. I was aiming to have the 
same structure so that there's maximal similarity in info creation and 
things like fscrypt_generate_iv would always be getting an info, 
regardless of inode vs extent, but we could throw a conditional in there 
and create a different structure for in-memory extent infos.

However, it seems like an extent and a leaf inode in inode fscrypt need 
the same information, so if splitting the fscrypt_info structure makes 
sense, maybe it should be on that boundary?

> 
> I think that would avoid many of the problems that it seems you've had to work
> around or have had to change user-visible semantics for.  For example the
> problems involving master keys being added and removed.  It would also avoid
> having to overload 'fscrypt_info' to be either a per-inode or a per-extent key.
> And it would save space on disk and in memory.

I might be misunderstanding what you're referencing, but I think you're 
talking about the change where with extent fscrypt, IO has to be forced 
down before removing a key, otherwise it is lost. I think that's a 
fundamental problem given the filesystem has no way to know that there 
are new, dirty pages in the pagecache until those pages are issued for 
write, so it can't create a new extent or few until that point, 
potentially after the relevant key has been evicted. But maybe I'm 
missing a hook that would let us make extents earlier.

I suppose we could give each leaf inode a proper nonce/prepared key 
instead of borrowing its parent dir's: if a write came in after the key 
was removed but the inode is still open, the new extent(s) could grab 
the key material out of the inode's info. I don't like this very much 
since it could result in multiple extents grabbing the same key 
material, but I suppose it could work if it's important to maintain that 
behavior.
> 
> Can you elaborate on why you went with a more "heavyweight" extents design?
Being able to rekey a directory is the reason for having full contexts: 
suppose I take a snapshot of an encrypted dir and want to change the key 
for new data going forward, to avoid using a single key on too much 
data. It's too expensive to reencrypt every extent with the new key, 
since the whole point of a snapshot is to make a lightweight copy that 
gets COWed on write. Then each extent needs to know what its own master 
key identifier/policy/flags are, since different extents in the same 
file could have different master keys. We could say the mode and flags 
have to match, but it doesn't seem to me worth saving seven bytes to add 
a new structure to just store the master key identifier and nonce.

For a non-Meta usecase, from what I've heard from Fedora-land, it's 
possibly interesting to them to be able to ship an encrypted image, and 
then be able to change the key after encrypted install to something 
user-controlled.

Without rekeying, my understanding is that we may write too much data 
with one key for safety; notes in the updated design doc 
https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing 
are that writing more than 1P per key raises cryptographic concerns, and 
since btrfs is COW and could have volumes up to the full 16E size that 
btrfs supports, we don't want to have just one immutable key per subvol.

To me the lightweight-on-disk vision sounds a lot like the original 
design: 
https://lore.kernel.org/linux-btrfs/YXGyq+buM79A1S0L@relinquished.localdomain 
and the Nov '22 version of the patchset: 
https://lore.kernel.org/linux-btrfs/cover.1667389115.git.sweettea-kernel@dorminy.me/ 
(which didn't have rekeying). I think rekeying is worth the higher disk 
usage; but I'm probably missing something about how your vision differs 
from the original. Could you please take a look at it again?

> 
> Maybe your motivation is that extents can be referenced by more than one inode
> and thus do not have a unique owning inode?  That's true, but I don't think that
> really matters.  All the inodes that reference an extent will have the same
> encryption policy, right? 
As above, not necessarily

> Also, it looks like the "struct extent_map" that
> you're caching the per-extent key in is already cached on a per-inode basis, in
> btrfs_inode::extent_tree, similar to the pagecache which is also per-inode.  So
> if the same extent happens to be accessed via multiple inodes, that's still
> going to cause the fscrypt key to be set up twice anyway.

A good point, and if you want me to take advantage of the 
one-copy-per-inode fact for general extent-based fscrypt I can do so.

Many thanks!

Sweet Tea
