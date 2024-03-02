Return-Path: <linux-fscrypt+bounces-213-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE0C486F15B
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Mar 2024 17:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B2D61F22031
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Mar 2024 16:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E25A22EF3;
	Sat,  2 Mar 2024 16:37:25 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DDE1EB3C
	for <linux-fscrypt@vger.kernel.org>; Sat,  2 Mar 2024 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709397445; cv=none; b=VbO+QlLYKlYTJesFnrCeHPE6RXn+lOLcAlbgzuM6C+sJddS8DMz2HMYpqyfEOacL+K2iMN/58P/lpwgwRGBy703vWq2xyM9ik5dO3QgSaG6FOo7/jIHuPKggof+j8czGLgkiWHs2FqCcFDQ29fKfXzrLTp+EmJcBWCGbM0whWwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709397445; c=relaxed/simple;
	bh=9IC3fMEoEfXo3NNBOsCfC/33CDE0noCZBrsTmZNyk4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L6DsKwe52AmBH8VzZV48EbnUHF07ZHzmAzTpP/mIsrsRE4fFUvgldp4TTCxtS5WfLdiTOB/ee/T0jMM1/gcmP1VWuLExs+/ZgIOQPcrxZomsCs67GzITGtaChWKdCX4GPbwsHN6ovVxq+LZT/+0puzFOh7jZOtMAzfesTXMIXg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-69012259657so13964706d6.0
        for <linux-fscrypt@vger.kernel.org>; Sat, 02 Mar 2024 08:37:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709397441; x=1710002241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bU93HGrxoKEjIsJ9NGLvb4RDQbkWY7Y2iFs9PS//8I=;
        b=MALEGVTCRE4cCTVCnQm+G2Uj1HK1LNybSugDGoenThXDhuhnM9easIkOflNYfJIj0K
         7PBaF/oYoZsiMomJ6Z8Ds1drISzIK4EbaPMAjvrbzL4k53692xrntt5toVrFCWXsTCyf
         3UfkolglfvfTYIZUxkG48ZsQCvlh0+DbbmDv3FMY1H9JsJwYz7fsaNi7+u0aSFIOfw39
         rp8ZntJw/Y7bAWIrDrrhJ/nsfcw3C97ZXbR1r9qy/4w0P2WGV8aosUIMqgSE9+AZQGB9
         WadysBWFzOr6OcXKeciziq5FBTsCLWuPt4Kvznq6OGNcG0FSKspt3fudvWIoYpcuXtwF
         ujNw==
X-Forwarded-Encrypted: i=1; AJvYcCWOMU/7b/SW2OyQQEySwGImFap8VpVegTwaazjUUmgPHls7UnfJHqYEtkxNN0kjzF443sNDs2PZT19e/UpZF1apWu92IJu+fHIAhbzKSA==
X-Gm-Message-State: AOJu0YwYC1BVsniZLgtLMjvXq2yVkl9m3i/nojRAZu739H95hSQd6YGN
	FkGmwVK1iteoZMoT8bH/t/nPqnGitFpCYrnzZJ3C0s8Re7Nc2kGFizE/iWLcag==
X-Google-Smtp-Source: AGHT+IGWfJd4hsp4cquzrMgFaq/8ztZK/NQH0jQErvnt6KcdvzJSodCboJ3PnepuNNUxb0g3iW3fHA==
X-Received: by 2002:a0c:f885:0:b0:690:4916:4de9 with SMTP id u5-20020a0cf885000000b0069049164de9mr4614368qvn.34.1709397441567;
        Sat, 02 Mar 2024 08:37:21 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id ks30-20020a056214311e00b0068ffde5efb0sm3123189qvb.49.2024.03.02.08.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 08:37:21 -0800 (PST)
Date: Sat, 2 Mar 2024 11:37:20 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Fan Wu <wufan@linux.microsoft.com>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
	serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
	axboe@kernel.dk, agk@redhat.com, eparis@redhat.com,
	paul@paul-moore.com, linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v13 14/20] dm verity: consume root hash digest and
 signature data via LSM hook
Message-ID: <ZeNVwBkbw2HlMRfa@redhat.com>
References: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
 <1709168102-7677-15-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1709168102-7677-15-git-send-email-wufan@linux.microsoft.com>

On Wed, Feb 28 2024 at  7:54P -0500,
Fan Wu <wufan@linux.microsoft.com> wrote:

