Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B9F488C55
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jan 2022 21:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbiAIUpk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jan 2022 15:45:40 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:43286 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbiAIUpj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jan 2022 15:45:39 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 9AA9F72C905;
        Sun,  9 Jan 2022 23:45:37 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 4E7644A46EA;
        Sun,  9 Jan 2022 23:45:37 +0300 (MSK)
Date:   Sun, 9 Jan 2022 23:45:37 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
Message-ID: <20220109204537.oueokvvkrkyy3ipq@altlinux.org>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
 <20211202215507.298415-5-zohar@linux.ibm.com>
 <YalDvGjq0inMFKln@sol.localdomain>
 <56c53b027ae8ae6909d38904bf089e73011657d7.camel@linux.ibm.com>
 <YdYrw4eiQPryOMkZ@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <YdYrw4eiQPryOMkZ@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Eric,

On Wed, Jan 05, 2022 at 03:37:39PM -0800, Eric Biggers wrote:
> On Fri, Dec 31, 2021 at 10:35:00AM -0500, Mimi Zohar wrote:
> > On Thu, 2021-12-02 at 14:07 -0800, Eric Biggers wrote:
> > > On Thu, Dec 02, 2021 at 04:55:06PM -0500, Mimi Zohar wrote:
> > > >  	case IMA_VERITY_DIGSIG:
> > > > -		fallthrough;
> > > > +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> > > > +
> > > > +		/*
> > > > +		 * The IMA signature is based on a hash of IMA_VERITY_DIGSIG
> > > > +		 * and the fs-verity file digest, not directly on the
> > > > +		 * fs-verity file digest.  Both digests should probably be
> > > > +		 * included in the IMA measurement list, but for now this
> > > > +		 * digest is only used for verifying the IMA signature.
> > > > +		 */
> > > > +		verity_digest[0] = IMA_VERITY_DIGSIG;
> > > > +		memcpy(verity_digest + 1, iint->ima_hash->digest,
> > > > +		       iint->ima_hash->length);
> > > > +
> > > > +		hash.hdr.algo = iint->ima_hash->algo;
> > > > +		hash.hdr.length = iint->ima_hash->length;
> > > 
> > > This is still wrong because the bytes being signed don't include the hash
> > > algorithm.  Unless you mean for it to be implicitly always SHA-256?  fs-verity
> > > supports SHA-512 too, and it may support other hash algorithms in the future.
> > 
> > IMA assumes that the file hash algorithm and the signature algorithm
> > are the same.   If they're not the same, for whatever reason, the
> > signature verification would simply fail.
> > 
> > Based on the v2 signature header 'type' field, IMA can differentiate
> > between regular IMA file hash based signatures and fs-verity file
> > digest based signatures.  The digest field (d-ng) in the IMA
> > meausrement list prefixes the digest with the hash algorithm. I'm
> > missing the reason for needing to hash fs-verity's file digest with
> > other metadata, and sign that hash rather than fs-verity's file digest
> > directly.
> 
> Because if someone signs a raw hash, then they also implicitly sign the same
> hash value for all supported hash algorithms that produce the same length hash.

Unless there is broken hash algorithm allowing for preimage attacks this
is irrelevant. If there is two broken algorithms allowing for collisions,
colliding hashes could be prepared even if algo id is hashed too.

Thanks,

> Signing a raw hash is only appropriate when there is only 1 supported algorithm.
> 
> All the other stuff you mentioned is irrelevant.
> 
> - Eric
