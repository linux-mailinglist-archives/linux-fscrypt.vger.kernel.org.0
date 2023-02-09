Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902AC68FDFC
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Feb 2023 04:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbjBIDbS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Feb 2023 22:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjBIDak (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Feb 2023 22:30:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C13E04E;
        Wed,  8 Feb 2023 19:30:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9E096187E;
        Thu,  9 Feb 2023 03:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811C9C433EF;
        Thu,  9 Feb 2023 03:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675913436;
        bh=DbojSuLwxvxHTVD5904kFFvTdY99TONLdsOPCTQ9EhM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FA0VUJj7ytZLpiHkeewSZwqz9dEmgx0S3pifki8Zcpk9++H3Dqe+ArXeU9EurEFys
         ncnXUbFFqyS9VkC+E8xoFZquwJXy9AVKuAwPwv3ga2wiJWXdWpzFj1p3Xjqo20tInp
         QZfUyf7VMb2de0AVoGcS9d6TwcYYx4KlLDxzLck5lO4Gm+r41WiAU2NazDYBvoHoFw
         SYHH4IYpw9aQvAdWes6uALQdiP83QzMgGmH+TMupJAVoK2V4dPWN3PVi7ixp4oeUJO
         N05xOagdxelzguO4h2Ct5mt2kfIXcBqgA4Ke6UiB4SM6vCbypBiN/Mmptr3UWmlD8k
         gSiecvIQEJMkw==
Date:   Wed, 8 Feb 2023 19:30:33 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Fan Wu <wufan@linux.microsoft.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, axboe@kernel.dk, agk@redhat.com,
        snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com,
        linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 12/16] fsverity: consume builtin signature via LSM
 hook
Message-ID: <Y+Ro2Uor21d/Gfqc@sol.localdomain>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-13-git-send-email-wufan@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675119451-23180-13-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

So disregarding the fact that using the fsverity builtin signatures still seems
like a bad idea to me, here's a few comments on the diff itself:

On Mon, Jan 30, 2023 at 02:57:27PM -0800, Fan Wu wrote:
> diff --git a/fs/verity/open.c b/fs/verity/open.c
> index 81ff94442f7b..7e6fa52c0e9c 100644
> --- a/fs/verity/open.c
> +++ b/fs/verity/open.c
> @@ -7,7 +7,9 @@
>  
>  #include "fsverity_private.h"
>  
> +#include <linux/security.h>
>  #include <linux/slab.h>
> +#include <crypto/public_key.h>

There's no need to include <crypto/public_key.h>.

>  
>  static struct kmem_cache *fsverity_info_cachep;
>  
> @@ -146,7 +148,7 @@ static int compute_file_digest(struct fsverity_hash_alg *hash_alg,
>   * appended signature), and check the signature if present.  The
>   * fsverity_descriptor must have already undergone basic validation.
>   */
> -struct fsverity_info *fsverity_create_info(const struct inode *inode,
> +struct fsverity_info *fsverity_create_info(struct inode *inode,
>  					   struct fsverity_descriptor *desc)
>  {
>  	struct fsverity_info *vi;
> @@ -182,6 +184,15 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
>  
>  	err = fsverity_verify_signature(vi, desc->signature,
>  					le32_to_cpu(desc->sig_size));
> +	if (err) {
> +		fsverity_err(inode, "Error %d verifying signature", err);
> +		goto out;
> +	}

The above error message is unnecessary because fsverity_verify_signature()
already prints an error message on failure.

> +
> +	err = security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME, desc->signature,
> +					 le32_to_cpu(desc->sig_size), 0);

This runs even if CONFIG_FS_VERITY_BUILTIN_SIGNATURES is disabled.  Is that
really the right behavior?

Also a nit: please stick to the preferred line length of 80 characters.
See Documentation/process/coding-style.rst

> diff --git a/fs/verity/signature.c b/fs/verity/signature.c
> index 143a530a8008..5d7b9496f9c4 100644
> --- a/fs/verity/signature.c
> +++ b/fs/verity/signature.c
> @@ -9,6 +9,7 @@
>  
>  #include <linux/cred.h>
>  #include <linux/key.h>
> +#include <linux/security.h>
>  #include <linux/slab.h>
>  #include <linux/verification.h>

This change is unnecessary.

> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index 40f14e5fed9d..29e9888287ba 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -254,4 +254,6 @@ static inline bool fsverity_active(const struct inode *inode)
>  	return fsverity_get_info(inode) != NULL;
>  }
>  
> +#define FS_VERITY_INODE_SEC_NAME "fsverity.inode-info"

"inode-info" is very vague.  Shouldn't it be named "builtin-sig" or something?

- Eric
