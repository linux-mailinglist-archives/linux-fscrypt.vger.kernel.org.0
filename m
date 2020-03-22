Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E42418E671
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Mar 2020 05:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgCVE5Z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 22 Mar 2020 00:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgCVE5Z (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 22 Mar 2020 00:57:25 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0DBF2072E;
        Sun, 22 Mar 2020 04:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584853043;
        bh=lUmav+k2ECIkv/lPZk8owz/KQf2XdG6R5bbayO3v/7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dNSNXKUumO35QiBij3tmwwTk1KUje7/bub85tZDsBTPffeXOCfkqRX/GqZQTRkToz
         qVJUl4qBgdPmhtROWK01V9ZOJCUOCeON0l39gLFa28ATgM0D88YUVQWlw9uHhgHVB+
         HJfReleD10Z8FQMkSjFMLSTkmOeBWZ1L81sBd+Fc=
Date:   Sat, 21 Mar 2020 21:57:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 3/9] Move fsverity_descriptor definition to libfsverity.h
Message-ID: <20200322045722.GC111151@sol.localdomain>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
 <20200312214758.343212-4-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312214758.343212-4-Jes.Sorensen@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 12, 2020 at 05:47:52PM -0400, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
> ---
>  cmd_sign.c    | 19 +------------------
>  libfsverity.h | 26 +++++++++++++++++++++++++-
>  2 files changed, 26 insertions(+), 19 deletions(-)
> 
> diff --git a/cmd_sign.c b/cmd_sign.c
> index dcc44f8..1792084 100644
> --- a/cmd_sign.c
> +++ b/cmd_sign.c
> @@ -20,26 +20,9 @@
>  #include <unistd.h>
>  
>  #include "commands.h"
> -#include "fsverity_uapi.h"
> +#include "libfsverity.h"
>  #include "hash_algs.h"
>  
> -/*
> - * Merkle tree properties.  The file measurement is the hash of this structure
> - * excluding the signature and with the sig_size field set to 0.
> - */
> -struct fsverity_descriptor {
> -	__u8 version;		/* must be 1 */
> -	__u8 hash_algorithm;	/* Merkle tree hash algorithm */
> -	__u8 log_blocksize;	/* log2 of size of data and tree blocks */
> -	__u8 salt_size;		/* size of salt in bytes; 0 if none */
> -	__le32 sig_size;	/* size of signature in bytes; 0 if none */
> -	__le64 data_size;	/* size of file the Merkle tree is built over */
> -	__u8 root_hash[64];	/* Merkle tree root hash */
> -	__u8 salt[32];		/* salt prepended to each hashed block */
> -	__u8 __reserved[144];	/* must be 0's */
> -	__u8 signature[];	/* optional PKCS#7 signature */
> -};
> -
>  /*
>   * Format in which verity file measurements are signed.  This is the same as
>   * 'struct fsverity_digest', except here some magic bytes are prepended to
> diff --git a/libfsverity.h b/libfsverity.h
> index ceebae1..396a6ee 100644
> --- a/libfsverity.h
> +++ b/libfsverity.h
> @@ -13,13 +13,14 @@
>  
>  #include <stddef.h>
>  #include <stdint.h>
> +#include <linux/types.h>
>  
>  #define FS_VERITY_HASH_ALG_SHA256       1
>  #define FS_VERITY_HASH_ALG_SHA512       2
>  
>  struct libfsverity_merkle_tree_params {
>  	uint16_t version;
> -	uint16_t hash_algorithm;
> +	uint16_t hash_algorithm;	/* Matches the digest_algorithm type */
>  	uint32_t block_size;
>  	uint32_t salt_size;
>  	const uint8_t *salt;
> @@ -27,6 +28,7 @@ struct libfsverity_merkle_tree_params {
>  };
>  
>  struct libfsverity_digest {
> +	char magic[8];			/* must be "FSVerity" */
>  	uint16_t digest_algorithm;
>  	uint16_t digest_size;
>  	uint8_t digest[];
> @@ -38,4 +40,26 @@ struct libfsverity_signature_params {
>  	uint64_t reserved[11];
>  };
>  
> +/*
> + * Merkle tree properties.  The file measurement is the hash of this structure
> + * excluding the signature and with the sig_size field set to 0.
> + */
> +struct fsverity_descriptor {
> +	uint8_t version;	/* must be 1 */
> +	uint8_t hash_algorithm;	/* Merkle tree hash algorithm */
> +	uint8_t log_blocksize;	/* log2 of size of data and tree blocks */
> +	uint8_t salt_size;	/* size of salt in bytes; 0 if none */
> +	__le32 sig_size;	/* size of signature in bytes; 0 if none */
> +	__le64 data_size;	/* size of file the Merkle tree is built over */
> +	uint8_t root_hash[64];	/* Merkle tree root hash */
> +	uint8_t salt[32];	/* salt prepended to each hashed block */
> +	uint8_t __reserved[144];/* must be 0's */
> +	uint8_t signature[];	/* optional PKCS#7 signature */
> +};
> +

I thought there was no need for this to be part of the library API?

- Eric
