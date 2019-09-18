Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A32AB5927
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Sep 2019 03:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfIRBBE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Sep 2019 21:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfIRBBE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Sep 2019 21:01:04 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C83120640;
        Wed, 18 Sep 2019 01:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568768463;
        bh=9fuLOK0CqBsG9RDwdyXhx3bH7OmlmAi5CxgMMLeTIJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OTSe8L31zjXFxnU6WUZ32x93j7cJmJVw2LZNw8rBjAfYtQ9fJs3bP+zU4kQotqvoq
         EqaxjSIrA3o+DXrmW7W1uxAAGvBxq3u7E4Isxxx1bB4Dm2Rk1kfeSXoJg7Oa1HbhJa
         qTTSU5r7VihGnL+vYJrnK7gTn1Kvr3SrJAVpGJCI=
Date:   Tue, 17 Sep 2019 18:01:01 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4] e2fsck: check for consistent encryption policies
Message-ID: <20190918010100.GA45382@gmail.com>
Mail-Followup-To: Andreas Dilger <adilger@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>
References: <20190909174310.182019-1-ebiggers@kernel.org>
 <2757ADAC-336F-4EC8-8DBF-2B9C61C196C4@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2757ADAC-336F-4EC8-8DBF-2B9C61C196C4@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 10, 2019 at 05:40:51PM -0600, Andreas Dilger wrote:
> > diff --git a/e2fsck/encrypted_files.c b/e2fsck/encrypted_files.c
> > new file mode 100644
> > index 00000000..3dc706a7
> > --- /dev/null
> > +++ b/e2fsck/encrypted_files.c
> > @@ -0,0 +1,368 @@
> > 
> > +/* A range of inodes which share the same encryption policy */
> > +struct encrypted_file_range {
> > +	ext2_ino_t		first_ino;
> > +	ext2_ino_t		last_ino;
> > +	__u32			policy_id;
> > +};
> 
> This seems like a clear win...  As long as we have at least two inodes
> in a row with the same policy ID it will take less space than the previous
> version of the patch.
> 
> > +static int handle_nomem(e2fsck_t ctx, struct problem_context *pctx)
> > +{
> > +	fix_problem(ctx, PR_1_ALLOCATE_ENCRYPTED_DIRLIST, pctx);
> > +	/* Should never get here */
> > +	ctx->flags |= E2F_FLAG_ABORT;
> > +	return 0;
> > +}
> 
> It would be useful if the error message for PR_1_ALLOCATE_ENCRYPTED_DIRLIST
> printed the actual allocation size that failed, so that the user has some
> idea of how much memory would be needed.  The underlying ext2fs_resize_mem()
> code doesn't print anything, just returns EXT2_ET_NO_MEMORY.
> 

Yes, I can make it print the number of bytes using %N.

> > +	if (info->file_ranges_count == info->file_ranges_capacity) {
> > +		/* Double the capacity by default. */
> > +		size_t new_capacity = info->file_ranges_capacity * 2;
> > +
> > +		/* ... but go from 0 to 128 right away. */
> > +		if (new_capacity < 128)
> > +			new_capacity = 128;
> > +
> > +		/* We won't need more than the filesystem's inode count. */
> > +		if (new_capacity > ctx->fs->super->s_inodes_count)
> > +			new_capacity = ctx->fs->super->s_inodes_count;
> > +
> > +		/* To be safe, ensure the capacity really increases. */
> > +		if (new_capacity < info->file_ranges_capacity + 1)
> > +			new_capacity = info->file_ranges_capacity + 1;
> 
> Not sure how this could happen (more inodes than s_inodes_count?), but
> better safe than sorry I guess?
> 

Either that, or an integer overflow.  It shouldn't really happen, but I think we
should have this check to be safe.

> > +		if (ext2fs_resize_mem(info->file_ranges_capacity *
> > +					sizeof(*range),
> > +				      new_capacity * sizeof(*range),
> > +				      &info->file_ranges) != 0)
> > +			return handle_nomem(ctx, pctx);
> 
> This is the only thing that gives me pause, potentially having a huge
> allocation, but I think the RLE encoding of entries and the fact we
> have overwhelmingly 64-bit CPUs means we could still run with swap
> (on an internal NVMe M.2 device) if really needed.  A problem to fix
> if it ever actually rears its head, so long as there is a decent error
> message printed.
> 
> > +/*
> > + * Find the ID of an inode's encryption policy, using the information saved
> > + * earlier.
> > + *
> > + * If the inode is encrypted, returns the policy ID or
> > + * UNRECOGNIZED_ENCRYPTION_POLICY.  Else, returns NO_ENCRYPTION_POLICY.
> > + */
> > +__u32 find_encryption_policy(e2fsck_t ctx, ext2_ino_t ino)
> > +{
> > +	const struct encrypted_file_info *info = ctx->encrypted_files;
> > +	size_t l, r;
> > +
> > +	if (info == NULL)
> > +		return NO_ENCRYPTION_POLICY;
> > +	l = 0;
> > +	r = info->file_ranges_count;
> > +	while (l < r) {
> > +		size_t m = l + (r - l) / 2;
> 
> Using the RLE encoding for the entries should also speed up searching
> here considerably.  In theory, for a single-user Android filesystem
> there might only be one or two entries here.  It would be interesting
> to run this on some of your filesystems to see what the average count
> of inodes per entry is.
> 

On a freshly reset Android device I'm seeing 58 ranges for 4705 encrypted
inodes, so it's not quite *that* good, but it still helps a lot.

Note that there are actually 4 encryption policies on a single-user Android
device: system device-encrypted, user device-encrypted, user
credential-encrypted, and (recently added) per-boot encrypted.

- Eric
