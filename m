Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289926191F4
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 08:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiKDH2d (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 03:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiKDH2Q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 03:28:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2422D2982D;
        Fri,  4 Nov 2022 00:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD496620D2;
        Fri,  4 Nov 2022 07:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14D1C433D6;
        Fri,  4 Nov 2022 07:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667546895;
        bh=fbWGgbdJBtNAz3pN1HaYyaU1xkkr+pI3p1rhDkRjRSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dd1QCBFpBu+RcloXNFmkOCRAsWKfNldK0gpfq/cAHinRR57UFT7RdudFR0v06ZjlF
         fSCYR7xwaxZ6O4RVyKM7d82KtFOnwtCjrMPYINScDroOlOYrlw/ngc9rGtYGYgNrN4
         KCPRSz9DZUvaaKbDV3XjFfFJwB55xwE8OYUSMVhDAZVZbgKi3jZWwIVisWpYjw+3so
         1RdOxP8gglFhqHmPNdAdilUtD3FZot9+w6Z7+RlqzR9Hni2Vwh0qjgsVq3Ffwr8AXi
         87OfB+R2LhjgOtF6w5tiG32cCxC8Qcw/PHC4PEpM5wEv+8+/XvSx5OjXOR9fU93i4W
         QP/yXmumj/UsA==
Date:   Fri, 4 Nov 2022 00:28:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/2] blk-crypto: don't use struct request_queue for
 public interfaces
Message-ID: <Y2S/DfZTr90t6QXv@sol.localdomain>
References: <20221104054621.628369-1-hch@lst.de>
 <20221104054621.628369-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104054621.628369-2-hch@lst.de>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 04, 2022 at 06:46:20AM +0100, Christoph Hellwig wrote:
>  Each device driver that
>  wants to support inline encryption will construct a blk_crypto_profile, then
> -associate it with the disk's request_queue.
> +associate it with the block device.
>  
[...]
> -Once the driver registers a blk_crypto_profile with a request_queue, I/O
> +Once the driver registers a blk_crypto_profile with a block_device, I/O
>  requests the driver receives via that queue may have an encryption context.
[...]
> -Request queue based layered devices like dm-rq that wish to support inline
> -encryption need to create their own blk_crypto_profile for their request_queue,
> +Request based layered devices like dm-rq that wish to support inline
> +encryption need to create their own blk_crypto_profile for their block_device,
>  and expose whatever functionality they choose. When a layered device wants to
[...]

Shouldn't the three places above still say request_queue, not block_device?
They're talking about the driver.

- Eric
