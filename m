Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EA61FC657
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Jun 2020 08:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgFQGsY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Jun 2020 02:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgFQGsX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Jun 2020 02:48:23 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDCFC061755
        for <linux-fscrypt@vger.kernel.org>; Tue, 16 Jun 2020 23:48:23 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id v13so783964otp.4
        for <linux-fscrypt@vger.kernel.org>; Tue, 16 Jun 2020 23:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eUDSD6z6rPH0CReES0Wf0V4zppIWRjMIWkdDaKPcoe4=;
        b=oBAB7SlLC6G9XCadbh6agjeaubv5miRZ4A7qOr7fJzW+IGL0agM1hSLaEXMm0fwq+P
         czHMu4iQNOIGOKb5Ng34Xn6o+qYHhGTs40WKCBORE+6bWQL5Mr9JT1CyFpt3fDj2wC/H
         OM2U84GCRsQZz99YUyFO5O7Hy1Q2BGYfjW0/xZBqHxQ94rQKGILDgKaMhjUSgrUrNhFP
         ClqY505KCO5/fOQwvPzQKyyWhWWjGFhp/nflqlU93p2GlZ96+vfhUy1+A5aLjAvB252t
         +pX54qga2hHsGUc3HycYEej26ZjKS6w6Y8snR7f0llU4/ReY7VajuuIrfN37gffCx8lh
         bWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eUDSD6z6rPH0CReES0Wf0V4zppIWRjMIWkdDaKPcoe4=;
        b=CTgjgwEkXIchCiREPcJXeTPaARpdNjfg5nsRfMI43bYV3y29z7xbWUmXWaO59rYkLK
         xOrJh6FzfjD6E3ytMzweuM3dwXgMvVBO8y1LSk9+k+GPVUI/RNiYws/hj1GMuOD8NEYY
         YELtk1J+pDSfZt1n2LA7QghfLJm+o68BkbCQFSpUpJQ6FGd88awv5OVId5n1WGC+TsHY
         rxJKUpE6RV0+ZUFf8hYtdu8tkrrzynvWP1u2vDI6SOCSCLMvuXklyAUj1BalHrNMp8xv
         2g1/2MOZr5CdphewpR+HZ5cY678dccPWAs10LmBhnrQTUBeDJwUV3PUOgHGzLJL3/40v
         rALg==
X-Gm-Message-State: AOAM533rmGvj7s9A7DL1xW6rgiWqJovq5tBgzG7SODOPeH22XIWrWphx
        H9DXuCRUMGkRiK5Yb+y6TzHuvA==
X-Google-Smtp-Source: ABdhPJzhXNxnWAfZ5ITiZG0bsUWWR1kLvJdkRGUYGyKerqr8WAdOj3reUJLA8mUAtlbam1MOx/CdpA==
X-Received: by 2002:a05:6830:1e61:: with SMTP id m1mr5299019otr.42.1592376502256;
        Tue, 16 Jun 2020 23:48:22 -0700 (PDT)
