Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5BE6BBCC0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 19:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCOSy0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 14:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbjCOSy0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 14:54:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D5C64B14;
        Wed, 15 Mar 2023 11:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4319B81F12;
        Wed, 15 Mar 2023 18:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C459C433D2;
        Wed, 15 Mar 2023 18:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678906460;
        bh=ee5kTehngzPfOByeAW7UeXzrlRNEHMzeqzVzMB4Tf+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FVNtibesEOiYqrE8UzEsPaqPWnem1H2pwjrr5EZSASfSOkGnh07BAe4C5j7Ix7h6N
         27974gyL4BhS1CuAgt5pkK70uk4R9S3yMsIamK2FgYWv3GdIsbpjF0YpQDpR8OX7pg
         xDChw+3eN9BUSa9AW7y94hon/pFv6Di0c+plkO5hMSNG9gQv06e+sA/CwMdC00m3B4
         6qU1xQ7Cp6sHOX7t8D4yWOYObzbDm2Qf01EUq8WNx+m7InaHkHoN6HJwTWPpUnRckf
         qV0bTt+TtOGgNU9iSzXKtcqweOzDZKMrtYgtK+y6GpIIhDziXpPrriQzSv0xSykeu7
         Z04P4h0NOQKzg==
Date:   Wed, 15 Mar 2023 11:54:18 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: Re: [PATCH v3 5/6] blk-mq: return actual keyslot error in
 blk_insert_cloned_request()
Message-ID: <20230315185418.GD975@sol.localdomain>
References: <20230315183907.53675-1-ebiggers@kernel.org>
 <20230315183907.53675-6-ebiggers@kernel.org>
 <881ec7d4-8169-70f6-2e29-131ca9ca0573@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <881ec7d4-8169-70f6-2e29-131ca9ca0573@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Mar 15, 2023 at 12:50:45PM -0600, Jens Axboe wrote:
> On 3/15/23 12:39 PM, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > To avoid hiding information, pass on the error code from
> > blk_crypto_rq_get_keyslot() instead of always using BLK_STS_IOERR.
> 
> Maybe just fold this with the previous patch?

I'd prefer to keep the behavior change separate from the cleanup.

- Eric
