Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56325372D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Aug 2020 20:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgHZSbU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Aug 2020 14:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgHZSbT (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Aug 2020 14:31:19 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59A8220786;
        Wed, 26 Aug 2020 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598466678;
        bh=TDqYw1I+fMxiQUBOM0I/yhNL2p/c91r6+Mvhjf8c08M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SBu7tcGwJm4xoOWOW9+I34FoVOS8UzadGsHvfwOW2YXT/X+jLiA6KXdHGvnb+Xif+
         5gBs/B7t5q6ahgE1zGUnhFpBlsjFm/Vz3V/ra7Xplg/AubfJM6Na+hjHBbtXo55Y/t
         4JY+QkLCYW/ztTfXAFHK6/296//XU6ECRX081NDk=
Date:   Wed, 26 Aug 2020 11:31:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: IMA metadata format to support fs-verity
Message-ID: <20200826183116.GC2239109@gmail.com>
References: <760DF127-CA5F-4E86-9703-596E95CEF12F@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <760DF127-CA5F-4E86-9703-596E95CEF12F@oracle.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 26, 2020 at 10:13:43AM -0700, Chuck Lever wrote:
> Hi Eric-
> 
> I'm trying to construct a viable IMA metadata format (ie, what
> goes into security.ima) to support Merkle trees.
> 
> Rather than storing an entire Merkle tree per file, Mimi would
> like to have a metadata format that can store the root hash of
> a Merkle tree. Instead of reading the whole tree, an NFS client
> (for example) would generate the parts of the file's fs-verity
> Merkle tree on-demand. The tree itself would not be exposed or
> transported by the NFS protocol.

This won't work because you'd need to reconstruct the whole Merkle tree when
reading the first byte from the file.  Check the fs-verity FAQ
(https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#faq) where I
explained this in more detail (fourth question).

> Following up with the recent thread on linux-integrity, starting
> here:
> 
>   https://lore.kernel.org/linux-integrity/1597079586.3966.34.camel@HansenPartnership.com/t/#u
> 
> I think the following will be needed.
> 
> 1. The parameters for (re)constructing the Merkle tree:
> - The name of the digest algorithm
> - The unit size represented by each leaf in the tree
> - The depth of the finished tree
> - The size of the file
> - Perhaps a salt value
> - Perhaps the file's mtime at the time the hash was computed
> - The root hash

Well, the xattr would need to contain the same information as
struct fsverity_enable_arg, the argument to FS_IOC_ENABLE_VERITY.

> 2. A fingerprint of the signer:
> - The name of the digest algorithm
> - The digest of the signer's certificate
> 
> 3. The signature
> - The name of the signature algorithm
> - The signature, computed over 1.

I thought there was a desire to just use the existing "integrity.ima"
signature format.

> Does this seem right to you?
> 
> There has been some controversy about whether to allow the
> metadata to be unsigned. It can't ever be unsigned for NFS files,
> but some feel that on a physically secure local-only set up,
> signatures could be unnecessary overhead. I'm not convinced, and
> believe the metadata should always be signed: that's the only
> way to guarantee end-to-end integrity, which includes protection
> of the content's provenance, no matter how it is stored.

Are you looking for integrity-only protection (protection against accidental
modification), or also for authenticity protection (protection against
malicicous modifications)?  For authenticity, you have to verify the file's hash
against something you trust.  A signature is the usual way to do that.

- Eric
