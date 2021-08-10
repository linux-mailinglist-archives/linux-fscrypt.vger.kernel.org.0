Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B01E3E7F13
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Aug 2021 19:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhHJRhK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Aug 2021 13:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233111AbhHJRfm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Aug 2021 13:35:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1A4961078;
        Tue, 10 Aug 2021 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628616909;
        bh=5jlE0TUgE5RDQgFQx7JWN1AdC5wesc5yenYunntH3Fw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YRdxnJTNVftw5bm8DFvo6/PznraYXGeBvH/hzNu9t1A2rusybiaYw+mMZm+6uRnHM
         pMIiohzkdSReZeaZDecc9mniTbQYkHqHHjwpGjHqfIwp17ds6ipiwse0bm69WpplQK
         m40rZYzMxyCI45dC4IZleqOCiyTfOHthE7tCe1vlEVof3p+KuCRys2MwSQc627gE1V
         RmnwVPTc7wNYT+9bxBqpxc+QGTJh0/czsDNgH7ukXk3zA+4tLqdiUSp+ugQbHIF8qf
         L2Tgl9KaCT9JGNNimYqFgfZAJ5aOjylSjLI/wVTc1w8KMeI/ySNRjB6TsLdZjaR6H7
         xgEa9jdajLGYQ==
Date:   Tue, 10 Aug 2021 10:35:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel@pengutronix.de,
        Jarkko Sakkinen <jarkko@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fscrypt: support trusted keys
Message-ID: <YRK4y9XkDPbvWzgb@gmail.com>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
 <YRGdBiJQ3xqZAT4w@gmail.com>
 <2bc19003-82a1-0d2d-4548-3315686d77b4@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bc19003-82a1-0d2d-4548-3315686d77b4@pengutronix.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 10, 2021 at 09:41:20AM +0200, Ahmad Fatoum wrote:
> Hello Eric,
> 
> On 09.08.21 23:24, Eric Biggers wrote:
> > Hi Ahmad,
> > 
> > This generally looks okay, but I have some comments below.
> > 
> > On Fri, Aug 06, 2021 at 05:09:28PM +0200, Ahmad Fatoum wrote:
> >> Kernel trusted keys don't require userspace knowledge of the raw key
> >> material and instead export a sealed blob, which can be persisted to
> >> unencrypted storage. Userspace can then load this blob into the kernel,
> >> where it's unsealed and from there on usable for kernel crypto.
> > 
> > Please be explicit about where and how the keys get generated in this case.
> 
> I intentionally avoided talking about this. You see, the trusted key documentation[1]
> phrases it as "all keys are created in the kernel", but you consider
> "'The key material is generated
>  within the kernel' [a] misleading claim'. [2]
> 
> Also, I hope patches to force kernel RNG and CAAM support (using kernel RNG as
> default) will soon be accepted, which would invalidate any further claims in the
> commit message without a means to correct them.
> 
> I thus restricted my commit message to the necessary bit that are needed to
> understand the patch, which is: userspace knowledge of the key material is
> not required. If you disagree, could you provide me the text you'd prefer?

Just write that the trusted key subsystem is responsible for generating the
keys.  And please fix the trusted keys documentation to properly document key
generation, or better yet just fix the trusted keys subsystem to generate the
keys properly.

> >> This is incompatible with fscrypt, where userspace is supposed to supply
> >> the raw key material. For TPMs, a work around is to do key unsealing in
> >> userspace, but this may not be feasible for other trusted key backends.
> > 
> > As far as I can see, "Key unsealing in userspace" actually is the preferred way
> > to implement TPM-bound encryption.  So it doesn't seem fair to call it a "work
> > around".
> 
> In the context of *kernel trusted keys*, direct interaction with the TPM
> outside the kernel to decrypt a kernel-encrypted blob is surely not the
> preferred way.
> 
> For TPM-bound encryption completely in userspace? Maybe. But that's not
> what this patch is about. It's about kernel trusted keys and offloading
> part of its functionality to userspace to _work around_ lack of kernel-side
> integration is exactly that: a _work around_.

As I said before, there's no need for kernel trusted keys at all in cases where
the TPM userspace tools can be used.  This is existing, well-documented process,
e.g. see: https://wiki.archlinux.org/title/Trusted_Platform_Module.  You are
starting with a solution ("I'm going to use kernel trusted keys") and not a
problem ("I want my fscrypt key(s) to be TPM-bound").  So please fix this patch
to explain the situation(s) in which it actually solves a problem that isn't
already solved.

- Eric
