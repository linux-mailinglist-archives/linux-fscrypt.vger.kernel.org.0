Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36EB2F9454
	for <lists+linux-fscrypt@lfdr.de>; Sun, 17 Jan 2021 18:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbhAQR5g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 17 Jan 2021 12:57:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728693AbhAQR5f (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 17 Jan 2021 12:57:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A76152076A;
        Sun, 17 Jan 2021 17:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610906214;
        bh=2p0k3AN/m2VZRjQsPPjixdnG2qd7PIrAtRAWM+KBqiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pMffMb4ghBSMWBeBFcblgogeroRIocPHlwgmpbkfpi6re7IDuIOMwZQbeaHbHOZyh
         yTQaw1+AKHpTpHSS9DEyNU4NiTnxcavjmxsM9/5bZeeRguGLgkqM3/7c+/A8qJ1fPJ
         ILGr+qACDCJJ5G1DTiXay1vQwaBB7I6BaaDsOc+UFovymW7A09goaLDK4SWHEN8Jb5
         uNBhXLp3o8maYFmltR4Xqacxf5qp6vKP6ASdBdV44Xxy7zN70hhdQl1IO1q/FTlgZ9
         +nKQIQjCwpGCi+peU0ABGPkv18WQLYmrusZg8me6pxxVL9upgpKT1BlGH1njFmFQAg
         qn++Sr1qdFipw==
Date:   Sun, 17 Jan 2021 09:56:53 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Colin Walters <walters@verbum.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: new libfsverity release?
Message-ID: <YAR6ZUIpfLmwg5Bo@sol.localdomain>
References: <cc99418f-4171-4113-9689-afcf46695d95@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc99418f-4171-4113-9689-afcf46695d95@www.fastmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 17, 2021 at 09:20:32AM -0500, Colin Walters wrote:
> There's been a good amount of changes since the last libfsverity release.  I'm primarily interested in
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/commit/?id=f76d01b8ce8ce13538bac89afa8acfea9e2bdd57
> 
> I have some work in progress to update the ostree fsverity support to use it:
> https://github.com/ostreedev/ostree/pull/2269
> 
> Anything blocking a release?

Not really.

> 
> While I'm here, some feedback on the new library APIs:
> 
> - ostree is multi-threaded, and a process global error callback is problematic for that.  I think a GLib-style "GError" type which is really just a pair of error code and string is better.

It would be annoying for all library functions to dynamically allocate an
extended error structure on failure, because callers will forget to free it.  So
that's not a very good solution either.

Couldn't you allocate a per-thread variable (e.g. with pthread_setspecific())
that contains a pointer to your context or message buffer or whatever you need,
and use it from the error callback function?

Anyway, I can't change the API because it is stable now, and other people are
already using libfsverity.

> - Supporting passing the keys via file descriptor or byte array would be nice; or perhaps even better than that we should just expose the openssl types and allow passing pre-parsed key+certificate?

It sounds like you're interested in using the in-kernel signature verification
support.  Can you elaborate on why you want to use it (as opposed to e.g. doing
the signature verification in userspace), and what security properties you are
aiming to achieve with it, and how you would be achieving them?  Keep in mind
that userspace still needs to verify which files have fs-verity enabled.

- Eric
