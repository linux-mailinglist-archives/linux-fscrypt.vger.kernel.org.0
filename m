Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC85862B1B0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Nov 2022 04:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiKPDKy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Nov 2022 22:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiKPDKy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Nov 2022 22:10:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7155625E88;
        Tue, 15 Nov 2022 19:10:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C330B81BB1;
        Wed, 16 Nov 2022 03:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D655C433C1;
        Wed, 16 Nov 2022 03:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668568248;
        bh=2OOvndA+O2pI98Z9bUzvRHZsKKydt/X6wmEUlnKLYvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M4Unpo8Zanqrb6eUEnMZKwHuUTmscVmaPsmf1GfCpd4EaS9IKvbFuUSmUhNZrtQkN
         b4wgNDfXLf6293r9cEgbb0Pp+rAzbOAxvPS/C62kp392fgFjDquMISqsAMmmD/znqa
         9P98AAYFV3IZAoS5vl3hBOpKOhFxAAmi9r5da3HupxsmLGS9dipAFfOMSocJCizwAz
         0+I+xoDk0hwcKSQeEs1Q03LwWm1/R8fU+4rphaXKB4J4cYtLtbcP9RxLRZUVk2I2WU
         NguIVEntyLPM3lCJbJfsFTwqwl8XzEC0vNWb1BrRrLsoBxqeCzhIbsgJCI1wCyPrTW
         FNN/6hZ/1FArA==
Date:   Tue, 15 Nov 2022 19:10:46 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/3] blk-crypto: don't use struct request_queue for
 public interfaces
Message-ID: <Y3RUtg9s+MeXi+Y1@sol.localdomain>
References: <20221114042944.1009870-1-hch@lst.de>
 <20221114042944.1009870-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114042944.1009870-2-hch@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 14, 2022 at 05:29:42AM +0100, Christoph Hellwig wrote:
> Switch all public blk-crypto interfaces to use struct block_device
> arguments to specify the device they operate on instead of th
> request_queue, which is a block layer implementation detail.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
