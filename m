Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296126191C6
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 08:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiKDHXN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 03:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiKDHXM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 03:23:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD346DF51;
        Fri,  4 Nov 2022 00:23:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 710C5B82B41;
        Fri,  4 Nov 2022 07:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D54C433D6;
        Fri,  4 Nov 2022 07:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667546589;
        bh=eSuuH9/oUtk/WtNsMhQHynTS3lzvAy6kg0GggGpltfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Skak6zHOpyfHS3AN62zTx4FcXcyFdQVkTaEs5VPTldbAve0m9Vp40ff1uGgmWSGEK
         H75OOWMCOHZp5G/WrdinbPjch72hLdY+5pheETQrLz84gDN/uyTDfdeaz5u/A1Wvpj
         kCfkFj51eyrbfJlqmjwkGA6ZTti0BgBGCx4z0Hdu40wqYa4w1I+PdcNJrYlqXKW/PU
         yXDIaSNm/+SOMLhkjLD53P9dLoqrYO2ViFGIAX4rJnP8k7nyoHiEJ12JmHb+mKWq3X
         ZoWtD4oiU3k1zZlvGMxtmhK2wlv1hmsBi7nxpVvVS6cpHuMdG2FThAVTxsI+64QyTg
         q3h4MYrSdJwyA==
Date:   Fri, 4 Nov 2022 00:23:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 2/2] blk-crypto: add a blk_crypto_cfg_supported helper
Message-ID: <Y2S927PXuEYM7xwJ@sol.localdomain>
References: <20221104054621.628369-1-hch@lst.de>
 <20221104054621.628369-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104054621.628369-3-hch@lst.de>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 04, 2022 at 06:46:21AM +0100, Christoph Hellwig wrote:
> Add a blk_crypto_cfg_supported helper that wraps
> __blk_crypto_cfg_supported to retreive the crypto_profile from the
> request queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-crypto-profile.c         |  7 +++++++
>  block/blk-crypto.c                 | 13 ++++---------
>  fs/crypto/inline_crypt.c           |  4 +---
>  include/linux/blk-crypto-profile.h |  2 ++
>  4 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
> index 96c511967386d..e8a0a3457fa29 100644
> --- a/block/blk-crypto-profile.c
> +++ b/block/blk-crypto-profile.c
> @@ -353,6 +353,13 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
>  	return true;
>  }
>  
> +bool blk_crypto_cfg_supported(struct block_device *bdev,
> +			      const struct blk_crypto_config *cfg)
> +{
> +	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
> +					  cfg);
> +}

I think this part is too confusing, because there's already a function
blk_crypto_config_supported() which does something slightly different.

How about calling this blk_crypto_config_supported_natively() instead?  It's
kind of long, but it's much clearer.

Also, it should be defined in blk-crypto.c, next to
blk_crypto_config_supported(), and not in blk-crypto-profile.c.
(And declared in blk-crypto.h, not blk-crypto-profile.h.)

This would also make it so that fs/crypto/inline_crypt.c could go back to
including blk-crypto.h instead of blk-crypto-profile.h.  blk-crypto.h is
supposed to be the interface to upper layers, not blk-crypto-profile.h.

So, something like this:

	bool blk_crypto_config_supported(struct block_device *bdev,
					 const struct blk_crypto_config *cfg)
	{
		return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
		       blk_crypto_config_supported_natively(bdev, cfg);
	}

	bool blk_crypto_config_supported_natively(struct block_device *bdev,
						  const struct blk_crypto_config *cfg)
	{
		return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
						  cfg);
	}

- Eric
