Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D127024E44F
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Aug 2020 02:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgHVA6i (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 20:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbgHVA6h (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 20:58:37 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 383FE2067C;
        Sat, 22 Aug 2020 00:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598057916;
        bh=Bv0quwB7pCWkloss4ROqxolrUmxLVdVPEY/wnAax+IA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R6MTF+PCYv5lx990i38DnY56iaWv3eumXA3T2EO8TyqXj6WAMHs3oe/PMtbcUsBJJ
         VT9Qv7E1m2bmSjfXLuacwXDsdcvqsvbAq0flng9GHcFxIBD9nhgh99d/iVKDZjiR8l
         71lIQFVLOYG9o56KvWRBC/ze0VFkTrO3TXezUDu8=
Message-ID: <2a6b92f25325fa95164f418c669883f73a291b77.camel@kernel.org>
Subject: Re: [RFC PATCH 00/14] ceph+fscrypt: together at last (contexts and
 filenames)
From:   Jeff Layton <jlayton@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Date:   Fri, 21 Aug 2020 20:58:35 -0400
In-Reply-To: <20200822002301.GA834@sol.localdomain>
References: <20200821182813.52570-1-jlayton@kernel.org>
         <20200822002301.GA834@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 2020-08-21 at 17:23 -0700, Eric Biggers wrote:
> Hi Jeff,
> 
> On Fri, Aug 21, 2020 at 02:27:59PM -0400, Jeff Layton wrote:
> > This is a (very rough and incomplete) draft patchset that I've been
> > working on to add fscrypt support to cephfs. The main use case is being
> > able to allow encryption at the edges, without having to trust your storage
> > provider with keys.
> 
> This is very interesting work -- thanks for sending this out!
> 

Thanks. As I said, it's still very rough at this point, but I'm hoping
to have something ready for v5.11. I think we'll need to plumb some
support into the MDS too, so getting all of that lined up may take
longer.

> > Implementing fscrypt on a network filesystem has some challenges that
> > you don't have to deal with on a local fs:
> > 
> > Ceph (and most other netfs') will need to pre-create a crypto context
> > when creating a new inode as we'll need to encrypt some things before we
> > have an inode. This patchset stores contexts in an xattr, but that's
> > probably not ideal for the final implementation [1].
> 
> Coincidentally, I've currently working on solving a similar problem.  On ext4,
> the inode number can't be assigned, and the encryption xattr can't be set, until
> the jbd2 transaction which creates the inode.  Also, if the new inode is a
> symlink, then fscrypt_encrypt_symlink() has to be called during the transaction.
> Together, these imply that fscrypt_get_encryption_info() has to be called during
> the transaction.
> 

Yes, similar problem. I started looking at symlinks today, and got a
little ways into a patchset to refactor some fscrypt code to handle
them, but I don't think it's quite right yet. A more general solution
would be nice.

> That's what we do, currently.  However, it's technically wrong and can deadlock,
> since fscrypt_get_encryption_info() isn't GFP_NOFS-safe (and it can't be).
> 
> f2fs appears to have a similar problem, though I'm still investigating.
> 
> To fix this, I'm planning to add new functions:
> 
>    - fscrypt_prepare_new_inode() will set up the fscrypt_info for a new
>      'struct inode' which hasn't necessarily had an inode number assigned yet.
>      It won't set the encryption xattr yet.
> 

I more or less have that in 02/14, I think, but if you have something
else in mind, I'm happy to follow suit.

>    - fscrypt_set_context() will set the encryption xattr, using the fscrypt_info
>      that fscrypt_prepare_new_inode() created earlier.  It will replace
>      fscrypt_inherit_context().
> 

Ok. I don't think we'll need that for ceph, generally as we'll want to
send the context so it can be attached atomically during the create.

> I'm working on my patches at
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=wip-fscrypt.
> They're not ready to send out yet, but I'll Cc you when I do.
> 

Thanks. I'll check them out.

> It seems there's still something a bit different that you need: you want
> fs/crypto/ to provide a buffer containing the encryption xattr (presumably
> because ceph needs to package it up into a single network request that creates
> the file?), instead of calling a function which then uses
> fscrypt_operations::set_context().  I could pretty easily handle that by adding
> a function that returns the xattr directly and would be an alternative to
> fscrypt_set_context().
> 

Exactly. We want to send the context with the create call.

> > Storing a binary crypttext filename on the MDS (or most network
> > fileservers) may be problematic. We'll probably end up having to base64
> > encode the names when storing them. I expect most network filesystems to
> > have similar issues. That may limit the effective NAME_MAX for some
> > filesystems [2].
> 
> I strongly recommend keeping support for the full NAME_MAX (255 bytes), if it's
> at all possible.  eCryptfs limited filenames to 143 bytes, which has
> historically caused lots of problems.  Try the following Google search to get a
> sense of the large number of users that have run into this limitation:
> https://www.google.com/search?q=ecryptfs+143+filename
> 

Absolutely. I don't think it'll be a problem with ceph as we have more
flexibility to change the protocol and underlying server
implementation. 

It would be really cool to weave this into NFS and CIFS/SMB eventually
too, but that might be more difficult as Linux has less control over
servers in the field, and most of them will cap out at 255 chars. Maybe
we could extend those protocols too though, if there were desire.

> > For content encryption, Ceph (and probably at least CIFS/SMB) will need
> > to deal with writes not aligned on crypto blocks. These filesystems
> > sometimes write synchronously to the server instead of going through the
> > pagecache [3].
> 
> I/O that isn't aligned to the "encryption data unit size" (which on the
> filesystems that currently support fscrypt, is the same thing as the
> "filesystem block size") isn't really possible unless it's buffered.  For
> AES-XTS specifically, *in principle* it's possible to encrypt/decrypt an
> individual 16-byte aligned region.  But Linux's crypto API doesn't currently
> support sub-message crypto, and also fscrypt supports the AES-CBC and Adiantum
> encryption modes which have stricter requirements.
> 
> So, I think that reads/writes to encrypted files will always need to go through
> the page cache.
> 

The ceph OSD protocol (which is the data path) can do cmpxchg-like
operations on an object. So, theoretically we can do a
read/modify/write, and the write would only work if the content hadn't
changed since the read. We'd then just redo the whole thing if there was
a conflicting change in the interim.

It'd be slow and would suck, but I think it would give us a correct
result. The good news is that usually the clients are granted the
capability to buffer up writes, at which point we can use the pagecache
like anything else. This would only be to ensure correctness in
contended cases.

> > Symlink handling in fscrypt will also need to be refactored a bit, as we
> > won't have an inode before we'll need to encrypt its contents.
> 
> Will there be an in-memory inode allocated yet (a 'struct inode'), just with no
> inode number assigned yet?  If so, my work-in-progress patchset I mentioned
> earlier should be sufficient to address this.  The order would be:
> 
> 	1. fscrypt_prepare_new_inode()
> 	2. fscrypt_encrypt_symlink()
> 	3. Assign inode number
> 
> 
> Or does ceph not have a 'struct inode' at all until step (3)?

No, generally ceph doesn't create an inode until the reply comes in. I
think we'll need to be able to create a context and encrypt the symlink
before we issue the call to the server. I started hacking at the fscrypt
code for this today, but I didn't get very far.

FWIW, ceph is a bit of an odd netfs protocol in that there is a standard
"trace" that holds info about dentries and inodes that are created or
modified as a result of an operation. Most of the dentry/inode cache
manipulation is done at that point, which is done as part of the reply
processing.

Thanks for the comments so far!
--
Jeff Layton <jlayton@kernel.org>

