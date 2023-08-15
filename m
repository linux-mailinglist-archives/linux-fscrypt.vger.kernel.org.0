Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B84A77CEBD
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Aug 2023 17:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjHOPMg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Aug 2023 11:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237676AbjHOPMN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Aug 2023 11:12:13 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807F71733
        for <linux-fscrypt@vger.kernel.org>; Tue, 15 Aug 2023 08:12:09 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-4039f7e1d3aso42789011cf.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 15 Aug 2023 08:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1692112328; x=1692717128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=13kQ7DPdX5VCZmuDZ5ko+IVwo2OafLOIPXAzQNAn5wA=;
        b=BHjSV/UQkRM0L/GQtm97m6L5maILVO8lOlZoBKha0hECa+kkwbNlpJM6DjOq7SOfkA
         zwKMr0YLvmcVmoURpNXeLP6IOI3uAb4AcVERZnC1oF+FXdQzyA659yP0XTwJV7DaIU40
         YX3GiO9UO237PXtjhRKXt8+zbFYFD5b0Hx9x/ap9nzyPC9HnxWXsKI/XcUwkCf2PgBsg
         7MtOvX0fk7myvyhmB9yBtGWV1YcF4ETMu7wVhZCgBrRozKvquEAQus4/tmlb9OG7jhsh
         6CqAJ4y+Mt1pBGbXdWEC0BVL23UEacAhCfweyWozwUZyiDVejOzhnBvQ5JAyPxQGAxlN
         k9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692112328; x=1692717128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13kQ7DPdX5VCZmuDZ5ko+IVwo2OafLOIPXAzQNAn5wA=;
        b=hE8W/flHQHBjAPbcBPQ/X4HtjROd6xGondqWC2sh42f/jUc+g9IN/t748H+5MTe1Tj
         cgds0GBk+AvXpZ3VPqWfxkrjQqJzkMpMa/chub+/Seq/87ZEwjc9Lh3tKsISLiQOSrej
         bhTWAR8uCpL/dPV7EM4/yik4RKMJrse5Qra8XNetSZy8Ca13XFdcZ1MkaEIB6cZbFOo/
         7dbV47fHYE6WPPpXDxaWfxoT43/zii6NSS31DcrELcljlEIyYwzSbd1R1gHYQuaxBsme
         /+++I4nsEF6CGYoLEq9AgItyzVB81Ep3zaJE4z+FMOUY5Wif9dI6VFbFK+9sGhNd3fed
         0VEQ==
X-Gm-Message-State: AOJu0Yz36FjA6oKXNweBm2e/ZF/ZiR9tPV1yomSNYWDteTOq3+PMb5mO
        cbM8tbL1g2YEAPNUQXeP3sZhqg==
X-Google-Smtp-Source: AGHT+IFEynnheutvB0XO0QKs+nrCRoGmoOn/Ljuxi2F+kAUDGC3+f/VoVOC5RORzawETPID9fQjoUg==
X-Received: by 2002:ac8:7e96:0:b0:403:a308:3cfc with SMTP id w22-20020ac87e96000000b00403a3083cfcmr18624942qtj.25.1692112328577;
        Tue, 15 Aug 2023 08:12:08 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id z1-20020ac875c1000000b00401e04c66fesm3866568qtq.37.2023.08.15.08.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 08:12:07 -0700 (PDT)
Date:   Tue, 15 Aug 2023 11:12:06 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 00/16] fscrypt: add extent encryption
Message-ID: <20230815151206.GA2844403@perftesting>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
 <20230812221514.GA2207@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230812221514.GA2207@sol.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Aug 12, 2023 at 03:15:14PM -0700, Eric Biggers wrote:
