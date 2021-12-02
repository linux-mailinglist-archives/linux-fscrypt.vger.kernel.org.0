Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC539466BF9
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 23:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhLBWSc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 17:18:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56190 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhLBWSc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 17:18:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A9D762849;
        Thu,  2 Dec 2021 22:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F788C00446;
        Thu,  2 Dec 2021 22:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638483308;
        bh=KFPCchr4RdVJHXvFJ+rPkCdEx1z6KUKFMpCs0o/MV5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHEySldnLPW8S1ppgwOIN8JomdpbOTF203p+YQf5R4arPGIOeWFRnGJnClC86ADh5
         aslEIOEQbjIjbEswH02SDJ1FjXe4RUAkprSmIQaWFvwCodZLIdwYe/vET1NIt+oLq8
         zkEpFA6MfTx6foTpfdysFLAb6GF5D2dLBMlBVAhHKjYaksJdZBbYR3CixXOR47rhoJ
         FJH0bjlSWhVgcrBNONiSAGBu2UfkV4xblhptzITAEep1wpTdtPOgS54sIrfg1eKEfx
         HMPGuYhjIyr7CjzXDFT/9Bxmidpt1xt4NMrbR2j18Lc8S8gzAOAiFfuE0d63/B+i4C
         3YgryBWsyT/1A==
Date:   Thu, 2 Dec 2021 14:15:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/5] fs-verity: define a function to return the
 integrity protected file digest
Message-ID: <YalFa3eBR/8tp0AP@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
 <20211202215507.298415-2-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202215507.298415-2-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 02, 2021 at 04:55:03PM -0500, Mimi Zohar wrote:
> +
> +/**
> + * fsverity_collect_digest() - get a verity file's digest
> + * @inode: inode to get digest of
> + * @digest: (out) pointer to the digest
> + * @alg: (out) pointer to the hash algorithm enumeration
> + *
> + * Return the file hash algorithm and digest of an fsverity protected file.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int fsverity_collect_digest(struct inode *inode,
> +			    u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
> +			    enum hash_algo *alg)

I'd still prefer that this be named fsverity_get_digest(), but this is fine too.

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
> +
> +	/* convert hash algorithm to hash_algo_name */
> +	for (i = 0; i < HASH_ALGO__LAST; i++) {
> +		pr_debug("name %s hash_algo_name[%d] %s\n",
> +			  hash_alg->name, i, hash_algo_name[i]);
> +
> +		if (!strcmp(hash_alg->name, hash_algo_name[i])) {
> +			*alg = i;
> +			break;
> +		}
> +	}

How about using match_string() here?

> +	pr_debug("file digest:%s %*phN\n", hash_algo_name[*alg],
> +		  hash_digest_size[*alg], digest);

Other log messages in fs/verity/ use the format alg:hash.  How about using
"file_digest %s:%*phN\n" as the format string here?

- Eric
