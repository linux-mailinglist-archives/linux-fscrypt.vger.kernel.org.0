Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AFA61FF5E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Nov 2022 21:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbiKGUQ0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Nov 2022 15:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbiKGUQZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Nov 2022 15:16:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F6219024;
        Mon,  7 Nov 2022 12:16:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E562D612E3;
        Mon,  7 Nov 2022 20:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37EBC433C1;
        Mon,  7 Nov 2022 20:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667852184;
        bh=sqbQzGFBxWgN0I891jJiwQLt04aCFVqUHKmVQGRkM0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PkWAbphQt4O3o2q5HgZU0Sq5a+yfqvxm/UMbackXW9aOTqbhIk2aUWfxwJJtxeJmS
         6W3HlMvsgRjomWURjbI0SI3CxrUT3YL8a1RghIETOUDE9Mq8LEocMID4cX4tz4sbc8
         9nGRoIrCdx+AsfjhqJESsNt2ylMbA0GvpxrRurQlJWcgA8r12cFL4NuGqCG/ZhwGXg
         YSnqsJLz/V/7TtrUkQLw6aoVAfsD5BCnGOCGRkQqwAQA1Ub9wdZU1sgDixcE2Zpjsi
         IWjCGlu54j1opOpsD1PZLzo9NmaoavDbUJg/x8GPBzkih8wwsrlYqYHzyH8MlQ638L
         ZKdXpwOVS3fpQ==
Date:   Mon, 7 Nov 2022 12:16:22 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/3] blk-crypto: don't use struct request_queue for
 public interfaces
Message-ID: <Y2lnloNN5wovDBMF@sol.localdomain>
References: <20221107144229.1547370-1-hch@lst.de>
 <20221107144229.1547370-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107144229.1547370-2-hch@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 07, 2022 at 03:42:27PM +0100, Christoph Hellwig wrote:
> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index a496aaef85ba4..0e0c2fc56c428 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -357,17 +357,18 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
>   * request queue it's submitted to supports inline crypto, or the
>   * blk-crypto-fallback is enabled and supports the cfg).
>   */

Replace "request queue" with block_device in the above comment?

> -bool blk_crypto_config_supported(struct request_queue *q,
> +bool blk_crypto_config_supported(struct block_device *bdev,
>  				 const struct blk_crypto_config *cfg)
>  {
>  	return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
> -	       __blk_crypto_cfg_supported(q->crypto_profile, cfg);
> +	       __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
> +	       				  cfg);
>  }

There's a whitespace error here:

$ checkpatch 0001-blk-crypto-don-t-use-struct-request_queue-for-public.patch
ERROR: code indent should use tabs where possible
#87: FILE: block/blk-crypto.c:365:
+^I       ^I^I^I^I  cfg);$

WARNING: please, no space before tabs
#87: FILE: block/blk-crypto.c:365:
+^I       ^I^I^I^I  cfg);$

> -int blk_crypto_evict_key(struct request_queue *q,
> +int blk_crypto_evict_key(struct block_device *bdev,
>                          const struct blk_crypto_key *key)
>  {
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
>	if (__blk_crypto_cfg_supported(q->crypto_profile, &key->crypto_cfg))
>		return __blk_crypto_evict_key(q->crypto_profile, key);
>
>	/*
>        * If the request_queue didn't support the key, then blk-crypto-fallback
>        * may have been used, so try to evict the key from blk-crypto-fallback.
>        */
>	return blk_crypto_fallback_evict_key(key);

Likewise, s/request_queue/block_device/ in the above comment.

> diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
> index 69b24fe92cbf1..b314e2febcaf5 100644
> --- a/include/linux/blk-crypto.h
> +++ b/include/linux/blk-crypto.h
[...]
>
> struct request;
> struct request_queue;

These forward declarations are no longer needed and can be removed.

- Eric
