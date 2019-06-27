Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A567958723
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jun 2019 18:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfF0QcY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jun 2019 12:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfF0QcY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jun 2019 12:32:24 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 256742133F;
        Thu, 27 Jun 2019 16:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561653143;
        bh=l+tpA8pTSE7U2Xt092Cu2tDM10p0PpnM8sLMPlQKFsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lUjg23UCBQQEqIOZnF8gvrMMj8kB7OF23AlJoJG1+1WZMSXu61OilQF2cqiaIDcff
         Gu6WhfcS4pR1m17ItBlI9zulFWiLYv7Pym6PrNQjANgtCjF3SEXBb21iQBj8bIl5gO
         dpyjyl71HNu2mF0UYpdRkLg0suGaUq742fuZz5WA=
Date:   Thu, 27 Jun 2019 09:32:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v5 5/7] crypto: essiv - add test vector for
 essiv(cbc(aes),aes,sha256)
Message-ID: <20190627163221.GC686@sol.localdomain>
References: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
 <20190626204047.32131-6-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626204047.32131-6-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 26, 2019 at 10:40:45PM +0200, Ard Biesheuvel wrote:
> Add a test vector for the ESSIV mode that is the most widely used,
> i.e., using cbc(aes) and sha256.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/tcrypt.c  |   9 +
>  crypto/testmgr.c |   6 +
>  crypto/testmgr.h | 213 ++++++++++++++++++++
>  3 files changed, 228 insertions(+)

Shouldn't there be an authenc test vector too?  Otherwise there will be no way
to test the AEAD support in essiv.c using the crypto self-tests.

- Eric
