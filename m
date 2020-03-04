Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14B617963E
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2020 18:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgCDREw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Mar 2020 12:04:52 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41437 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729501AbgCDREv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Mar 2020 12:04:51 -0500
Received: by mail-pg1-f194.google.com with SMTP id b1so1267575pgm.8
        for <linux-fscrypt@vger.kernel.org>; Wed, 04 Mar 2020 09:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=+ou/OdAfTiHYp4j2KMmUahM1JBJV325ndgSFeza38do=;
        b=SLHEESA+7k3EclcR1c45IiMJT4Fv3sBySnsgP7jdnPR9aF8PtoMUSZ54awwT2KgbLF
         vyjd5lzwQ2FjtXJ6/bOztSJIxL2FQ6NE+mSwaK2e/q0Dvi9b5yeIKYcM2vZdODv+5fD9
         9s+E5guANFSaHOZjuHleUMTwkW2pozVzi7v+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=+ou/OdAfTiHYp4j2KMmUahM1JBJV325ndgSFeza38do=;
        b=g4+jHSgwZiaCjozv2KRxMzfRrYrxQ7EFsNS5ZfeNim2Y2xNB0nYi+qmMQaNe/JN2Pw
         VYHwIdH9baQcq1cpfKtzzrSGfoSxiSUtuHC93TUlm4u54bMAVC2+BcxE5jJ2tdN0baP1
         cyLgb59IegH0k8qb51S+AVqCqs4bwWnFwj0IOqbMzkhKgm21O/6tC2bTsRnnsyCjx43u
         /6RfUY5oSKJ2Z/r4MEcs6y45dwDYOVspSxGgIPGC+K1l5yjhBysHoluj7p/OO3nsv7rN
         krmxKEwY4DuaLJ4HCV4oUk9DBLJ80kSfB4EgrTeZCfsj0hK+o/y1FBGTAP42jwb2rBHV
         NZqg==
X-Gm-Message-State: ANhLgQ2dFN4Pd5uGfXTxNbxusjO+CBPioa2CT3aVFtLnq60UvhHyD8bi
        +KLgeAboQKX916GlSHgjYyIhfg==
X-Google-Smtp-Source: ADFU+vsqNg1+yh+/sD1uGquKOupANCVFksOVini3LC+fUYE3d/JepP8yCmd7cxFAe18RcCRpmNdiTA==
X-Received: by 2002:a63:f752:: with SMTP id f18mr3426343pgk.196.1583341490800;
        Wed, 04 Mar 2020 09:04:50 -0800 (PST)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id b15sm29092475pft.58.2020.03.04.09.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 09:04:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200304064942.371978-2-ebiggers@kernel.org>
References: <20200304064942.371978-1-ebiggers@kernel.org> <20200304064942.371978-2-ebiggers@kernel.org>
Subject: Re: [RFC PATCH v2 1/4] firmware: qcom_scm: Add support for programming inline crypto keys
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Date:   Wed, 04 Mar 2020 09:04:49 -0800
Message-ID: <158334148941.7173.15031605009318265979@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Quoting Eric Biggers (2020-03-03 22:49:39)
> diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
> index 059bb0fbae9e..7fb9f606250f 100644
> --- a/drivers/firmware/qcom_scm.c
> +++ b/drivers/firmware/qcom_scm.c
> @@ -926,6 +927,101 @@ int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_clien=
t id, u32 offset, u32 size)
[...]
> +
> +/**
> + * qcom_scm_ice_set_key() - Set an inline encryption key
> + * @index: the keyslot into which to set the key
> + * @key: the key to program
> + * @key_size: the size of the key in bytes
> + * @cipher: the encryption algorithm the key is for
> + * @data_unit_size: the encryption data unit size, i.e. the size of each
> + *                 individual plaintext and ciphertext.  Given in 512-by=
te
> + *                 units, e.g. 1 =3D 512 bytes, 8 =3D 4096 bytes, etc.
> + *
> + * Program a key into a keyslot of Qualcomm ICE (Inline Crypto Engine), =
where it
> + * can then be used to encrypt/decrypt UFS I/O requests inline.
> + *
> + * The UFSHCI standard defines a standard way to do this, but it doesn't=
 work on
> + * these SoCs; only this SCM call does.
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_ice_set_key(u32 index, const u8 *key, int key_size,
> +                        enum qcom_scm_ice_cipher cipher, int data_unit_s=
ize)

Why not make key_size and data_unit_size unsigned?

> +{
> +       struct qcom_scm_desc desc =3D {
> +               .svc =3D QCOM_SCM_SVC_ES,
> +               .cmd =3D QCOM_SCM_ES_CONFIG_SET_ICE_KEY,
> +               .arginfo =3D QCOM_SCM_ARGS(5, QCOM_SCM_VAL, QCOM_SCM_RW,
> +                                        QCOM_SCM_VAL, QCOM_SCM_VAL,
> +                                        QCOM_SCM_VAL),
> +               .args[0] =3D index,
> +               .args[2] =3D key_size,
> +               .args[3] =3D cipher,
> +               .args[4] =3D data_unit_size,
> +               .owner =3D ARM_SMCCC_OWNER_SIP,
> +       };
> +       u8 *keybuf;
> +       dma_addr_t key_phys;
> +       int ret;
> +
> +       keybuf =3D kmemdup(key, key_size, GFP_KERNEL);

Is this to make the key physically contiguous? Probably worth a comment
to help others understand why this is here.

> +       if (!keybuf)
> +               return -ENOMEM;
> +
> +       key_phys =3D dma_map_single(__scm->dev, keybuf, key_size, DMA_TO_=
DEVICE);
> +       if (dma_mapping_error(__scm->dev, key_phys)) {
> +               ret =3D -ENOMEM;
> +               goto out;
> +       }
> +       desc.args[1] =3D key_phys;
> +
> +       ret =3D qcom_scm_call(__scm->dev, &desc, NULL);
> +
> +       dma_unmap_single(__scm->dev, key_phys, key_size, DMA_TO_DEVICE);
> +out:
> +       kzfree(keybuf);

And this is because we want to clear key contents out of the slab? What
about if the dma_map_single() bounces to a bounce buffer? I think that
isn't going to happen because __scm->dev is just some firmware device
that doesn't require bounce buffers but it's worth another comment to
clarify this.

> +       return ret;
> +}
> +EXPORT_SYMBOL(qcom_scm_ice_set_key);
> +
>  /**
>   * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
>   *
