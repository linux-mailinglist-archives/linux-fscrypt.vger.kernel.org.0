Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114A97BA298
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Oct 2023 17:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbjJEPmZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 Oct 2023 11:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbjJEPmJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 Oct 2023 11:42:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550EB1FC01;
        Thu,  5 Oct 2023 07:57:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7460C433C7;
        Thu,  5 Oct 2023 03:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696475379;
        bh=hiVA8PcTMa3N1KnvuxxVLVJWzq2JJuH5+TvMi9NajNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NTLENRzR0Mm8d8yUp2nI8REk89Dq7XVRk23IGQDOYwNWaRpIlNOyDnN6NpFtbF6MP
         lM3Pxs2hYwKxlBbdxtKFRLe8zGCTi5ZdgF6Gl7Phb0t6/xlxZonsaU8v7J/pfr0Uwr
         AOw6titvBu6PurzAmUbpsfCnPb6xIOJo7xzXvCR8CT6oux+TN5d09L5B0AldhPxB6i
         vgfd3Yu5DbwO+mDkcuqHjDLDrEsK/4j/dmDSvs/QOww9pXp36ywlzRvjfQhJuqTOVs
         5Le4zphOMMbrNzCyOWzUZ1bfQjpocaj19g4wz/BmmVsCKwyFhOu6sX0LPzfnw4XFWh
         vzltChfmBOkyg==
Date:   Wed, 4 Oct 2023 23:09:35 -0400
From:   Eric Biggers <ebiggers@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        sweettea-kernel@dorminy.me
Subject: Re: Master key removal semantics
Message-ID: <20231005030935.GB1688@quark.localdomain>
References: <20231004164412.GA363973@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004164412.GA363973@localhost.localdomain>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 04, 2023 at 12:44:12PM -0400, Josef Bacik wrote:
> Hello,
> 
> While getting the fstests stuff nailed down to deal with btrfs I ran into
> failures with generic/595, specifically the multi-threaded part.
> 
> In one thread we have a loop adding and removing the master key.
> 
> In the other thread we have us trying to echo a character into a flie in the
> encrypted side, and if it succeeds we echo a character into a temporary file,
> and then after the runtime has elapsed we compare these two files to make sure
> they match.
> 
> The problem with this is that btrfs derives the per-extent key from the master
> key at writeout time.  Everybody else has their content key derived at flie open
> time, so they don't need the master key to be around once the file is opened, so
> any writes that occur while that file is held open are allowed to happen.
> 
> Sweet Tea had some changes around soft unloading the master key to handle this
> case.  Basically we allow the master key to stick around by anybody who may need
> it who is currently open, and then any new users get denied.  Once all the
> outstanding open files are closed the master key is unloaded.
> 
> This keeps the semantics of what happens for everybody else.
> 
> What is currently happening with my version of the patchset, which didn't bring
> in those patches, is that you get an ENOKEY at writeout time if you remove the
> key.  The fstest fails because even tho we let you write to the file sometimes,
> it doesn't necessarily mean it'll make it to disk.
> 
> If we want to keep the semantics of "when userspace tells us to throw away the
> master key, we absolutely throw the master key away" then I can just make
> adjustments to the fstests test and call what I have good enough.
> 
> If we want to have the semantics of "when userspace tells us to throw away the
> master key we'll make it unavailable for any new users, but existing open files
> operate as normal" then I can pull in Sweet Tea's soft removal patches and call
> it good enough.
> 
> There's a third option that is a bit of a middle ground with varying degrees of
> raciness.  We could sync the file system before we do the removal just to narrow
> the window where we could successfully write to a file but get an ENOKEY at
> writeout time.  We could freeze the filesystem to make sure it's sync'ed and
> allow any current writers to complete, this would be a stronger version of the
> first option, again just narrows the window.  Neither of these cases help if the
> file is being held open.  If we wanted to fully deal with the file being held
> open case we could set a flag, sync, then remove the key.  Then we add a new
> fscrypt_prep_write() hook that filesystems could optionally use, obviously just
> btrfs for now, that we'd stick in the write path that would check for this flag
> or if the master key had been removed so we can deny dirtying when the key is
> removed.
> 
> At this point I don't have strong opinions, it's easier for me to just leave it
> like it is and change fstests.  Anything else is a change in the semantics of
> how the master key is handled, and that's not really a decision I feel
> comfortable making for everybody.  Once we nail this detail down I can send the
> updated version of all the patches and we can start talking about inclusion.
> Thanks,

There is already a sync just before the master key removal.  See
try_to_lock_evicted_files().  It's racy, of course, as you noticed.

The "soft removal" is what I recommended earlier.  See
https://lore.kernel.org/r/20230703181745.GA1194@sol.localdomain and
https://lore.kernel.org/r/20230704002854.GA860@sol.localdomain.  I think it's
probably still the way to go, but I was a bit confused by the way that Sweet Tea
had implemented it.  Maybe it can be simplified?

I've been pretty busy this week; I'll take a look at your latest patches soon.
I've gone ahead and tweaked your patch "fscrypt: rename fscrypt_info =>
fscrypt_inode_info" a bit and applied it to the fscrypt tree for 6.7 so that we
can get it out of the way; let me know if that's okay.  I've just sent out the
version that I applied.  BTW, I also applied my patchset "fscrypt: add support
for data_unit_size < fs_block_size" recently, so you'll need to rebase onto the
fscrypt tree anyway.  Sorry for the churn, but that feature is apparently
something that people need...

- Eric
