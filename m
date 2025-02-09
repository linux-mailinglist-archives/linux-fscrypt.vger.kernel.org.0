Return-Path: <linux-fscrypt+bounces-596-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E243A2DEED
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Feb 2025 16:50:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0372E3A6412
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Feb 2025 15:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0B71DF960;
	Sun,  9 Feb 2025 15:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aVr+PACB"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888581DF25A
	for <linux-fscrypt@vger.kernel.org>; Sun,  9 Feb 2025 15:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739116248; cv=none; b=UOCTFiHKAwyL1bm1o4NFzxlXSHAlAmxib1BOWmqwWWgg2vdCyWlOFrgbHue8cwrnERyxtBRSBOjzFcCbHRu5UqwGIcJQYmJR8twH8VlMH8R8zye1sea69LExQnC8FAVoJB2RZhHSYxYAgim09lS4kJSfzdc1Ih8xzDNrbkmiY/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739116248; c=relaxed/simple;
	bh=3tTvuuiVnCPVSn8oE7K5yeOzQnMOW0db5YwDCMguaLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g26BXtSydBupsUdqbNCXzYFauPmAW818oGn/5ccR7Y8drM67lPw6bGrfVOnnSGaiqKO7iLVhqDsxh6OMs8+nX84Rl/XCcsiySM2P53Pk+1Chdl98guVtW6Wq78ZdRpFpJtKahHsAV1khz7LIxyV1fS/80wwQNIJN1AeNbDsOUu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aVr+PACB; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21f44e7eae4so52265305ad.2
        for <linux-fscrypt@vger.kernel.org>; Sun, 09 Feb 2025 07:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739116246; x=1739721046; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z+3e8LQ4+KCVM1ZlHvF+ScpOdJFsseLnvwjtZa8Jb9M=;
        b=aVr+PACB9VG26qPt95YFGXicHmK+aWC1lxtpVI7fagTPPPPBNww3O4dCVqVNSmLtjQ
         rC35qvTkFjPhZdDNTLRD6enqpAyOwL4akPZNHf1eOeWajHTlKpjobgNpObn7yV0nZEdF
         CUSnV2F5Hy6UjmijrGZttCm2tNlkVAQ2IIfhnzt2oXxNdPKebQ5qH+Nf46Pz8xRPCUT8
         3nBgqRrBAOFCW+EJkVAT0rSGJMAJ+9Kiv1bBBtZ3cl6wR3w7kOR4jEqzTJMgYLCfYqri
         OMu8D9ILow8rSrAQETeOv8ghx4ocVTKgU1gr/je5UyiKpEpKhDSFLb8sf7KHm9s3PehC
         Tfqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739116246; x=1739721046;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z+3e8LQ4+KCVM1ZlHvF+ScpOdJFsseLnvwjtZa8Jb9M=;
        b=SWnfN1SsGW88puTo+OZZUPA6gBD7hSqTrK4EmRP0XRNfF67bFGBBjEL6UIBO1xbtfI
         2V16VBceQG023pdls5DbT7Z+6zXE3OkMJ49wnSdxH6fS0KPjF94tfWAOPiHeDfh+9ilX
         er822F/d7Upx/Ii+KGbMBDRby0Y9ySxlc46gW8HW+cwnsueTvCSh2oALWJVxCKD9wVsA
         LI0yU4Dbr8IuFw17fCXXEKLHJXmucNl5W6I1KGoU9OBX8JBkw7tM0piK8YnwsJmFQyBy
         uANK2S8XCZIzmVPMsvWzUgioVP6s+dcrR6XlPMmQgSm98UwBb3+H9/AnsHrCnJ7DMdta
         FXzg==
X-Forwarded-Encrypted: i=1; AJvYcCUl8TwO7hVGq2cH4xyztnztQK229jCwThcLa8rH9WsVy/tchK5ddJA79xeazW1XxVbHZ4taNNbGTVwkdHej@vger.kernel.org
X-Gm-Message-State: AOJu0YzDelb9jpoLxzb6Sd+bDF/nF6zMHEAZKmpk/cE9c5STJXe3tw+9
	q5M5+TWGjVVAKf/boazN66bTZPFvCIlDiZtOIWrKfksy3sYsCTfGJsveyyg2Sg==
X-Gm-Gg: ASbGncsiW70jB6ycdbET4738r+cfycS/tAEClEnl6yG8v1uMmwAlbfuBPuf7FjGvHLu
	KSUJjsSQL4uaKdjt5b9FsPP3G9Ky6nDShU81f/8zK7LjtWhBFlzMxjyPHAfXVxoF+Sgo+LcBFIX
	1tZJTsAxFUs8LIiIJBwgjy0wm0GkYA0pO9p+cKp/VijiohNtwSLoAJ7t4hRoH7aDyV8Q4xYzYXN
	QC3h7oovQK2XWdYdF+Nnyq3bwkyPeK58FikqAENc7mp2VzhSmsT8WgaW+AXQIKcKvKnjNxgwChg
	PZmneas3SwzJ59Of2BOAKDUUlLwo
