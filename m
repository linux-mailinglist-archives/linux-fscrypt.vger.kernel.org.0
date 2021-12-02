Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01052466B90
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 22:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377102AbhLBVVW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 16:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377084AbhLBVVP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 16:21:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4159C06175E;
        Thu,  2 Dec 2021 13:17:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 793A162828;
        Thu,  2 Dec 2021 21:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41C9C00446;
        Thu,  2 Dec 2021 21:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638479867;
        bh=W3xBBcJLWE+u1rVNV1hlT/71b+PMgM8tysBbrSfTzDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PEpysPPvcXC93E20vqKNSFueqtlAsE8GLTU75A0Sn8GAoMnBm9aJA3vofCC3SG1pi
         TEnlp/B/SoZ0ubVJNCfBZ7wbbQi+Y+VWD97JmDbRt2h2uqkc6mmfVtNxm8/mvWiMfU
         T0pDhabkyq/GgUWK6SqEqdoOkit7n5kxDxVkxn7Wy+4MKCkFNjDO0ccoEiSzygk2Xz
         S3IjMM6xzLXZ8Bi/RGTrvZ3bocU8Vp+E1+Mkk8DG8c612TnzixeuGDtNht6v5OgZTG
         3k5Ib3TZotJ+P/FszdA8URr5Jx7a692+FMr0OjKrLE7Hw08zEm1TCX1xzrgzqGCVzW
         byTjNBijWEV8Q==
Date:   Thu, 2 Dec 2021 13:17:46 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ima: define a new signature type named
 IMA_VERITY_DIGSIG
Message-ID: <Yak3+n7fcqaM53ct@sol.localdomain>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
 <20211129170057.243127-3-zohar@linux.ibm.com>
 <YaWNX3nwslG/Q2aH@sol.localdomain>
 <6931ed7b1c7d5906bb595447fc24cd8a9b3e3d62.camel@linux.ibm.com>
 <a1b808d664603bfd4bd2f747b59c3e0c51646922.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1b808d664603bfd4bd2f747b59c3e0c51646922.camel@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 02, 2021 at 11:25:05AM -0500, Mimi Zohar wrote:
> Hi Eric,
> 
> On Tue, 2021-11-30 at 13:14 -0500, Mimi Zohar wrote:
> > On Mon, 2021-11-29 at 18:33 -0800, Eric Biggers wrote:
> > > On Mon, Nov 29, 2021 at 12:00:55PM -0500, Mimi Zohar wrote:
> > > > To differentiate between a regular file hash and an fs-verity file digest
> > > > based signature stored as security.ima xattr, define a new signature type
> > > > named IMA_VERITY_DIGSIG.
> > > > 
> > > > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> > > 
> > > For this new signature type, what bytes are actually signed?  It looks like it's
> > > just the raw digest, which isn't sufficient since it is ambiguous.  It needs to
> > > include information that makes it clear what the signer is actually signing,
> > > such as "this is an fs-verity SHA-256 file digest".  See
> > > 'struct fsverity_formatted_digest' for an example of this (but it isn't
> > > necessary to use that exact structure).
> > > 
> > > I think the existing IMA signatures have the same problem (but it is hard for me
> > > to understand the code).  However, a new signature type doesn't have
> > > backwards-compatibility concerns, so it could be done right.
> > 
> > As this change should probably be applicable to all signature types,
> > the signature version in the  signature_v2_hdr should be bumped.  The
> > existing signature version could co-exist with the new signature
> > version.
> 
> By signing the file hash, the sig field in the IMA measurement list can
> be directly verified against the digest field.  For appended
> signatures, we defined a new template named ima-modsig which contains
> two file hashes, with and without the appended signature.
> 
> Similarly, by signing a digest containing other metadata and fs-
> verity's file digest, the measurement list should include both digests.
> Otherwise the consumer of the measurement list would first need to
> calculate the signed digest before verifying the signature.
> 
> Options:
> - Include just fs-verity's file digest and the signature in the
> measurement list.  Leave it to the consumer of the measurement list to
> deal with.
> - Define a new template format to include both digests, add a new field
> in the iint for the signed digest.  (Much more work.)
> - As originally posted, directly sign fs-verity's file digest.

I don't really have enough knowledge about IMA and how it is used to decide on
one approach or the other.  Note that earlier I mentioned that it would be
possible to have an fs-verity setting that makes a full file digest be included
in the fsverity_descriptor, so it gets covered by the fs-verity file digest and
is also retrievable in constant time like the fs-verity file digest is.

If you'd like to solve this problem at the IMA layer instead, by storing the
full file digest in an xattr and signing both the full file digest and fs-verity
file digest together, that would achieve the same goal of making the full file
digest available, and wouldn't require any changes to fs-verity.  This would
assume that the file would be signed, though.  What about audit-only mode
without signatures; is that something you care about?

Alternatively, maybe this problem doesn't need to be solved at all and IMA would
be fine with the fs-verity file digest only, and not need the full file hash
too.  I don't know the answer to that; I think it's up to you to decide.

- Eric
