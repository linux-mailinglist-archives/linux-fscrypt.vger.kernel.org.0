Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0355C40B7A7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Sep 2021 21:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbhINTNJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Sep 2021 15:13:09 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:42829 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233277AbhINTMz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Sep 2021 15:12:55 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 0CB60320084E;
        Tue, 14 Sep 2021 15:11:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 14 Sep 2021 15:11:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=EvYWqsGHF6A08/ENJFhKJKZ9I9B
        AuppZ35XvUPULW/c=; b=b3swDc98WH0aVuyRmJsEg9ksoBsQGNYgkqvOPGWr3WH
        dFFd60PeDXtimfqyWbv6186WKlDYr002fI47hPj7VTjWGR0jFU9hjAqyZc124mhu
        xsWyJ0p/yKhTGr70t1HxDnoSkIcPsxFQoEFAZGsI0BE919Cpzm1zzFazKI8vz5/E
        MW4pEHvoayhH2etNwTqIgDHy4hzTobLrkJajDPmzZriXjX1ePNZ0i8x6kOwK6q8Z
        ryGpGVGW68JNYq2gF4aHwOMGmsCGks32LO8vtZmk3Mgudvu02aQf7SAMmlAzAor8
        NTNIEFl1XGpZMxP8lkLfb8n2m55A7uRbBoUdlnDNVQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EvYWqs
        GHF6A08/ENJFhKJKZ9I9BAuppZ35XvUPULW/c=; b=i22CkO6prKULj05aij9ffV
        PU9zeRNCt9VV175nNrePBlbceiSd46fzT/FUYxgxZXHY01H6ZxPIGo9FFrSNoCZc
        HU2+x3dWNeFYAN7SsTTBcvA4lPBkPYwy+TdFs7QW4At/eAdcHUmJSf1T9QyuMcn7
        jMtUrAjzVVxaqPoMLAlMhhvCfe9oIvQrNdTUGVP4Urun1100Q68vZUnUVvcbCZZl
        5GlHKI54Ww3w+D/XcMjQyo+o4BlD5Qw6Y/ByGztmc+ZwwGoDFFfshGtHl28/ZMNx
        XMu6QGGZJNAKB03sBuQyhv7dx6yUcoXk3iCaEN9P9xg6+DcjCkj56knnsC3RFjTA
        ==
X-ME-Sender: <xms:5_NAYSyEA6kApOoPB8HNb3kEr5VW7YDlEs3moc6d9su41ImvKJv_7w>
    <xme:5_NAYeTqxGfR9NpECEzwXDdhDset0qYO7vtnsQeKzjX4-1FwikRh9vWhQeI_q3vCY
    dRKbuE-XW4Y74w-yOs>
X-ME-Received: <xmr:5_NAYUUzcVOQcsm5GRcX9N-8ZitXXGo8loBYFeAukAPspR-ZDeyGWa4jRfifRGvWLzUJXFj8V_wRkPhHMcM0ITi0Rq7QDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegledgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    ehudevleekieetleevieeuhfduhedtiefgheekfeefgeelvdeuveeggfduueevfeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhsse
    gsuhhrrdhioh
X-ME-Proxy: <xmx:5_NAYYg-wpnhA-YSfIONrvazyrqXzaLFh07wBFL8GvjxkAs4gbYtxQ>
    <xmx:5_NAYUCUhs3WVSw3QneE8i7Lm_prO_wPxJK-AzN4bVIpQJu09MyNaA>
    <xmx:5_NAYZI7ZRe9B9_arhEn47Y76MSfg2-y6NQ5K9ZJR1BM5zIoFzW6yQ>
    <xmx:5_NAYd6S3xOpAdlZQ7OUtRXvQJqrkblzb3JcVSgd_k9YpxIGB9IlZA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 15:11:35 -0400 (EDT)
Date:   Tue, 14 Sep 2021 12:11:34 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH] fsverity: add enable sysctl
Message-ID: <YUDz0dGsLGoFbHXg@zen>
References: <ebc9c81c31119e0ce8f810c5729b42eef4c5c3af.1631560857.git.boris@bur.io>
 <YUATekKOECWznxl8@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUATekKOECWznxl8@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 13, 2021 at 08:14:02PM -0700, Eric Biggers wrote:
> On Mon, Sep 13, 2021 at 05:37:15PM -0700, Boris Burkov wrote:
> > At Facebook, we would find a global killswitch sysctl reassuring while
> > rolling fs-verity out widely. i.e., we could run it in a logging mode
> > for a while, measure how it's doing, then fully enable it later.
> > 
> > However, I feel that "let root turn off verity" seems pretty sketchy, so
> > I was hoping to ask for some feedback on it.
> > 
> > I had another idea of making it per-file sort of like MODE_LOGGING in
> > dm-verity. I could add a mode to the ioctl args, and perhaps a new ioctl
> > for getting/setting the mode?
> > 
> > The rest is the commit message from the patch I originally wrote:
> > 
> > 
> > Add a sysctl killswitch for verity:
> > 0: verity has no effect, even if configured or used
> > 1: verity is in "audit" mode, only log on failures
> > 2: verity fully enabled; the behavior before this patch
> > 
> > This also precipitated re-organizing sysctls for verity as previously
> > the only sysctl was for signatures and setting up the sysctl was coupled
> > with the signature logic.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> 
> I don't think there's any security problem with having this root-only sysctl.
> The fs.verity.require_signatures sysctl already works that way.  We aren't
> trying to protect against root, unless you've set up your system properly with
> SELinux, in which case fine-grained access control of sysctls is available.

Good to know. I couldn't quickly think of a way a root user could really
badly defeat verity (get in an evil file that would trick userspace
hiding in dm-verity) but I didn't really think about what you could do
with modules, bpf, just rebooting into a new kernel, etc..

> 
> The mode 0 is the one I like the least, as it makes some ad-hoc changes like
> making the fs-verity ioctls fail with -EOPNOTSUPP.  If userspace doesn't want to
> use those ioctls, shouldn't it just not use those ioctls?
> 
> It might help if you elaborated on what sort of problems you are trying to plan
> for.  One concern that was raised on Android was that on low-end flash storage,
> files can have bit-flips that would normally be "benign" but would cause errors
> if fs-verity detects them.  Falling back to your mode 1 (logging-only) would be
> sufficient if that happened and caused problems.  So I am wondering more what
> the purpose of mode 0 would be; it seems it might be overkill, and an
> "enforcing" boolean equivalent to your modes 1 and 2 might be sufficient?

In our situation, I think we are less worried about these sorts of
bit-flips as we already use btrfs checksums and verity would only catch
the cases where the checksum also changed (presumably this is only the
malicious case, in practice)

Mode 0 is actually probably more interesting to us, as it would be
insurance against the case where there is either a serious bug in the
btrfs implementation or if there is a performance regression on some
unforeseen workload. Without being able to shut it off entirely, we
would be in a tough spot of having to replace the affected files.

The most important part of this mode to me is the skip and return 0 in
fsverity_verify_page. I agree that failing the enables is sort of lame
because userspace would need to be ignoring errors or falling back to
not-verity for that to even "help".

Maybe I could make them a no-op? That could be too surprising, but is
in line with verify being a no-op and could actually have useful
semantics in an emergency shutoff scenario.

> 
> Did you also consider a filesystem mount option?  I guess the sysctl makes sense
> especially since we already have the require_signatures one, but you probably
> should CC this to the filesystem mailing lists (ext4, f2fs, and btrfs) in case
> other people have opinions on this.

I didn't consider a mount option, but I'll follow up as you suggest.

> 
> - Eric

Thanks,
Boris
