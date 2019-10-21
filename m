Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2D0DF6BD
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Oct 2019 22:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbfJUU2j (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Oct 2019 16:28:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbfJUU2i (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Oct 2019 16:28:38 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 419AA2067B;
        Mon, 21 Oct 2019 20:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571689718;
        bh=liNerNN4X6Xfh6Ywy8zZWRiH6u0AxwRBvXXp8HOlPHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2rOrzmDOpvfCAOm46BHlwACupM9ivFXgpF0n7xoYgXL7DeUb9IXWe26O5O9WnUSyF
         aH8hnZjqcZRbq3Lp+aKfQPz9TUoeOz6Lz2zsvQcCb3mtzsjNux059jkcJ132v9bkkA
         XHZu3tEZ3PucFVHAmQrODjhHt5GhQoqe1nbwH8g4=
Date:   Mon, 21 Oct 2019 13:28:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] fscrypt: zeroize fscrypt_info before freeing
Message-ID: <20191021202836.GC122863@gmail.com>
Mail-Followup-To: linux-fscrypt@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20191009234442.225847-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009234442.225847-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 09, 2019 at 04:44:42PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> memset the struct fscrypt_info to zero before freeing.  This isn't
> really needed currently, since there's no secret key directly in the
> fscrypt_info.  But there's a decent chance that someone will add such a
> field in the future, e.g. in order to use an API that takes a raw key
> such as siphash().  So it's good to do this as a hardening measure.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/keysetup.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index df3e1c8653884..0ba33e010312f 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -325,6 +325,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
>  			key_invalidate(key);
>  		key_put(key);
>  	}
> +	memzero_explicit(ci, sizeof(*ci));
>  	kmem_cache_free(fscrypt_info_cachep, ci);
>  }
>  
> -- 
> 2.23.0.581.g78d2f28ef7-goog
> 

Applied to fscrypt.git for 5.5.

- Eric