> From: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> dm-verity provides a strong guarantee of a block device's integrity. As
> a generic way to check the integrity of a block device, it provides
> those integrity guarantees to its higher layers, including the filesystem
> level.
> 
> An LSM that control access to a resource on the system based on the
> available integrity claims can use this transitive property of
> dm-verity, by querying the underlying block_device of a particular
> file.
> 
> The digest and signature information need to be stored in the block
> device to fulfill the next requirement of authorization via LSM policy.
> This will enable the LSM to perform revocation of devices that are still
> mounted, prohibiting execution of files that are no longer authorized
> by the LSM in question.
> 
> This patch added two security hook calls in dm-verity to save the
> dm-verity roothash and the roothash signature to the block device's
> LSM blobs. The hook calls are depended on CONFIG_IPE_PROP_DM_VERITY,
> which will be introduced in the next commit.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
>   + No Changes
> 
> v3:
>   + No changes
> 
> v4:
>   + No changes
> 
> v5:
>   + No changes
> 
> v6:
>   + Fix an improper cleanup that can result in
>     a leak
> 
> v7:
>   + Squash patch 08/12, 10/12 to [11/16]
>   + Use part0 for block_device, to retrieve the block_device, when
>     calling security_bdev_setsecurity
> 
> v8:
>   + Undo squash of 08/12, 10/12 - separating drivers/md/ from
>     security/ & block/
>   + Use common-audit function for dmverity_signature.
>   + Change implementation for storing the dm-verity digest to use the
>     newly introduced dm_verity_digest structure introduced in patch
>     14/20.
>   + Create new structure, dm_verity_digest, containing digest algorithm,
>     size, and digest itself to pass to the LSM layer. V7 was missing the
>     algorithm.
>   + Create an associated public header containing this new structure and
>     the key values for the LSM hook, specific to dm-verity.
>   + Additional information added to commit, discussing the layering of
>     the changes and how the information passed will be used.
> 
> v9:
>   + No changes
> 
> v10:
>   + No changes
> 
> v11:
>   + Add an optional field to save signature
>   + Move the security hook call to the new finalize hook
> 
> v12:
>   + No changes
> 
> v13:
>   + No changes
> ---
>  drivers/md/dm-verity-target.c | 71 +++++++++++++++++++++++++++++++++++
>  drivers/md/dm-verity.h        |  6 +++
>  include/linux/dm-verity.h     | 19 ++++++++++
>  3 files changed, 96 insertions(+)
>  create mode 100644 include/linux/dm-verity.h
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index a99ef30e45ca..e7bc6afae708 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -13,6 +13,7 @@
>   * access behavior.
>   */
>  
> +#include "dm-core.h"
>  #include "dm-verity.h"
>  #include "dm-verity-fec.h"
>  #include "dm-verity-verify-sig.h"

Why are you including dm-core.h? (DM targets really shouldn't need it).

And from that header:

/*
 * DM core internal structures used directly by dm.c, dm-rq.c and dm-table.c.
 * DM targets must _not_ deference a mapped_device or dm_table to directly
 * access their members!
 */

> @@ -22,6 +23,9 @@
>  #include <linux/scatterlist.h>
>  #include <linux/string.h>
>  #include <linux/jump_label.h>
> +#include <linux/security.h>
> +#include <linux/dm-verity.h>
> +#include <crypto/hash_info.h>
>  
>  #define DM_MSG_PREFIX			"verity"
>  
> @@ -990,6 +994,17 @@ static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  	blk_limits_io_min(limits, limits->logical_block_size);
>  }
>  
> +#ifdef CONFIG_IPE_PROP_DM_VERITY
> +static void verity_free_sig(struct dm_verity *v)
> +{
> +	kfree(v->root_digest_sig);
> +}
> +#else
> +static inline void verity_free_sig(struct dm_verity *v)
> +{
> +}
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> +
>  static void verity_dtr(struct dm_target *ti)
>  {
>  	struct dm_verity *v = ti->private;
> @@ -1008,6 +1023,7 @@ static void verity_dtr(struct dm_target *ti)
>  	kfree(v->salt);
>  	kfree(v->root_digest);
>  	kfree(v->zero_digest);
> +	verity_free_sig(v);
>  
>  	if (v->tfm)
>  		crypto_free_ahash(v->tfm);
> @@ -1199,6 +1215,25 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
>  	return r;
>  }
>  
> +#ifdef CONFIG_IPE_PROP_DM_VERITY
> +static int verity_init_sig(struct dm_verity *v, const void *sig,
> +			   size_t sig_size)
> +{
> +	v->sig_size = sig_size;
> +	v->root_digest_sig = kmalloc(v->sig_size, GFP_KERNEL);
> +	if (!v->root_digest)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +#else
> +static inline int verity_init_sig(struct dm_verity *v, const void *sig,
> +				  size_t sig_size)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> +
>  /*
>   * Target parameters:
>   *	<version>	The current format is version 1.
> @@ -1407,6 +1442,13 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  		ti->error = "Root hash verification failed";
>  		goto bad;
>  	}
> +
> +	r = verity_init_sig(v, verify_args.sig, verify_args.sig_size);
> +	if (r < 0) {
> +		ti->error = "Cannot allocate root digest signature";
> +		goto bad;
> +	}
> +
>  	v->hash_per_block_bits =
>  		__fls((1 << v->hash_dev_block_bits) / v->digest_size);
>  
> @@ -1557,6 +1599,32 @@ int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned i
>  	return 0;
>  }
>  
> +#ifdef CONFIG_IPE_PROP_DM_VERITY
> +static int verity_finalize(struct dm_target *ti)
> +{
> +	struct block_device *bdev;
> +	struct dm_verity_digest root_digest;
> +	struct dm_verity *v;
> +	int r;
> +
> +	v = ti->private;
> +	bdev = dm_table_get_md(ti->table)->disk->part0;

Must be for dereferencing mapped_device struct here ^

Please remove the dm-core.h include and use this instead:

struct gendisk *disk = dm_disk(dm_table_get_md(ti->table));

Mike

> +	root_digest.digest = v->root_digest;
> +	root_digest.digest_len = v->digest_size;
> +	root_digest.alg = v->alg_name;
> +
> +	r = security_bdev_setsecurity(bdev, DM_VERITY_ROOTHASH_SEC_NAME, &root_digest,
> +				      sizeof(root_digest));
> +	if (r)
> +		return r;
> +
> +	return security_bdev_setsecurity(bdev,
> +					 DM_VERITY_SIGNATURE_SEC_NAME,
> +					 v->root_digest_sig,
> +					 v->sig_size);
> +}
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> +
>  static struct target_type verity_target = {
>  	.name		= "verity",
>  	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,

