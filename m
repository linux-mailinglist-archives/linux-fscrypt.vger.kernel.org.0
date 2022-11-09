Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1882D622C36
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Nov 2022 14:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiKINOP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Nov 2022 08:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiKINOP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Nov 2022 08:14:15 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B34226ADC;
        Wed,  9 Nov 2022 05:14:14 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2991D68AA6; Wed,  9 Nov 2022 14:14:10 +0100 (CET)
Date:   Wed, 9 Nov 2022 14:14:09 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/3] blk-crypto: don't use struct request_queue for
 public interfaces
Message-ID: <20221109131409.GD32628@lst.de>
References: <20221107144229.1547370-1-hch@lst.de> <20221107144229.1547370-2-hch@lst.de> <Y2lnloNN5wovDBMF@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2lnloNN5wovDBMF@sol.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 07, 2022 at 12:16:22PM -0800, Eric Biggers wrote:
> On Mon, Nov 07, 2022 at 03:42:27PM +0100, Christoph Hellwig wrote:
> > diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> > index a496aaef85ba4..0e0c2fc56c428 100644
> > --- a/block/blk-crypto.c
> > +++ b/block/blk-crypto.c
> > @@ -357,17 +357,18 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
> >   * request queue it's submitted to supports inline crypto, or the
> >   * blk-crypto-fallback is enabled and supports the cfg).
> >   */
> 
> Replace "request queue" with block_device in the above comment?

Done.

> > -	       __blk_crypto_cfg_supported(q->crypto_profile, cfg);
> > +	       __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
> > +	       				  cfg);
> >  }
> 
> There's a whitespace error here:

Fixed.

> >	/*
> >        * If the request_queue didn't support the key, then blk-crypto-fallback
> >        * may have been used, so try to evict the key from blk-crypto-fallback.
> >        */
> >	return blk_crypto_fallback_evict_key(key);
> 
> Likewise, s/request_queue/block_device/ in the above comment.

Done.

> > struct request;
> > struct request_queue;
> 
> These forward declarations are no longer needed and can be removed.

Done.
