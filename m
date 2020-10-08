Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D904A287B28
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Oct 2020 19:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbgJHRqo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Oct 2020 13:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbgJHRqo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Oct 2020 13:46:44 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBB04221FE;
        Thu,  8 Oct 2020 17:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602179203;
        bh=qR3kt5ngoTrkP6SeXaz22MvAG3J8V5pwp5o9tEVX8kI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LoAkoKArDyVvtY1vmpGflmDCv1LFFNmfSu0imo9EHlunCAHTuvnHONLjAhxRHkgRU
         6X85Uixynk3BpA+8Rm/WN9X7VbDTE50wPXqQPiyEBxOUcXU3uMLm2KUZsFhz7Q4QS/
         M+65IDat/o6loayOF2CL83BI65xWuguixSw/oQQA=
Date:   Thu, 8 Oct 2020 10:46:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: fscrypt, i_blkbits and network filesystems
Message-ID: <20201008174640.GC1869638@gmail.com>
References: <24943af8b2ede65d5ff1c8ff78c7a00b914e1a20.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24943af8b2ede65d5ff1c8ff78c7a00b914e1a20.camel@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 08, 2020 at 08:25:10AM -0400, Jeff Layton wrote:
> I've had to table the work on fscrypt+ceph for a bit to take care of
> some other issues, but I'm hoping to return to it soon, and I've started
> looking at the content encryption in more detail.
> 
> One thing I'm not sure how to handle yet is fscrypt's reliance on
> inode->i_blkbits. For ceph (and most netfs's), this value is a fiction.
> We're not constrained to reading/writing along block boundaries.
> 
> Cephfs usually sets the blocksize in a S_ISREG inode to the same as a
> "chunk" on the OSD (usu. 4M). That's a bit too large to deal with IMO,
> so I'm looking at lowering that to PAGE_SIZE when fscrypt is enabled.
> 
> That's reasonable when we can do pagecache-based I/O, but sometimes
> netfs's will do I/O directly from read_iter/write_iter. For ceph, we may
> need to do a rmw cycle if the iovec passed down from userland doesn't
> align to crypto block boundaries. Ceph has a way to do a cmp_extent
> operation such that it will only do the write if nothing changed in the
> interim, so we can handle that case, but it would be better not to have
> to read/write more than we need.
> 
> For the netfs case, would we be better off avoiding routines that take
> i_blkbits into account, and instead just work with
> fscrypt_encrypt_block_inplace / fscrypt_decrypt_block_inplace, maybe
> even by rolling new helpers that call them under the hood? Or, would
> that cause issues that I haven't forseen, and I should just stick to
> PAGE_SIZE blocks?

First, you should avoid using "PAGE_SIZE" as the crypto data unit size, since
PAGE_SIZE isn't the same everywhere.  E.g. PAGE_SIZE is 4096 bytes on x86, but
usually 65536 bytes on PowerPC.  If encrypted files are created on x86, they
should be readable on PowerPC too, and vice versa.  That means the crypto data
unit size should be a specific value, generally 4096 bytes.  But other
power-of-2 sizes could be allowed too.

Second, I'm not really understanding what the problem is with setting i_blkbits
for IS_ENCRYPTED() inodes to the log2 of the crypto data unit size.  Wouldn't
that be the right thing to do?  Even though it wouldn't have any meaning for the
server, it would have a meaning for the client -- it would be the granularity of
encryption (and decryption).

If it really is a problem, by "fscrypt's reliance on inode->i_blkbits" are you
specifically referring to fscrypt_encrypt_pagecache_blocks() and
fscrypt_decrypt_pagecache_blocks()?  If so, I think the way to go would be to
add __fscrypt_encrypt_pagecache_blocks() and
__fscrypt_decrypt_pagecache_blocks() which have a blkbits argument.

Or alternatively just add a blkbits argument to the existing functions, but I'd
prefer to avoid adding error-prone arguments to all callers of these.

fscrypt_encrypt_block_inplace() does in-place encryption, which isn't what you
want because you want to encrypt into a bounce page, right?
fscrypt_encrypt_block_inplace() and fscrypt_decrypt_block_inplace() also take
too many arguments, including lblk_num, which is error-prone.

- Eric
