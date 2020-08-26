Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7A7253960
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Aug 2020 22:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgHZUvq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Aug 2020 16:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbgHZUvq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Aug 2020 16:51:46 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 375AF2078D;
        Wed, 26 Aug 2020 20:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598475105;
        bh=wE0T2s3H9QjfKz3VvdOk93oK3T4iAQ3TJs7Wxfj57aU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CPe5SbaKdMpHqG/Bt8xSc+ElnRZvWllXsK1cX/oOcnOnRGKfDQASbXolorGoEzmO2
         fx29fLHEfmUGobyElTgWiZe9DFV+HQytGWu5/3nEnkzd7UhKyyxt6cjJiIX/Ul8VPv
         mKIS5/9Gzsl88pFk9NocCG5lpqrhK5HiveP9SQxc=
Date:   Wed, 26 Aug 2020 13:51:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: IMA metadata format to support fs-verity
Message-ID: <20200826205143.GE2239109@gmail.com>
References: <760DF127-CA5F-4E86-9703-596E95CEF12F@oracle.com>
 <20200826183116.GC2239109@gmail.com>
 <6C2D16FB-C098-43F3-A7D3-D8AC783D1AB5@oracle.com>
 <20200826192403.GD2239109@gmail.com>
 <E7A87987-AF41-42AC-8244-0D07AA68A6E7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E7A87987-AF41-42AC-8244-0D07AA68A6E7@oracle.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 26, 2020 at 03:51:48PM -0400, Chuck Lever wrote:
> 
> 
> > On Aug 26, 2020, at 3:24 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > On Wed, Aug 26, 2020 at 02:56:45PM -0400, Chuck Lever wrote:
> >> 
> >>> On Aug 26, 2020, at 2:31 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> >>> 
> >>> On Wed, Aug 26, 2020 at 10:13:43AM -0700, Chuck Lever wrote:
> >>>> Hi Eric-
> >>>> 
> >>>> I'm trying to construct a viable IMA metadata format (ie, what
> >>>> goes into security.ima) to support Merkle trees.
> >>>> 
> >>>> Rather than storing an entire Merkle tree per file, Mimi would
> >>>> like to have a metadata format that can store the root hash of
> >>>> a Merkle tree. Instead of reading the whole tree, an NFS client
> >>>> (for example) would generate the parts of the file's fs-verity
> >>>> Merkle tree on-demand. The tree itself would not be exposed or
> >>>> transported by the NFS protocol.
> >>> 
> >>> This won't work because you'd need to reconstruct the whole Merkle tree when
> >>> reading the first byte from the file.  Check the fs-verity FAQ
> >>> (https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#faq) where I
> >>> explained this in more detail (fourth question).
> >> 
> >> We agree there are inefficiencies with the proposed scheme. The
> >> Merkle tree would be rehydrated at measurement time, and used at
> >> read time to verify the results of each subsequent NFS READ.
> >> 
> >> We assume that parts of the tree and parts of the file content
> >> can be evicted from the client's memory at any time. So verifying
> >> READ results may require rehydration of some or all of the Merkle
> >> tree. If we're careful, eviction might avoid the higher levels of
> >> the tree to prevent the need to read the whole file again.
> >> 
> >> So, maybe we want to store the first level or two of the tree as
> >> well? Obviously there is a limit to how much can be stored in an
> >> extended attribute.
> > 
> > That's going to be very inefficient, and difficult to handle the caching,
> > preferential eviction, and constant tree rebuilding.
> 
> My focus is code signing. I'm expecting individual executables to
> be under a few dozen megabytes in size, on average, and to change
> infrequently or never (immutable). Configuration files, shell
> scripts, and symlinks will be even smaller on average.
> 
> Thus I anticipate that the frequency of eviction should be pretty
> small, and the client should be able to read the files in their
> entirety quickly. Efficiency comes from reading each file as few
> times as possible to maintain its Merkle tree. The cost of
> measuring the file is amortized well if the file is used
> frequently enough to keep its tree in the client's memory.
> 
> The inefficient case is a file that is large and used infrequently,
> IIUC.
> 
> 
> > IMO, the only model that really makes sense is one where the full tree is stored
> > persistently.
> 
> Can you say more about why you believe that?

Because if the full tree isn't stored, it defeats most of the point of doing a
Merkle tree based hash.  The filesystem would have to read and hash the full
file up-front, which by itself defeats the main benefit.  Then later, reads from
the file can result in having to rebuild large parts of the tree --- unless the
entire tree is kept pinned in memory, which isn't feasible for large files.

> > Have you considered options for how that could be done in NFS?
> 
> We have.
> 
> 
> > What NFS protocol modifications (if any) are in scope?
> 
> There are two ways to pull data via NFS. One is READ, which assumes
> an arbitrarily large byte stream and the ability to seek in it. The
> byte stream content is read in sections no larger than "rsize"
> (typically 1MB or less). The client has various mechanisms to
> detect when the file content has changed on the server, and can use
> them to cache the file's content aggressively.
> 
> The other is attribute data, which is pulled in a single operation and
> is therefore limited in size. There is no cache consistency scheme
> for this type of data, so clients typically read it every time there
> is an application request for it.
> 
> - We could define a named attribute that is a secondary byte stream
> associated with a filehandle. It can be arbitrarily large and is
> read piecemeal via NFS READ.

If it's possible, a secondary byte stream associated with the file would be a
good option.  The fs-verity implementation in ext4 and f2fs has been criticized
because the Merkle tree is stored past the end of the file rather than in a
separate file stream, which in theory would be a cleaner solution.

> > fs-verity is mostly just a way of hashing a file.  Can't IMA just continue to do
> > its signatures in the same way, and just swap out the traditional full file hash
> > with the fs-verity file hash (when it's enabled)?
> 
> Essentially that's what we're doing: inventing a new IMA metadata
> format that stores a Merkle root hash instead of a linear hash.
> 
> The current IMA formats take a single parameter: which hash algo
> to use. Merkle tree construction requires a larger set of parameters,
> which is why we think a new metadata format is necessary.

Well, you'll need to store the fsverity_descriptor or something equivalent.  Not
because it would be signed directly (it would be hashed first, as per
https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#file-measurement-computation),
but because it's needed to understand the Merkle tree.

Of course, the bytes that are actually signed need to include not just the hash
itself, but also the type of hash algorithm that was used.  Else it's ambiguous
what the signer intended to sign.

Unfortunately, currently EVM appears to sign a raw hash, which means it is
broken, as the hash algorithm is not authenticated.  I.e. if the bytes
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 are signed,
there's no way to prove that the signer meant to sign a SHA-256 hash, as opposed
to, say, a Streebog hash.  So that will need to be fixed anyway.  While doing
so, you should reserve some fields so that there's also a flag available to
indicate whether the hash is a traditional full file hash or a fs-verity hash.

- Eric
