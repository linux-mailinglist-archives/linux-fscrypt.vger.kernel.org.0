Return-Path: <linux-fscrypt+bounces-206-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6FF86BFF8
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 05:46:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84268287D52
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 04:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC2039840;
	Thu, 29 Feb 2024 04:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I0SfIz6K"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F1638F80;
	Thu, 29 Feb 2024 04:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709181988; cv=none; b=BQLfsatGnFvgOB4ky7BC2ICZKC6z2lwiu+rNTcZHuu/TZ2EnefvnK++8SegPwscKM5jVs1KGyCMCYBgOV1WY6n31CvznpBr4ZpDJMd+T8nMpX+NmRraiXWgjS1LPEmmyUG2ooJPqnhRVOzeC2JqZoE5QkuoA5xNSvAOp7JTz/g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709181988; c=relaxed/simple;
	bh=G615x2fPETkC6k8ewYPfYhknWUlajYkHMppEN+Pscsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o3789GLX/Y5YoaEqTls+PFvjdb/VOg0mhBlCy2a3i1OwAqztxHhj656cJgkWqQ9yDZaWhvvHZBqvglpdFK5H06ZRcQWFUJPfcVSmY5ezRBOGhxuLUPfIG0hE5OMAdRLqlVcHTyWrgMvxYWzf05QbQaGHq/S2z1BKeBDZi0Ni0GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I0SfIz6K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723F2C433C7;
	Thu, 29 Feb 2024 04:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709181988;
	bh=G615x2fPETkC6k8ewYPfYhknWUlajYkHMppEN+Pscsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I0SfIz6K4eWboYPJOn9QHUR9jcspDY0b9JguNlXodaayrm9xfqHOcEeY/fJfposd3
	 V8r1gYbc8BJCo8zKx1EsIvKX6/RPT848BpEU2DP+eEv7Qt4Z46DEsLojDaKwEnPN8m
	 wGp82+pjV8TU0IhG7W56CnPbV+7b+BPDIDbvmrWgXs1AeGWCYzVJ7JAM7HsfNdMB1s
	 vzOb1/oCpJER2nuxDKX/t2FTZppQm9NocVloRX8bIAGRt9cjYU5h7gT+M5KbVMiELY
	 9MKr7Y4dHClV+1ImFEhmA8MujCP60bPtXA8kI3Hv/gJ0oP+/dlLS8xUwST5T5gUuo8
	 f95kSrKe/18PQ==
Date: Wed, 28 Feb 2024 20:46:25 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Fan Wu <wufan@linux.microsoft.com>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
	serge@hallyn.com, tytso@mit.edu, axboe@kernel.dk, agk@redhat.com,
	snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com,
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v13 17/20] ipe: enable support for fs-verity as a
 trust provider
Message-ID: <20240229044625.GA1946@sol.localdomain>
References: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
 <1709168102-7677-18-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1709168102-7677-18-git-send-email-wufan@linux.microsoft.com>

On Wed, Feb 28, 2024 at 04:54:59PM -0800, Fan Wu wrote:
> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> index f5190a1347a6..ca1573ff21b7 100644
> --- a/security/ipe/hooks.c
> +++ b/security/ipe/hooks.c
> @@ -254,3 +254,33 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
>  	return -EOPNOTSUPP;
>  }
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
> +
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +/**
> + * ipe_inode_setsecurity - Sets fields of a inode security blob from @key.
> + * @inode: The inode to source the security blob from.
> + * @name: The name representing the information to be stored.
> + * @value: The value to be stored.
> + * @size: The size of @value.
> + * @flags: unused
> + *
> + * Saves fsverity signature & digest into inode security blob
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Error
> + */
> +int ipe_inode_setsecurity(struct inode *inode, const char *name,
> +			  const void *value, size_t size,
> +			  int flags)
> +{
> +	struct ipe_inode *inode_sec = ipe_inode(inode);
> +
> +	if (!strcmp(name, FS_VERITY_INODE_SEC_NAME)) {
> +		inode_sec->fs_verity_signed = size > 0 && value;
> +		return 0;
> +	}
> +
> +	return -EOPNOTSUPP;
> +}

So IPE is interested in whether a file has an fsverity builtin signature, but it
doesn't care what the signature is or whether it has been checked.  What is the
point?

- Eric

