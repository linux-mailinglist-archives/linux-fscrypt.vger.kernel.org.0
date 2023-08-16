Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573E477D92D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Aug 2023 05:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238605AbjHPDkz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Aug 2023 23:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241658AbjHPDi1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Aug 2023 23:38:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0F43A8D;
        Tue, 15 Aug 2023 20:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C28B760AF5;
        Wed, 16 Aug 2023 03:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06C1C433C7;
        Wed, 16 Aug 2023 03:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692157042;
        bh=solSRAGpgSZcMnqMOVx0CFwCgZEIm+YXlHL3BSJb+zc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ofiii+jJHno9MzUCHG0WBzfQeZYC8QaaYxDLsffFUU6fCpRy8WjMB2kIDFZhCcy8Z
         y1rPfStzPXQ2i5/JREpOBdRjD0lwXl3ujE8/soAruQSJ2PRPcNzONZifHXxVwLSLoP
         /5RmvfX4QrUGkPn0yvgn0jAwjbxkEeyKDG7PmxoSfPc4FjOdXFmjtvp5CSuo1DUKZP
         7SVF6ELmPux5Pjfq/URiWoeocJ018IlUFgo06lYr4dMxIqpdvCXsbHyLyfmsyvChtS
         mWAmaOfZx247Xebt7vE8uEt2HW8ZTmUHL0VzgrIlfvFvv2LsBUWzlbgSxTHGQKK0sk
         SGu5ulWRb1f/w==
Date:   Tue, 15 Aug 2023 20:37:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 00/16] fscrypt: add extent encryption
Message-ID: <20230816033720.GB899@sol.localdomain>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
 <20230812221514.GA2207@sol.localdomain>
 <20230815151206.GA2844403@perftesting>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815151206.GA2844403@perftesting>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 15, 2023 at 11:12:06AM -0400, Josef Bacik wrote:
> 
> This is partly my fault, Sweet Tea has been working on this for a while, and it
> seems the lack of progress is partly to do with him wanting everything to be
> perfect before sending things out, so I've been encouraging him to increase his
> iteration frequency so we could get to a mergeable state sooner.
> 
> To that end, I told him to leave off the "change the encryption key"
> functionality for now and send that along once we had agreement on this part.
> My thinking was that's the hairier/more controversial part, and I want to see
> progress made on the core fscrypt functionality so we don't get bogged down on
> other discussions.

I've recommended, and continue to recommend, leaving out that feature from the
patchset for now too.  The question is how does the plan to implement this
feature impact the initial patchset, i.e. the basic support for btrfs
encryption.  Should we choose a "heavyweight extents" design (a full
fscrypt_context per extent: nonce, encryption modes, and key) now in preparation
for that feature, or should we choose a "lightweight extents" design (just a
nonce per extent, with modes and key coming from one of the extent's inodes
which would all be enforced to have the same values of those).  The lightweight
extents design wouldn't be compatible with the "change the encryption key"
feature, but I expect it would be simpler.  Maybe there are issues that I
haven't thought of, but that is what I expect.

So before going with a design that is potentially more complex, and won't be
able to be changed later as it will define the on-disk format, I'm hoping to see
a little more confirmation of "yes, this is really needed".  That could mean
getting the design, or even better the implementation, ready for the "change the
encryption key" feature.  Or, maybe you need "heavyweight extents" anyway
because you want/need btrfs extents to be completely self-describing and don't
want to have to pull any information from an inode -- maybe for technical
reasons, maybe for philosophical reasons.  I don't know.  It's up to you guys to
provide the rationale for the design you've chosen.

BTW, one of the reasons for my concern is that the original plan for ext4
encryption, which became fscrypt, was extremely ambitious and resulted in a
complex design.  But only the first phase actually ended up getting implemented,
and as a result the design was simplified greatly just before ext4 encryption
was upstreamed.  I worry about something similar happening, but missing the
"simplify the design" part and ending up with unnecessary complexity.

> As for the data structures part I was lead to believe this was important for our
> usecase.  But it appears you have another method in mind.
> 
> In the interest of getting this thing unstuck I'd like to get it clear in my
> head what you're wanting to see, and explain what we're wanting to do, and then
> I can be more useful in guiding Sweet Tea through this.
> 
> What we want (as I currently understand it):
> 
> - We have an un-encrypted subvolumed that contains the base image.  Think a
>   chroot of centos9 or whatever.
> - Start a container, we snapshot this base image, set an encryption key for this
>   container, all new writes into this snapshot will now be encrypted with this
>   per-container key.
> - This container could potentially create a container within this encrypted
>   container to run.  Think a short lived job orchestrator.  I run service X that
>   is going to run N tasks, each task in it's own container.  Under my encrypted
>   container I'm going to be creating new subvolumes and setting a different key
>   for those subvolumes.  Then once those jobs are done I'm going to delete that
>   subvolume and carry on.
> 
> Weird btrfs things that make life difficult:
> 
> - Reflink.  Obviously we're not going to be reflinking from an encrypted
>   subvolume into a non-encrypted subvolume, everything will have to match, but
>   this is still between different inodes, which means we need some per-extent
>   context.
> - Snapshots.  Technically we would be fine here since the inodes metadata would
>   be the same here, so maybe not so difficult.
> - Relocation.  This is our "move data around underneath everybody" thing that we
>   do all the time.  I'm not actually sure if this poses a problem, I know Sweet
>   Tea said it did, but my eyes sort of glaze over whenever we're talking about
>   encryption so I don't remember the details.

I think a big challenge which is being glossed over is how do you actually set a
new encryption policy for an entire directory tree, which can contain thousands
(or even millions!) of files.  Do you actually go through and update something
on every file, and if so who does it: userspace or kernel?  Or will there be a
layer of indirection that allows the operation to be done in a fixed amount of
work?  Maybe each inode has an encryption policy ID which points into a btree of
encryption policies, and you update that btree to change what the ID refers to?
But that doesn't work if you're changing the encryption policy of only a subset
of files that use a given encryption policy, or if the files are unencrypted.

What happens for directories?  Can their policy change?  I think it can't; all
filenames will have to be encrypted with the original policy.  Is that okay?

What about regular files?  I assume their policy would get replaced, not
appended to, since with extent-based encryption the only purpose of a regular
file's policy is to have it be inherited by new extents of that file?

> 
> What I think you want:
> 
> - A clearer deliniation in the fscrypt code of what we do with per-extent
>   encryption vs everything else.  This is easy for me to grok.
> - A lighter weight per-extent encryption scheme.  This is the part that I'm
>   having trouble with.  I've been reviewing the code from a "is this broken"
>   standpoint, because I don't have the expertise in this area to make a sound
>   judgement.  The btrfs parts are easy, and that code is fine.  I trust Sweet
>   Tea's judgement to do make decisions that fit our use case, but this seems to
>   be the crux of the problem.
> 
> This series is the barebones "get fscrypt encrypting stuff on btrfs" approach,
> with followups for the next, hairier bits.
> 
> But we're over a year into this process and still stuck, so I'm sitting down to
> understand this code and the current situation in order to provide better
> guidance for Sweet Tea.  Please correct me where I've gone wrong, I've been
> going back and reading the emails trying to catch up, so I'm sure I've missed
> things.  Thanks,

The number one thing I'm asking for is something that's maintainable and as easy
to understand as possible.  I don't think we've quite reached that yet.

- Eric
