Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DC518E6FE
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Mar 2020 06:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgCVFyL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 22 Mar 2020 01:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgCVFyL (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 22 Mar 2020 01:54:11 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53DF620724;
        Sun, 22 Mar 2020 05:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584856450;
        bh=cfXE1RVRPjJrPl4Mflbf6IeVT9A/kLZdF49H3bYeBK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2e8JCjdskGB0JMOjE8qhyJS95J/YsXRNNg/vrZ5uOqTyybfwY5y5lfablvOt2R3KD
         Cy9P0+vooQSjlfcohnrNiIsg8XvX1paJdpam2qwwefl1F3+T94Lvv3CIifUnrRuaAp
         lVM+sd+/r1h/YxuoSL3vWsQNF1KHq2bF/1YvJGkM=
Date:   Sat, 21 Mar 2020 22:54:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 9/9] Document API of libfsverity
Message-ID: <20200322055408.GJ111151@sol.localdomain>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
 <20200312214758.343212-10-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312214758.343212-10-Jes.Sorensen@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 12, 2020 at 05:47:58PM -0400, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
> ---
>  libfsverity.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/libfsverity.h b/libfsverity.h
> index a2abdb3..f6c4b13 100644
> --- a/libfsverity.h
> +++ b/libfsverity.h
> @@ -64,18 +64,63 @@ struct fsverity_hash_alg {
>  	struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
>  };
>  
> +/*
> + * libfsverity_compute_digest - Compute digest of a file
> + * @fd: open file descriptor of file to compute digest for
> + * @params: struct libfsverity_merkle_tree_params specifying hash algorithm,
> + *	    block size, version, and optional salt parameters.
> + *	    reserved parameters must be zero.
> + * @digest_ret: Pointer to pointer for computed digest
> + *
> + * Returns:
> + * * 0 for success, -EINVAL for invalid input arguments, -ENOMEM if failed
> + *   to allocate memory, -EBADF if fd is invalid, and -EAGAIN if root hash
> + *   fails to compute.
> + * * digest_ret returns a pointer to the digest on success.
> + */
>  int
>  libfsverity_compute_digest(int fd,
>  			   const struct libfsverity_merkle_tree_params *params,
>  			   struct libfsverity_digest **digest_ret);

Can you add a brief explanation here that clarifies that the "digest of a file"
in this context means fs-verity's Merkle tree-based hash (what the kernel calls
the "file measurement"), not a standard file hash?  These could easily be
confused, especially by people not as familiar with fs-verity.

Also, it's important to also mention that the digest needs to be free()d.

>  
> +/*
> + * libfsverity_sign_digest - Sign previously computed digest of a file
> + * @digest: pointer to previously computed digest
> + * @sig_params: struct libfsverity_signature_params providing filenames of
> + *          the keyfile and certificate file. Reserved parameters must be zero.
> + * @sig_ret: Pointer to pointer for signed digest
> + * @sig_size_ret: Pointer to size of signed return digest
> + *
> + * Returns:
> + * * 0 for success, -EINVAL for invalid input arguments, -EAGAIN if key or
> + *   certificate files fail to read, or if signing the digest fails.
> + * * sig_ret returns a pointer to the signed digest on success.
> + * * sig_size_ret returns the size of the signed digest on success.
> + */
>  int
>  libfsverity_sign_digest(const struct libfsverity_digest *digest,
>  			const struct libfsverity_signature_params *sig_params,
>  			uint8_t **sig_ret, size_t *sig_size_ret);

Can you add some more details here?  What is the signature for, what type of
signature is it, what format do the key file and certificate file need to be in,
what crypto algorithms do they need to use, etc.?

(I know, I need to add a man page for the 'fsverity' program that explains this
too.  There's some explanation in the README but not enough.)

Also, it's important to mention that the signature needs to be free()d.

> +/*
> + * libfsverity_find_hash_alg_by_name - Find hash algorithm by name
> + * @name: Pointer to name of hash algorithm
> + *
> + * Returns:
> + * struct fsverity_hash_alg success
> + * NULL on error
> + */

We should be more specific and write "NULL if not found", since "not found" is
the only type of error that makes sense for this.

>  const struct fsverity_hash_alg *
>  libfsverity_find_hash_alg_by_name(const char *name);
> +
> +/*
> + * libfsverity_find_hash_alg_by_num - Find hash algorithm by number
> + * @name: Number of hash algorithm
> + *
> + * Returns:
> + * struct fsverity_hash_alg success
> + * NULL on error
> + */
>  const struct fsverity_hash_alg *
>  libfsverity_find_hash_alg_by_num(unsigned int num);

Likewise.

- Eric
