Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8911061FF7B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Nov 2022 21:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiKGUYD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Nov 2022 15:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiKGUYB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Nov 2022 15:24:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871E962CD;
        Mon,  7 Nov 2022 12:24:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45BA8B81698;
        Mon,  7 Nov 2022 20:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FEEC433C1;
        Mon,  7 Nov 2022 20:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667852637;
        bh=3hSQMyHzzb1qvEGKfCW2d+14fPlyf1oF9apNDHd9a1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C4bA668PDuYNLHpT22WxpZWlUkjohVmfdUJKoKC28CfkxY/BPvvT4OPsVovgRW7y8
         oMMd96lkYqHujvvXlb5hmTcSH1a8cuS4gzmf6WiYrgATsH5gTza99a2++FoxZVeXkI
         /Au1IrzluTGkW+j6VIqKsnGaINKul4ni9vRgyYvwRRT5RuV//AH3Qi4/4Gh6pPj0t4
         MJmOBW9b2t5f6PX/wKY+UZ6wPIevhwmIyPyh3HqeYKR2yKknk69kiqBeNdgi7VwL3c
         vZAVwx2U6gOdkQliB7xwCaQbTdpazi9ZUI9iJGNsBaZ2qxD7YDhZ/nFFL99fwuQqyy
         8GRq3ox0vBCDg==
Date:   Mon, 7 Nov 2022 12:23:56 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 3/3] blk-crypto: move __blk_crypto_cfg_supported to
 blk-crypto-internal.h
Message-ID: <Y2lpXPD2jlumpNfr@sol.localdomain>
References: <20221107144229.1547370-1-hch@lst.de>
 <20221107144229.1547370-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107144229.1547370-4-hch@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 07, 2022 at 03:42:29PM +0100, Christoph Hellwig wrote:
> __blk_crypto_cfg_supported is only used internally by the blk-crypto
> code now, so move it out of the public header.

"public header" is ambiguous here.  blk-crypto.h is the "public header" for
upper layers, but blk-crypto-profile.h is the "public header" for drivers.
Maybe write "blk-crypto-profile.h, which is included by drivers".

> diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
> index e6818ffaddbf8..c587b3e1886c9 100644
> --- a/block/blk-crypto-internal.h
> +++ b/block/blk-crypto-internal.h
> @@ -19,6 +19,9 @@ struct blk_crypto_mode {
>  
>  extern const struct blk_crypto_mode blk_crypto_modes[];
>  
> +bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
> +				const struct blk_crypto_config *cfg);
> +
>  #ifdef CONFIG_BLK_INLINE_ENCRYPTION

It should go in the '#ifdef CONFIG_BLK_INLINE_ENCRYPTION' section.

> diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
> index bbab65bd54288..e990ec9b32aa4 100644
> --- a/include/linux/blk-crypto-profile.h
> +++ b/include/linux/blk-crypto-profile.h
> @@ -144,9 +144,6 @@ blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
>  
>  void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
>  
> -bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
> -				const struct blk_crypto_config *cfg);
> -
>  int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
>  			   const struct blk_crypto_key *key);

Otherwise I guess this patch is fine.  The exact same argument would also apply
to blk_crypto_get_keyslot(), blk_crypto_put_keyslot(), and
__blk_crypto_evict_key(), though.  It might be worth handling them all in one
patch.

- Eric
