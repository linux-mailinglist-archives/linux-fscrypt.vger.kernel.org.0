Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78BCE4C3C2
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 00:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfFSWhO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jun 2019 18:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfFSWhO (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jun 2019 18:37:14 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41C39215EA;
        Wed, 19 Jun 2019 22:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560983833;
        bh=7+Xk6jM1swrTvpZVNL3BFK9YYli9gbq2RRURsP3i9Rs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DHXGsRof2r9UQuUm4dZLiBOni5/eVdITgvyd+JYMYPVTNdcKY9XNj73BqIL7hk04t
         xCGAu1FHPGiAzlfHHiUQgSmT8B9trWf739BKVVktDhoLEyGTI3FMBlUMiLt/8c6tNC
         V3ySfHm4ThvmVAx6lYQS3Y+9t6jqnfkjk8lGPkTs=
Date:   Wed, 19 Jun 2019 15:37:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v3 6/6] crypto: arm64/aes - implement accelerated
 ESSIV/CBC mode
Message-ID: <20190619223710.GC33328@gmail.com>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-7-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619162921.12509-7-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

I'm not sure we should bother with this, since fscrypt normally uses AES-256-XTS
for contents encryption.  AES-128-CBC-ESSIV support was only added because
people wanted something that is fast on low-powered embedded devices with crypto
accelerators such as CAAM or CESA that don't support XTS.

In the case of Android, the CDD doesn't even allow AES-128-CBC-ESSIV with
file-based encryption (fscrypt).  It's still the default for "full disk
encryption" (which uses dm-crypt), but that's being deprecated.

So maybe dm-crypt users will want this, but I don't think it's very useful for
fscrypt.

- Eric
