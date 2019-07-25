Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F254C7440B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Jul 2019 05:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389971AbfGYDkI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 23:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389704AbfGYDkI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 23:40:08 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F2B216F4;
        Thu, 25 Jul 2019 03:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564026006;
        bh=9BMauwEy1lGIJ9pUkmok8zRfXwbOeUrTUzWPT9b+bsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZQQBfNWmB3OCie57T2P6IO8YyrX+334Ql5pYpHjLHfQave82AuHEGJ4eFdEbDFUWw
         kM6y05VA3zfnppuA8VXfrbriUHLw/BzVU6BPuxhbwM0jaLEs5MgBubJb7+fe8VIjop
         vURvdDecRFjdfm+pFz7S3zVJNqwAvq8i6q81GuLM=
Date:   Wed, 24 Jul 2019 20:39:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] fs: crypto: keyinfo: Fix a possible null-pointer
 dereference in derive_key_aes()
Message-ID: <20190725033951.GA677@sol.localdomain>
Mail-Followup-To: Jia-Ju Bai <baijiaju1990@gmail.com>, tytso@mit.edu,
        jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20190724100204.2009-1-baijiaju1990@gmail.com>
 <20190724160711.GB673@sol.localdomain>
 <3d206c43-994e-6134-3f28-b4a500472760@gmail.com>
 <9740973d-6e59-e4df-7097-4e5d0da89235@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9740973d-6e59-e4df-7097-4e5d0da89235@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 25, 2019 at 11:33:53AM +0800, Jia-Ju Bai wrote:
> Sorry, I forgot to send to Eric, so send it again.
> 
> On 2019/7/25 11:30, Jia-Ju Bai wrote:
> > 
> > 
> > On 2019/7/25 0:07, Eric Biggers wrote:
> > > [+Cc linux-crypto]
> > > 
> > > On Wed, Jul 24, 2019 at 06:02:04PM +0800, Jia-Ju Bai wrote:
> > > > In derive_key_aes(), tfm is assigned to NULL on line 46, and then
> > > > crypto_free_skcipher(tfm) is executed.
> > > > 
> > > > crypto_free_skcipher(tfm)
> > > >      crypto_skcipher_tfm(tfm)
> > > >          return &tfm->base;
> > > > 
> > > > Thus, a possible null-pointer dereference may occur.
> > > This analysis is incorrect because only the address &tfm->base is taken.
> > > There's no pointer dereference.
> > > 
> > > In fact all the crypto_free_*() functions are no-ops on NULL
> > > pointers, and many
> > > other callers rely on it.  So there's no bug here.
> > 
> > Thanks for the reply :)
> > I admit that "&tfm->base" is not a null-pointer dereference when tfm is
> > NULL.
> > But I still think crypto_free_skcipher(tfm) can cause security problems
> > when tfm is NULL.
> > 
> > Looking at the code:
> > 
> > static inline void crypto_free_skcipher(struct crypto_skcipher *tfm)
> > {
> >     crypto_destroy_tfm(tfm, crypto_skcipher_tfm(tfm));
> > }
> > 
> > static inline struct crypto_tfm *crypto_skcipher_tfm(
> >     struct crypto_skcipher *tfm)
> > {
> >     return &tfm->base;
> > }
> > 
> > void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
> > {
> >     struct crypto_alg *alg;
> > 
> >     if (unlikely(!mem))
> >         return;

When the original pointer is NULL, mem == NULL here so crypto_destroy_tfm() is a
no-op.

> > Besides, I also find that some kernel modules check tfm before calling
> > crypto_free_*(), such as:
> > 
> > drivers/crypto/vmx/aes_xts.c:
> >     if (ctx->fallback) {
> >         crypto_free_skcipher(ctx->fallback);
> >         ctx->fallback = NULL;
> >     }
> > 
> > net/rxrpc/rxkad.c:
> >     if (conn->cipher)
> >         crypto_free_skcipher(conn->cipher);
> > 
> > drivers/crypto/chelsio/chcr_algo.c:
> >     if (ablkctx->aes_generic)
> >         crypto_free_cipher(ablkctx->aes_generic);
> > 
> > net/mac80211/wep.c:
> >     if (!IS_ERR(local->wep_tx_tfm))
> >         crypto_free_cipher(local->wep_tx_tfm);
> > 

Well, people sometimes do that for kfree() too.  But that doesn't mean it's
needed, or that it's the preferred style (it's not).

- Eric
