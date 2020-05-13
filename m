Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0485C1D0547
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2020 05:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgEMDMI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 12 May 2020 23:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgEMDMI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 12 May 2020 23:12:08 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27B3A2312B;
        Wed, 13 May 2020 03:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589339528;
        bh=sIfDqqShqDcXIL5Ts6hJw6nw2IZoaZwk5xhWhieDeDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pQuMRTuCpOdmOb1siziEWXmktvJf14z2QfinwY1YMPsx/x2KSJ5YAJyoqW/Vylqv3
         QOeSo31io+pU6juoQkpg4ia1yXZhR2H6f71IGmz6R7tK+wIo11mQ3lOSAznUdM2MEE
         LhId6mJ5Ceh6DYwTdS7ZVD4VjHQ7Fw+nrnNfLE1A=
Date:   Tue, 12 May 2020 20:12:07 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH 4/4] fscrypt: make test_dummy_encryption use v2 by default
Message-ID: <20200513031207.GD108075@google.com>
References: <20200512233251.118314-1-ebiggers@kernel.org>
 <20200512233251.118314-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512233251.118314-5-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 05/12, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since v1 encryption policies are deprecated, make test_dummy_encryption
> test v2 policies by default.
> 
> Note that this causes ext4/023 and ext4/028 to start failing due to
> known bugs in those tests (see previous commit).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>

> ---
>  fs/crypto/policy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index ca0ee337c9627f..cb7fd8f7f0eca1 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -632,7 +632,7 @@ int fscrypt_set_test_dummy_encryption(struct super_block *sb,
>  				      const substring_t *arg,
>  				      struct fscrypt_dummy_context *dummy_ctx)
>  {
> -	const char *argstr = "v1";
> +	const char *argstr = "v2";
>  	const char *argstr_to_free = NULL;
>  	struct fscrypt_key_specifier key_spec = { 0 };
>  	int version;
> -- 
> 2.26.2
