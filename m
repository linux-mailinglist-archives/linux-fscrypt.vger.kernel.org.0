Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1AD7335B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jul 2019 18:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfGXQHO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 12:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbfGXQHN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 12:07:13 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1443D21850;
        Wed, 24 Jul 2019 16:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563984433;
        bh=96FrxNUCXMvPogW3TwPyyX6qG00JpbqSZqT2kyR9gdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m8T+w3Zz3mHDzPZOVJL0jgJ6TYRTby1WvDsg8LPEhI5rWbN/NQFaOz1wpdVMAGvkI
         jDEIalJDJWvBEK95Gbdt17sFToFIFRVzb94JsjkqDnV/KlqPgPkY+E+qARKeJYiwNy
         K9VZLZDnOtG9A0HuNX1ZeRl5TFoR1QUps2bvI17k=
Date:   Wed, 24 Jul 2019 09:07:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] fs: crypto: keyinfo: Fix a possible null-pointer
 dereference in derive_key_aes()
Message-ID: <20190724160711.GB673@sol.localdomain>
Mail-Followup-To: Jia-Ju Bai <baijiaju1990@gmail.com>, tytso@mit.edu,
        jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20190724100204.2009-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724100204.2009-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[+Cc linux-crypto]

On Wed, Jul 24, 2019 at 06:02:04PM +0800, Jia-Ju Bai wrote:
> In derive_key_aes(), tfm is assigned to NULL on line 46, and then
> crypto_free_skcipher(tfm) is executed.
> 
> crypto_free_skcipher(tfm)
>     crypto_skcipher_tfm(tfm)
>         return &tfm->base;
> 
> Thus, a possible null-pointer dereference may occur.

This analysis is incorrect because only the address &tfm->base is taken.
There's no pointer dereference.

In fact all the crypto_free_*() functions are no-ops on NULL pointers, and many
other callers rely on it.  So there's no bug here.

It appears you've sent the same patch for some of these other callers
(https://lore.kernel.org/lkml/?q=%22fix+a+possible+null-pointer%22), but none
are Cc'ed to linux-crypto or another mailing list I'm subscribed to, so I can't
respond to them.  But this feedback applies equally to them too.

Note also that if there actually were a bug here (which again, there doesn't
appear to be), we'd need to fix it in crypto_free_*(), not in the callers.

- Eric
