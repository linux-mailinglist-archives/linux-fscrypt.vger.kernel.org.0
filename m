Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3973E638FDF
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Nov 2022 19:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiKYSfS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Nov 2022 13:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKYSfR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Nov 2022 13:35:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3184EC33;
        Fri, 25 Nov 2022 10:35:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B72EC60BA6;
        Fri, 25 Nov 2022 18:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AFBC433C1;
        Fri, 25 Nov 2022 18:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669401316;
        bh=1BO5DlQJmT/mIvkMV0tDh7U4Ecq3FXjCk9hLzseEy5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PLcT7dwBWgO7Z1cNtZN2ZknXKtyR9VoYEDPV1ryB0ySp1PszZQP3qca7Bbqd3+TM7
         RU1QHBSbOboix6FOOTBYdgM3vAQgjPg0StuOhWW+opt3JUo+tpnoU/vPyyWq37D8u2
         LgQx3qjhLEhyJdsh0+lQh4eOEXDAPZvRW93VBGraQBzq/h9tffW/WZjFKDhT1Rhn23
         6hditb1qKzvNkwWLOaOtgVJtIteECbYPmEvmTTIAQeG9UEIgKdlN68R7AQtXsOfE89
         VNiwPqoZx/nZVZRANKljLoL6meJ8qTRt8xoR8F1rQtl/KDFioqWqJYqC/0y7WtyhmR
         JgetnprB125hg==
Date:   Fri, 25 Nov 2022 10:35:14 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v3 1/2] blk-crypto: Add support for SM4-XTS blk crypto
 mode
Message-ID: <Y4EK4iEmvPWRNRm9@sol.localdomain>
References: <20221125121630.87793-1-tianjia.zhang@linux.alibaba.com>
 <20221125121630.87793-2-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125121630.87793-2-tianjia.zhang@linux.alibaba.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 25, 2022 at 08:16:29PM +0800, Tianjia Zhang wrote:
> SM4 is a symmetric algorithm widely used in China, and SM4-XTS is also
> used to encrypt length-preserving data, these algoritms are mandatory
> in many scenarios. This patch enables the use of SM4-XTS algorithm in
> block inline encryption, and provides support for fscrypt.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  block/blk-crypto.c         | 6 ++++++
>  include/linux/blk-crypto.h | 1 +
>  2 files changed, 7 insertions(+)
> 
> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index a496aaef85ba..e44709fc6a08 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -36,6 +36,12 @@ const struct blk_crypto_mode blk_crypto_modes[] = {
>  		.keysize = 32,
>  		.ivsize = 32,
>  	},
> +	[BLK_ENCRYPTION_MODE_SM4_XTS] = {
> +		.name = "SM4-XTS",
> +		.cipher_str = "xts(sm4)",
> +		.keysize = 32,
> +		.ivsize = 16,
> +	},
>  };
>  
>  /*
> diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
> index 69b24fe92cbf..26b1b71c3091 100644
> --- a/include/linux/blk-crypto.h
> +++ b/include/linux/blk-crypto.h
> @@ -13,6 +13,7 @@ enum blk_crypto_mode_num {
>  	BLK_ENCRYPTION_MODE_AES_256_XTS,
>  	BLK_ENCRYPTION_MODE_AES_128_CBC_ESSIV,
>  	BLK_ENCRYPTION_MODE_ADIANTUM,
> +	BLK_ENCRYPTION_MODE_SM4_XTS,
>  	BLK_ENCRYPTION_MODE_MAX,

The commit message should mention that this is needed for the inlinecrypt mount
option to be supported via blk-crypto-fallback, as it is for the other fscrypt
modes.  (Since there's no inline encryption hardware that supports SM4-XTS.)

Anyway, if SM4-XTS support is really being added to fscrypt, then this patch
looks fine.  Jens, are you okay with me taking it through the fscrypt tree?

- Eric
