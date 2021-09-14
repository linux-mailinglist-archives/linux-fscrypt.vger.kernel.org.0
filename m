Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039AF40A43A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Sep 2021 05:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbhINDPV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Sep 2021 23:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237213AbhINDPU (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Sep 2021 23:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47B8960FDA;
        Tue, 14 Sep 2021 03:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631589244;
        bh=UWbFquzJhf+9on/4+wZjpNbZ+ccIIONOtOe76sOgn0E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FMfxMdSvlnDc3U+byx4OWDzgIAOxU3jEK9tAQWuO6sa5BYDH8gZ0cU3YwGG+mthvW
         +qHFCRPi+R4m99oc7+9OeyqbyAqYiNIBiLpHKYKo7Jy8sy4UYbkKlKSgQiUjHuhf3r
         EHtpBXGHLfj+kVfyEmkarApUFioCTlOtSp6pYrkDsEj/Q5XtG1ornOIDjj5U0dA57E
         lyyIy+axxqjiUa3sJceabjEfrMwYlGncKaKcu9iC+RY3EHhvgbB6l+QnUwBTCqO4C/
         nBu0DAuvJHzV1MEku5YwSSfJZItyT47rR95Ly4pVOWlMYjBg9BokdRTjStjg+3qA6x
         9Q+u7rXu6oOWA==
Date:   Mon, 13 Sep 2021 20:14:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH] fsverity: add enable sysctl
Message-ID: <YUATekKOECWznxl8@sol.localdomain>
References: <ebc9c81c31119e0ce8f810c5729b42eef4c5c3af.1631560857.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebc9c81c31119e0ce8f810c5729b42eef4c5c3af.1631560857.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 13, 2021 at 05:37:15PM -0700, Boris Burkov wrote:
> At Facebook, we would find a global killswitch sysctl reassuring while
> rolling fs-verity out widely. i.e., we could run it in a logging mode
> for a while, measure how it's doing, then fully enable it later.
> 
> However, I feel that "let root turn off verity" seems pretty sketchy, so
> I was hoping to ask for some feedback on it.
> 
> I had another idea of making it per-file sort of like MODE_LOGGING in
> dm-verity. I could add a mode to the ioctl args, and perhaps a new ioctl
> for getting/setting the mode?
> 
> The rest is the commit message from the patch I originally wrote:
> 
> 
> Add a sysctl killswitch for verity:
> 0: verity has no effect, even if configured or used
> 1: verity is in "audit" mode, only log on failures
> 2: verity fully enabled; the behavior before this patch
> 
> This also precipitated re-organizing sysctls for verity as previously
> the only sysctl was for signatures and setting up the sysctl was coupled
> with the signature logic.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

I don't think there's any security problem with having this root-only sysctl.
The fs.verity.require_signatures sysctl already works that way.  We aren't
trying to protect against root, unless you've set up your system properly with
SELinux, in which case fine-grained access control of sysctls is available.

The mode 0 is the one I like the least, as it makes some ad-hoc changes like
making the fs-verity ioctls fail with -EOPNOTSUPP.  If userspace doesn't want to
use those ioctls, shouldn't it just not use those ioctls?

It might help if you elaborated on what sort of problems you are trying to plan
for.  One concern that was raised on Android was that on low-end flash storage,
files can have bit-flips that would normally be "benign" but would cause errors
if fs-verity detects them.  Falling back to your mode 1 (logging-only) would be
sufficient if that happened and caused problems.  So I am wondering more what
the purpose of mode 0 would be; it seems it might be overkill, and an
"enforcing" boolean equivalent to your modes 1 and 2 might be sufficient?

Did you also consider a filesystem mount option?  I guess the sysctl makes sense
especially since we already have the require_signatures one, but you probably
should CC this to the filesystem mailing lists (ext4, f2fs, and btrfs) in case
other people have opinions on this.

- Eric
