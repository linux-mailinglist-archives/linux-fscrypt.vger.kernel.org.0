Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C6833CA81
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Mar 2021 01:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhCPA5T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Mar 2021 20:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234089AbhCPA5R (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Mar 2021 20:57:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD5DB64F5D;
        Tue, 16 Mar 2021 00:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615856236;
        bh=lsWCJsGLsP/5b3YVMqXwoiTWmaOnfuPIlfO2eWBJr2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HUtpLePayeKYizmK597Jq/0+TG5eZhL4tGnPcxhX9wfgpNWj26O4CWQBj7bpqNX7L
         XLIm5Amlo+exS+wLI/S7CDNsn8BtRwKrwHfXMG9uAGEceWhi5QlHxfoyaDKUu2KlNJ
         ACAqAlsA5hkusStVG9FYqwLjy3VAJO44irHb/tkjZdEPE4AC8fznMkXs12Ct6Rxi9U
         t4Ae630N8h04eXKwmEieaETK97ZYTwKPPnPaRWW/yFhqcovJxOl5ES8uxNXINYe6tg
         5Ps4pjXJCeRe4Seh0xZJgcszYHeFKmKOzDcSbsly0S39XTskw+LzDnxhjQwRWV64Vu
         ygk5jPVFdQoOQ==
Date:   Mon, 15 Mar 2021 17:57:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 2/5] btrfs: initial fsverity support
Message-ID: <YFACawRlGEvvmF9B@gmail.com>
References: <cover.1614971203.git.boris@bur.io>
 <71249018efc661fdd3c43bda5d7cea271904ae1a.1614971203.git.boris@bur.io>
 <YE/q/bYckkAewbbl@gmail.com>
 <20210316004248.GC3610049@devbig008.ftw2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316004248.GC3610049@devbig008.ftw2.facebook.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 15, 2021 at 05:42:48PM -0700, Boris Burkov wrote:
> > Is the separate size field really needed?  It seems like the type of thing that
> > would be redundant with information that btrfs already stores about the tree
> > items.  Having two sources of truth is error-prone.
> 
> For the case where the user supplied signature is absent or fits in one
> 1K btrfs verity descriptor item, I believe you are right, and we could
> infer that from the generic item size. Assuming arbitrary signature
> lengths, we could still probably do it by searching for the last item
> and computing the size from its key offset and item size. Though now
> that we have a special meaning for offset 0, that gets a bit messier.
> 
> I believe we will need the special item no matter what for the eventual
> encryption case, so I figured it wasn't a big deal to include the size
> rather than try to come up with some computation to get it. I like the
> argument about redundant representation, and saving 8 bytes per verity
> enabled file isn't nothing either. I will see if I can compute it
> efficiently without adding the extra field.

To be clear, I'm not necessarily saying "remove the size field".  But if you
keep it, it needs a proper explanation and careful consideration of what to do
if it doesn't match the actual size.

I don't think 8 bytes per file matters, especially when the Merkle tree blocks
are zero-padded to 4096 bytes anyway.

> > > +	true_size = btrfs_stack_verity_descriptor_size(&item);
> > > +	if (!buf_size)
> > > +		return true_size;
> > > +	if (buf_size < true_size)
> > > +		return -ERANGE;
> > 
> > 
> > It would be good to validate that true_size <= INT_MAX, as it's returned it an
> > 'int'.
> > 
> > > +
> > > +	ret = read_key_bytes(BTRFS_I(inode),
> > > +			     BTRFS_VERITY_DESC_ITEM_KEY, 1,
> > > +			     buf, buf_size, NULL);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +	if (ret != buf_size)
> > > +		return -EIO;
> > > +
> > > +	return buf_size;
> > 
> > Shouldn't this part use true_size, not buf_size?
> 
> I felt this was clunky when writing it. If I'm not mistaken, it doesn't
> really matter what we return since the actual key line is the
> `ret != buf_size` check above.
> 
> I think it would be reasonable to allow too-large buffers and check
> against/return true_size. If true_size is somehow wrong, then presumably
> the signature check itself will still fail.

fsverity_operations::get_verity_descriptor() is supposed to behave like
getxattr().  That means that if the buffer provided is too large, the function
shouldn't fail but rather just read and return the actual size.

That means using true_size above.

I probably should have gone with something harder to get wrong, but getxattr()
semantics seemed "simple".

- Eric