X-Google-Smtp-Source: AGHT+IE4gdu2yxLbkLWa2z+fxMD4SNoZKshd8ELUK0DWfD4+eLBEQB9U2Q8lXY9MpRroDTXbBu5Psw==
X-Received: by 2002:a05:6a00:9289:b0:730:8d25:4c31 with SMTP id d2e1a72fcca58-7308d25550amr2078276b3a.8.1739116245689;
        Sun, 09 Feb 2025 07:50:45 -0800 (PST)
Received: from thinkpad ([220.158.156.173])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73048ad2866sm6332220b3a.52.2025.02.09.07.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 07:50:45 -0800 (PST)
Date: Sun, 9 Feb 2025 21:20:40 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	linux-fscrypt@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: Re: [PATCH v11 5/7] soc: qcom: ice: make qcom_ice_program_key() take
 struct blk_crypto_key
Message-ID: <20250209155040.gnkf6xuhhzp5jnrw@thinkpad>
References: <20250204060041.409950-1-ebiggers@kernel.org>
 <20250204060041.409950-6-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250204060041.409950-6-ebiggers@kernel.org>

On Mon, Feb 03, 2025 at 10:00:39PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> qcom_ice_program_key() currently accepts the key as an array of bytes,
> algorithm ID, key size enum, and data unit size.  However both callers
> have a struct blk_crypto_key which contains all that information.  Thus
> they both have similar code that converts the blk_crypto_key into the
> form that qcom_ice_program_key() wants.  Once wrapped key support is
> added, the key type would need to be added to the arguments too.
> 
> Therefore, this patch changes qcom_ice_program_key() to take in all this
> information as a struct blk_crypto_key directly.  The calling code is
> updated accordingly.  This ends up being much simpler, and it makes the
> key type be passed down automatically once wrapped key support is added.
> 
> Based on a patch by Gaurav Kashyap <quic_gaurkash@quicinc.com> that
> replaced the byte array argument only.  This patch makes the
> blk_crypto_key replace other arguments like the algorithm ID too,
> ensuring that there remains only one source of truth.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

