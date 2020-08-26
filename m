Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C7225383F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Aug 2020 21:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHZTYG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Aug 2020 15:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbgHZTYG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Aug 2020 15:24:06 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5FA52078A;
        Wed, 26 Aug 2020 19:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598469845;
        bh=SaUbEt3IVf9LXgdJkwNfYVM7lY/VyHQBl54Q5ymJrAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r/HvpQv0yE4VHw2tJRO5UvM8d8HAIrOqTPIeihv3QrH3Tuvl+fxgIPnDdi3PBt7+i
         jHarVbPirtqhl9zoGmOr/cu4l/S98dGmBTCD9Y3egES1fseDGMqZcpJGTG1ddLJwfv
         5aYSvkUkAU6dJ86fdhyphzpVhbilVfGJ4VHirM3U=
Date:   Wed, 26 Aug 2020 12:24:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: IMA metadata format to support fs-verity
Message-ID: <20200826192403.GD2239109@gmail.com>
References: <760DF127-CA5F-4E86-9703-596E95CEF12F@oracle.com>
 <20200826183116.GC2239109@gmail.com>
 <6C2D16FB-C098-43F3-A7D3-D8AC783D1AB5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6C2D16FB-C098-43F3-A7D3-D8AC783D1AB5@oracle.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 26, 2020 at 02:56:45PM -0400, Chuck Lever wrote:
> 
> > On Aug 26, 2020, at 2:31 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > On Wed, Aug 26, 2020 at 10:13:43AM -0700, Chuck Lever wrote:
> >> Hi Eric-
> >> 
> >> I'm trying to construct a viable IMA metadata format (ie, what
> >> goes into security.ima) to support Merkle trees.
> >> 
> >> Rather than storing an entire Merkle tree per file, Mimi would
> >> like to have a metadata format that can store the root hash of
> >> a Merkle tree. Instead of reading the whole tree, an NFS client
> >> (for example) would generate the parts of the file's fs-verity
> >> Merkle tree on-demand. The tree itself would not be exposed or
> >> transported by the NFS protocol.
> > 
> > This won't work because you'd need to reconstruct the whole Merkle tree when
> > reading the first byte from the file.  Check the fs-verity FAQ
> > (https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#faq) where I
> > explained this in more detail (fourth question).
> 
> We agree there are inefficiencies with the proposed scheme. The
> Merkle tree would be rehydrated at measurement time, and used at
> read time to verify the results of each subsequent NFS READ.
> 
> We assume that parts of the tree and parts of the file content
> can be evicted from the client's memory at any time. So verifying
> READ results may require rehydration of some or all of the Merkle
> tree. If we're careful, eviction might avoid the higher levels of
> the tree to prevent the need to read the whole file again.
> 
> So, maybe we want to store the first level or two of the tree as
> well? Obviously there is a limit to how much can be stored in an
> extended attribute.

That's going to be very inefficient, and difficult to handle the caching,
preferential eviction, and constant tree rebuilding.

IMO, the only model that really makes sense is one where the full tree is stored
persistently.  Have you considered options for how that could be done in NFS?
What NFS protocol modifications (if any) are in scope?

> >> Following up with the recent thread on linux-integrity, starting
> >> here:
> >> 
> >>  https://lore.kernel.org/linux-integrity/1597079586.3966.34.camel@HansenPartnership.com/t/#u
> >> 
> >> I think the following will be needed.
> >> 
> >> 1. The parameters for (re)constructing the Merkle tree:
> >> - The name of the digest algorithm
> >> - The unit size represented by each leaf in the tree
> >> - The depth of the finished tree
> >> - The size of the file
> >> - Perhaps a salt value
> >> - Perhaps the file's mtime at the time the hash was computed
> >> - The root hash
> > 
> > Well, the xattr would need to contain the same information as
> > struct fsverity_enable_arg, the argument to FS_IOC_ENABLE_VERITY.
> > 
> >> 2. A fingerprint of the signer:
> >> - The name of the digest algorithm
> >> - The digest of the signer's certificate
> >> 
> >> 3. The signature
> >> - The name of the signature algorithm
> >> - The signature, computed over 1.
> > 
> > I thought there was a desire to just use the existing "integrity.ima"
> > signature format.
> 
> I am very interested in using EVM_IMA_DIGSIG. However, there appears
> to be a consensus that for cases like NFS, every readpage result needs
> to be verified, just as fs-verity does it.
> 
> I suppose measurement for an NFS file could involve verifying a
> saved linear hash while at the same time constructing a Merkle tree
> on the client?

fs-verity is mostly just a way of hashing a file.  Can't IMA just continue to do
its signatures in the same way, and just swap out the traditional full file hash
with the fs-verity file hash (when it's enabled)?

fs-verity does support its own signature mechanism, because people wanted a
simple knob to set that makes the kernel verify and enforce signatures for all
fs-verity files.  But it's not mandatory to use that.

- Eric
