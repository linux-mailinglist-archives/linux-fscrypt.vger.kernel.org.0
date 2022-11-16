Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7DF62B1BF
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Nov 2022 04:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiKPDSP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Nov 2022 22:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiKPDSO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Nov 2022 22:18:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE8DB1C5;
        Tue, 15 Nov 2022 19:18:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 492E06185C;
        Wed, 16 Nov 2022 03:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDEEC433C1;
        Wed, 16 Nov 2022 03:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668568692;
        bh=UG2XUVfgPgocgLhXMPmGg0XgeObiIoUzaWvgpL2BAlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bdRf0KfFffp3J7+Hg87Jh64Z4RlumFbpXiqPSlhdFB1VfU60ychdPL2rDJCqETAhE
         Qw8CAMWSDy/+tSsDAPKjlz6aq3ftuCOipbIQM1E9VooTuMP79/rnBAGE9y/pliJRDw
         FKaDpKXAs7IVwZX0++lmQXZ9vpo8NCUaO+ZAjtY9fabGWMEpiNLuyo6tgOi++bHBpC
         92MRgthckcrCpvPB0lMDLhCwfkJbPNyfY1dtdM62fzss9knc00xAg29PiZdLqd9qTD
         jN0JNpGtLYrB9w1DukaYGf1rPB41jH8QEebe8jLJwo0Kob3t7zxyDcGRCn4nSU87zU
         48pYk5amhnXHQ==
Date:   Tue, 15 Nov 2022 19:18:10 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 3/3] blk-crypto: move internal only declarations to
 blk-crypto-internal.h
Message-ID: <Y3RWcm8pWma84RUs@sol.localdomain>
References: <20221114042944.1009870-1-hch@lst.de>
 <20221114042944.1009870-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114042944.1009870-4-hch@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 14, 2022 at 05:29:44AM +0100, Christoph Hellwig wrote:
>  blk_crypto_get_keyslot, blk_crypto_put_keyslot, __blk_crypto_evict_key
> and __blk_crypto_cfg_supported are only used internally by the
> blk-crypto code, so move the out of blk-crypto-profile.h, which is
> included by drivers that supply blk-crypto functionality.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-crypto-internal.h        | 12 ++++++++++++
>  include/linux/blk-crypto-profile.h | 12 ------------
>  2 files changed, 12 insertions(+), 12 deletions(-)

With the include of blk-crypto-internal.h in blk-crypto-profile.c added, feel
free to add:

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
