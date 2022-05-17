Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE3252AE5E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 May 2022 01:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiEQXDv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 May 2022 19:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiEQXDv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 May 2022 19:03:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC5853A4E
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 May 2022 16:03:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83635613F5
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 May 2022 23:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F75C385B8;
        Tue, 17 May 2022 23:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652828628;
        bh=c2gTE6qjNsGKwxnddLQGQ4NQLPFitrPBL+slppyj0eo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tEGClbjmZGhNhqKahc04LS6OGAM92cNnxlWwSxnxOfaODFZEiLM8fTlYzFvZSuIGW
         H8AhuAjVU2obtiOx1jaeaPDYQpfB03cEB2uOnde8X+5BvF1+E1uNFGkF4seGjoApb0
         jx4kv82oR7r3t5zGcYm811hjxk+3PPPwLNDIJ7Wf1swwKzN4Gmc84seoF0FawPpRTi
         TLzN4rReJC/nijlu87EIHjzoL2JxWkTRlqzER3oRVxR3g8X0uyCCoyX9jiRzvmdNIb
         Qhn4C3PRsNJmMUUnRYvie56c9Rka+hmk7TU3aGgxtZkX7CUvsG3wV0QH7gtc3Sog42
         w+a1owPyIB5kw==
Date:   Tue, 17 May 2022 16:03:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 2/2] fsverity: add mode sysctl
Message-ID: <YoQp0+g+sLxSe8dk@sol.localdomain>
References: <cover.1651184207.git.boris@bur.io>
 <70ca249017356383ed420b8213713309b8d15d0f.1651184207.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70ca249017356383ed420b8213713309b8d15d0f.1651184207.git.boris@bur.io>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Sorry for the slow review.  Some comments:

On Thu, Apr 28, 2022 at 03:19:20PM -0700, Boris Burkov wrote:
> Add a "mode" sysctl to act as a killswitch for fs-verity. The motivation
> is that in case there is an unforeseen performance regression or bug in
> verity as one attempts to use it in production, being able to disable it
> live gives a lot of peace of mind. One could also run in audit mode for
> a while before switching to the enforcing mode.
> 
> The modes are:
> disable: verity has no effect, even if configured or used
> audit: run the verity logic, permit ioctls, but only log on failures
> enforce: fully enabled; the default and the behavior before this patch
> 
> This also precipitated re-organizing sysctls for verity as previously
> the only sysctl was for signatures so sysctls and signatures were
> coupled.
> 
> One slightly subtle issue is what errors should "audit" swallow.
> Certainly verification or signature errors, but there is a slippery
> slope leading to inconsistent states with half set up verity if you try
> to ignore errors in enabling verity on a file. The intent of audit mode
> is to still fail normally in verity specific ioctls, but to leave the
> file be from the perspective of normal filesystem APIs. However, we must
> still disallow writes in audit mode, or else it would immediately lead
> to invalid verity state.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/verity/enable.c           |  3 ++
>  fs/verity/fsverity_private.h | 10 ++++++
>  fs/verity/measure.c          |  3 ++
>  fs/verity/open.c             | 14 +++++++--
>  fs/verity/read_metadata.c    |  3 ++
>  fs/verity/signature.c        | 14 +++++++--
>  fs/verity/sysctl.c           | 59 ++++++++++++++++++++++++++++++++++++
>  fs/verity/verify.c           | 34 +++++++++++++++++++--
>  include/linux/fsverity.h     |  4 +--
>  9 files changed, 136 insertions(+), 8 deletions(-)

The new sysctl needs to be documented.

Also, the documentation for any ioctls that now can fail in a new way needs to
be updated.

Also, can you please Cc this to the filesystem mailing lists (ext4, f2fs, and
btrfs) too?  As this is a new UAPI, we need to make sure that enough people have
an opportunity to review it before it's set in stone.

> diff --git a/fs/verity/measure.c b/fs/verity/measure.c
> index f0d7b30c62db2..f17efaa919e37 100644
> --- a/fs/verity/measure.c
> +++ b/fs/verity/measure.c
> @@ -28,6 +28,9 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
>  	const struct fsverity_hash_alg *hash_alg;
>  	struct fsverity_digest arg;
>  
> +	if (fsverity_disabled())
> +		return -EPERM;
> +
>  	vi = fsverity_get_info(inode);
>  	if (!vi)
>  		return -ENODATA; /* not a verity file */

Perhaps the error code should be ENODATA, the same as the file not having
fs-verity enabled?  Would userspace ever have any reason to handle the cases
differently?

Also, shouldn't audit mode be handled the same way as disabled mode here?  The
whole point of using this ioctl is that it gives you the correct hash.  In audit
mode, it's not guaranteed to do that.

