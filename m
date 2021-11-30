Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF16462A4A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 03:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbhK3CWj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Nov 2021 21:22:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38084 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhK3CWj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Nov 2021 21:22:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1739AB81691;
        Tue, 30 Nov 2021 02:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DD5C53FC7;
        Tue, 30 Nov 2021 02:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638238757;
        bh=mG4YfZJm0dmSgc40+VKGusKgVhMSLNBbi9zaaojluz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qP2h2CsOftyzS8CHfk/aLQ34OTNNMw40913/VyAxXlRbB+39HX4g5VdH3ihJzTizn
         3RhzqYKJCvU10iAaU4WMJZ6p1Z+exRMaz60Dre7MQqPSo+Mb4TnVKvuPLy7fgoUmje
         +Hl9XJYvhanxFZWL1aPQ3Va+2XIEwaoZ+E0I2nNHNUtknZ1UacQEKlVJPO6jRoDMvY
         hI9U7yjRMBbFnQ0aXr8FUvZUqI2oNwi4tQH5N7yAHeVGdD7tctribRaYrfoGd0/nwE
         mKU6Vct/ZGVAp2qm8YkH+6SblGWf/Je7Gm90TnuOLhH8VpuQJhcaYPEVv8kkded4fv
         uLkW0sPm3Npfw==
Date:   Mon, 29 Nov 2021 18:19:16 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] fs-verity: define a function to return the integrity
 protected file digest
Message-ID: <YaWKJEqD6G23uG/A@sol.localdomain>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
 <20211129170057.243127-2-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129170057.243127-2-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Generally looks fine.  A few nits below:

On Mon, Nov 29, 2021 at 12:00:54PM -0500, Mimi Zohar wrote:
> Define a function named fsverity_measure() to return the verity file digest
> and the associated hash algorithm (enum hash_algo).
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  fs/verity/fsverity_private.h |  6 -----
>  fs/verity/measure.c          | 49 ++++++++++++++++++++++++++++++++++++
>  include/linux/fsverity.h     | 17 +++++++++++++
>  3 files changed, 66 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
> index a7920434bae5..54c5f0993541 100644
> --- a/fs/verity/fsverity_private.h
> +++ b/fs/verity/fsverity_private.h
> @@ -26,12 +26,6 @@ struct ahash_request;
>   */
>  #define FS_VERITY_MAX_LEVELS		8
>  
> -/*
> - * Largest digest size among all hash algorithms supported by fs-verity.
> - * Currently assumed to be <= size of fsverity_descriptor::root_hash.
> - */
> -#define FS_VERITY_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE

The include of sha2.h should be removed from this file.

> +/**
> + * fsverity_measure() - get a verity file's digest
> + * @inode: inode to get digest of
> + * @digest: pointer to the digest
> + * @alg: pointer to the hash algorithm enumeration

It should be made clear that @digest and @alg are output, for example:

 * @digest: (out) pointer to the digest
 * @alg: (out) pointer to the hash algorithm enumeration

> + * Return the file hash algorithm, digest size, and digest of an fsverity
> + * protected file.

The digest size is implied, not returned.

> +
> +		if (!strcmp(hash_alg->name, hash_algo_name[i])) {

As the kernel test robot pointed out, this creates a dependency on
CRYPTO_HASH_INFO.  So FS_VERITY will need to select CRYPTO_HASH_INFO.

- Eric
