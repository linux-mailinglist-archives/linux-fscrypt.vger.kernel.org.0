Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9680D466C00
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 23:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhLBWWI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 17:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhLBWWI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 17:22:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C195C06174A;
        Thu,  2 Dec 2021 14:18:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C53F6B823AA;
        Thu,  2 Dec 2021 22:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59408C00446;
        Thu,  2 Dec 2021 22:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638483522;
        bh=YH4TOJRyH4rRdQrUQ5WZQ74ziTws+s2sSJiYYsJ8HPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hthdPKE9Tw0YNz6Z1NkOAe11T+COAFIijQ2Ga941VrEPAvoaIf4dEVDDHftqLil+a
         6yLOdh8VeT46wVfkj2aYOQU3STnMxAj1XdCgN/0+EGFz/y+Fv6tAOJkmNrUzR2t6fX
         b6ZuFDn/0k1bbrdZJjaPAtB+DDKAOSOON5Z2p9jxQx5NCJlS/ZXhXrZVSb7da5d+Qi
         QcGG4SF8kW0jGun8qFHpP7UWHSpWrp4G6XiZUQdoEnLrWGhgbKTvWCMfr3dURwAVwg
         e0axtQR8U8iFmn9WGOzXkwX31MMI8JzXujmL2aNPzQVQx5FWGNvZL6crsN486eYCot
         xQ6C4jmFYeK0w==
Date:   Thu, 2 Dec 2021 14:18:40 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
Message-ID: <YalGQHTq51SHqC1a@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
 <20211202215507.298415-5-zohar@linux.ibm.com>
 <YalDvGjq0inMFKln@sol.localdomain>
 <4dc45d1ec7450b4d1d06b12baf73668525bd8157.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dc45d1ec7450b4d1d06b12baf73668525bd8157.camel@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 02, 2021 at 05:13:15PM -0500, Mimi Zohar wrote:
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
> The signature stored in security.ima is prefixed with a header
> (signature_v2_hdr).

Yes, but the byte that identifies the hash algorithm is not included in the
bytes that are actually signed, as far as I can tell.

- Eric
