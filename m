Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73C256174
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Jun 2019 06:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbfFZEdB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Jun 2019 00:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbfFZEdA (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Jun 2019 00:33:00 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 253BB208CB;
        Wed, 26 Jun 2019 04:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561523580;
        bh=3PdvR/W1Y+BNMIHVbN36FKlI1rUa2DPI/1eDMQbjv8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1HpUyhZF/g2+1AwBJ/Q3r2KL5OP074wNQaFJ7YN6Pjsl7HeJO+WKm1Jbl5Qq6LImh
         ir0f/NK6X658XY6eQNLHIrQKm0WJiqiZB61JPRkntGT/wdTQRQo1LC5G8l9U01WKCl
         o6ZmvGs7Pzqi+XCPp/uj/ERWO9xD+Y4hjb/LUM5U=
Date:   Tue, 25 Jun 2019 21:32:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v3 6/6] crypto: arm64/aes - implement accelerated
 ESSIV/CBC mode
Message-ID: <20190626043258.GA23471@sol.localdomain>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-7-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619162921.12509-7-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 19, 2019 at 06:29:21PM +0200, Ard Biesheuvel wrote:
> Add an accelerated version of the 'essiv(cbc(aes),aes,sha256)'
> skcipher, which is used by fscrypt, and in some cases, by dm-crypt.
> This avoids a separate call into the AES cipher for every invocation.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This patch causes a self-tests failure:

[   26.787681] alg: skcipher: essiv-cbc-aes-sha256-neon encryption test failed (wrong result) on test vector 1, cfg="two even aligned splits"

- Eric