Received: from yoga (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id g2sm4722635otq.9.2020.06.16.23.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 23:48:21 -0700 (PDT)
Date:   Tue, 16 Jun 2020 23:48:19 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [RFC PATCH v4 1/4] firmware: qcom_scm: Add support for
 programming inline crypto keys
Message-ID: <20200617064819.GF11847@yoga>
References: <20200501045111.665881-1-ebiggers@kernel.org>
 <20200501045111.665881-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501045111.665881-2-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu 30 Apr 21:51 PDT 2020, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> Add support for the Inline Crypto Engine (ICE) key programming interface
> that's needed for the ufs-qcom driver to use inline encryption on
> Snapdragon SoCs.  This interface consists of two SCM calls: one to
> program a key into a keyslot, and one to invalidate a keyslot.
> 
> Although the UFS specification defines a standard way to do this, on
> these SoCs the Linux kernel isn't permitted to access the needed crypto
> configuration registers directly; these SCM calls must be used instead.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/firmware/qcom_scm.c | 101 ++++++++++++++++++++++++++++++++++++
>  drivers/firmware/qcom_scm.h |   4 ++
>  include/linux/qcom_scm.h    |  19 +++++++
>  3 files changed, 124 insertions(+)
> 
> diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
> index 059bb0fbae9e5b..646f9613393612 100644
> --- a/drivers/firmware/qcom_scm.c
> +++ b/drivers/firmware/qcom_scm.c
> @@ -926,6 +926,107 @@ int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size)
>  }
>  EXPORT_SYMBOL(qcom_scm_ocmem_unlock);
>  
> +/**
> + * qcom_scm_ice_available() - Is the ICE key programming interface available?
> + *
> + * Return: true iff the SCM calls wrapped by qcom_scm_ice_invalidate_key() and
> + *	   qcom_scm_ice_set_key() are available.
> + */
> +bool qcom_scm_ice_available(void)
> +{
> +	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
> +					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
> +		__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
> +					     QCOM_SCM_ES_CONFIG_SET_ICE_KEY);
> +}
> +EXPORT_SYMBOL(qcom_scm_ice_available);
> +
> +/**
> + * qcom_scm_ice_invalidate_key() - Invalidate an inline encryption key
> + * @index: the keyslot to invalidate
> + *
> + * The UFSHCI standard defines a standard way to do this, but it doesn't work on
> + * these SoCs; only this SCM call does.
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_ice_invalidate_key(u32 index)
> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd = QCOM_SCM_ES_INVALIDATE_ICE_KEY,
> +		.arginfo = QCOM_SCM_ARGS(1),
> +		.args[0] = index,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +
> +	return qcom_scm_call(__scm->dev, &desc, NULL);
> +}
> +EXPORT_SYMBOL(qcom_scm_ice_invalidate_key);
> +
> +/**
> + * qcom_scm_ice_set_key() - Set an inline encryption key
> + * @index: the keyslot into which to set the key
> + * @key: the key to program
> + * @key_size: the size of the key in bytes
> + * @cipher: the encryption algorithm the key is for
> + * @data_unit_size: the encryption data unit size, i.e. the size of each
> + *		    individual plaintext and ciphertext.  Given in 512-byte
> + *		    units, e.g. 1 = 512 bytes, 8 = 4096 bytes, etc.
> + *
> + * Program a key into a keyslot of Qualcomm ICE (Inline Crypto Engine), where it
> + * can then be used to encrypt/decrypt UFS I/O requests inline.
> + *
> + * The UFSHCI standard defines a standard way to do this, but it doesn't work on
> + * these SoCs; only this SCM call does.
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
> +			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size)
> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd = QCOM_SCM_ES_CONFIG_SET_ICE_KEY,
> +		.arginfo = QCOM_SCM_ARGS(5, QCOM_SCM_VAL, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL, QCOM_SCM_VAL,
> +					 QCOM_SCM_VAL),
> +		.args[0] = index,
> +		.args[2] = key_size,
> +		.args[3] = cipher,
> +		.args[4] = data_unit_size,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +	void *keybuf;
> +	dma_addr_t key_phys;
> +	int ret;
> +
> +	/*
> +	 * 'key' may point to vmalloc()'ed memory, but we need to pass a
> +	 * physical address that's been properly flushed.  The sanctioned way to
> +	 * do this is by using the DMA API.  But as is best practice for crypto
> +	 * keys, we also must wipe the key after use.  This makes kmemdup() +
> +	 * dma_map_single() not clearly correct, since the DMA API can use
> +	 * bounce buffers.  Instead, just use dma_alloc_coherent().  Programming
> +	 * keys is normally rare and thus not performance-critical.
> +	 */
> +
> +	keybuf = dma_alloc_coherent(__scm->dev, key_size, &key_phys,
> +				    GFP_KERNEL);
> +	if (!keybuf)
> +		return -ENOMEM;
> +	memcpy(keybuf, key, key_size);
> +	desc.args[1] = key_phys;
> +
> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +
> +	memzero_explicit(keybuf, key_size);
> +
> +	dma_free_coherent(__scm->dev, key_size, keybuf, key_phys);
> +	return ret;
> +}
> +EXPORT_SYMBOL(qcom_scm_ice_set_key);
> +
>  /**
>   * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
>   *
> diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
> index d9ed670da222c8..38ea614d29fea2 100644
> --- a/drivers/firmware/qcom_scm.h
> +++ b/drivers/firmware/qcom_scm.h
> @@ -103,6 +103,10 @@ extern int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
>  #define QCOM_SCM_OCMEM_LOCK_CMD		0x01
>  #define QCOM_SCM_OCMEM_UNLOCK_CMD	0x02
>  
> +#define QCOM_SCM_SVC_ES			0x10	/* Enterprise Security */
> +#define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
> +#define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
> +
>  #define QCOM_SCM_SVC_HDCP		0x11
>  #define QCOM_SCM_HDCP_INVOKE		0x01
>  
> diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
> index 3d6a2469776153..2e1193a3fb5f06 100644
> --- a/include/linux/qcom_scm.h
> +++ b/include/linux/qcom_scm.h
> @@ -44,6 +44,13 @@ enum qcom_scm_sec_dev_id {
>  	QCOM_SCM_ICE_DEV_ID     = 20,
>  };
>  
> +enum qcom_scm_ice_cipher {
> +	QCOM_SCM_ICE_CIPHER_AES_128_XTS = 0,
> +	QCOM_SCM_ICE_CIPHER_AES_128_CBC = 1,
> +	QCOM_SCM_ICE_CIPHER_AES_256_XTS = 3,
> +	QCOM_SCM_ICE_CIPHER_AES_256_CBC = 4,
> +};
> +
>  #define QCOM_SCM_VMID_HLOS       0x3
>  #define QCOM_SCM_VMID_MSS_MSA    0xF
>  #define QCOM_SCM_VMID_WLAN       0x18
> @@ -88,6 +95,12 @@ extern int qcom_scm_ocmem_lock(enum qcom_scm_ocmem_client id, u32 offset,
>  extern int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset,
>  				 u32 size);
>  
> +extern bool qcom_scm_ice_available(void);
> +extern int qcom_scm_ice_invalidate_key(u32 index);
> +extern int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
> +				enum qcom_scm_ice_cipher cipher,
> +				u32 data_unit_size);
> +
>  extern bool qcom_scm_hdcp_available(void);
>  extern int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
>  			     u32 *resp);
> @@ -138,6 +151,12 @@ static inline int qcom_scm_ocmem_lock(enum qcom_scm_ocmem_client id, u32 offset,
>  static inline int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id,
>  		u32 offset, u32 size) { return -ENODEV; }
>  
> +static inline bool qcom_scm_ice_available(void) { return false; }
> +static inline int qcom_scm_ice_invalidate_key(u32 index) { return -ENODEV; }
> +static inline int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
> +				       enum qcom_scm_ice_cipher cipher,
> +				       u32 data_unit_size) { return -ENODEV; }
> +
>  static inline bool qcom_scm_hdcp_available(void) { return false; }
>  static inline int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
>  		u32 *resp) { return -ENODEV; }
> -- 
> 2.26.2
> 
