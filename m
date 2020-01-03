Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C65012FAFE
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Jan 2020 17:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgACQ6k (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 3 Jan 2020 11:58:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbgACQ6k (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 3 Jan 2020 11:58:40 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BED3206DB
        for <linux-fscrypt@vger.kernel.org>; Fri,  3 Jan 2020 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578070719;
        bh=TjBSC13j3CaEUDMtec8dd0ObqtBYGMGckPPLjsIVpqA=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=pxWCH2rpJjFC2D7GXjBxxsFcmpEfkP3TJnr46LohQfCVe6LRF0zYuM2L1lV1512rF
         jZrf6pYEW2GXls1DFMhTVmarES5MGtxaw7p+8y4J4GKGFOK1eEkroHxOSh9uxNoDye
         XzpyNQijLK1wYgpmcGbFhEGYtt3NZW6qOtTor+wU=
Date:   Fri, 3 Jan 2020 08:58:38 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: constify struct fscrypt_hkdf parameter to
 fscrypt_hkdf_expand()
Message-ID: <20200103165837.GE19521@gmail.com>
References: <20191209204054.227736-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209204054.227736-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 09, 2019 at 12:40:54PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Constify the struct fscrypt_hkdf parameter to fscrypt_hkdf_expand().
> This makes it clearer that struct fscrypt_hkdf contains the key only,
> not any per-request state.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/fscrypt_private.h | 2 +-
>  fs/crypto/hkdf.c            | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 130b50e5a0115..23cef4d3793a5 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -287,7 +287,7 @@ extern int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
>  #define HKDF_CONTEXT_DIRECT_KEY		3
>  #define HKDF_CONTEXT_IV_INO_LBLK_64_KEY	4
>  
> -extern int fscrypt_hkdf_expand(struct fscrypt_hkdf *hkdf, u8 context,
> +extern int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
>  			       const u8 *info, unsigned int infolen,
>  			       u8 *okm, unsigned int okmlen);
>  
> diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
> index f21873e1b4674..efb95bd19a894 100644
> --- a/fs/crypto/hkdf.c
> +++ b/fs/crypto/hkdf.c
> @@ -112,7 +112,7 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
>   * adds to its application-specific info strings to guarantee that it doesn't
>   * accidentally repeat an info string when using HKDF for different purposes.)
>   */
> -int fscrypt_hkdf_expand(struct fscrypt_hkdf *hkdf, u8 context,
> +int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
>  			const u8 *info, unsigned int infolen,
>  			u8 *okm, unsigned int okmlen)
>  {
> -- 
> 2.24.0.393.g34dc348eaf-goog
> 

Applied to fscrypt.git#master for 5.6.

- Eric