For ufs-qcom:

Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/mmc/host/sdhci-msm.c | 11 +----------
>  drivers/soc/qcom/ice.c       | 23 ++++++++++++-----------
>  drivers/ufs/host/ufs-qcom.c  | 11 +----------
>  include/soc/qcom/ice.h       | 22 +++-------------------
>  4 files changed, 17 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index 3c383bce4928f..2c926f566d053 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -1960,20 +1960,11 @@ static int sdhci_msm_ice_keyslot_program(struct blk_crypto_profile *profile,
>  					 unsigned int slot)
>  {
>  	struct sdhci_msm_host *msm_host =
>  		sdhci_msm_host_from_crypto_profile(profile);
>  
> -	/* Only AES-256-XTS has been tested so far. */
> -	if (key->crypto_cfg.crypto_mode != BLK_ENCRYPTION_MODE_AES_256_XTS)
> -		return -EOPNOTSUPP;
> -
> -	return qcom_ice_program_key(msm_host->ice,
> -				    QCOM_ICE_CRYPTO_ALG_AES_XTS,
> -				    QCOM_ICE_CRYPTO_KEY_SIZE_256,
> -				    key->bytes,
> -				    key->crypto_cfg.data_unit_size / 512,
> -				    slot);
> +	return qcom_ice_program_key(msm_host->ice, slot, key);
>  }
>  
>  static int sdhci_msm_ice_keyslot_evict(struct blk_crypto_profile *profile,
>  				       const struct blk_crypto_key *key,
>  				       unsigned int slot)
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 393d2d1d275f1..78780fd508f0b 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -159,41 +159,42 @@ int qcom_ice_suspend(struct qcom_ice *ice)
>  
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_suspend);
>  
> -int qcom_ice_program_key(struct qcom_ice *ice,
> -			 u8 algorithm_id, u8 key_size,
> -			 const u8 crypto_key[], u8 data_unit_size,
> -			 int slot)
> +int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
> +			 const struct blk_crypto_key *blk_key)
>  {
>  	struct device *dev = ice->dev;
>  	union {
>  		u8 bytes[AES_256_XTS_KEY_SIZE];
>  		u32 words[AES_256_XTS_KEY_SIZE / sizeof(u32)];
>  	} key;
>  	int i;
>  	int err;
>  
>  	/* Only AES-256-XTS has been tested so far. */
> -	if (algorithm_id != QCOM_ICE_CRYPTO_ALG_AES_XTS ||
> -	    key_size != QCOM_ICE_CRYPTO_KEY_SIZE_256) {
> -		dev_err_ratelimited(dev,
> -				    "Unhandled crypto capability; algorithm_id=%d, key_size=%d\n",
> -				    algorithm_id, key_size);
> +	if (blk_key->crypto_cfg.crypto_mode !=
> +	    BLK_ENCRYPTION_MODE_AES_256_XTS) {
> +		dev_err_ratelimited(dev, "Unsupported crypto mode: %d\n",
> +				    blk_key->crypto_cfg.crypto_mode);
>  		return -EINVAL;
>  	}
>  
> -	memcpy(key.bytes, crypto_key, AES_256_XTS_KEY_SIZE);
> +	if (blk_key->size != AES_256_XTS_KEY_SIZE) {
> +		dev_err_ratelimited(dev, "Incorrect key size\n");
> +		return -EINVAL;
> +	}
> +	memcpy(key.bytes, blk_key->bytes, AES_256_XTS_KEY_SIZE);
>  
>  	/* The SCM call requires that the key words are encoded in big endian */
>  	for (i = 0; i < ARRAY_SIZE(key.words); i++)
>  		__cpu_to_be32s(&key.words[i]);
>  
>  	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
>  				   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
> -				   data_unit_size);
> +				   blk_key->crypto_cfg.data_unit_size / 512);
>  
>  	memzero_explicit(&key, sizeof(key));
>  
>  	return err;
>  }
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index c3f0aa81ff983..9330022e98eec 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -193,21 +193,12 @@ static int ufs_qcom_ice_keyslot_program(struct blk_crypto_profile *profile,
>  {
>  	struct ufs_hba *hba = ufs_hba_from_crypto_profile(profile);
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>  	int err;
>  
> -	/* Only AES-256-XTS has been tested so far. */
> -	if (key->crypto_cfg.crypto_mode != BLK_ENCRYPTION_MODE_AES_256_XTS)
> -		return -EOPNOTSUPP;
> -
>  	ufshcd_hold(hba);
> -	err = qcom_ice_program_key(host->ice,
> -				   QCOM_ICE_CRYPTO_ALG_AES_XTS,
> -				   QCOM_ICE_CRYPTO_KEY_SIZE_256,
> -				   key->bytes,
> -				   key->crypto_cfg.data_unit_size / 512,
> -				   slot);
> +	err = qcom_ice_program_key(host->ice, slot, key);
>  	ufshcd_release(hba);
>  	return err;
>  }
>  
>  static int ufs_qcom_ice_keyslot_evict(struct blk_crypto_profile *profile,
> diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
> index 5870a94599a25..4cecc7f088b4b 100644
> --- a/include/soc/qcom/ice.h
> +++ b/include/soc/qcom/ice.h
> @@ -4,34 +4,18 @@
>   */
>  
>  #ifndef __QCOM_ICE_H__
>  #define __QCOM_ICE_H__
>  
> +#include <linux/blk-crypto.h>
>  #include <linux/types.h>
>  
>  struct qcom_ice;
>  
> -enum qcom_ice_crypto_key_size {
> -	QCOM_ICE_CRYPTO_KEY_SIZE_INVALID	= 0x0,
> -	QCOM_ICE_CRYPTO_KEY_SIZE_128		= 0x1,
> -	QCOM_ICE_CRYPTO_KEY_SIZE_192		= 0x2,
> -	QCOM_ICE_CRYPTO_KEY_SIZE_256		= 0x3,
> -	QCOM_ICE_CRYPTO_KEY_SIZE_512		= 0x4,
> -};
> -
> -enum qcom_ice_crypto_alg {
> -	QCOM_ICE_CRYPTO_ALG_AES_XTS		= 0x0,
> -	QCOM_ICE_CRYPTO_ALG_BITLOCKER_AES_CBC	= 0x1,
> -	QCOM_ICE_CRYPTO_ALG_AES_ECB		= 0x2,
> -	QCOM_ICE_CRYPTO_ALG_ESSIV_AES_CBC	= 0x3,
> -};
> -
>  int qcom_ice_enable(struct qcom_ice *ice);
>  int qcom_ice_resume(struct qcom_ice *ice);
>  int qcom_ice_suspend(struct qcom_ice *ice);
> -int qcom_ice_program_key(struct qcom_ice *ice,
> -			 u8 algorithm_id, u8 key_size,
> -			 const u8 crypto_key[], u8 data_unit_size,
> -			 int slot);
> +int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
> +			 const struct blk_crypto_key *blk_key);
>  int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
>  struct qcom_ice *of_qcom_ice_get(struct device *dev);
>  #endif /* __QCOM_ICE_H__ */
> -- 
> 2.48.1
> 

-- 
மணிவண்ணன் சதாசிவம்

