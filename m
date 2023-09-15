Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E6C7A166A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Sep 2023 08:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbjIOGss (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Sep 2023 02:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjIOGsr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Sep 2023 02:48:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E972D4D;
        Thu, 14 Sep 2023 23:48:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0856C433C8;
        Fri, 15 Sep 2023 06:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694760498;
        bh=lWztj3r9iypypdZ0FREOy5ynsNzq+ID/Wk+Vqrw7u/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mifHp2kZRjEKP82mQzk/H+QmCWmvZ7wZ7i7LzTRJHdLfm5AEDgpjSU6RyWXYzIEat
         G5v3oOYaMUmvKuH4A3mJQNH/ShyoDCJCHliEIg0hwjQKVcz/iRhU4aRSKWCIi1P1rd
         cGHfupi9b7R2/hhJkPY/SAv8f7dNQJGldAYaoEsbgfvXn/u6hVqlKiUo9L5i/gHcsU
         EIAgc+r7k8uEGPBc8MoB74ddtVuoS8pHVD6pIGfvi9H+q/cuN9DmycCfjXmyQSXqci
         xBQ8et/sqDSHIZDpUV51eCIwQ/4bxMycridxtSdr/yQpeKuRbb5hqsqtLLOhdxy13q
         PveCxHE0vqJmg==
Date:   Thu, 14 Sep 2023 23:48:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        clm@fb.com, ngompa13@gmail.com, sweettea-kernel@dorminy.me,
        kernel-team@meta.com
Subject: Re: [RFC PATCH 0/4] fscrypt: add support for per-extent encryption
Message-ID: <20230915064816.GA2090@sol.localdomain>
References: <cover.1694738282.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1694738282.git.josef@toxicpanda.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Sep 14, 2023 at 08:47:41PM -0400, Josef Bacik wrote:
> Hello,
> 
> This is meant as a replacement for the last set of patches Sweet Tea sent [1].
> This is an attempt to find a different path forward.  Strip down everything to
> the basics.  Essentially all we appear to need is a nonce, and then we can use
> the inode context to derive per-extent keys.
> 
> I'm sending this as an RFC to see if this is a better direction to try and make
> some headway on this project.  The btrfs side doesn't change too much, the code
> just needs to be adjusted to use the new helpers for the extent contexts.  I
> have this work mostly complete, but I'm afraid I won't have it ready for another
> day or two and I want to get feedback on this ASAP before I burn too much time
> on it.
> 
> Additionally there is a callback I've put in the inline block crypto stuff that
> we need in order to handle the checksumming.  I made my best guess here as to
> what would be the easiest and simplest way to acheive what we need, but I'm open
> to suggestions here.
> 
> The other note is I've disabled all of the policy variations other than default
> v2 policies if you enable extent encryption.  This is for simplicity sake.  We
> could probably make most of it work, but reflink is basically impossible for v1
> with direct key, and is problematic for the lblk related options.  It appears
> this is fine, as those other modes are for specific use cases and the vast
> majority of normal users are encouraged to use normal v2 policies anyway.
> 
> This stripped down version gives us most of what we want, we can reflink between
> different inodes that have the same policy.  We lose the ability to mix
> differently encrypted extents in the same inode, but this is an acceptable
> limitation for now.
> 
> This has only been compile tested, and as I've said I haven't wired it
> completely up into btrfs yet.  But this is based on a rough wire up and appears
> to give us everything we need.  The btrfs portion of Sweet Teas patches are
> basically untouched except where we use these helpers to deal with the extent
> contexts.  Thanks,
> 
> Josef
> 
> [1] https://lore.kernel.org/linux-fscrypt/cover.1693630890.git.sweettea-kernel@dorminy.me/
> 
> Josef Bacik (4):
>   fscrypt: rename fscrypt_info => fscrypt_inode_info
>   fscrypt: add per-extent encryption support
>   fscrypt: disable all but standard v2 policies for extent encryption
>   blk-crypto: add a process bio callback
> 
>  block/blk-crypto-fallback.c |  18 ++++
>  block/blk-crypto-profile.c  |   2 +
>  block/blk-crypto.c          |   6 +-
>  fs/crypto/crypto.c          |  23 +++--
>  fs/crypto/fname.c           |   6 +-
>  fs/crypto/fscrypt_private.h |  78 ++++++++++++----
>  fs/crypto/hooks.c           |   2 +-
>  fs/crypto/inline_crypt.c    |  50 +++++++++--
>  fs/crypto/keyring.c         |   4 +-
>  fs/crypto/keysetup.c        | 174 ++++++++++++++++++++++++++++++++----
>  fs/crypto/keysetup_v1.c     |  14 +--
>  fs/crypto/policy.c          |  45 ++++++++--
>  include/linux/blk-crypto.h  |   9 +-
>  include/linux/fs.h          |   4 +-
>  include/linux/fscrypt.h     |  41 ++++++++-
>  15 files changed, 400 insertions(+), 76 deletions(-)

Thanks Josef!  At a high level this looks good to me.  It's much simpler.  I
guess my main question is "what is missing" (besides the obvious things like
updating the documentation and polishing code comments).  I see you got rid of a
lot of the complexity in Sweet Tea's patchset, which is great as I think a lot
of it was unnecessary as I've mentioned.  But maybe something got overlooked?
I'm mainly wondering about the patches like "fscrypt: allow asynchronous info
freeing" that were a bit puzzling but have now gone away.

Not supporting v1 encryption policies is the right call, I think.  xfstests will
need to be updated to not assume that v1 is always supported, but that's
something I've been thinking about doing anyway.

The patch that adds support for checksumming the on-disk data is new.  I see why
it's needed.  I suppose that's just been overlooked until now?  It's definitely
correct that you need to checksum the ciphertext, not the plaintext.  Otherwise
the checksums leak information about the plaintext.

Did you consider the idea I mentioned at the end of
https://lore.kernel.org/r/20230907055233.GB37146@sol.localdomain where we store
a full fscrypt_context per extent, but for now validate that it matches the
inode's context (minus the nonce) and only support that case?

I guess the reasons to do that would be (1) futureproofing, (2) error checking
to catch any bugs where an extent might be accessed inconsistently, and (3)
making extents "standalone" so that they can be decrypted by anything that
iterates through the extents only (e.g. btrfs scrub as mentioned by Sweet Tea;
though, how will scrub even have access to the encryption keys?).  I don't have
a great sense of how strong these reasons actually are, so any thoughts would be
appreciated.  If just the nonce is really all that's needed, then that's fine
too.  The point is, the part I was concerned about wasn't really whether the key
identifier and encryption settings get stored per extent, but rather whether we
actually support the case where these differ from the inode's.

(And by "the inode" I really mean "the inode that owns the extent cache entry
the extent is being accessed through".  It's the case that when an extent is
shared by multiple inodes, it gets a cache entry for each one, right?)

- Eric
