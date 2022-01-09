Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28387488C7B
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jan 2022 22:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbiAIVHi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jan 2022 16:07:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53068 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbiAIVHV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jan 2022 16:07:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3D9F60FF8;
        Sun,  9 Jan 2022 21:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E08C36AEF;
        Sun,  9 Jan 2022 21:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641762440;
        bh=7xQcc5emTD5BbRbVtm9nurIK5RQS/EjcWO2jQit9YYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BY93rMgbrNl/5QgWAFlLvPvN31G1XF2Xc5RklhnirBtfbfwAATn5WD9XAvIUTd6fI
         CoF4t1CMo1ywDsS/2mKxhCpbJCWYJQJMos2KCXg3De4NcdgeslYAVrzvxXce8Kdpqg
         zmYxJo+0ZPmxD1oSVR+ARcJn6b1PqQLXFiLANxWCXRvk0qzys9Tpxij9HmjjWcZoap
         s7Bj+3PEkAqKVaaNgVNx9WglvIFjedIjT6THlxurfi89cVBttU2TUsLba+6xvNZMb9
         ZNMRWMi6kdr6uxwRXkRQqUKU+V6HJWvuKQu3sLNBL2GXQYiglwQeQeOoA+xNJ369Xh
         Em2qX6Av1tdUA==
Date:   Sun, 9 Jan 2022 13:07:18 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
Message-ID: <YdtOhsv/A5dqlApY@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
 <20211202215507.298415-5-zohar@linux.ibm.com>
 <YalDvGjq0inMFKln@sol.localdomain>
 <56c53b027ae8ae6909d38904bf089e73011657d7.camel@linux.ibm.com>
 <YdYrw4eiQPryOMkZ@gmail.com>
 <20220109204537.oueokvvkrkyy3ipq@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220109204537.oueokvvkrkyy3ipq@altlinux.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 09, 2022 at 11:45:37PM +0300, Vitaly Chikunov wrote:
> Eric,
> 
> On Wed, Jan 05, 2022 at 03:37:39PM -0800, Eric Biggers wrote:
> > On Fri, Dec 31, 2021 at 10:35:00AM -0500, Mimi Zohar wrote:
> > > On Thu, 2021-12-02 at 14:07 -0800, Eric Biggers wrote:
> > > > On Thu, Dec 02, 2021 at 04:55:06PM -0500, Mimi Zohar wrote:
> > > > >  	case IMA_VERITY_DIGSIG:
> > > > > -		fallthrough;
> > > > > +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> > > > > +
> > > > > +		/*
> > > > > +		 * The IMA signature is based on a hash of IMA_VERITY_DIGSIG
> > > > > +		 * and the fs-verity file digest, not directly on the
> > > > > +		 * fs-verity file digest.  Both digests should probably be
> > > > > +		 * included in the IMA measurement list, but for now this
> > > > > +		 * digest is only used for verifying the IMA signature.
> > > > > +		 */
> > > > > +		verity_digest[0] = IMA_VERITY_DIGSIG;
> > > > > +		memcpy(verity_digest + 1, iint->ima_hash->digest,
> > > > > +		       iint->ima_hash->length);
> > > > > +
> > > > > +		hash.hdr.algo = iint->ima_hash->algo;
> > > > > +		hash.hdr.length = iint->ima_hash->length;
> > > > 
> > > > This is still wrong because the bytes being signed don't include the hash
> > > > algorithm.  Unless you mean for it to be implicitly always SHA-256?  fs-verity
> > > > supports SHA-512 too, and it may support other hash algorithms in the future.
> > > 
> > > IMA assumes that the file hash algorithm and the signature algorithm
> > > are the same.   If they're not the same, for whatever reason, the
> > > signature verification would simply fail.
> > > 
> > > Based on the v2 signature header 'type' field, IMA can differentiate
> > > between regular IMA file hash based signatures and fs-verity file
> > > digest based signatures.  The digest field (d-ng) in the IMA
> > > meausrement list prefixes the digest with the hash algorithm. I'm
> > > missing the reason for needing to hash fs-verity's file digest with
> > > other metadata, and sign that hash rather than fs-verity's file digest
> > > directly.
> > 
> > Because if someone signs a raw hash, then they also implicitly sign the same
> > hash value for all supported hash algorithms that produce the same length hash.
> 
> Unless there is broken hash algorithm allowing for preimage attacks this
> is irrelevant. If there is two broken algorithms allowing for collisions,
> colliding hashes could be prepared even if algo id is hashed too.
> 

Only one algorithm needs to be broken.  For example, SM3 has the same hash
length as SHA-256.  If SM3 support were to be added to fs-verity, and if someone
were to find a way to find an input that has a specific SM3 digest, then they
could also make it match a specific SHA-256 digest.  Someone might intend to
sign a SHA-256 digest, but if they are only signing the raw 32 bytes of the
digest, then they would also be signing the corresponding SM3 digest.  That's
why the digest that is signed *must* also include the algorithm used in the
digest (not the algorithm(s) used in the signature, which is different).

- Eric
