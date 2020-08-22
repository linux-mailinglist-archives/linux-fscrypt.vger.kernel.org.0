Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E1024E41B
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Aug 2020 02:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgHVAXE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 20:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgHVAXD (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 20:23:03 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3C01214F1;
        Sat, 22 Aug 2020 00:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598055783;
        bh=BYNcF5+CZAB6RYfei1Ao7hHUCwtnOZqYU9vE2rpsMOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XArcEtjw0R/HKh8/EpUMpTpnQPMu4VQNNHnzJAOSkHsoghC7EGk566xTPFLE+Um+F
         b6pMTCGSq88bFRe40StsLrUIPh6vt4wxN7UxuIXHrUCIvkPwW/VZuA1FDnfILUUzmG
         tbcxQqKlKc3CfpXh7Mq3+IEDZzsmS8y2AABsYXJc=
Date:   Fri, 21 Aug 2020 17:23:01 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [RFC PATCH 00/14] ceph+fscrypt: together at last (contexts and
 filenames)
Message-ID: <20200822002301.GA834@sol.localdomain>
References: <20200821182813.52570-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821182813.52570-1-jlayton@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Jeff,

On Fri, Aug 21, 2020 at 02:27:59PM -0400, Jeff Layton wrote:
> This is a (very rough and incomplete) draft patchset that I've been
> working on to add fscrypt support to cephfs. The main use case is being
> able to allow encryption at the edges, without having to trust your storage
> provider with keys.

This is very interesting work -- thanks for sending this out!

> Implementing fscrypt on a network filesystem has some challenges that
> you don't have to deal with on a local fs:
> 
> Ceph (and most other netfs') will need to pre-create a crypto context
> when creating a new inode as we'll need to encrypt some things before we
> have an inode. This patchset stores contexts in an xattr, but that's
> probably not ideal for the final implementation [1].

Coincidentally, I've currently working on solving a similar problem.  On ext4,
the inode number can't be assigned, and the encryption xattr can't be set, until
the jbd2 transaction which creates the inode.  Also, if the new inode is a
symlink, then fscrypt_encrypt_symlink() has to be called during the transaction.
Together, these imply that fscrypt_get_encryption_info() has to be called during
the transaction.

That's what we do, currently.  However, it's technically wrong and can deadlock,
since fscrypt_get_encryption_info() isn't GFP_NOFS-safe (and it can't be).

f2fs appears to have a similar problem, though I'm still investigating.

To fix this, I'm planning to add new functions:

   - fscrypt_prepare_new_inode() will set up the fscrypt_info for a new
     'struct inode' which hasn't necessarily had an inode number assigned yet.
     It won't set the encryption xattr yet.

   - fscrypt_set_context() will set the encryption xattr, using the fscrypt_info
     that fscrypt_prepare_new_inode() created earlier.  It will replace
     fscrypt_inherit_context().

I'm working on my patches at
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=wip-fscrypt.
They're not ready to send out yet, but I'll Cc you when I do.

It seems there's still something a bit different that you need: you want
fs/crypto/ to provide a buffer containing the encryption xattr (presumably
because ceph needs to package it up into a single network request that creates
the file?), instead of calling a function which then uses
fscrypt_operations::set_context().  I could pretty easily handle that by adding
a function that returns the xattr directly and would be an alternative to
fscrypt_set_context().

> Storing a binary crypttext filename on the MDS (or most network
> fileservers) may be problematic. We'll probably end up having to base64
> encode the names when storing them. I expect most network filesystems to
> have similar issues. That may limit the effective NAME_MAX for some
> filesystems [2].

I strongly recommend keeping support for the full NAME_MAX (255 bytes), if it's
at all possible.  eCryptfs limited filenames to 143 bytes, which has
historically caused lots of problems.  Try the following Google search to get a
sense of the large number of users that have run into this limitation:
https://www.google.com/search?q=ecryptfs+143+filename

> 
> For content encryption, Ceph (and probably at least CIFS/SMB) will need
> to deal with writes not aligned on crypto blocks. These filesystems
> sometimes write synchronously to the server instead of going through the
> pagecache [3].

I/O that isn't aligned to the "encryption data unit size" (which on the
filesystems that currently support fscrypt, is the same thing as the
"filesystem block size") isn't really possible unless it's buffered.  For
AES-XTS specifically, *in principle* it's possible to encrypt/decrypt an
individual 16-byte aligned region.  But Linux's crypto API doesn't currently
support sub-message crypto, and also fscrypt supports the AES-CBC and Adiantum
encryption modes which have stricter requirements.

So, I think that reads/writes to encrypted files will always need to go through
the page cache.

> 
> Symlink handling in fscrypt will also need to be refactored a bit, as we
> won't have an inode before we'll need to encrypt its contents.

Will there be an in-memory inode allocated yet (a 'struct inode'), just with no
inode number assigned yet?  If so, my work-in-progress patchset I mentioned
earlier should be sufficient to address this.  The order would be:

	1. fscrypt_prepare_new_inode()
	2. fscrypt_encrypt_symlink()
	3. Assign inode number

Or does ceph not have a 'struct inode' at all until step (3)?

- Eric
