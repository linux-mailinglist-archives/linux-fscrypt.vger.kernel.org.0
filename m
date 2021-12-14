Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D5A4739C7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Dec 2021 01:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244523AbhLNAxu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Dec 2021 19:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbhLNAxt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Dec 2021 19:53:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2A5C061574;
        Mon, 13 Dec 2021 16:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79E97B8122A;
        Tue, 14 Dec 2021 00:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33D0C34600;
        Tue, 14 Dec 2021 00:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639443226;
        bh=NUueBP/VQKH6a8DQwX5d4UQ6rC+VsJnl6SBcExqoP8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eocpukJGil5y40M1Tyytsu5840uWKhudl6vs/9OhwkhyorGXYZ7NrC2zWBjznUV9z
         OXvr9AUWNYFL01i61DFZ7CtpVHQGwxQT/JM3NTngSZQXqf6M24cMJ87ajqlJOiQzcQ
         O0CDQhVXU9pFdwp3ZiBuWNGdM/Y2DBtxIgGCDFi4AIunBBW6K1ynI7bunXPYmYd/Az
         vaT+Q8RBL8ucUoXJe3H55zeI9e0YzlMNDF9yaZZ/25h1nhrJKNKzligXGrSKUlW2lY
         iYVSN0QZTGt8+wBLhCJ5K8QsTp/S5Lh/0OOJXRYIeCfiplwmXr9sFtfCthyWveZbRZ
         wVb/Ped2w1Gug==
Date:   Mon, 13 Dec 2021 16:53:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        quic_neersoni@quicinc.com, dineshg@quicinc.com
Subject: Re: [PATCH 03/10] qcom_scm: scm call for deriving a software secret
Message-ID: <YbfrGNIogV0diME/@gmail.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <20211206225725.77512-4-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206225725.77512-4-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 06, 2021 at 02:57:18PM -0800, Gaurav Kashyap wrote:
> Storage encryption requires fscrypt deriving a sw secret from

As I mentioned on the previous version of this patchset, I think mentions of
"fscrypt" should generally be avoided at the driver level.  Drivers don't know
or care who is using block layer functionality.  It's better to think of the
sw_secret support as simply one of the requirements for hardware-wrapped keys,
alongside the other ones such as support for import_key, prepare_key, etc.

> +/**
> + * qcom_scm_derive_sw_secret() - Derive SW secret from wrapped encryption key
> + * @wrapped_key: the wrapped key used for inline encryption
> + * @wrapped_key_size: size of the wrapped key
> + * @sw_secret: the secret to be derived which is at most the secret size
> + * @secret_size: maximum size of the secret that is derived
> + *
> + * Derive a SW secret to be used for inline encryption using Qualcomm ICE.

The SW secret isn't used for inline encryption.  It's actually the opposite; the
SW secret is used only for tasks that can't use inline encryption.

> + * For wrapped keys, the key needs to be unwrapped, in order to derive a
> + * SW secret, which can be done only by the secure EE. So, it makes sense
> + * for the secure EE to derive the sw secret and return to the kernel when
> + * wrapped keys are used.

The second sentence above seems to be saying the same as the first.

> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_derive_sw_secret(const u8 *wrapped_key, u32 wrapped_key_size,
> +			      u8 *sw_secret, u32 secret_size)

Is @secret_size really the "maximum size of the secret that is derived"?  That
would imply that a shorter secret might be derived.  But if the return value is
0 on success, then there is no way for callers to know what length was derived.

Can't the semantics be "derive exactly secret_size bytes"?  That would make much
more sense.

> diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
> index c0475d1c9885..ccd764bdc357 100644
> --- a/include/linux/qcom_scm.h
> +++ b/include/linux/qcom_scm.h
> @@ -103,6 +103,9 @@ extern int qcom_scm_ice_invalidate_key(u32 index);
>  extern int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
>  				enum qcom_scm_ice_cipher cipher,
>  				u32 data_unit_size);
> +extern int qcom_scm_derive_sw_secret(const u8 *wrapped_key,
> +				     u32 wrapped_key_size, u8 *sw_secret,
> +				     u32 secret_size);
>  
>  extern bool qcom_scm_hdcp_available(void);
>  extern int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
> @@ -169,6 +172,9 @@ static inline int qcom_scm_ice_invalidate_key(u32 index) { return -ENODEV; }
>  static inline int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
>  				       enum qcom_scm_ice_cipher cipher,
>  				       u32 data_unit_size) { return -ENODEV; }
> +static inline int qcom_scm_derive_sw_secret(const u8 *wrapped_key,
> +					u32 wrapped_key_size, u8 *sw_secret,
> +					u32 secret_size) { return -ENODEV; }
>  
>  static inline bool qcom_scm_hdcp_available(void) { return false; }
>  static inline int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,

These "return -ENODEV" stubs don't exist in the latest kernel.  Can you make
sure that you've developing on top of the latest kernel?  It looks like you
based this patchset on top of my patchset
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git/log/?h=wrapped-keys-v2.
But I had already sent out a newer version of it, based on v5.16-rc1:
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git/log/?h=wrapped-keys-v4.
So please make sure you're using the most recent version.

- Eric
