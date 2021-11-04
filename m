Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADA9445CA7
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Nov 2021 00:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhKDXe0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Nov 2021 19:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhKDXe0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Nov 2021 19:34:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56CDE61056;
        Thu,  4 Nov 2021 23:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636068707;
        bh=mfqQWG4k4Emm7i4Vymspp+T+fdvYq6LE0sU05GFqLy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SREA5ZIZ4vZAKM8XEJfUkCVw//9HSbFzFz8MzQtauK0HXobvCDYzCneeIxlEsRFLp
         Pak9moEWqPo0pRZsUiNjacgY7KJiD2y+HwotwLC9LvhHeiiINa44RTA7ScT9gOL2Cp
         SQsNE9DH2ABZ42j5F2Zz8v0WksmhFJZ/xe6z2s+Q2o8J5aKT4AdjR8wd2dEXY9S+wU
         rXVjNbXhT0xTBcGHEGaCroO1ATNvbQdH0icW5lxUyKNHgibYymYe/aduY6NWtOKBnQ
         0VnfQiejOMx4EdpiGcV0wOP1kO4zIKuXH87Ohs8yS6x8cu1IdUNX8w4G2rf+/fTSIJ
         NSxuK9rg9KQ1Q==
Date:   Thu, 4 Nov 2021 16:31:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        asutoshd@codeaurora.org
Subject: Re: [PATCH 2/4] qcom_scm: scm call for deriving a software secret
Message-ID: <YYRtYcHMav42zwTR@gmail.com>
References: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
 <20211103231840.115521-3-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103231840.115521-3-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 03, 2021 at 04:18:38PM -0700, Gaurav Kashyap wrote:
> 
> However, when keys are hardware wrapped, it can be only unwrapped
> by Qualcomm Trustzone.

Qualcomm Trustzone is software.  There is a mode where it passes the key to the
actual HWKM hardware as intended, right?

> +/**
> + * qcom_scm_derive_sw_secret() - Derive SW secret from wrapped encryption key
> + * @wrapped_key: the wrapped key used for inline encryption
> + * @wrapped_key_size: size of the wrapped key
> + * @sw_secret: the secret to be derived
> + * @secret_size: size of the secret derived

Please make the semantics of the @secret_size parameter clear.  Will the output
be at least @secret_size, exactly @secret_size, or at most @secret_size?

> + *
> + * Derive a SW secret to be used for inline encryption using Qualcomm ICE.
> + *
> + * Generally, for non-wrapped keys, fscrypt can derive a sw secret from the
> + * key in the clear in the linux keyring.
> + *
> + * However, for wrapped keys, the key needs to be unwrapped, which can be done
> + * only by the secure EE. So, it makes sense for the secure EE to derive the
> + * sw secret and return to the kernel when wrapped keys are used.

It's sort of a layering violation to mention fscrypt here, as this is low-level
driver code.  fscrypt is just an example user.  I recommend documenting this in
more general terms, and maybe referring to the "Hardware-wrapped keys" section
of Documentation/block/inline-encryption.rst (which my patchset adds) as that is
intended to explain derive_sw_secret already.

> +int qcom_scm_derive_sw_secret(const u8* wrapped_key, u32 wrapped_key_size,
> +			      u8 *sw_secret, u32 secret_size)
> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd =  QCOM_SCM_ES_DERIVE_RAW_SECRET,
> +		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RW,

wrapped_key is const.  Should it use QCOM_SCM_RO instead of QCOM_SCM_RW?

> +	keybuf = dma_alloc_coherent(__scm->dev, wrapped_key_size, &key_phys,
> +				    GFP_KERNEL);
> +	if (!keybuf)
> +		return -ENOMEM;
> +	secretbuf = dma_alloc_coherent(__scm->dev, secret_size, &secret_phys,
> +				    GFP_KERNEL);
> +	if (!secretbuf)
> +		return -ENOMEM;

In the '!secretbuf' case, this leaks 'keybuf'.

Also, my understanding is that the use of dma_alloc_coherent() here is a bit
unusual.  It would be helpful to leave a comment like:

	/*
	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
	 * get a physical address, while guaranteeing that we can zeroize the
	 * key material later using memzero_explicit().
	 */

> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +	memcpy(sw_secret, secretbuf, secret_size);

This is copying out the data even if the SCM call failed.

> diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
> index d92156ceb3ac..de5d4f8fd20d 100644
> --- a/drivers/firmware/qcom_scm.h
> +++ b/drivers/firmware/qcom_scm.h
> @@ -110,6 +110,7 @@ extern int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
>  #define QCOM_SCM_SVC_ES			0x10	/* Enterprise Security */
>  #define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
>  #define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
> +#define QCOM_SCM_ES_DERIVE_RAW_SECRET 0x07

Can this be renamed to DERIVE_SW_SECRET?

If not, then you probably should call the function qcom_scm_derive_raw_secret()
instead of qcom_scm_derive_sw_secret(), since the functions in qcom_scm.c are
intended to be thin wrappers around the SCM calls.  The naming difference can be
dealt with at a higher level.

- Eric
