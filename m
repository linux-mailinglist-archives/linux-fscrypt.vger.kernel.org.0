Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D58A462A90
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 03:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbhK3Ci3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Nov 2021 21:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhK3Ci2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Nov 2021 21:38:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F92EC061574;
        Mon, 29 Nov 2021 18:35:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 345B1CE16E3;
        Tue, 30 Nov 2021 02:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCEFC53FC7;
        Tue, 30 Nov 2021 02:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638239706;
        bh=tmYk4H8UA3jezTm1e03NlcIdb7MNCUMlUvqHiMWyHPc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sm3ML29t17gXxoBoN9nGtQni6WJhROsTgESSzEqXVUFheTHORAZR+KWO+sIEjz/Z0
         Jq13ZWYjpFGxp1XWxwchI7ESRkZyUCqZh0ZGmytx/lY257FSrcij0A2OgVYHZXtwVH
         klZDO80ntwBYIJRRVbkeESGdQ3060R7QsqD3qIsuLEXJiP+LTgoGXGhYF6P10WTK/w
         CVJizzJL3SanPgYp2OmyV1LUwUlD4gZNusSS11VNd9RxSU2083Js6Ii+WSh5LEHiXU
         YFy2nnF4X75OZKPO7IYzG/LeI7Akk+WEzwPEocIf7V5fUeWRkFxkglv1yjKGo6B0Gm
         H5iXI71GGuKQA==
Date:   Mon, 29 Nov 2021 18:35:05 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ima: limit including fs-verity's file digest in
 measurement list
Message-ID: <YaWN2RPEO3fZqkv4@sol.localdomain>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
 <20211129170057.243127-4-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129170057.243127-4-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 29, 2021 at 12:00:56PM -0500, Mimi Zohar wrote:
> Without the file signature included the IMA measurement list, the type
> of file digest is unclear.  Limit including fs-verity's file digest in
> the IMA measurement list based on whether the template name is ima-sig.
> In the future, this could be relaxed to include any template format that
> includes the file signature.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  security/integrity/ima/ima.h              | 3 ++-
>  security/integrity/ima/ima_api.c          | 3 ++-
>  security/integrity/ima/ima_appraise.c     | 3 ++-
>  security/integrity/ima/ima_main.c         | 7 ++++++-
>  security/integrity/ima/ima_template_lib.c | 3 ++-
>  5 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index be965a8715e4..ab257e404f8e 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -262,7 +262,8 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
>  int ima_must_measure(struct inode *inode, int mask, enum ima_hooks func);
>  int ima_collect_measurement(struct integrity_iint_cache *iint,
>  			    struct file *file, void *buf, loff_t size,
> -			    enum hash_algo algo, struct modsig *modsig);
> +			    enum hash_algo algo, struct modsig *modsig,
> +			    bool veritysig);
>  void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
>  			   const unsigned char *filename,
>  			   struct evm_ima_xattr_data *xattr_value,
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index 42c6ff7056e6..179c7f0364c2 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -217,7 +217,8 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
>   */
>  int ima_collect_measurement(struct integrity_iint_cache *iint,
>  			    struct file *file, void *buf, loff_t size,
> -			    enum hash_algo algo, struct modsig *modsig)
> +			    enum hash_algo algo, struct modsig *modsig,
> +			    bool veritysig)

'veritysig' is being added here but it doesn't actually do anything.  It seems
this patchset is not split up correctly.

> +	rc = ima_collect_measurement(iint, file, NULL, 0, ima_hash_algo,
> +				     NULL, FALSE);
>  	if (rc < 0)
>  		return;

false should be used instead of FALSE.

>  
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 465865412100..a73e1e845ea8 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -216,6 +216,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
>  	bool violation_check;
>  	enum hash_algo hash_algo;
>  	unsigned int allowed_algos = 0;
> +	int veritysig = FALSE;

Likewise.

> +	if (xattr_value && xattr_value->type == IMA_VERITY_DIGSIG &&
> +	    strcmp(template_desc->name, "ima-sig") == 0)
> +		veritysig = TRUE;

Likewise, true instead of TRUE.

- Eric
