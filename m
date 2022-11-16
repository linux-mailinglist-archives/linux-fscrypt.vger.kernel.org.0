Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC20F62C64D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Nov 2022 18:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiKPR0L (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Nov 2022 12:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiKPR0I (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Nov 2022 12:26:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE24E63;
        Wed, 16 Nov 2022 09:26:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25AFF61F0E;
        Wed, 16 Nov 2022 17:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF62C433D6;
        Wed, 16 Nov 2022 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668619565;
        bh=PT+8MkgMTV9fwJCv3MTZ299Jqr5mxS8H+pV7cIqlGBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yu8b70BDWrnw5JdJlGg+tQ9HWB7F06X7t4IAKbX29G+IaLUh57DqsZLwlarmg8WbT
         pI8qz4v8Se0eOtkzfw9fZVFnPkWbgPVR/8/4Z05htxNw60TLy82s8ABI4mWkgdwkqa
         afSz7B/4yd0L4jj9zSd5mn2ceaWWZYO6AR5E7af725wqAFq4IbM7Vk76EulUA6SZk+
         JhpDfgmni0MNNPXfrt00sVetkF4bTeGLKdmpjlis9krJccZBOfxdgTB/6+hWrHpsnp
         H+emKZU15lwTaej0J8j9csK2soG0t0RE0DHnRdyq8H9hduPpzRJqoVdNWDQ5JP1kjY
         fYG1AonYGG6Sw==
Date:   Wed, 16 Nov 2022 09:26:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/2] fscrypt: Add SM4 XTS/CTS symmetric algorithm support
Message-ID: <Y3UdKwtHE+SrERka@sol.localdomain>
References: <20221116082416.98977-1-tianjia.zhang@linux.alibaba.com>
 <20221116082416.98977-3-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116082416.98977-3-tianjia.zhang@linux.alibaba.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 16, 2022 at 04:24:16PM +0800, Tianjia Zhang wrote:
> SM4 is a symmetric algorithm widely used in China

So?

What is the use case for adding this to fscrypt specifically?

Just because an algorithm is widely used doesn't necessarily mean it is useful
or appropriate to support with fscrypt.

> , this patch enables
> to use SM4-XTS mode to encrypt file content, and use SM4-CBC-CTS to
> encrypt filename.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  Documentation/filesystems/fscrypt.rst |  1 +
>  fs/crypto/fscrypt_private.h           |  2 +-
>  fs/crypto/keysetup.c                  | 15 +++++++++++++++
>  fs/crypto/policy.c                    |  4 ++++
>  include/uapi/linux/fscrypt.h          |  4 +++-
>  5 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 5ba5817c17c2..af27e7b2c74f 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -336,6 +336,7 @@ Currently, the following pairs of encryption modes are supported:
>  
>  - AES-256-XTS for contents and AES-256-CTS-CBC for filenames
>  - AES-128-CBC for contents and AES-128-CTS-CBC for filenames
> +- SM4-XTS for contents and SM4-CTS-CBC for filenames
>  - Adiantum for both contents and filenames
>  - AES-256-XTS for contents and AES-256-HCTR2 for filenames (v2 policies only)
>  
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index d5f68a0c5d15..e79a701de028 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -31,7 +31,7 @@
>  #define FSCRYPT_CONTEXT_V2	2
>  
>  /* Keep this in sync with include/uapi/linux/fscrypt.h */
> -#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
> +#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_SM4_CTS
>  
>  struct fscrypt_context_v1 {
>  	u8 version; /* FSCRYPT_CONTEXT_V1 */
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index f7407071a952..c0a3f882f5a4 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -59,6 +59,21 @@ struct fscrypt_mode fscrypt_modes[] = {
>  		.security_strength = 32,
>  		.ivsize = 32,
>  	},
> +	[FSCRYPT_MODE_SM4_XTS] = {
> +		.friendly_name = "SM4-XTS",
> +		.cipher_str = "xts(sm4)",
> +		.keysize = 32,
> +		.security_strength = 16,
> +		.ivsize = 16,
> +		.blk_crypto_mode = BLK_ENCRYPTION_MODE_SM4_XTS,
> +	},
> +	[FSCRYPT_MODE_SM4_CTS] = {
> +		.friendly_name = "SM4-CTS",
> +		.cipher_str = "cts(cbc(sm4))",
> +		.keysize = 16,
> +		.security_strength = 16,
> +		.ivsize = 16,
> +	},
>  };
>  
>  static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index 46757c3052ef..4881fd3af6ee 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -75,6 +75,10 @@ static bool fscrypt_valid_enc_modes_v1(u32 contents_mode, u32 filenames_mode)
>  	    filenames_mode == FSCRYPT_MODE_ADIANTUM)
>  		return true;
>  
> +	if (contents_mode == FSCRYPT_MODE_SM4_XTS &&
> +	    filenames_mode == FSCRYPT_MODE_SM4_CTS)
> +		return true;
> +
>  	return false;
>  }
>  
> diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
> index a756b29afcc2..34d791bd162c 100644
> --- a/include/uapi/linux/fscrypt.h
> +++ b/include/uapi/linux/fscrypt.h
> @@ -28,7 +28,9 @@
>  #define FSCRYPT_MODE_AES_128_CTS		6
>  #define FSCRYPT_MODE_ADIANTUM			9
>  #define FSCRYPT_MODE_AES_256_HCTR2		10
> -/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
> +#define FSCRYPT_MODE_SM4_XTS			11
> +#define FSCRYPT_MODE_SM4_CTS			12
> +/* If adding a mode number > 12, update FSCRYPT_MODE_MAX in fscrypt_private.h */

This might be a good time to reclaim some of the unused mode numbers.  Maybe 7-8
which were very briefly used for Speck128/256.  (Irony not lost?)

- Eric
