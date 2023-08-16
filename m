Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082EE77E3FB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Aug 2023 16:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245686AbjHPOnB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Aug 2023 10:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343735AbjHPOmb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Aug 2023 10:42:31 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F067926BD
        for <linux-fscrypt@vger.kernel.org>; Wed, 16 Aug 2023 07:42:29 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-645181e1eaeso25687006d6.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 16 Aug 2023 07:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1692196949; x=1692801749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=51xssmTKzhjllo0q2riJzihCMnkv/Wkbx4FI27jmeKk=;
        b=kGDG3GBZt82vV3lQxUbHwBZ/AOupe1Tq8Og/rgpiea7HlNYOeEFP2AZ7pZd6TcnbBN
         ItdBGmMGgjomnjo2AaQdWyAR8yPWgyrJXWor40/Gi45gqAU7mqtFoCiSf7hetufT2VdO
         LwF8S+lgPepTMS7Z1ygvCnqztLSq9Qor7FcAW903HrKvr0c70z7GI3Q80/lL5gd/LJOH
         /AU3DCKLGF3T5E1Qoa9YH0aP+VZNi3PZSWya5ONZ8bjElllBccyiTQlCqr9VGL/mcbKt
         MXTYkqjuvNIdlWsYDT4f9TxzWQbCLtlwT/Tsq6DBguTKTAWMZ/FnowryFitw2xoc0/kh
         iWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692196949; x=1692801749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=51xssmTKzhjllo0q2riJzihCMnkv/Wkbx4FI27jmeKk=;
        b=HdtTnEb+0fYCQU6qwYF+iGrm91Cq6bFMpQEvU5dxuHS+Pt1Hijn9a8P9NGMQenGUpu
         aTUVxoTPGOJT/DNPiEzolaPYFW1u4Lpuzcp/GUiyqfzJU07TD0fKqabY4+yBNWCNSl57
         +WiHefepZNgPi4KJKxedyskFSp2D15mEm+esT7B+MmF4Ixl1MuFfeqSJr7Py4SQbf/vk
         UvabLy5VgUVApQ+vgFYJ68KYWghTx462KoZMo/zZYIhMR4yYXZ6wGiUmA0qqC0lMt+Cb
         l2HyMOXULYBQaHsKM9uOriIITAyQmGVMqRFe+frRZTb1JSVQ3y45z8OcVkkzwA4hihWE
         Y1rA==
X-Gm-Message-State: AOJu0Yxi48WWpSkxHwHhxJ0ve83He9eM33IHJ7DMdk8dZQi6DsOrGdAW
        mr0jn3E4UmK/p/yEQ0Wl6dSPPg==
X-Google-Smtp-Source: AGHT+IGAv8R8SKdwuvL0vMWHSa9ibU/B5A8bOAtGwbmR6ceVU78l5x6LcnQZd1CTDbAATHchKMg83Q==
X-Received: by 2002:a0c:f482:0:b0:63d:2e15:d014 with SMTP id i2-20020a0cf482000000b0063d2e15d014mr2189911qvm.57.1692196948984;
        Wed, 16 Aug 2023 07:42:28 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id f8-20020a0caa88000000b00637873ff0f3sm4942556qvb.15.2023.08.16.07.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 07:42:27 -0700 (PDT)
Date:   Wed, 16 Aug 2023 10:42:26 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 00/16] fscrypt: add extent encryption
Message-ID: <20230816144226.GA2919664@perftesting>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
 <20230812221514.GA2207@sol.localdomain>
 <20230815151206.GA2844403@perftesting>
 <20230816033720.GB899@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230816033720.GB899@sol.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 15, 2023 at 08:37:20PM -0700, Eric Biggers wrote:
> On Tue, Aug 15, 2023 at 11:12:06AM -0400, Josef Bacik wrote:
> > 
> > This is partly my fault, Sweet Tea has been working on this for a while, and it
> > seems the lack of progress is partly to do with him wanting everything to be
> > perfect before sending things out, so I've been encouraging him to increase his
> > iteration frequency so we could get to a mergeable state sooner.
> > 
> > To that end, I told him to leave off the "change the encryption key"
> > functionality for now and send that along once we had agreement on this part.
> > My thinking was that's the hairier/more controversial part, and I want to see
> > progress made on the core fscrypt functionality so we don't get bogged down on
> > other discussions.
> 
> I've recommended, and continue to recommend, leaving out that feature from the
> patchset for now too.  The question is how does the plan to implement this
> feature impact the initial patchset, i.e. the basic support for btrfs
> encryption.  Should we choose a "heavyweight extents" design (a full
> fscrypt_context per extent: nonce, encryption modes, and key) now in preparation
> for that feature, or should we choose a "lightweight extents" design (just a
> nonce per extent, with modes and key coming from one of the extent's inodes
> which would all be enforced to have the same values of those).  The lightweight
> extents design wouldn't be compatible with the "change the encryption key"
> feature, but I expect it would be simpler.  Maybe there are issues that I
> haven't thought of, but that is what I expect.
> 
> So before going with a design that is potentially more complex, and won't be
> able to be changed later as it will define the on-disk format, I'm hoping to see
> a little more confirmation of "yes, this is really needed".  That could mean
> getting the design, or even better the implementation, ready for the "change the
> encryption key" feature.  Or, maybe you need "heavyweight extents" anyway
> because you want/need btrfs extents to be completely self-describing and don't
> want to have to pull any information from an inode -- maybe for technical
> reasons, maybe for philosophical reasons.  I don't know.  It's up to you guys to
> provide the rationale for the design you've chosen.

