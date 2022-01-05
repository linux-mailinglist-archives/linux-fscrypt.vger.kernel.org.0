Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53442485C4E
	for <lists+linux-fscrypt@lfdr.de>; Thu,  6 Jan 2022 00:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245428AbiAEXho (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 Jan 2022 18:37:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41046 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245409AbiAEXhn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 Jan 2022 18:37:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9346AB81E4F;
        Wed,  5 Jan 2022 23:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29601C36AEB;
        Wed,  5 Jan 2022 23:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641425861;
        bh=OaLKFIb1ARkLk57/Qx+mC0toRsPO01IbTArB7l0GSGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fZ8YfQ49EC0EhJAppEFkb0vUFMS87Daa9OygTU2vi2TwRmWp4D0XjetDuyQ+d8W+6
         fKijCFS0fqjNli3Mt1ATHxCAnWCZc2y0USD4xWgeREAbFNv4iugCOgC2oRIEjk93X4
         vOewN73t8qiPTZm1I4kOTXjQGcm4LncJ6r09861TIcjfIXjGnXU3nZ19/9mpPpZl+m
         uWGV2aCA2Vezm/TxHvztqZ5gQkb/jeTtpTRPmSjpfqUauppTBBJKfLYzFrnSad/Fuu
         6apHsJXoSkRrs3YMf7/UP1ccuiW4i/CPddsOxNZli1r8HFMl3+d6S5fQdTIaRDBEwf
         34haKz9YnhOew==
Date:   Wed, 5 Jan 2022 15:37:39 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
Message-ID: <YdYrw4eiQPryOMkZ@gmail.com>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
 <20211202215507.298415-5-zohar@linux.ibm.com>
 <YalDvGjq0inMFKln@sol.localdomain>
 <56c53b027ae8ae6909d38904bf089e73011657d7.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56c53b027ae8ae6909d38904bf089e73011657d7.camel@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Dec 31, 2021 at 10:35:00AM -0500, Mimi Zohar wrote:
> Hi Eric,
> 
> On Thu, 2021-12-02 at 14:07 -0800, Eric Biggers wrote:
> > On Thu, Dec 02, 2021 at 04:55:06PM -0500, Mimi Zohar wrote:
> > >  	case IMA_VERITY_DIGSIG:
> > > -		fallthrough;
> > > +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> > > +
> > > +		/*
> > > +		 * The IMA signature is based on a hash of IMA_VERITY_DIGSIG
> > > +		 * and the fs-verity file digest, not directly on the
> > > +		 * fs-verity file digest.  Both digests should probably be
> > > +		 * included in the IMA measurement list, but for now this
> > > +		 * digest is only used for verifying the IMA signature.
> > > +		 */
> > > +		verity_digest[0] = IMA_VERITY_DIGSIG;
> > > +		memcpy(verity_digest + 1, iint->ima_hash->digest,
> > > +		       iint->ima_hash->length);
> > > +
> > > +		hash.hdr.algo = iint->ima_hash->algo;
> > > +		hash.hdr.length = iint->ima_hash->length;
> > 
> > This is still wrong because the bytes being signed don't include the hash
> > algorithm.  Unless you mean for it to be implicitly always SHA-256?  fs-verity
> > supports SHA-512 too, and it may support other hash algorithms in the future.
> 
> IMA assumes that the file hash algorithm and the signature algorithm
> are the same.   If they're not the same, for whatever reason, the
> signature verification would simply fail.
> 
> Based on the v2 signature header 'type' field, IMA can differentiate
> between regular IMA file hash based signatures and fs-verity file
> digest based signatures.  The digest field (d-ng) in the IMA
> meausrement list prefixes the digest with the hash algorithm. I'm
> missing the reason for needing to hash fs-verity's file digest with
> other metadata, and sign that hash rather than fs-verity's file digest
> directly.

Because if someone signs a raw hash, then they also implicitly sign the same
hash value for all supported hash algorithms that produce the same length hash.
Signing a raw hash is only appropriate when there is only 1 supported algorithm.

All the other stuff you mentioned is irrelevant.

- Eric
