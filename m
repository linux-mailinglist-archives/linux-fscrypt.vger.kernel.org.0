Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46BF46ECDA
	for <lists+linux-fscrypt@lfdr.de>; Sat, 20 Jul 2019 01:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbfGSX64 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 19 Jul 2019 19:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728939AbfGSX64 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 19 Jul 2019 19:58:56 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D03312082C;
        Fri, 19 Jul 2019 23:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563580734;
        bh=/yQ3KgpojU3ziG6gyfMBQPn0/dM7OGlR/vkzzBpZDLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vaq0qaI2PjsMhiNDDLgBN5HDftymwCMG216s/gv4fibRzAqgavsquOgPYRlENECEO
         fR30KuVerIT8tiFhTGx5mYofnnx4O6E0iDNKQxh40sMDgGMA9ONGfsrEppbeRx07M5
         swBb3fscCX0Y86vrO0fBI/VN5jp5JKjyTPuxYrcU=
Date:   Fri, 19 Jul 2019 16:58:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] e2fsck: check for consistent encryption policies
Message-ID: <20190719235852.GI1422@gmail.com>
Mail-Followup-To: Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org
References: <20190718011325.19516-1-ebiggers@kernel.org>
 <D9B442DB-51C2-4AAC-8113-AE462E7DA637@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D9B442DB-51C2-4AAC-8113-AE462E7DA637@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 18, 2019 at 12:25:42AM -0600, Andreas Dilger wrote:
> On Jul 17, 2019, at 7:13 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > By design, the kernel enforces that all files in an encrypted directory
> > use the same encryption policy as the directory.  It's not possible to
> > violate this constraint using syscalls.  Lookups of files that violate
> > this constraint also fail, in case the disk was manipulated.
> > 
> > But this constraint can also be violated by accidental filesystem
> > corruption.  E.g., a power cut when using ext4 without a journal might
> > leave new files without the encryption bit and/or xattr.  Thus, it's
> > important that e2fsck correct this condition.
> > 
> > Therefore, this patch makes the following changes to e2fsck:
> > 
> > - During pass 1 (inode table scan), create a map from inode number to
> >  encryption xattr for all encrypted inodes.  If an encrypted inode has
> >  a missing or clearly invalid xattr, offer to clear the inode.
> > 
> > - During pass 2 (directory structure check), verify that all regular
> >  files, directories, and symlinks in encrypted directories use the
> >  directory's encryption policy.  Offer to clear any directory entries
> >  for which this isn't the case.
> > 
> > Add a new test "f_bad_encryption" to test the new behavior.
> > 
> > Due to the new checks, it was also necessary to update the existing test
> > "f_short_encrypted_dirent" to add an encryption xattr to the test file,
> > since it was missing one before, which is now considered invalid.
> > 
> > Google-Bug-Id: 135138675
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> > diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> > index 2d359b38..10dcb582 100644
> > --- a/e2fsck/e2fsck.h
> > +++ b/e2fsck/e2fsck.h
> > @@ -135,6 +135,22 @@ struct dx_dirblock_info {
> > #define DX_FLAG_FIRST		4
> > #define DX_FLAG_LAST		8
> > 
> > +/*
> > + * The encrypted file information structure; stores information for files which
> > + * are encrypted.
> > + */
> > +struct encrypted_file {
> > +	ext2_ino_t ino;
> > +	void *xattr_value;
> > +	size_t xattr_size;
> > +};
> 
> This structure is pretty memory inefficient.  4 byte ino, 8 bytes pointer, then a
> 8 byte size. I don't think that we need a full size_t to store a valid xattr size,
> given that is limited to 64KB currently, while size_t is an unsigned long.
> 
> It would save 8 bytes per inode to rearrange these,

Yes, it can be reduced to 16 bytes.  Probably we should go with the 8 bytes
(ino, id) as you suggested elsewhere, though.

> and add a unique prefix to make
> the fields easier to find:
> 
> struct e2fsck_encrypted_file {
> 	ext2_ino_t   eef_ino;
> 	unsigned int eef_xattr_size;
> 	void        *eef_xattr_value;
> };
> 
> > +struct encrypted_files {
> > +	size_t count;
> > +	size_t capacity;
> > +	struct encrypted_file *files;
> > +};
> 
> Searching for "encrypted_file" vs. "encrypted_files" is not great.  Maybe
> "e2fsck_encrypted_(file_)list" or "e2fsck_encrypted_(file_)array"?  As above,
> better to have a prefix for these structure fields, like "eel_" or "eea_".

I can change it to *_file_list.  However, did you see that all the other structs
in e2fsck/e2fsck.h besides e2fsck_struct already have names like:

	struct dir_info
	struct dx_dir_info
	struct dx_dirblock_info
	struct resource_track
	struct ea_refcount
	struct extent_tree_level
	struct extent_tree_info

So for consistency, I'm not sure the "e2fsck_" prefix is warranted.

> 
> > +int add_encrypted_file(e2fsck_t ctx, struct problem_context *pctx)
> > +{
> > +	pctx->errcode = get_encryption_xattr(ctx, ino, &file->xattr_value,
> > +					     &file->xattr_size);
> > +	if (pctx->errcode) {
> > +		if (fix_problem(ctx, PR_1_MISSING_ENCRYPTION_XATTR, pctx))
> > +			return -1;
> 
> At this point, you don't really know if the inode _should_ be encrypted,
> or if it is a stray bit flip in the EXT4_ENCRYPT_STATE that resulted in
> add_encrypted_file being called.  This results in the inode being deleted,
> even though it is possible that it was never encrypted.  This determination
> should be made later when the inode's parent directory is known.  Either
> the parent also has an encryption flag+xattr and it _should_ have been
> encrypted and should be cleared, or the parent doesn't have an encryption
> flag+xattr and only the child inode flag should be cleared...

How about simply clearing the encrypt flag instead in this case?

That does the right thing in the bit flip case.  It also does the right thing
when the file is in an encrypted directory (so it's supposed to be encrypted),
as then the file will be deleted during the encryption policy check in pass 2
due to PR_2_UNENCRYPTED_FILE.

It wouldn't properly handle the rare case where a new encryption policy was just
set on a top level directory, and encrypted entries were already created in it
before the encryption xattr was persisted.  The directory would be marked as
unencrypted, not deleted as expected.  Though this should be a really rare case,
and hard to distinguish from a bitflip anyway, so probably not worth worrying
about...  (And it could also go the other way: xattr was persisted but not the
encrypt flag, which would be inconvenient to check for.)

> 
> > +	} else if (!possibly_valid_encryption_xattr(file->xattr_value,
> > +						    file->xattr_size)) {
> > +		ext2fs_free_mem(&file->xattr_value);
> > +		file->xattr_size = 0;
> > +		if (fix_problem(ctx, PR_1_CORRUPT_ENCRYPTION_XATTR, pctx))
> > +			return -1;
> > +	}
> 
> 
> I can see in this case, where the inode is flagged and the encryption xattr
> exists (named "c" if I read correctly?), but is corrupt, then there isn't
> much to do for the file.
> 
> > @@ -1415,18 +1478,21 @@ skip_checksum:
> > 			}
> > 
> > -		if (encrypted && (dot_state) > 1 &&
> > -		    encrypted_check_name(ctx, dirent, &cd->pctx)) {
> 
> No need for () around "dot_state".

This patch actually removes those unnecessary ().

- Eric