> diff --git a/fs/verity/open.c b/fs/verity/open.c
> index 92df87f5fa38..840ad62bf6ac 100644
> --- a/fs/verity/open.c
> +++ b/fs/verity/open.c
> @@ -177,7 +177,7 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
>  		fsverity_err(inode, "Error %d computing file digest", err);
>  		goto out;
>  	}
> -	pr_debug("Computed file digest: %s:%*phN\n",
> +	pr_info("Computed file digest: %s:%*phN\n",
>  		 vi->tree_params.hash_alg->name,
>  		 vi->tree_params.digest_size, vi->file_digest);

This would be far too noisy.

> @@ -353,7 +358,12 @@ int fsverity_file_open(struct inode *inode, struct file *filp)
>  		return -EPERM;
>  	}
>  
> -	return ensure_verity_info(inode);
> +	ret = ensure_verity_info(inode);
> +	if (!fsverity_enforced()) {
> +		fsverity_warn(inode, "AUDIT ONLY: ignore missing verity info");
> +		return 0;
> +	}
> +	return ret;

Is the above intended to check for failure of ensure_verity_info()?  That's not
what it does.  Also, the warning message is not going to be clear to anyone
reading it.  What does it mean, and if someone gets that warning message what
are they supposed to do about it?

> @@ -157,6 +157,9 @@ int fsverity_ioctl_read_metadata(struct file *filp, const void __user *uarg)
>  	int length;
>  	void __user *buf;
>  
> +	if (fsverity_disabled())
> +		return -EPERM;
> +
>  	vi = fsverity_get_info(inode);
>  	if (!vi)
>  		return -ENODATA; /* not a verity file */

As for FS_IOC_MEASURE_VERITY, perhaps the error code here should be ENODATA?

> diff --git a/fs/verity/signature.c b/fs/verity/signature.c
> index 67a471e4b570..b10515817d8a 100644
> --- a/fs/verity/signature.c
> +++ b/fs/verity/signature.c
> @@ -42,12 +42,18 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
>  	int err;
>  
>  	if (sig_size == 0) {
> +		err = 0;
>  		if (fsverity_require_signatures) {
>  			fsverity_err(inode,
>  				     "require_signatures=1, rejecting unsigned file!");
> -			return -EPERM;
> +			if (fsverity_enforced()) {
> +				err = -EPERM;
> +			} else {
> +				fsverity_warn(vi->inode, "AUDIT ONLY. ignore unsigned");
> +				err = 0;
> +			}
>  		}
> -		return 0;
> +		return err;
>  	}
>  
>  	d = kzalloc(sizeof(*d) + hash_alg->digest_size, GFP_KERNEL);
> @@ -75,6 +81,10 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
>  		else
>  			fsverity_err(inode, "Error %d verifying file signature",
>  				     err);
> +		if (!fsverity_enforced()) {
> +			fsverity_warn(vi->inode, "AUDIT ONLY. ignore signature error");
> +			err = 0;
> +		}
>  		return err;
>  	}

In "audit" mode these errors already get swallowed at a higher level in
fsverity_file_open().  So it's unclear what the above changes are intended for.

> @@ -98,8 +103,10 @@ static bool verify_page(struct inode *inode, const struct fsverity_info *vi,
>  	unsigned int hoffsets[FS_VERITY_MAX_LEVELS];
>  	int err;
>  
> -	if (WARN_ON_ONCE(!PageLocked(data_page) || PageUptodate(data_page)))
> -		return false;
> +	if (WARN_ON_ONCE(!PageLocked(data_page) || PageUptodate(data_page))) {
> +		err = -EINVAL;
> +		goto out;
> +	}

This change introduces an uninitialized variable bug, and otherwise has no
effect.

>  
>  	pr_debug_ratelimited("Verifying data page %lu...\n", index);
>  
> @@ -193,6 +200,8 @@ bool fsverity_verify_page(struct page *page)
>  	struct ahash_request *req;
>  	bool valid;
>  
> +	if (fsverity_disabled())
> +		return true;
>  	/* This allocation never fails, since it's mempool-backed. */
>  	req = fsverity_alloc_hash_request(vi->tree_params.hash_alg, GFP_NOFS);

Isn't this redundant with the check of fsverity_disabled() in fsverity_active()?

And if not, why doesn't fsverity_verify_bio() get this check too?

> +/**
> + * fsverity_active() - do reads from the inode need to go through fs-verity?
> + * @inode: inode to check
> + *
> + * This checks whether ->i_verity_info has been set.
> + *
> + * Filesystems call this from ->readahead() to check whether the pages need to
> + * be verified or not.  Don't use IS_VERITY() for this purpose; it's subject to
> + * a race condition where the file is being read concurrently with
> + * FS_IOC_ENABLE_VERITY completing.  (S_VERITY is set before ->i_verity_info.)
> + *
> + * Return: true if reads need to go through fs-verity, otherwise false
> + */

Please don't copy-and-paste long comments like this.  When a function has two
versions, a stub (!CONFIG_FS_VERITY) and a non-stub (CONFIG_FS_VERITY), to avoid
redundancy the comment should go above the non-stub version only.

> +bool fsverity_active(const struct inode *inode)
> +{
> +	if (fsverity_disabled())
> +		return false;
> +	return fsverity_get_info(inode) != NULL;
> +}
> +EXPORT_SYMBOL_GPL(fsverity_active);

Please add a comment that describes why the check of fsverity_get_info() alone
is not sufficient here.

- Eric
