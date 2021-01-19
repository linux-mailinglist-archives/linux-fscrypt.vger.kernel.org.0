Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F752FBF38
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jan 2021 19:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731595AbhASS2w (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jan 2021 13:28:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731809AbhASS2r (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jan 2021 13:28:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27A13216FD;
        Tue, 19 Jan 2021 18:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611080866;
        bh=htBl0n5q1kh9OZUvWrbG0zkdCbhNTZ/6FtkTdpiJSNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VFkZSQg/tUyHSHTotgYbyt8iwuZVVf5PJ2bItwtNvRbplr2r/6GU6+hEfyeBk4+Ju
         KsN8iVpbYFWtMPxU4U2mEb+9EMtIPgFlDYgXLq15qJXSIglv1S1lVxq9jmtnAnCV5s
         /hjJ6qW6z7j3+MKO85Zt+KKkPfIB+Q/JXRCQH+AH6ZhuNz5BkNN42K65gc03Qb/Cou
         g/WWXPinMpRFypua2YLiTp2hWIP3FwwkR7ppQa0TSsNJYePDe7K90jw0tkqSZfbNwk
         nSrRKtBrGhSkQJ8LTgIeds2DpXhoksM9MqdEq0sSsgwiTrmz0NiTx+4IduPrv9DLiu
         Y/RIOP2u7D5iw==
Date:   Tue, 19 Jan 2021 10:27:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Colin Walters <walters@verbum.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: new libfsverity release?
Message-ID: <YAcf2kryXlb9z40i@sol.localdomain>
References: <cc99418f-4171-4113-9689-afcf46695d95@www.fastmail.com>
 <YAR6ZUIpfLmwg5Bo@sol.localdomain>
 <fa3cce0c-43c7-4d0d-aadf-2fb5cea9e0ff@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa3cce0c-43c7-4d0d-aadf-2fb5cea9e0ff@www.fastmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 18, 2021 at 01:40:08PM -0500, Colin Walters wrote:
> 
> On Sun, Jan 17, 2021, at 12:56 PM, Eric Biggers wrote:
> > On Sun, Jan 17, 2021 at 09:20:32AM -0500, Colin Walters wrote:
> 
> > > Anything blocking a release?
> >
> > Not really.
> 
> Ok, cool.
> 
> > It would be annoying for all library functions to dynamically allocate
> > an extended error structure on failure, because callers will forget to
> > free it.  So that's not a very good solution either.
> 
> All my C code today uses __attribute__((cleanup(func)).  Old blog entry
> of mine on it:
> https://blog.verbum.org/2012/05/09/__attribute__-cleanup-or-how-i-came-to-love-c-again/
> systemd also uses it extensively today.  (Has this actually come up for
> use in the Linux kernel?  It's hard to do a web search for, I don't see
> it mentioned in
> https://www.kernel.org/doc/Documentation/process/coding-style.rst
> surprisingly - though I guess a lot of "hot paths" would still want
> `goto out` for speed and control).
> 
> libfsverity would also benefit from this IMO.
> 
> Of course since 2012 Rust appeared and I try to write new code in it
> where I can, but __attribute__((cleanup)) is the single best thing from
> C++ available in C and still feels like "native C".

Wouldn't callers still need to manually add __attribute__((cleanup)), though?
So this wouldn't prevent callers from forgetting to free the error struct.

> 
> > Couldn't you allocate a per-thread variable (e.g. with
> > pthread_setspecific()) that contains a pointer to your context or
> > message buffer or whatever you need, and use it from the error
> > callback function?
> 
> Yeah, a per-thread variable is better than a global mutex for this
> indeed.  I'll try reworking my code.
> 
> > Anyway, I can't change the API because it is stable now, and other
> > people are already using libfsverity.
> 
> True, but we could add new APIs?  There aren't that many. But I dunno, I
> don't feel very strongly about this, I can live with a pthread variable.
> If we decide to do that let's just add a note to the docs recommending
> that (for callers that want to do something other than print to stderr).
> 
> That said of course this whole discussion about errno and strings
> parallels the kernel side: https://lwn.net/Articles/374794/
> https://lwn.net/Articles/532771/ and I guess no progress has been made
> on that?  We just live with extracting more information about errors
> like EIO or EPERM out-of-band from kernel subsystems (e.g. audit log for
> SELinux, etc.).

We can add new APIs if there is a good reason to.  But I'm not sure that whether
what you suggest would even be better (for a C API).  I think something like
OpenSSL's per-thread error queues would be better, and that could be added
without changing the function prototypes.

> 
> > It sounds like you're interested in using the in-kernel signature
> > verification support.  Can you elaborate on why you want to use it (as
> > opposed to e.g. doing the signature verification in userspace), and
> > what security properties you are aiming to achieve with it, and how
> > you would be achieving them?  Keep in mind that userspace still needs
> > to verify which files have fs-verity enabled.
> 
> This is a much longer discussion probably best done as a separate
> thread.  But broadly speaking I'm looking at using fsverity as parts of systems
> that look more like "traditional Linux" than e.g. Android.  The security
> properties will be weaker, but I think that's an inherent part of shipping a system where
> the user owns the computer and maintaining support for the vast array of systems management tooling out there.  I am hopeful that we can strengthen it over time while still providing some useful security properties.
> 
> OK more specific answers: just to start, I really, really like the "files are *truly* read-only even to root" aspect of fs-verity.

I'm not sure what your definition of "truly" is, but keep in mind that root can
usually still replace a verity file with another file, or ptrace all processes
(including overriding all data read from a particular file), or write to raw
block devices, or load kernel modules, etc...

> This alone avoids whole classes of accidental system damage and can mitigate some types of exploit chains (I gave the example of the runc exploit in the Fedora thread on IMA).  Another example (I didn't fully dig into this but just some thoughts) is that since dm-crypt doesn't provide integrity, fs-verity-on-dm-crypt can help mitigate some offline attacks as well as online attacks in "encrypted virtualization" (https://lwn.net/Articles/841549/) scenarios.
> 
> To answer your specific question, one idea I'd like to pursue is patching systemd to require the target of `ExecStart=` be verity signed.  And more generally (this leads into IMA-policy like flows) require any privileged (CAP_SYS_ADMIN) binaries be verity signed.
> 
> Now related to this...I see you have some recent patches to allow userspace to extract the signature from a verity file.  That sounds very useful because it will avoid the need for out of band signature data for e.g. `/usr/bin/bash` right?  Although hmm, I guess today one could store signatures in an xattr?
> 
> (Thanks for all your work on fsverity btw!)

Okay, the use cases of "require the target of `ExecStart=` be verity signed" and
"require any privileged (CAP_SYS_ADMIN) binaries be verity signed" sound
reasonable.  I was concerned that you might be just adding signatures without
any policy of what to do with them.  IIRC, in the last discussion we had on this
list, you were just enabling fs-verity on files without actually writing any
code to do anything with it.

I recommend against using the built-in signature verification support (though,
so far I've been unsuccessful at stopping people from using it...), as verifying
out-of-band signatures in userspace would be much more flexible and reduce the
kernel's attack surface.

- Eric
