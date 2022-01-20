Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0864955C3
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jan 2022 22:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347392AbiATVFr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jan 2022 16:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347149AbiATVFr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jan 2022 16:05:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A43C061574;
        Thu, 20 Jan 2022 13:05:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6AD461881;
        Thu, 20 Jan 2022 21:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0807DC340E0;
        Thu, 20 Jan 2022 21:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642712746;
        bh=QG0w1QxyWXBXF08ydmzYpj/kUSr7oA+nVV6K7TKRTlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=plnjsfwST8po8W1XACJ8CrFOfSxWQC0R8tRaUIuiE0ncoDtJPlQ8kKoPmZcr1mHLr
         e3lGfQG2P4/lV4vP8xSrRv7QuuyLfHjAqJA54y7kgEpX9bDBpNyUgPJUrSP/rxgge/
         bV5IkyL6exYoIrx8mcqylkRYoguCp8jynLI2e3dFUrfvfWB8S+GSmd72FESgU5T67z
         9+4vRyCpsTB6Ju/uNyUx2UFLywzM0+LBsRie6g61Wacodo1iBEaROVFQxoCbCtf4kV
         H0b5oU8FPI6J12ig1kF0ViWt80UxDHBaVfk2T2NIXXMeG7F9Dro9UI6OUmo5UKfMA+
         g2qPSOjQHWylA==
Date:   Thu, 20 Jan 2022 13:05:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Vitaly Chikunov <vt@altlinux.org>, linux-integrity@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
Message-ID: <YenOqJtjS/Y2zBQC@sol.localdomain>
References: <YalDvGjq0inMFKln@sol.localdomain>
 <56c53b027ae8ae6909d38904bf089e73011657d7.camel@linux.ibm.com>
 <YdYrw4eiQPryOMkZ@gmail.com>
 <20220109204537.oueokvvkrkyy3ipq@altlinux.org>
 <YdtOhsv/A5dqlApY@sol.localdomain>
 <20220115053101.36xoy2bc7ypozo6l@altlinux.org>
 <YeJn7hxLEfdVrUQT@sol.localdomain>
 <bc803a35d914dde65640428d2b29cc6e89d176d4.camel@linux.ibm.com>
 <Yedd0CKCHSq1ugFk@sol.localdomain>
 <c0676336a7992b6495c5f5dec7ca1897fb4005eb.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0676336a7992b6495c5f5dec7ca1897fb4005eb.camel@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jan 20, 2022 at 11:39:56AM -0500, Mimi Zohar wrote:
> Eric, Vitaly,
> 
> On Tue, 2022-01-18 at 16:39 -0800, Eric Biggers wrote:
> 
> > > > The easiest way to do this would be sign/verify the following struct:
> > > > 	struct ima_file_id {
> > > > 		u8 is_fsverity;
> > > > 		u8 hash_algorithm;
> > > > 		u8 hash[];
> > > > 	};
> 
> 
> > > This would be the *data* that is signed/verified -- meaning that it
> would be
> > > > hashed again as part of the signature algorithm (whether that hash is built-in
> > > > to the signature algorithm, as is the case for modern algorithms, or handled by
> > > > the caller as is the case for legacy algorithms).
> > > 
> > > There seems to be an inconsistency, here, with what you said above,
> > > "... ECDSA just signs/verifies a raw hash, and in fact it *must* be a
> > > raw hash for it to be secure."
> > 
> > There isn't an inconsistency.  ECDSA is among the algorithms where the caller is
> > expected to handle the hash.
> > 
> > It is confusing dealing with all these different signature algorithms.  I think
> > the right way to think about this is in terms of what *data* is being
> > signed/verified.  Currently the data is the full file contents.  I think it
> > needs to be made into an annotated hash, e.g. the struct I gave.
> > 
> > public_key_verify_signature() also needs to be fixed to support both types of
> > signature algorithms (caller-provided hash and internal hash) in a logical way.
> > Originally it only supported caller-provided hashes, but then SM2 support was
> > added and now it is super broken.
> 
> Eric, did you say you're working on fixes to address these problems?

Yes, I was working on some patches at
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=wip-keys-fixes
but got distracted by other things, as well as finding the problems with SM2
which will take some time to decide what to do with.  I'll try to get some
patches ready, but there are a lot of things to fix.

> 
> Instead of using a flexible array, Vitaly suggested defining the hash
> as FS_VERITY_MAX_DIGEST_SIZE, so that it could be allocated temporarily
> on stack
> instead of kalloc.
> 
> As the above struct is not limited to fsverity, we could use
> MAX_HASH_DIGESTSIZE, if it was exported, but it isn't.  Would the
> following work for you?
> 
> /*
>  * IMA signature header version 3 disambiguates the data that is signed
> by
>  * indirectly signing the hash of this structure, containing either the
>  * fsverity_descriptor struct digest or, in the future, the traditional
> IMA
>  * file hash.
>  */
> struct ima_file_id {
>         __u8 is_fsverity;       /* set to 1 for IMA_VERITY_DIGSIG */
>         __u8 hash_algorithm;    /* Digest algorithm [enum hash_algo] */
> #ifdef __KERNEL__
>         __u8 hash[HASH_MAX_DIGESTSIZE];
> #else
>         __u8 hash[];
> #endif
> };

You could certainly declare a fixed-length struct, but only sign/verify the used
portion of it.  The fixed-length struct would just be an implementation detail.

Alternatively, you could always sign/verify a fixed-length struct, with any
shorter hashes zero-padded to HASH_MAX_DIGESTSIZE (64 bytes).  This would be
fine if you're confident that hashes longer than 64 bytes will never be used.
(They don't make sense cryptographically, but who knows.)

For future extensibility, you might want to call the 'is_fsverity' field
something like 'hash_type', so it would be like an enum rather than a bool.  I
just used 'is_fsverity' as a minimal example.

- Eric
