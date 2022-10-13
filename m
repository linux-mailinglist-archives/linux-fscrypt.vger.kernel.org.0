Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCAB5FD465
	for <lists+linux-fscrypt@lfdr.de>; Thu, 13 Oct 2022 07:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJMF7T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 13 Oct 2022 01:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiJMF7E (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 13 Oct 2022 01:59:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5D612B342;
        Wed, 12 Oct 2022 22:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30EE2616E9;
        Thu, 13 Oct 2022 05:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF91C433C1;
        Thu, 13 Oct 2022 05:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665640742;
        bh=DK64fl751xVY8Ub8Pzwk0LwN2a/+JSruWUsDadJ0ANk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vi/Mg5di5NC3MyXp+85YQfB/46sEBKlvxvTO6WHWlGUy+yuktgN+kKPbLRhdYMun6
         s1pmi1xwUbvsJmBKCwz+q7vO5gsUSw32g2NDRUJJME23LY6t3NkHP0lbQy7iDEcaGk
         qRuYjAJXSq4a1IEHdyO9z5W9VdSRCWnzYGIgRXBK2WiOg7TYTakkyxu8TbxgGuiiG2
         +etiyAmuQR1KfN0n1cwhiNajj73CleaXfNDU1nTLWKZrf3dp/8knkd1WgGgkByE1D6
         xAm8wluSM9K92pgS7m+5BU/4sneI4v5aqqH8kBQa/K7QSC1E5iFs1aAe3GKK215Ied
         IpylxptBEAlEg==
Date:   Wed, 12 Oct 2022 22:59:00 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+104c2a89561289cec13e@syzkaller.appspotmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] memory leak in crypto_create_tfm_node
Message-ID: <Y0epJNEHusJWKE51@sol.localdomain>
References: <0000000000009aad5e05eac85f36@google.com>
 <Y0aHieBUF+CY2rTT@gondor.apana.org.au>
 <CACT4Y+bATweY=FD-9+FN3nyTjuN7mNy6QM8y6GeSzPdjzo4R-w@mail.gmail.com>
 <Y0dwVfoSE4igPtMW@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0dwVfoSE4igPtMW@gondor.apana.org.au>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 13, 2022 at 09:56:37AM +0800, Herbert Xu wrote:
> On Wed, Oct 12, 2022 at 12:26:09PM +0200, Dmitry Vyukov wrote:
> > On Wed, 12 Oct 2022 at 11:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > Hi:
> > >
> > > I presume this is a leak in fscrypt (or perhaps something at an
> > > even higher level).
> > 
> > Eric sent this:
> > 
> > [PATCH] fscrypt: fix keyring memory leak on mount failure
> > https://lore.kernel.org/all/20221011213838.209879-1-ebiggers@kernel.org/
> 
> Oh I missed that.
> 
> Thanks,

Yes, and I used 'git format-patch --in-reply-to=$messageId' with the message ID
of the syzbot email, so it should show up in this same thread.

- Eric
