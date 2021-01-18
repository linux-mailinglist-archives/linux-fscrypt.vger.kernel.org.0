Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5342FA949
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Jan 2021 19:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390780AbhARSlz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jan 2021 13:41:55 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48671 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436885AbhARSlO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jan 2021 13:41:14 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 058611908;
        Mon, 18 Jan 2021 13:40:28 -0500 (EST)
Received: from imap10 ([10.202.2.60])
  by compute1.internal (MEProxy); Mon, 18 Jan 2021 13:40:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BCUtno
        JHA1bj3TvFeVdPNYE/yX8dDvjwTAZytxgKjsI=; b=qkCE1l0uh/+BWzg+BSldv4
        c7sGVeE40IY2f5439IWQgjhgRPkwkaiV5TMOTo6f/NfS9I/U/NYOLmSPbRUNMbqv
        f9pRbwkbs9OnDbVZ77oMOniFiEpxeaE01ahOW7RygQN2Nt1ay5PTcet/XzUuu1Gw
        5oj/1DhYjznXgB+J02Xq8qSLAuwnUGX4IibD7Ac9jYNDg5GQusW3QzwAzAa4djE4
        fU10BV6f1wb74HWDB21/DOox+FbEQkwbMHevffssg7TBQgS4EaX/AnZU6jku0pql
        UlDGsQmT79zjrwZ4ZEpuaVIqaUxaBL1dYtXfXRjrReBDOt52CyL6RLbf/Qt2bdcg
        ==
X-ME-Sender: <xms:HNYFYO6MhUzSq22vMU1yVcbhA5Y7xTLFeBZXDWGDK6iWJVZDjOBmVg>
    <xme:HNYFYH7x2CjH6affK0Yz9GS3B0waGcqSp-Tl-EgwMfMu9Ch5V1B4ksTdzXa_-J-OD
    -GZROyO_dGfRVLR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdevohhl
    ihhnucghrghlthgvrhhsfdcuoeifrghlthgvrhhssehvvghrsghumhdrohhrgheqnecugg
    ftrfgrthhtvghrnhepkeffgfdtgfevueffuddvgfduueefkeeltefggeelkeeiheeitefg
    gefghfehfeeknecuffhomhgrihhnpehvvghrsghumhdrohhrghdpkhgvrhhnvghlrdhorh
    hgpdhlfihnrdhnvghtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepfigrlhhtvghrshesvhgvrhgsuhhmrdhorhhg
X-ME-Proxy: <xmx:HNYFYNde3igYFd1IMOkF5ickYlVOLbhJ1R8-5jJ3JEyjeWGuQNCjgw>
    <xmx:HNYFYLL3-lSc6bdqDBnNJeP05ybAlfBFUmSskMV_lwJLSk4rlzLpDQ>
    <xmx:HNYFYCInwZkmWPdwx254Jdvg2pHmvVWW0rsZ6UeC0pl6zNnb9biTAA>
    <xmx:HNYFYHVndYy0AyXwtHNKg3Icc-ZKSylRWaMdKLsxvtxUlGTAPP8NEA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3C07A20102; Mon, 18 Jan 2021 13:40:28 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-45-g4839256-fm-20210104.001-g48392560
Mime-Version: 1.0
Message-Id: <fa3cce0c-43c7-4d0d-aadf-2fb5cea9e0ff@www.fastmail.com>
In-Reply-To: <YAR6ZUIpfLmwg5Bo@sol.localdomain>
References: <cc99418f-4171-4113-9689-afcf46695d95@www.fastmail.com>
 <YAR6ZUIpfLmwg5Bo@sol.localdomain>
Date:   Mon, 18 Jan 2021 13:40:08 -0500
From:   "Colin Walters" <walters@verbum.org>
To:     "Eric Biggers" <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: new libfsverity release?
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On Sun, Jan 17, 2021, at 12:56 PM, Eric Biggers wrote:
> On Sun, Jan 17, 2021 at 09:20:32AM -0500, Colin Walters wrote:

> > Anything blocking a release?
>
> Not really.

Ok, cool.

> It would be annoying for all library functions to dynamically allocate
> an extended error structure on failure, because callers will forget to
> free it.  So that's not a very good solution either.

All my C code today uses __attribute__((cleanup(func)).  Old blog entry
of mine on it:
https://blog.verbum.org/2012/05/09/__attribute__-cleanup-or-how-i-came-to-love-c-again/
systemd also uses it extensively today.  (Has this actually come up for
use in the Linux kernel?  It's hard to do a web search for, I don't see
it mentioned in
https://www.kernel.org/doc/Documentation/process/coding-style.rst
surprisingly - though I guess a lot of "hot paths" would still want
`goto out` for speed and control).

libfsverity would also benefit from this IMO.

Of course since 2012 Rust appeared and I try to write new code in it
where I can, but __attribute__((cleanup)) is the single best thing from
C++ available in C and still feels like "native C".

> Couldn't you allocate a per-thread variable (e.g. with
> pthread_setspecific()) that contains a pointer to your context or
> message buffer or whatever you need, and use it from the error
> callback function?

Yeah, a per-thread variable is better than a global mutex for this
indeed.  I'll try reworking my code.

> Anyway, I can't change the API because it is stable now, and other
> people are already using libfsverity.

True, but we could add new APIs?  There aren't that many. But I dunno, I
don't feel very strongly about this, I can live with a pthread variable.
If we decide to do that let's just add a note to the docs recommending
that (for callers that want to do something other than print to stderr).

That said of course this whole discussion about errno and strings
parallels the kernel side: https://lwn.net/Articles/374794/
https://lwn.net/Articles/532771/ and I guess no progress has been made
on that?  We just live with extracting more information about errors
like EIO or EPERM out-of-band from kernel subsystems (e.g. audit log for
SELinux, etc.).

> It sounds like you're interested in using the in-kernel signature
> verification support.  Can you elaborate on why you want to use it (as
> opposed to e.g. doing the signature verification in userspace), and
> what security properties you are aiming to achieve with it, and how
> you would be achieving them?  Keep in mind that userspace still needs
> to verify which files have fs-verity enabled.

This is a much longer discussion probably best done as a separate
thread.  But broadly speaking I'm looking at using fsverity as parts of systems
that look more like "traditional Linux" than e.g. Android.  The security
properties will be weaker, but I think that's an inherent part of shipping a system where
the user owns the computer and maintaining support for the vast array of systems management tooling out there.  I am hopeful that we can strengthen it over time while still providing some useful security properties.

OK more specific answers: just to start, I really, really like the "files are *truly* read-only even to root" aspect of fs-verity.  This alone avoids whole classes of accidental system damage and can mitigate some types of exploit chains (I gave the example of the runc exploit in the Fedora thread on IMA).  Another example (I didn't fully dig into this but just some thoughts) is that since dm-crypt doesn't provide integrity, fs-verity-on-dm-crypt can help mitigate some offline attacks as well as online attacks in "encrypted virtualization" (https://lwn.net/Articles/841549/) scenarios.

To answer your specific question, one idea I'd like to pursue is patching systemd to require the target of `ExecStart=` be verity signed.  And more generally (this leads into IMA-policy like flows) require any privileged (CAP_SYS_ADMIN) binaries be verity signed.

Now related to this...I see you have some recent patches to allow userspace to extract the signature from a verity file.  That sounds very useful because it will avoid the need for out of band signature data for e.g. `/usr/bin/bash` right?  Although hmm, I guess today one could store signatures in an xattr?

(Thanks for all your work on fsverity btw!)
