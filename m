Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615E543AD90
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Oct 2021 09:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbhJZHzv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Oct 2021 03:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbhJZHzu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Oct 2021 03:55:50 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898E3C061767
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Oct 2021 00:53:27 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id l203so8788389pfd.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Oct 2021 00:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gite0SGGIQ7qm710ogoNzYimbvpwi6b1/lYzpJUFn9I=;
        b=QXPYIzIbGweO/lzaH2mxDmvHVA2AlwwEe9LZAl6Sfxx/kP96zNrFOkMK7O38JrNl90
         +rf92ia6TtF1UxTVKmBw+ax7S947WxCopjqCu+WHqhca9gGFDEDUi4G85+7bbTHf2mqX
         FG2BKVI1cFMCb0zaSMkxLWPFVgOej4DpqSy6B9PVds0+4xsjrjVyKn5XacxhB+8Lv3Mg
         h9NZl24NIFqU3GrUGQjKaMXGkct2o9gva34vBQtOtI5d47ZmkedfpeE3tToUHjhiaAJj
         vvOtzYzow4TAiihfv7Q1qNxp8VvE9c61ojgNoIMMZPbnKAUiTqRz+b45v8J9gEXQpHI7
         KOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gite0SGGIQ7qm710ogoNzYimbvpwi6b1/lYzpJUFn9I=;
        b=MayGPjfz2atdD4dYGiXZNFm/B2PGD448ckunaU6ZduwdTeTTH1ONB7Y2iihMK1dfDC
         3q5YgN6xfXntIVZQEuNfwL7K1yLTCg6Wi+XkoBMSBXr4UBHuNjh/Kmo+uaZMzscB+Uqu
         JZHd3ohfb59yxDa/HzUgCRduuO9uYTyOLE316YBi5ZQn3sgJbpOSpVk1ubAxReHkr6jX
         yrokW3BFy+Qflkv51pBHMUOIq0O3gbSNrfaUmmN2iruhCSoQnbkJFaZoVYeidOyL3y+a
         Q3zbgO1AluGkcbilgoiwOF7TwolYTiBcWThS8qyHSv/abSH6eFp33rqPEGeqf2aPH2Tr
         TDTg==
X-Gm-Message-State: AOAM533jSvbvF192XJLGpbCNvNbrLY/JxowHBo2X/KIIa7McP3mf7Esc
        ngm14tJllHcpwKK24b7YvIvQIA==
X-Google-Smtp-Source: ABdhPJw8oJUD9xbwHkBYPTCC0f8p6bBgMQGIv0ZU9Kog7XsFemIRVNppFzkSisRC6Rm0ZLUIYEbyTA==
X-Received: by 2002:a05:6a00:ac1:b0:44c:4dc6:b897 with SMTP id c1-20020a056a000ac100b0044c4dc6b897mr24615248pfl.25.1635234806524;
        Tue, 26 Oct 2021 00:53:26 -0700 (PDT)
Received: from relinquished.localdomain ([2601:602:8b80:8e0::381])
        by smtp.gmail.com with ESMTPSA id v14sm10201203pff.199.2021.10.26.00.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 00:53:26 -0700 (PDT)
Date:   Tue, 26 Oct 2021 00:53:25 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@fb.com
Subject: Re: Btrfs Fscrypt Design Document
Message-ID: <YXez9Yq9ygfjKhoz@relinquished.localdomain>
References: <YXGyq+buM79A1S0L@relinquished.localdomain>
 <YXcKX3iNmqlGsdzv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXcKX3iNmqlGsdzv@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 25, 2021 at 12:49:51PM -0700, Eric Biggers wrote:
> On Thu, Oct 21, 2021 at 11:34:19AM -0700, Omar Sandoval wrote:
> > Hello,
> > 
> > I've been working on adding fscrypt support to Btrfs. Btrfs has some
> > features (namely, reflinks and snapshots) that don't work well with the
> > existing fscrypt encryption policies. I've been discussing and
> > prototyping how to support these Btrfs features with fscrypt, so I
> > figured it was high time I write it down and loop in the fscrypt
> > developers as well.
> > 
> > Here is the Google Doc:
> > https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk9ALQW3XuII/edit?usp=sharing
> > 
> > Please feel free to comment there or via email.
> > 
> 
> Just some preliminary comments:
> 
> Given that you need reflinking to remain supported, for file contents encryption
> I think it's the right choice to store the IVs explicitly rather than have them
> determined by the offset within the file.
> 
> How many derived encryption keys to use is somewhat orthogonal to that.  As I
> mentioned in my other mail, you could still have one key per extent rather than
> one per encryption policy as you're proposing.  I'm *guessing* it wouldn't be
> practical, and I don't consider it to be required (just preferable), but the
> document doesn't discuss this possibility at all.

I overlooked this option because my gut instinct was that the memory
usage would be prohibitive. It looks like one AES-256-XTS prepared key
is about 1k in memory (960 bytes for the encryption and decryption key
schedules for each key, plus a bit more for the crypto API structures).
I thought it'd be too expensive to store this naively for each cached
extent.

However, across various machines I checked, the number of cached inodes
and the number of cached extents is in the same order magnitude (and in
fact, almost equal in many cases). So per-extent keys aren't out of the
question. We can store a 16-byte nonce in the extent, use that to derive
the per-extent key from the master key, and use the offset in the extent
as the IV. I'll think about it some more and make sure I'm not missing
anything.

> Storing just the "starting IV" for each extent also makes sense, assuming that
> you only want to support an unauthenticated mode such as AES-XTS.  However,
> given that btrfs is a copy-on-write filesystem and thus can support per-block
> metadata, a natural question is why not support an authenticated mode such as
> AES-GCM, with a nonce and authentication tag stored per block?  Have you thought
> about this?
> 
> Now, I personally think that authenticating file contents only wouldn't give
> much benefit, and whole-filesystem authentication would be needed to get a real
> benefit.  But "why aren't you using an authenticated mode" is a *very* common
> question, so you need an answer to that -- or ideally, just support it if it
> isn't much work.

We already store a checksum per block; I don't see any reason that it
couldn't be a MAC. Johannes Thumshirn had a proof of concept for storing
an HMAC for all blocks:
https://lore.kernel.org/linux-btrfs/20191015121405.19066-1-jthumshirn@suse.de/#b
Plumbing it through for authenticated encryption would be a little
harder, but probably not by much.

> What is your proposal for how filenames encryption would work when the
> EXPLICIT_IV flag is used?  That doesn't appear to be mentioned.

Since there's no such thing as "reflinking" filenames, I think filename
encryption can be unchanged, i.e., per-directory encryption keys. (This
would probably be the case with per-extent keys for data, as well.)

> Finally, the proposal to allow encrypting the changed data of snapshots is a
> larger departure from the fscrypt model.  I'm still trying to wrap my head
> around how that could work.  Could you provide any more details about that?
> E.g. what metadata would actually be stored on-disk, and how would it be used?
> When would things be done in terms of filesystem operations?  E.g. let's say I
> open a file for writing -- would the encryption key be set up right away, or
> would it not happen until I actually write data?

On disk, we still only need to store the usual fscrypt context. It will
always be present for the top-level of the snapshot. It may or may not
be present for any files or directories under that.

In memory, we'd store whether the subvolume is encrypted. This would be
set when enabling encryption and when caching the subvolume. Since every
inode has a reference to the subvolume it is in, and inodes can't move
between subvolumes, all we need is a check like:

if (IS_ENCRYPTED(inode->subvolume) && !IS_ENCRYPTED(inode))
	set_up_encryption(inode);

I'm leaning towards doing that either at the time that userspace writes
the data, or at the time that we're flushing the data to disk, whichever
ends up being more convenient for Btrfs. I'd rather not do it at open
time.

Thanks for the very helpful reply!
