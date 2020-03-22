Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B591018E6B8
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Mar 2020 06:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgCVFiF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 22 Mar 2020 01:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgCVFiE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 22 Mar 2020 01:38:04 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED0FA20722;
        Sun, 22 Mar 2020 05:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584855484;
        bh=PJ8K404/Sb2gH7ztPU2Mn0pmZzwW6e/zNoO0EswmgQY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y42Uq5kg2W8acYm870/XLr/vJrU5VFPML1QuqJcOdk6yFT2DIn30IkEvQBGqGqomU
         m70/kzGcy7IufjJvhcwoSENh6qwYdOvw3xsY9pTmyRAzeTT9NzX70kcUOQM9tOAc8j
         biOydO/WMyXzNR4vZyKg+WyVWGyvileuBuXBl4qQ=
Date:   Sat, 21 Mar 2020 22:38:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 4/9] Move hash algorithm code to shared library
Message-ID: <20200322053802.GH111151@sol.localdomain>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
 <20200312214758.343212-5-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312214758.343212-5-Jes.Sorensen@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 12, 2020 at 05:47:53PM -0400, Jes Sorensen wrote:
> diff --git a/libfsverity.h b/libfsverity.h
> index 396a6ee..318dcd7 100644
> --- a/libfsverity.h
> +++ b/libfsverity.h
> @@ -18,6 +18,9 @@
>  #define FS_VERITY_HASH_ALG_SHA256       1
>  #define FS_VERITY_HASH_ALG_SHA512       2
>  
> +/* The hash algorithm that fsverity-utils assumes when none is specified */
> +#define FS_VERITY_HASH_ALG_DEFAULT	FS_VERITY_HASH_ALG_SHA256
> +
>  struct libfsverity_merkle_tree_params {
>  	uint16_t version;
>  	uint16_t hash_algorithm;	/* Matches the digest_algorithm type */
> @@ -27,6 +30,12 @@ struct libfsverity_merkle_tree_params {
>  	uint64_t reserved[11];
>  };
>  
> +/*
> + * Largest digest size among all hash algorithms supported by fs-verity.
> + * This can be increased if needed.
> + */
> +#define FS_VERITY_MAX_DIGEST_SIZE	64
> +
>  struct libfsverity_digest {
>  	char magic[8];			/* must be "FSVerity" */
>  	uint16_t digest_algorithm;
> @@ -57,9 +66,22 @@ struct fsverity_descriptor {
>  	uint8_t signature[];	/* optional PKCS#7 signature */
>  };
>  
> +struct fsverity_hash_alg {
> +	const char *name;
> +	unsigned int digest_size;
> +	unsigned int block_size;
> +	uint16_t hash_num;
> +	struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
> +};
> +

It's still a bit weird to have struct fsverity_hash_alg as part of the library
API, since the .create_ctx() member is for internal library use only.  We at
least need to clearly comment this:

	struct fsverity_hash_alg {
		const char *name;
		unsigned int digest_size;
		unsigned int block_size;
		uint16_t hash_num;

		/* for library-internal use only */
		struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
	};

But ideally there would be nothing library-internal in the API at all.

- Eric
