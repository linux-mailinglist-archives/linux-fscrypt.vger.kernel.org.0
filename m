Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309E85FD30C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 13 Oct 2022 03:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJMB4y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 Oct 2022 21:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiJMB4x (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 Oct 2022 21:56:53 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2910212B35F;
        Wed, 12 Oct 2022 18:56:53 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oinSf-00EA0C-D6; Thu, 13 Oct 2022 12:56:38 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Oct 2022 09:56:37 +0800
Date:   Thu, 13 Oct 2022 09:56:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+104c2a89561289cec13e@syzkaller.appspotmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] memory leak in crypto_create_tfm_node
Message-ID: <Y0dwVfoSE4igPtMW@gondor.apana.org.au>
References: <0000000000009aad5e05eac85f36@google.com>
 <Y0aHieBUF+CY2rTT@gondor.apana.org.au>
 <CACT4Y+bATweY=FD-9+FN3nyTjuN7mNy6QM8y6GeSzPdjzo4R-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+bATweY=FD-9+FN3nyTjuN7mNy6QM8y6GeSzPdjzo4R-w@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 12, 2022 at 12:26:09PM +0200, Dmitry Vyukov wrote:
> On Wed, 12 Oct 2022 at 11:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Hi:
> >
> > I presume this is a leak in fscrypt (or perhaps something at an
> > even higher level).
> 
> Eric sent this:
> 
> [PATCH] fscrypt: fix keyring memory leak on mount failure
> https://lore.kernel.org/all/20221011213838.209879-1-ebiggers@kernel.org/

Oh I missed that.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
