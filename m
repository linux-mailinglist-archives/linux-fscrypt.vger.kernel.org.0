Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20896BBCE7
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 20:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjCOTEp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 15:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbjCOTEo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 15:04:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2894535A5;
        Wed, 15 Mar 2023 12:04:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EA65B81F13;
        Wed, 15 Mar 2023 19:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D755C433D2;
        Wed, 15 Mar 2023 19:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678907071;
        bh=06iy3CA39P3hJaqa0g/7wFcg9PPY5DarzvNffa0IpfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OI5z/+6mG+YzpYAnUJiPHZGUppqPlKYkf2krpSYS02LzSdda9NeoXYdqQpVF16HBJ
         UI+uTZB63oVqUI8yDjB/XIDMxsWsmtsBNoLcR3SLHTp/yhpwnJaQ45Qu+j5YYp13cF
         uZwnimu6ycCu1UPHuBGdOhLrSEmZsWqMpF3JFoICI3vxhEl1IGNFy2o2yszfUJgREJ
         WtYSF/U8gDTksqh38eNiDW2QATiOhltA1hOvTc6BAG45hoIp9NK7qoCIlPTq7955ME
         3XypZmvXl25UGvrtTbVfr3/MN5V8P5vdHUXJZbh9dINUhQTGH0ezQ0KSIEC5hGRaM6
         j2UOlgwtbfeIQ==
Date:   Wed, 15 Mar 2023 12:04:29 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: Re: [PATCH v3 5/6] blk-mq: return actual keyslot error in
 blk_insert_cloned_request()
Message-ID: <20230315190429.GE975@sol.localdomain>
References: <20230315183907.53675-1-ebiggers@kernel.org>
 <20230315183907.53675-6-ebiggers@kernel.org>
 <881ec7d4-8169-70f6-2e29-131ca9ca0573@kernel.dk>
 <20230315185418.GD975@sol.localdomain>
 <c930024d-64d8-901d-972b-9786f7803011@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c930024d-64d8-901d-972b-9786f7803011@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Mar 15, 2023 at 12:55:31PM -0600, Jens Axboe wrote:
> On 3/15/23 12:54 PM, Eric Biggers wrote:
> > On Wed, Mar 15, 2023 at 12:50:45PM -0600, Jens Axboe wrote:
> >> On 3/15/23 12:39 PM, Eric Biggers wrote:
> >>> From: Eric Biggers <ebiggers@google.com>
> >>>
> >>> To avoid hiding information, pass on the error code from
> >>> blk_crypto_rq_get_keyslot() instead of always using BLK_STS_IOERR.
> >>
> >> Maybe just fold this with the previous patch?
> > 
> > I'd prefer to keep the behavior change separate from the cleanup.
> 
> OK fair enough, not a big deal to me. Series looks fine as far as
> I'm concerned. Not loving the extra additions in the completion path,
> but I suppose there's no way around that.

Well, my first patch didn't have that:

https://lore.kernel.org/linux-block/20230226203816.207449-1-ebiggers@kernel.org

But it didn't fix the keyslot refcounting work as expected, which Nathan didn't
like (and I agree with that).

- Eric
