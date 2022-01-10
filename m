Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF50488D88
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Jan 2022 01:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbiAJArl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jan 2022 19:47:41 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:34124 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiAJArk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jan 2022 19:47:40 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 4C9C872C905;
        Mon, 10 Jan 2022 03:47:38 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 347B04A46EA;
        Mon, 10 Jan 2022 03:47:38 +0300 (MSK)
Date:   Mon, 10 Jan 2022 03:47:38 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] fs-verity: define a function to return the
 integrity protected file digest
Message-ID: <20220110004738.kzhzyastvq5rn2g5@altlinux.org>
References: <20220109185517.312280-1-zohar@linux.ibm.com>
 <20220109185517.312280-3-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20220109185517.312280-3-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Mimi,

On Sun, Jan 09, 2022 at 01:55:13PM -0500, Mimi Zohar wrote:
> Define a function named fsverity_get_digest() to return the verity file
> digest and the associated hash algorithm (enum hash_algo).
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  fs/verity/Kconfig            |  1 +
>  fs/verity/fsverity_private.h |  7 -------
>  fs/verity/measure.c          | 40 ++++++++++++++++++++++++++++++++++++
>  include/linux/fsverity.h     | 18 ++++++++++++++++
>  4 files changed, 59 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/verity/measure.c b/fs/verity/measure.c
> index f0d7b30c62db..52906b2e5811 100644
> --- a/fs/verity/measure.c
> +++ b/fs/verity/measure.c
> @@ -57,3 +57,43 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(fsverity_ioctl_measure);
> +
> +/**
> + * fsverity_get_digest() - get a verity file's digest
> + * @inode: inode to get digest of
> + * @digest: (out) pointer to the digest
> + * @alg: (out) pointer to the hash algorithm enumeration
> + *
> + * Return the file hash algorithm and digest of an fsverity protected file.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int fsverity_get_digest(struct inode *inode,
> +			    u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
> +			    enum hash_algo *alg)
> +{
> +	const struct fsverity_info *vi;
> +	const struct fsverity_hash_alg *hash_alg;
> +	int i;
> +
> +	vi = fsverity_get_info(inode);
> +	if (!vi)
> +		return -ENODATA; /* not a verity file */
> +
> +	hash_alg = vi->tree_params.hash_alg;
> +	memset(digest, 0, FS_VERITY_MAX_DIGEST_SIZE);
> +	*alg = HASH_ALGO__LAST;

Perhaps this line is redundant (*alg is overwritten later) and would
needlessly mangle output value in case of -EINVAL while it's being
untouched on -ENODATA.

Thanks,

> +
> +	/* convert hash algorithm to hash_algo_name */
> +	i = match_string(hash_algo_name, HASH_ALGO__LAST, hash_alg->name);
> +	if (i < 0)
> +		return -EINVAL;
> +	*alg = i;
> +
> +	memcpy(digest, vi->file_digest, hash_alg->digest_size);
> +
> +	pr_debug("file digest %s:%*phN\n", hash_algo_name[*alg],
> +		  hash_digest_size[*alg], digest);
> +
> +	return 0;
> +}
