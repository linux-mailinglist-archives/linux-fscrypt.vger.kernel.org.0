Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C55C289B31
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Oct 2020 23:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391917AbgJIVuK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Oct 2020 17:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732056AbgJIVuI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Oct 2020 17:50:08 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C2932225B;
        Fri,  9 Oct 2020 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602280207;
        bh=WyMppXPktdXIOAElv4xvLpl5glu7hSFKv764NQjUVyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n2lMLf90vxjJ3OFAOX8E+Iqp0fTw6ruef/rW6msMNkD/RDdh0BUxGCyOhTv/v/ug1
         TumORT4dvqXGMkMHmxGp083sTpZsauO8Do+XSfVUQyuwR+vu7vmGdGf8T7clReRFcU
         6pHSHiQxmhAeqkHZkE4OeNi9leQBSrZt0cSn5hsI=
Date:   Fri, 9 Oct 2020 14:50:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: fscrypt, i_blkbits and network filesystems
Message-ID: <20201009215005.GB839@sol.localdomain>
References: <24943af8b2ede65d5ff1c8ff78c7a00b914e1a20.camel@kernel.org>
 <20201008174640.GC1869638@gmail.com>
 <5e3273e2a2c8d95b5dfd77c35e133767d4e32e29.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e3273e2a2c8d95b5dfd77c35e133767d4e32e29.camel@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Oct 09, 2020 at 04:16:38PM -0400, Jeff Layton wrote:
> On Thu, 2020-10-08 at 10:46 -0700, Eric Biggers wrote:
> > 
> > First, you should avoid using "PAGE_SIZE" as the crypto data unit size, since
> > PAGE_SIZE isn't the same everywhere.  E.g. PAGE_SIZE is 4096 bytes on x86, but
> > usually 65536 bytes on PowerPC.  If encrypted files are created on x86, they
> > should be readable on PowerPC too, and vice versa.  That means the crypto data
> > unit size should be a specific value, generally 4096 bytes.  But other
> > power-of-2 sizes could be allowed too.
> > 
> 
> Ok, good point.
> 
> Pardon my lack of crypto knowledge, but I assume we have to ensure that
> we use the same crypto block size everywhere for the same inode as well?
> i.e., I can't encrypt a 4k block and then read in and decrypt a 16 byte
> chunk of it?

That's basically correct.  As I mentioned earlier: For AES-XTS specifically,
*in principle* it's possible to encrypt/decrypt an individual 16-byte aligned
region.  But Linux's crypto API doesn't currently support sub-message crypto,
and also fscrypt supports the AES-CBC and Adiantum encryption modes which have
stricter requirements.

> > Second, I'm not really understanding what the problem is with setting i_blkbits
> > for IS_ENCRYPTED() inodes to the log2 of the crypto data unit size.  Wouldn't
> > that be the right thing to do?  Even though it wouldn't have any meaning for the
> > server, it would have a meaning for the client -- it would be the granularity of
> > encryption (and decryption).
> > 
> 
> It's not a huge problem. I was thinking there might be an issue with
> some applications, but I don't think it really matters. The blocksize
> reported by stat is sort of a nebulous concept anyway when you get to a
> network filesystem.
> 
> The only real problem we have is that an application might pass down an
> I/O that is smaller than 4k, but we haven't been granted the capability
> to do buffered I/O. In that situation, we'll need to read what's there
> now (if anything) and then dispatch a synchronous write op that is gated
> on that data not having changed. 
> 
> There's some benefit to dealing with as small a chunk of data as we can,
> but 4k is probably a reasonable chunk to work with in most cases if
> that's not possible.

Applications can do reads/writes of any length regardless of what they see in
stat::st_blksize.  So you're going to have to support reads/writes with length
less than the data unit size (granularity of encryption) anyway.

You can choose whatever data unit size you want; it's a trade-off between the
fixed overhead of doing each encryption/decryption operation, and the
granularity of I/O that you want to support.  I'd assume that 4096 bytes would
be a good compromise for ceph, like it is for the other filesystems.  It also
matches PAGE_SIZE on most platforms.  But it's possible that something else
would be better.

- Eric
