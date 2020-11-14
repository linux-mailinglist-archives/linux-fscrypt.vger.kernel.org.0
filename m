Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064D12B29CD
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Nov 2020 01:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgKNAVa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 19:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgKNAVa (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 19:21:30 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A30CC2224D;
        Sat, 14 Nov 2020 00:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605313289;
        bh=xarAYXBQMqM2GYKvTu1K8cNYSkYtym/+spz0l/1TGWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L6Yun3hGzTMRJ7VA28LYsJQEMorz1uLYb/CtZj1N7ri6lNJI4L1almmoC1u2bYMIe
         2obrQBCirgnnvHHaXWfKU+w6aUUP4aKIR6sT/hHKPx2ApNFPXviQ9HJ6kMqGrKk9gc
         79ibSpt17/l9psxy5WNIIP70qG35d8KFe8Gp9uS8=
Date:   Fri, 13 Nov 2020 16:21:28 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [fsverity-utils RFC PATCH] Add libfsverity_enable() API
Message-ID: <X68jCECcvkXs5VWf@sol.localdomain>
References: <20201113143527.1097499-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113143527.1097499-1-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 13, 2020 at 02:35:27PM +0000, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> Factor out the 'fsverity enable' implementation in the library, to
> give users a shortcut for reading signatures and enabling a file
> with the default parameters.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> ---
> Marked as RFC to get guidance on how to deal with helper functions
> duplication, that right now are part of the "programs" utility objects
> and not usable from the "library" objects.
> There's dozens of different ways to handle this, all equally valid, so
> it's down to the preference of the maintainer (eg: new common helpers,
> include helpers at build time, further splits of sources, etc).
> Please provide a preference and I'll follow up.
> 
>  common/common_defs.h  |   9 ++
>  include/libfsverity.h |  21 +++++
>  lib/enable.c          | 191 ++++++++++++++++++++++++++++++++++++++++++
>  programs/cmd_enable.c |  66 ++-------------
>  programs/fsverity.h   |   9 --
>  5 files changed, 227 insertions(+), 69 deletions(-)
>  create mode 100644 lib/enable.c
> 
> diff --git a/common/common_defs.h b/common/common_defs.h
> index 279385a..871db2c 100644
> --- a/common/common_defs.h
> +++ b/common/common_defs.h
> @@ -90,4 +90,13 @@ static inline int ilog2(unsigned long n)
>  #  define le64_to_cpu(v)	(__builtin_bswap64((__force u64)(v)))
>  #endif
>  
> +/* The hash algorithm that 'fsverity' assumes when none is specified */
> +#define FS_VERITY_HASH_ALG_DEFAULT	FS_VERITY_HASH_ALG_SHA256
> +
> +/*
> + * Largest digest size among all hash algorithms supported by fs-verity.
> + * This can be increased if needed.
> + */
> +#define FS_VERITY_MAX_DIGEST_SIZE	64
> +
>  #endif /* COMMON_COMMON_DEFS_H */
> diff --git a/include/libfsverity.h b/include/libfsverity.h
> index 8f78a13..8d1f93b 100644
> --- a/include/libfsverity.h
> +++ b/include/libfsverity.h
> @@ -112,6 +112,27 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
>  			const struct libfsverity_signature_params *sig_params,
>  			uint8_t **sig_ret, size_t *sig_size_ret);
>  
> +/**
> + * libfsverity_enable() - Enable fs-verity on a file
> + *          An fsverity_digest (also called a "file measurement") is the root of
> + *          a file's Merkle tree.  Not to be confused with a traditional file
> + *          digest computed over the entire file.
> + * @file: path to the file to enable
> + * @signature: (optional) path to signature for @file
> + * @params: struct libfsverity_merkle_tree_params specifying the fs-verity
> + *	    version, the hash algorithm, the block size, and
> + *	    optionally a salt.  Reserved fields must be zero.
> + *      All fields bar the version are optional, and defaults will be used
> + *      if set to zero.
> + *
> + * Returns:
> + * * 0 for success, -EINVAL for invalid input arguments, or a generic error
> + *   if the FS_IOC_ENABLE_VERITY ioctl fails.
> + */
> +int
> +libfsverity_enable(const char *file, const char *signature,
> +			struct libfsverity_merkle_tree_params *params);
> +
>  /**
>   * libfsverity_find_hash_alg_by_name() - Find hash algorithm by name
>   * @name: Pointer to name of hash algorithm

Hi Luca, can you consider
https://lkml.kernel.org/linux-fscrypt/20201114001529.185751-1-ebiggers@kernel.org/T/#u
instead?

It's somewhat useful to have a wrapper around FS_IOC_ENABLE_VERITY that takes
'struct libfsverity_merkle_tree_params', so that library users can deal with one
common struct.  (And I took advantage of that to simplify the code that parses
the parameters.)

But I think we should keep it as a thin wrapper, and not have file path
parameters or set defaults in the libfsverity_merkle_tree_params.  The library
user is better suited to deal with those, like they already do for
libfsverity_compute_digest().

- Eric