> Hi Sweet Tea,
> 
> On Tue, Aug 08, 2023 at 01:08:17PM -0400, Sweet Tea Dorminy wrote:
> > This changeset adds extent-based data encryption to fscrypt.
> > Some filesystems need to encrypt data based on extents, rather than on
> > inodes, due to features incompatible with inode-based encryption. For
> > instance, btrfs can have multiple inodes referencing a single block of
> > data, and moves logical data blocks to different physical locations on
> > disk in the background. 
> > 
> > As per discussion last year in [1] and later in [2], we would like to
> > allow the use of fscrypt with btrfs, with authenticated encryption. This
> > is the first step of that work, adding extent-based encryption to
> > fscrypt; authenticated encryption is the next step. Extent-based
> > encryption should be usable by other filesystems which wish to support
> > snapshotting or background data rearrangement also, but btrfs is the
> > first user. 
> > 
> > This changeset requires extent encryption to use inlinecrypt, as
> > discussed previously. 
> > 
> > This applies atop [3], which itself is based on kdave/misc-next. It
> > passes encryption fstests with suitable changes to btrfs-progs.
> > 
> > Changelog:
> > v3:
> >  - Added four additional changes:
> >    - soft-deleting keys that extent infos might later need to use, so
> >      the behavior of an open file after key removal matches inode-based
> >      fscrypt.
> >    - a set of changes to allow asynchronous info freeing for extents,
> >      necessary due to locking constraints in btrfs.
> > 
> > v2: 
> >  - https://lore.kernel.org/linux-fscrypt/cover.1688927487.git.sweettea-kernel@dorminy.me/T/#t
> > 
> > 
> > [1] https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
> > [2] https://lore.kernel.org/linux-fscrypt/80496cfe-161d-fb0d-8230-93818b966b1b@dorminy.me/T/#t
> > [3] https://lore.kernel.org/linux-fscrypt/cover.1691505830.git.sweettea-kernel@dorminy.me/
> > 
> > Sweet Tea Dorminy (16):
> >   fscrypt: factor helper for locking master key
> >   fscrypt: factor getting info for a specific block
> >   fscrypt: adjust effective lblks based on extents
> >   fscrypt: add a super_block pointer to fscrypt_info
> >   fscrypt: setup leaf inodes for extent encryption
> >   fscrypt: allow infos to be owned by extents
> >   fscrypt: use an optional ino equivalent for per-extent infos
> >   fscrypt: move function call warning of busy inodes
> >   fscrypt: revamp key removal for extent encryption
> >   fscrypt: add creation/usage/freeing of per-extent infos
> >   fscrypt: allow load/save of extent contexts
> >   fscrypt: save session key credentials for extent infos
> >   fscrypt: allow multiple extents to reference one info
> >   fscrypt: cache list of inlinecrypt devices
> >   fscrypt: allow asynchronous info freeing
> >   fscrypt: update documentation for per-extent keys
> > 
> >  Documentation/filesystems/fscrypt.rst |  43 +++-
> >  fs/crypto/crypto.c                    |   6 +-
> >  fs/crypto/fscrypt_private.h           | 158 +++++++++++-
> >  fs/crypto/inline_crypt.c              |  49 ++--
> >  fs/crypto/keyring.c                   |  78 +++---
> >  fs/crypto/keysetup.c                  | 336 ++++++++++++++++++++++----
> >  fs/crypto/keysetup_v1.c               |  10 +-
> >  fs/crypto/policy.c                    |  20 ++
> >  include/linux/fscrypt.h               |  67 +++++
> >  9 files changed, 654 insertions(+), 113 deletions(-)
> 
> I'm taking a look at this, but I don't think it's really reviewable in its
> current state.  The main problem is how the new functionality is reusing struct
> fscrypt_info.  Before an fscrypt_info was the information (key, policy, inode
> back-pointer, master key link, etc.) associated with an inode.  But now it can
> be any of the following:
> 
> - Information for an inode
> - Cached policy (?) for a "leaf inode"
> - Information for an extent
> 
> Everything just seems kind of mixed together.  It's not clear which fields of
> fscrypt_info apply to which scenario, and which scenario(s) is being handled
> when code works with fscrypt_info.  There seem to be bugs caused by these
> scenarios being mixed up.  Comments are also inconsistent; a huge number of them
> still refer only to "inode" or "file" when that is no longer correct.  So it's
> quite hard to understand the code now.
> 
> I think there really needs to be some work on designing and documenting the data
> structures for what you are trying to accomplish.  That really ought to have
> been the first step before getting deep into coding the actual functionality.
> 
> Have you considered creating a new struct like fscrypt_extent_info, instead of
> reusing fscrypt_info?  I think that would make things much clearer.  I suppose
> there is code that needs to operate on the shared fields of both, but that could
> be done by putting the shared fields in a sub-struct like 'struct
> fscrypt_common_info common;', and passing around a pointer to that where needed.
> 
> I'd also like to reiterate the concern I raised last month
> (https://lore.kernel.org/linux-fscrypt/20230703045417.GA3057@sol.localdomain/):
> a lot of this complexity seems to have been contributed to by the "heavyweight
> extents" design choice.  I was hoping to see a detailed design for the "change a
> directory's tree encryption policy" feature you are planning to use this for, in
> order to get some confidence that it will actually be implemented.  Otherwise, I
> fear we'll end up building in a lot of complexity for something that never gets
> implemented.

This is partly my fault, Sweet Tea has been working on this for a while, and it
seems the lack of progress is partly to do with him wanting everything to be
perfect before sending things out, so I've been encouraging him to increase his
iteration frequency so we could get to a mergeable state sooner.

To that end, I told him to leave off the "change the encryption key"
functionality for now and send that along once we had agreement on this part.
My thinking was that's the hairier/more controversial part, and I want to see
progress made on the core fscrypt functionality so we don't get bogged down on
other discussions.

As for the data structures part I was lead to believe this was important for our
usecase.  But it appears you have another method in mind.

In the interest of getting this thing unstuck I'd like to get it clear in my
head what you're wanting to see, and explain what we're wanting to do, and then
I can be more useful in guiding Sweet Tea through this.

What we want (as I currently understand it):

- We have an un-encrypted subvolumed that contains the base image.  Think a
  chroot of centos9 or whatever.
- Start a container, we snapshot this base image, set an encryption key for this
  container, all new writes into this snapshot will now be encrypted with this
  per-container key.
- This container could potentially create a container within this encrypted
  container to run.  Think a short lived job orchestrator.  I run service X that
  is going to run N tasks, each task in it's own container.  Under my encrypted
  container I'm going to be creating new subvolumes and setting a different key
  for those subvolumes.  Then once those jobs are done I'm going to delete that
  subvolume and carry on.

Weird btrfs things that make life difficult:

- Reflink.  Obviously we're not going to be reflinking from an encrypted
  subvolume into a non-encrypted subvolume, everything will have to match, but
  this is still between different inodes, which means we need some per-extent
  context.
- Snapshots.  Technically we would be fine here since the inodes metadata would
  be the same here, so maybe not so difficult.
- Relocation.  This is our "move data around underneath everybody" thing that we
  do all the time.  I'm not actually sure if this poses a problem, I know Sweet
  Tea said it did, but my eyes sort of glaze over whenever we're talking about
  encryption so I don't remember the details.

What I think you want:

- A clearer deliniation in the fscrypt code of what we do with per-extent
  encryption vs everything else.  This is easy for me to grok.
- A lighter weight per-extent encryption scheme.  This is the part that I'm
  having trouble with.  I've been reviewing the code from a "is this broken"
  standpoint, because I don't have the expertise in this area to make a sound
  judgement.  The btrfs parts are easy, and that code is fine.  I trust Sweet
  Tea's judgement to do make decisions that fit our use case, but this seems to
  be the crux of the problem.

This series is the barebones "get fscrypt encrypting stuff on btrfs" approach,
with followups for the next, hairier bits.

But we're over a year into this process and still stuck, so I'm sitting down to
understand this code and the current situation in order to provide better
guidance for Sweet Tea.  Please correct me where I've gone wrong, I've been
going back and reading the emails trying to catch up, so I'm sure I've missed
things.  Thanks,

Josef
