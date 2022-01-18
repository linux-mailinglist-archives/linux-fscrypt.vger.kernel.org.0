Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64DB493121
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jan 2022 00:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350160AbiARXDj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Jan 2022 18:03:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47748 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238025AbiARXDi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Jan 2022 18:03:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E0AD612D3;
        Tue, 18 Jan 2022 23:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C0FC340E0;
        Tue, 18 Jan 2022 23:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642547017;
        bh=JwxY2h9tn3QE+WRRLQPNM+uQ68EejJ4xhgjUAq77hWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ukveCzfprxQ8zpV7fQKoIcvoTWtVmd0L9ll7H6IeS2o3YDXLINBG4IVQACbTsgckj
         VOaDmm8ZlFqcwB9G1T4+orQSuAAlXBiwf4eTGA4XDmy3EpSr6ztf0omxs0Nehl9C8n
         UgfM55ECiqtgi0kv/orpwrsXyzbVw5ZMzxSh3PW4be1CQ+IGRKFuOw+VJVrDkXlWbk
         zzRYGUDlOcR4yPvkn6vRg2de85Takv9uNol9sxPQSj77osrWelTazrv7CIN0H9VlmT
         A7SxM8N/lkcAavSDt0fhpYBwoqXbqUjFGADZ34jxSAetjaWsrNzXe7ltqj+k5fcLrJ
         B7xomrIy3KdQg==
Date:   Tue, 18 Jan 2022 15:03:35 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Antony Vennard <antony@vennard.ch>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Roberto Sassu <roberto.sassu@huawei.com>, dhowells@redhat.com,
        dwmw2@infradead.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.ibm.com
Subject: Re: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
Message-ID: <YedHR93wPLS/JEsE@sol.localdomain>
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
 <YeV+jkGg6mpQdRID@zx2c4.com>
 <d92912bba61ee37e42d04b64073b9031604acc0f.camel@HansenPartnership.com>
 <079f10b9-060b-3a36-2224-fa1b483cbad5@vennard.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <079f10b9-060b-3a36-2224-fa1b483cbad5@vennard.ch>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jan 18, 2022 at 09:50:21PM +0100, Antony Vennard wrote:
> 
> Hi All,
> 
> On 17/01/2022 16:02, James Bottomley wrote:
> > On Mon, 2022-01-17 at 15:34 +0100, Jason A. Donenfeld wrote:
> > > Hi,
> > > 
> > > While it looks like you put a lot of work into this patchset, I think
> > > the general idea of adding PGP *to the kernel* is a pretty daunting
> > > proposition. The general consensus in the crypto engineering world is
> > > that PGP ought to be on its way out. We definitely don't want to
> > > perpetuate this project-on-life-support into the permanence of kernel
> > > code. Some quick Google searches will reveal a litany of blog posts
> > > to the tune of, "why oh why are people still using this?" Here's one
> > > from 2019:
> > > https://latacora.micro.blog/2019/07/16/the-pgp-problem.html . I
> > > think these are arguments to take seriously. And even if you disagree
> > > with some parts, you may want to consider whether the remaining parts
> > > warrant a bit of pause before adding this to the kernel and
> > > perpetuating PGP's design further.
> 
> So while I understand why this is being proposed and clearly effort has gone
> into it, I also think it is not the right approach. It seems this proposal
> is to include a full PGP packet parser and verification logic in the kernel
> as an equivalent to allow PGP signatures to be submitted via
> FS_IOC_ENABLE_VERITY:
> 
> "FS_IOC_ENABLE_VERITY accepts a pointer to a PKCS#7 formatted detached
> signature in DER format of the file’s fs-verity digest."
> 

It's worth noting that if fs-verity built-in signatures are used, a trusted
userspace program is still required to determine and enforce the policy of which
files are required to be signed.  The kernel only handles the actual signature
verification.  This was basically a proof-of-concept which reused the kernel's
module signature verification code (which happens to use PKCS#7).

I'd encourage new users to either go all-in on a userspace solution, using a
trusted userspace program to verify signatures of fs-verity file digests;
*or* go all-in on an in-kernel solution, using the IMA support for fs-verity
which Mimi Zohar is working on.  A userspace solution could use a simple
signature format, using a modern algorithm such as Ed25519.  IMA uses a simple
signature format too, though it uses a complex format (X.509) for public keys.

- Eric
