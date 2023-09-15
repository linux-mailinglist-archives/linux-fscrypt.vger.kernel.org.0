Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31BE7A1FD1
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Sep 2023 15:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbjION2M (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Sep 2023 09:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235233AbjION2L (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Sep 2023 09:28:11 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407D610D
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 Sep 2023 06:28:06 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-4135d72c75bso13304191cf.0
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 Sep 2023 06:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1694784485; x=1695389285; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8SxnKkQXIhJCaA3FrN/03NRqHQwr8oxA83eBkch9W/I=;
        b=R0xlW/moA0qavQsqtcziWHhCRD5jcD5x9paDCut9LWnvXimRKVZW7d/kkFOk9khii2
         2kzcIvDslKSAgWKJszTGPo4jvvKV9+5tQgCrH/moOkW26E5oLNRqEEOWALTw++K5Y7HK
         D9EEU+ZaLXTSi7akyQgQ/a2xsCyYg9xG84tUosA7r1DrLWLeUrt85dkacey77ADliVQA
         QZpmCSrbVxjeMVQN+g2tQyACnN4z/oEv8C++x/tHxtB1Qlxty5Kq0JLxF6QL1wpTQW3X
         R8G58IlfkQkXz9wLyOiYiBfFU6Vpig485JqIiesoKMNBCQoQG5HCr5N8nXtkxXfIdVtV
         KTYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694784485; x=1695389285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8SxnKkQXIhJCaA3FrN/03NRqHQwr8oxA83eBkch9W/I=;
        b=RhG6KP0TJ37U3TKIoI/OMNZedg4ZrYpvtMIrFd8qMrcOjn/e/jtCkdEzZl4nWYUR7g
         EAjNCsMb2VD/ULC7/rx6HQOxMmZc870V+2b6parwf31f+qn90Tb6Q/YhpctcVSYBdy73
         pVAT36hT8W0Y6lj/8QxUAuXGAWuHOiawfgQLAxUc8QYlHeL4tVzhMdRcjce1arhlHWz6
         Enr8P7qSCzxO50L0FBSZ6egLSf53vItzE62UHpumX8eH7PdpJIjt05bO4bKrYsUewc3N
         kb3KrUNtBXsLpDqoJPFizZzPZWDicpYO3aZ/o8n4fLRNx8TeKqS7dTiWraa4s6n7qTXW
         Qf5g==
X-Gm-Message-State: AOJu0YxNvDl8dC2d/V7WKCRuxnFfF1GxWvJhDhuK17dBKFEPhdlYcaBa
        6kuc+zzRc7f9ztBPYcQW4mZ3Ow==
X-Google-Smtp-Source: AGHT+IEJeGoizhLRjsRluKvIbhna8l0HngFTe7/SLs3Jfnj5lQJPp0lXR7xnv9RW3w+qjDiEPS91zQ==
X-Received: by 2002:ac8:5b16:0:b0:403:8de7:4503 with SMTP id m22-20020ac85b16000000b004038de74503mr2197396qtw.52.1694784485354;
        Fri, 15 Sep 2023 06:28:05 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id e6-20020ac81306000000b0041524a92367sm1147304qtj.16.2023.09.15.06.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 06:28:04 -0700 (PDT)
Date:   Fri, 15 Sep 2023 09:28:03 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        clm@fb.com, ngompa13@gmail.com, sweettea-kernel@dorminy.me,
        kernel-team@meta.com
Subject: Re: [RFC PATCH 0/4] fscrypt: add support for per-extent encryption
Message-ID: <20230915132803.GA3604351@perftesting>
References: <cover.1694738282.git.josef@toxicpanda.com>
 <20230915064816.GA2090@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915064816.GA2090@sol.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Sep 14, 2023 at 11:48:16PM -0700, Eric Biggers wrote:
> On Thu, Sep 14, 2023 at 08:47:41PM -0400, Josef Bacik wrote:
> > Hello,
> > 
> > This is meant as a replacement for the last set of patches Sweet Tea sent [1].
> > This is an attempt to find a different path forward.  Strip down everything to
> > the basics.  Essentially all we appear to need is a nonce, and then we can use
> > the inode context to derive per-extent keys.
> > 
> > I'm sending this as an RFC to see if this is a better direction to try and make
> > some headway on this project.  The btrfs side doesn't change too much, the code
> > just needs to be adjusted to use the new helpers for the extent contexts.  I
> > have this work mostly complete, but I'm afraid I won't have it ready for another
> > day or two and I want to get feedback on this ASAP before I burn too much time
> > on it.
> > 
> > Additionally there is a callback I've put in the inline block crypto stuff that
> > we need in order to handle the checksumming.  I made my best guess here as to
> > what would be the easiest and simplest way to acheive what we need, but I'm open
> > to suggestions here.
> > 
> > The other note is I've disabled all of the policy variations other than default
> > v2 policies if you enable extent encryption.  This is for simplicity sake.  We
> > could probably make most of it work, but reflink is basically impossible for v1
> > with direct key, and is problematic for the lblk related options.  It appears
> > this is fine, as those other modes are for specific use cases and the vast
> > majority of normal users are encouraged to use normal v2 policies anyway.
> > 
> > This stripped down version gives us most of what we want, we can reflink between
> > different inodes that have the same policy.  We lose the ability to mix
> > differently encrypted extents in the same inode, but this is an acceptable
> > limitation for now.
> > 
> > This has only been compile tested, and as I've said I haven't wired it
> > completely up into btrfs yet.  But this is based on a rough wire up and appears
> > to give us everything we need.  The btrfs portion of Sweet Teas patches are
> > basically untouched except where we use these helpers to deal with the extent
> > contexts.  Thanks,
> > 
> > Josef
> > 
> > [1] https://lore.kernel.org/linux-fscrypt/cover.1693630890.git.sweettea-kernel@dorminy.me/
> > 
> > Josef Bacik (4):
> >   fscrypt: rename fscrypt_info => fscrypt_inode_info
> >   fscrypt: add per-extent encryption support
> >   fscrypt: disable all but standard v2 policies for extent encryption
> >   blk-crypto: add a process bio callback
> > 
> >  block/blk-crypto-fallback.c |  18 ++++
> >  block/blk-crypto-profile.c  |   2 +
> >  block/blk-crypto.c          |   6 +-
> >  fs/crypto/crypto.c          |  23 +++--
> >  fs/crypto/fname.c           |   6 +-
> >  fs/crypto/fscrypt_private.h |  78 ++++++++++++----
> >  fs/crypto/hooks.c           |   2 +-
> >  fs/crypto/inline_crypt.c    |  50 +++++++++--
> >  fs/crypto/keyring.c         |   4 +-
> >  fs/crypto/keysetup.c        | 174 ++++++++++++++++++++++++++++++++----
> >  fs/crypto/keysetup_v1.c     |  14 +--
> >  fs/crypto/policy.c          |  45 ++++++++--
> >  include/linux/blk-crypto.h  |   9 +-
> >  include/linux/fs.h          |   4 +-
> >  include/linux/fscrypt.h     |  41 ++++++++-
> >  15 files changed, 400 insertions(+), 76 deletions(-)
> 
> Thanks Josef!  At a high level this looks good to me.  It's much simpler.  I
> guess my main question is "what is missing" (besides the obvious things like
> updating the documentation and polishing code comments).  I see you got rid of a
> lot of the complexity in Sweet Tea's patchset, which is great as I think a lot
> of it was unnecessary as I've mentioned.  But maybe something got overlooked?
> I'm mainly wondering about the patches like "fscrypt: allow asynchronous info
> freeing" that were a bit puzzling but have now gone away.
> 

I'm going to fix this in a different way internally in btrfs.  There's only once
place where we can't drop the lock, so I plan to just collate free'd EM's and
free them in bulk after we drop the lock.  This *may* not fix the problem, I
have to wait for lockdep to tell me I'm stupid and I missed some other
dependency, but if that's the case I'll just async free our EM's, that way I can
synchronize dropping the objects at inode drop time to avoid unpleasant timing
issues.

> Not supporting v1 encryption policies is the right call, I think.  xfstests will
> need to be updated to not assume that v1 is always supported, but that's
> something I've been thinking about doing anyway.
> 
> The patch that adds support for checksumming the on-disk data is new.  I see why
> it's needed.  I suppose that's just been overlooked until now?  It's definitely
> correct that you need to checksum the ciphertext, not the plaintext.  Otherwise
> the checksums leak information about the plaintext.
> 

I think Sweet Tea was leaving this as a followup exercise, but I'd rather have
everything working out of the box, and since my patchset was a lot simpler I
figured I'd give you more opportunities to yell at me for something.

> Did you consider the idea I mentioned at the end of
> https://lore.kernel.org/r/20230907055233.GB37146@sol.localdomain where we store
> a full fscrypt_context per extent, but for now validate that it matches the
> inode's context (minus the nonce) and only support that case?
> 

I missed this bit of feedback, I like it a lot actually because if we do decide
later to tackle key changing it would be nice if existing file systems had
everything they needed.  I think I'll still keep the slimmed down extent context
and just throw the master key in there and the encrytion type, and then do as
you say and validate it matches the inode.

> I guess the reasons to do that would be (1) futureproofing, (2) error checking
> to catch any bugs where an extent might be accessed inconsistently, and (3)
> making extents "standalone" so that they can be decrypted by anything that
> iterates through the extents only (e.g. btrfs scrub as mentioned by Sweet Tea;
> though, how will scrub even have access to the encryption keys?).  I don't have
> a great sense of how strong these reasons actually are, so any thoughts would be
> appreciated.  If just the nonce is really all that's needed, then that's fine
> too.  The point is, the part I was concerned about wasn't really whether the key
> identifier and encryption settings get stored per extent, but rather whether we
> actually support the case where these differ from the inode's.

Scrub just needs to read the raw bytes and validate the checksums.  This is my
other motivation for doing the checksum thing now, I want to make sure things
like scrub work out of the box since that's one of the "tricky" parts when it
comes to having data it can't actually derypt.

The key identifier is mostly around being able to simply support different keys
in the same inode, primarly for re-keying.  There is some talk of people wanting
to have differently encrypted subvolumes and reflink between them, and having
this information per-extent would make that a lot easier.  For now I've told
those people to kick rocks, but it'll be nice to be setup to add this support
later on.

> 
> (And by "the inode" I really mean "the inode that owns the extent cache entry
> the extent is being accessed through".  It's the case that when an extent is
> shared by multiple inodes, it gets a cache entry for each one, right?)
> 

Yup the cache entry gets loaded from the extent itself, so we'll have duplicate
cache entries since they're tied to the inode.  It's the same for our extent
maps as well, since you could at any point overwrite part of it and need to
update the in-memory mapping.

Thanks for the quick feedback, I'm going to finish making the appropriate
changes to the btrfs patches, make sure everything works.  I'll clean up these
patches and make the changes you suggested, and I'll update the documentation.
It'll probably be early next week when I send again, I'll do the work for
xfstests so everything works in this v2 only world.

Josef
