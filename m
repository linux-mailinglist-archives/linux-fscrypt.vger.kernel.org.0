Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EB640BC83
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Sep 2021 02:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbhIOAR3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Sep 2021 20:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235972AbhIOAR2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Sep 2021 20:17:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BA6960E90;
        Wed, 15 Sep 2021 00:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631664970;
        bh=enjNfR4WaUaM06R96C4rRITDPMrrGDyIbwRrfIV6o9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kCmENhy85CCuBVHCa1VxNArN2o1zzOZXWl/gl3EWFIQudpxwXvOeLowonOOENkHMF
         ovih45J+VC+2o3nwoPHCG1uhzmejSEP7WarV4d66zJGJ1ZWJurkQ3z7m9PRM6OT8sO
         UpOYKOlXX/LhvQjYZneVR3cOBxH0jQG75dLaGKn6TGZhpVRFjZB7G7V++YZOTc3NkB
         bS9waQm3Oz1du8RA2XAMgVsVYryhHEomKGKnpdqoH/XSWw7pMTv/+vNQhVB8LpIKos
         G8XkPMb8czGA/spUxVai6ZhaXAnvYsNUg1iPUJg1O4uypx2DQr9vQ+kR5NuAAXDIU1
         bo/191YA3e38Q==
Date:   Tue, 14 Sep 2021 17:16:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH] fsverity: add enable sysctl
Message-ID: <YUE7STrCSDobno6R@sol.localdomain>
References: <ebc9c81c31119e0ce8f810c5729b42eef4c5c3af.1631560857.git.boris@bur.io>
 <YUATekKOECWznxl8@sol.localdomain>
 <YUDz0dGsLGoFbHXg@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUDz0dGsLGoFbHXg@zen>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 14, 2021 at 12:11:34PM -0700, Boris Burkov wrote:
> > 
> > The mode 0 is the one I like the least, as it makes some ad-hoc changes like
> > making the fs-verity ioctls fail with -EOPNOTSUPP.  If userspace doesn't want to
> > use those ioctls, shouldn't it just not use those ioctls?
> > 
> > It might help if you elaborated on what sort of problems you are trying to plan
> > for.  One concern that was raised on Android was that on low-end flash storage,
> > files can have bit-flips that would normally be "benign" but would cause errors
> > if fs-verity detects them.  Falling back to your mode 1 (logging-only) would be
> > sufficient if that happened and caused problems.  So I am wondering more what
> > the purpose of mode 0 would be; it seems it might be overkill, and an
> > "enforcing" boolean equivalent to your modes 1 and 2 might be sufficient?
> 
> In our situation, I think we are less worried about these sorts of
> bit-flips as we already use btrfs checksums and verity would only catch
> the cases where the checksum also changed (presumably this is only the
> malicious case, in practice)
> 
> Mode 0 is actually probably more interesting to us, as it would be
> insurance against the case where there is either a serious bug in the
> btrfs implementation or if there is a performance regression on some
> unforeseen workload. Without being able to shut it off entirely, we
> would be in a tough spot of having to replace the affected files.
> 
> The most important part of this mode to me is the skip and return 0 in
> fsverity_verify_page. I agree that failing the enables is sort of lame
> because userspace would need to be ignoring errors or falling back to
> not-verity for that to even "help".
> 
> Maybe I could make them a no-op? That could be too surprising, but is
> in line with verify being a no-op and could actually have useful
> semantics in an emergency shutoff scenario.

In that case I guess it's reasonable to have all three modes, but they need to
have clearly defined semantics and have an intuitive interface, and be
documented.  Setting "enabled" to 1 to disable something is unintuitive; it
probably should be fs.verity.mode with string values, e.g. "enforcing",
"log-only" (or "audit"?), and "disabled".

For the log-only mode, you also need to consider which types of errors it
applies to, specifically.  In your patch, it appears that only data verification
errors would be log-only, whereas other errors such as bad signatures and
fsverity_descriptor corruption would still be fatal.  It probably would make
sense to have these other errors be log-only as well, so that log-only applies
to all fs-verity errors.

I don't think the "disabled" mode making the fs-verity ioctls be no-ops is a
good idea.  I think you should just make them return an error code, preferably a
distinct error code rather than overloading EOPNOTSUPP.  You can always make
userspace aware of whether fs-verity is disabled or not, if needed.  Trying to
make userspace think that it's using fs-verity when it's actually not isn't
going to work well, especially if it's using the FS_IOC_MEASURE_VERITY ioctl, as
there is no way to return a meaningful value from that if the prior call to
FS_IOC_ENABLE_VERITY was ignored.

- Eric
