Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3045843A37F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 25 Oct 2021 21:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbhJYT7s (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 Oct 2021 15:59:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238559AbhJYT5n (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Oct 2021 15:57:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E8CD61167;
        Mon, 25 Oct 2021 19:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635191392;
        bh=30fmfFz6l3SFT4Ek3GYe5i53GtxZudEDo0gOdYIcz6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZDMDiUZEVhRVnTbyydqALGfStWj1DqcyQJVRR4ogvpMI0kfAIm0S3noHrfwJZpfjt
         cHn6MSXh6MREevi00QTt/jp8KdNV5h0EcsH8cJrDIqG/ojQ39Khuf7socGz6HgRDWI
         Jiw1rExvWTpd8LTtJxY+XRCFhP0rU0i4EGJigtPyRMVz06GxS4G7FUJp/awynfrEJM
         cn2EyXrlZ0KC0Q7XNs1wp+UxUyZahOTKidtmKLgc+xNqQzNFRCy0XBMwsTh6trcvr8
         tYfoarYe7Q5cfsFkj1TM1i8gFW3FwQF3drBp1p6i9526CPjpc6/2jOc6e46rln09vk
         yCJJGhbu0q3jw==
Date:   Mon, 25 Oct 2021 12:49:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@fb.com
Subject: Re: Btrfs Fscrypt Design Document
Message-ID: <YXcKX3iNmqlGsdzv@gmail.com>
References: <YXGyq+buM79A1S0L@relinquished.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXGyq+buM79A1S0L@relinquished.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 21, 2021 at 11:34:19AM -0700, Omar Sandoval wrote:
> Hello,
> 
> I've been working on adding fscrypt support to Btrfs. Btrfs has some
> features (namely, reflinks and snapshots) that don't work well with the
> existing fscrypt encryption policies. I've been discussing and
> prototyping how to support these Btrfs features with fscrypt, so I
> figured it was high time I write it down and loop in the fscrypt
> developers as well.
> 
> Here is the Google Doc:
> https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk9ALQW3XuII/edit?usp=sharing
> 
> Please feel free to comment there or via email.
> 

Just some preliminary comments:

Given that you need reflinking to remain supported, for file contents encryption
I think it's the right choice to store the IVs explicitly rather than have them
determined by the offset within the file.

How many derived encryption keys to use is somewhat orthogonal to that.  As I
mentioned in my other mail, you could still have one key per extent rather than
one per encryption policy as you're proposing.  I'm *guessing* it wouldn't be
practical, and I don't consider it to be required (just preferable), but the
document doesn't discuss this possibility at all.

Storing just the "starting IV" for each extent also makes sense, assuming that
you only want to support an unauthenticated mode such as AES-XTS.  However,
given that btrfs is a copy-on-write filesystem and thus can support per-block
metadata, a natural question is why not support an authenticated mode such as
AES-GCM, with a nonce and authentication tag stored per block?  Have you thought
about this?

Now, I personally think that authenticating file contents only wouldn't give
much benefit, and whole-filesystem authentication would be needed to get a real
benefit.  But "why aren't you using an authenticated mode" is a *very* common
question, so you need an answer to that -- or ideally, just support it if it
isn't much work.

What is your proposal for how filenames encryption would work when the
EXPLICIT_IV flag is used?  That doesn't appear to be mentioned.

Finally, the proposal to allow encrypting the changed data of snapshots is a
larger departure from the fscrypt model.  I'm still trying to wrap my head
around how that could work.  Could you provide any more details about that?
E.g. what metadata would actually be stored on-disk, and how would it be used?
When would things be done in terms of filesystem operations?  E.g. let's say I
open a file for writing -- would the encryption key be set up right away, or
would it not happen until I actually write data?

- Eric
