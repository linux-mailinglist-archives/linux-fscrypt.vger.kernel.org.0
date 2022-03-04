Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C0E4CCB2A
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Mar 2022 02:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiCDBI3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Mar 2022 20:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiCDBI1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Mar 2022 20:08:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6965F1EC4B;
        Thu,  3 Mar 2022 17:07:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9F0FB826D4;
        Fri,  4 Mar 2022 01:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32781C004E1;
        Fri,  4 Mar 2022 01:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646356057;
        bh=3mi7VxXpLHb5nSJP4Fl9rRCoWjt0fOGvcpAtnS+zlq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SBRmJtsLeS4H3LTufeok6l2thSvNhjLSZ9Ew1WA/am/rFGLUWlyfeJFJCfV/YSLB6
         bQItQUclIp2+767l2tLEmfu0IfMcm2da/qOzDpKWMETA/zYD8VGenf7iyV5mXaHtSv
         yDw6WmWl4VtDwByvDVbG9DonEdEQ/ECVuns96yiQwSR1ATgrwr4wCmGMr5NW625aBE
         XiT9HzQ3cKE8SS+kuHhi+xRhZ85yVaPMw1oJkhOK9l+cocyyqOMm/wA9KSONmhBEee
         XPSNveb4J1euzOTOslg/FUhbm2GUsBe0N8LdHVe/q5n53c2ciGDQf+qngwkVABSnjz
         SPVIgosHLj//A==
Date:   Fri, 4 Mar 2022 01:07:35 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Israel Rukshin <israelr@nvidia.com>
Subject: Re: [PATCH v5 1/3] block: add basic hardware-wrapped key support
Message-ID: <YiFmV+WXY+mKsM83@gmail.com>
References: <20220228070520.74082-1-ebiggers@kernel.org>
 <20220228070520.74082-2-ebiggers@kernel.org>
 <ac499ff9-eeb4-4f25-bb59-3f37477190ed@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac499ff9-eeb4-4f25-bb59-3f37477190ed@acm.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 03, 2022 at 04:53:56PM -0800, Bart Van Assche wrote:
> On 2/27/22 23:05, Eric Biggers wrote:
> > @@ -68,7 +71,10 @@ static int __init bio_crypt_ctx_init(void)
> >   	/* Sanity check that no algorithm exceeds the defined limits. */
> >   	for (i = 0; i < BLK_ENCRYPTION_MODE_MAX; i++) {
> > -		BUG_ON(blk_crypto_modes[i].keysize > BLK_CRYPTO_MAX_KEY_SIZE);
> > +		BUG_ON(blk_crypto_modes[i].keysize >
> > +		       BLK_CRYPTO_MAX_STANDARD_KEY_SIZE);
> > +		BUG_ON(blk_crypto_modes[i].security_strength >
> > +		       blk_crypto_modes[i].keysize);
> >   		BUG_ON(blk_crypto_modes[i].ivsize > BLK_CRYPTO_MAX_IV_SIZE);
> >   	}
> 
> Does the following advice from Linus Torvalds apply to the above code:
> "because there is NO EXCUSE to knowingly kill the kernel"? See also
> https://lkml.org/lkml/2016/10/4/1.

These are boot time checks, so the advice doesn't apply.  If the code is buggy
here, then kernels with CONFIG_BLK_INLINE_ENCRYPTION enabled won't boot.  I
would prefer compile-time checks, of course, but that isn't possible here.  This
is the next best thing.

- Eric
