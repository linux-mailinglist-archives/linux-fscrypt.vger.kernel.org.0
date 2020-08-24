Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC0624FD66
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Aug 2020 14:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgHXMDi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Aug 2020 08:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgHXMDh (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Aug 2020 08:03:37 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E2802078A;
        Mon, 24 Aug 2020 12:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598270616;
        bh=/Tb+ArrQHcS4vh1LkPsPPiAjq3j5hYjlAjQCAJ7xVTo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PcBEhZplynFwwXd8pPOEgQbs7NZuzEJYhwyqxwnc3MxGrYjZPIZsZCWEjE/UndXvV
         3melJugZCQAzPGy2ybyiRP8h7O+s5xT6KubHlZHC8TKaosYy8WrDDcB/7KwOKFrZwv
         /eNw1kbP/szRo3PUSZl8eUc6yN5C6iJuIN5nbuk0=
Message-ID: <a33884434b772ad6d4393a591ff80bf0beb863d8.camel@kernel.org>
Subject: Re: [RFC PATCH 00/14] ceph+fscrypt: together at last (contexts and
 filenames)
From:   Jeff Layton <jlayton@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Date:   Mon, 24 Aug 2020 08:03:35 -0400
In-Reply-To: <20200822023440.GD834@sol.localdomain>
References: <20200821182813.52570-1-jlayton@kernel.org>
         <20200822002301.GA834@sol.localdomain>
         <2a6b92f25325fa95164f418c669883f73a291b77.camel@kernel.org>
         <20200822023440.GD834@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 2020-08-21 at 19:34 -0700, Eric Biggers wrote:
> On Fri, Aug 21, 2020 at 08:58:35PM -0400, Jeff Layton wrote:
> > > > Ceph (and most other netfs') will need to pre-create a crypto context
> > > > when creating a new inode as we'll need to encrypt some things before we
> > > > have an inode. This patchset stores contexts in an xattr, but that's
> > > > probably not ideal for the final implementation [1].
> > > 
> > > Coincidentally, I've currently working on solving a similar problem.  On ext4,
> > > the inode number can't be assigned, and the encryption xattr can't be set, until
> > > the jbd2 transaction which creates the inode.  Also, if the new inode is a
> > > symlink, then fscrypt_encrypt_symlink() has to be called during the transaction.
> > > Together, these imply that fscrypt_get_encryption_info() has to be called during
> > > the transaction.
> > > 
> > 
> > Yes, similar problem. I started looking at symlinks today, and got a
> > little ways into a patchset to refactor some fscrypt code to handle
> > them, but I don't think it's quite right yet. A more general solution
> > would be nice.
> > 
> > > That's what we do, currently.  However, it's technically wrong and can deadlock,
> > > since fscrypt_get_encryption_info() isn't GFP_NOFS-safe (and it can't be).
> > > 
> > > f2fs appears to have a similar problem, though I'm still investigating.
> > > 
> > > To fix this, I'm planning to add new functions:
> > > 
> > >    - fscrypt_prepare_new_inode() will set up the fscrypt_info for a new
> > >      'struct inode' which hasn't necessarily had an inode number assigned yet.
> > >      It won't set the encryption xattr yet.
> > > 
> > 
> > I more or less have that in 02/14, I think, but if you have something
> > else in mind, I'm happy to follow suit.
> [...]
> > > > Symlink handling in fscrypt will also need to be refactored a bit, as we
> > > > won't have an inode before we'll need to encrypt its contents.
> > > 
> > > Will there be an in-memory inode allocated yet (a 'struct inode'), just with no
> > > inode number assigned yet?  If so, my work-in-progress patchset I mentioned
> > > earlier should be sufficient to address this.  The order would be:
> > > 
> > > 	1. fscrypt_prepare_new_inode()
> > > 	2. fscrypt_encrypt_symlink()
> > > 	3. Assign inode number
> > > 
> > > 
> > > Or does ceph not have a 'struct inode' at all until step (3)?
> > 
> > No, generally ceph doesn't create an inode until the reply comes in. I
> > think we'll need to be able to create a context and encrypt the symlink
> > before we issue the call to the server. I started hacking at the fscrypt
> > code for this today, but I didn't get very far.
> > 
> > FWIW, ceph is a bit of an odd netfs protocol in that there is a standard
> > "trace" that holds info about dentries and inodes that are created or
> > modified as a result of an operation. Most of the dentry/inode cache
> > manipulation is done at that point, which is done as part of the reply
> > processing.
> 
> Your patch "fscrypt: add fscrypt_new_context_from_parent" takes in a directory
> and generates an fscrypt_context (a.k.a. an encryption xattr) for a new file
> that will be created in that directory.
> 
> fscrypt_prepare_new_inode() from my work-in-progress patches would do a bit more
> than that.  It would actually set up a "struct fscrypt_info" for a new inode.
> That includes the encryption key and all information needed to build the
> fscrypt_context.  So, afterwards it will be possible to call
> fscrypt_encrypt_symlink() before the fscrypt_context is "saved to disk".
> IIUC, that's part of what ceph will need.
> 
> The catch is that there will still have to be a 'struct inode' to associate the
> 'struct fscrypt_info' with.  It won't have to have ->i_ino set yet, but some
> other fields (at least ->i_mode and ->i_sb) will have to be set, since lots of
> code in fs/crypto/ uses those fields.
> 
> I think it would be possible to refactor things to make 'struct fscrypt_info'
> more separate from 'struct inode', so that filesystems could create a
> 'struct fscrypt_info' that isn't associated with an inode yet, then encrypt a
> symlink target using it (not caching it in ->i_link as we currently do).
> 
> However, it would require a lot of changes.
> 
> So I'm wondering if it would be easier to instead change ceph to create and
> start initializing the 'struct inode' earlier.  It doesn't have to have an inode
> number assigned or be added to the inode cache yet; it just needs to be
> allocated in memory and some basic fields need to be initialized.  In theory
> it's possible, right?  I'd expect that local filesystems aren't even that much
> different, in principle; they start initializing a new 'struct inode' in memory
> first, and only later do they *really* create the inode by allocating an inode
> number and saving the changes to disk.
> 

It's probably possible. I think we'd just need to attach the nascent
inode to the MDS request tracking structure, and convert that from using
iget5_locked to inode_insert5.

Would we need to do this for all inode types or just symlinks?
-- 
Jeff Layton <jlayton@kernel.org>