I've spent the last day getting a grasp on everything that we want and I'm in a
better place to answer these questions.

There seemed to be some confusion around having nested subvolumes with different
keys, and then reflinking between them.

So 

/container
/container/subcontainer

reflink /container/packagefile /container/subcontainer/packagefile

in this case the inode context wouldn't help, the inodes are different, thus the
heavy weight design is necessary.

However this isn't actually a thing that is a topline need.  I've told our
customers that in this case both /container and /container/subcontainer would
need to share encryption keys, and so this eliminates the need for the heavier
weight solution.  I like your design better, I think it fits most of our goals.

The actual real requirement we have is the unencrypted to encrypted, which is

/base/image
btrfs sub snap /base/image /container
turn on encryptiong /container

new writes in /container get encrypted.  We also want to be able to do

reflink /path/to/unencrypted/package/store/package /container/package

and have this work.  This still works with your design.  The only thing we would
reject with our design is

reflink /encrypted/key1/file /encrypted/key2/file

because the key id's wouldn't match.  This is an acceptable limitation for us to
acheive a more simplistic design.

> 
> BTW, one of the reasons for my concern is that the original plan for ext4
> encryption, which became fscrypt, was extremely ambitious and resulted in a
> complex design.  But only the first phase actually ended up getting implemented,
> and as a result the design was simplified greatly just before ext4 encryption
> was upstreamed.  I worry about something similar happening, but missing the
> "simplify the design" part and ending up with unnecessary complexity.
>
> > As for the data structures part I was lead to believe this was important for our
> > usecase.  But it appears you have another method in mind.
> > 
> > In the interest of getting this thing unstuck I'd like to get it clear in my
> > head what you're wanting to see, and explain what we're wanting to do, and then
> > I can be more useful in guiding Sweet Tea through this.
> > 
> > What we want (as I currently understand it):
> > 
> > - We have an un-encrypted subvolumed that contains the base image.  Think a
> >   chroot of centos9 or whatever.
> > - Start a container, we snapshot this base image, set an encryption key for this
> >   container, all new writes into this snapshot will now be encrypted with this
> >   per-container key.
> > - This container could potentially create a container within this encrypted
> >   container to run.  Think a short lived job orchestrator.  I run service X that
> >   is going to run N tasks, each task in it's own container.  Under my encrypted
> >   container I'm going to be creating new subvolumes and setting a different key
> >   for those subvolumes.  Then once those jobs are done I'm going to delete that
> >   subvolume and carry on.
> > 
> > Weird btrfs things that make life difficult:
> > 
> > - Reflink.  Obviously we're not going to be reflinking from an encrypted
> >   subvolume into a non-encrypted subvolume, everything will have to match, but
> >   this is still between different inodes, which means we need some per-extent
> >   context.
> > - Snapshots.  Technically we would be fine here since the inodes metadata would
> >   be the same here, so maybe not so difficult.
> > - Relocation.  This is our "move data around underneath everybody" thing that we
> >   do all the time.  I'm not actually sure if this poses a problem, I know Sweet
> >   Tea said it did, but my eyes sort of glaze over whenever we're talking about
> >   encryption so I don't remember the details.
> 
> I think a big challenge which is being glossed over is how do you actually set a
> new encryption policy for an entire directory tree, which can contain thousands
> (or even millions!) of files.  Do you actually go through and update something
> on every file, and if so who does it: userspace or kernel?  Or will there be a
> layer of indirection that allows the operation to be done in a fixed amount of
> work?  Maybe each inode has an encryption policy ID which points into a btree of
> encryption policies, and you update that btree to change what the ID refers to?
> But that doesn't work if you're changing the encryption policy of only a subset
> of files that use a given encryption policy, or if the files are unencrypted.

Since the scope is purely unencrypted snapshot -> encrypted this is much
simpler, only new things get the encryption policy set.

Say we snapshot, set the encryption key, and then write to the middle of a file.
That inode gets its encryption policy set, and that file extent is marked as
encrypted.  When we go to read back that whole file later we see the unencrypted
extents and read those like normal, then get to the encrypted extent and decrypt
that like normal.

> 
> > 
> > What I think you want:
> > 
> > - A clearer deliniation in the fscrypt code of what we do with per-extent
> >   encryption vs everything else.  This is easy for me to grok.
> > - A lighter weight per-extent encryption scheme.  This is the part that I'm
> >   having trouble with.  I've been reviewing the code from a "is this broken"
> >   standpoint, because I don't have the expertise in this area to make a sound
> >   judgement.  The btrfs parts are easy, and that code is fine.  I trust Sweet
> >   Tea's judgement to do make decisions that fit our use case, but this seems to
> >   be the crux of the problem.
> > 
> > This series is the barebones "get fscrypt encrypting stuff on btrfs" approach,
> > with followups for the next, hairier bits.
> > 
> > But we're over a year into this process and still stuck, so I'm sitting down to
> > understand this code and the current situation in order to provide better
> > guidance for Sweet Tea.  Please correct me where I've gone wrong, I've been
> > going back and reading the emails trying to catch up, so I'm sure I've missed
> > things.  Thanks,
> 
> The number one thing I'm asking for is something that's maintainable and as easy
> to understand as possible.  I don't think we've quite reached that yet.
> 

That's fair.  Like I said I've purposefully stayed out of this part because it's
quite a bit to page in a whole other project into my head and figure out what
would be the best course of action.  I think that narrowing our usecase to only
wanting to support unencrypted->encrypted for snapshots will make this simpler,
and integrating your more simplified light weight design for extent encryption
will result in something more to your liking.  Thanks,

Josef
