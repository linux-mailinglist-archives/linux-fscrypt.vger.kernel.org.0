Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D11179AAD
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2020 22:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbgCDVKX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Mar 2020 16:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728614AbgCDVKW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Mar 2020 16:10:22 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDEF020842;
        Wed,  4 Mar 2020 21:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583356221;
        bh=kepRXjqWr6V9/zasQpimjVtmfbbtcRsr8G6rLRP+xds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PmMyFhx05N23SO1Sn3z652YyV0bzBl8rEXnmpOb0CFUMZthAsRYlfO4VJgM2PTUEG
         MTsHvnpA+toAi8y7ca7tY6Kxq+QNLCZ98xqZxB+aNWp6nCTP293jFFTg8en60/BTdd
         hL8Y4h81osifJ6SPrHCR0gCbiQOXCoW4Xo1D4vGE=
Date:   Wed, 4 Mar 2020 13:10:19 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [RFC PATCH v2 1/4] firmware: qcom_scm: Add support for
 programming inline crypto keys
Message-ID: <20200304211019.GC1005@sol.localdomain>
References: <20200304064942.371978-1-ebiggers@kernel.org>
 <20200304064942.371978-2-ebiggers@kernel.org>
 <158334148941.7173.15031605009318265979@swboyd.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158334148941.7173.15031605009318265979@swboyd.mtv.corp.google.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Mar 04, 2020 at 09:04:49AM -0800, Stephen Boyd wrote:
> Quoting Eric Biggers (2020-03-03 22:49:39)
> > diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
> > index 059bb0fbae9e..7fb9f606250f 100644
> > --- a/drivers/firmware/qcom_scm.c
> > +++ b/drivers/firmware/qcom_scm.c
> > @@ -926,6 +927,101 @@ int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size)
> [...]
> > +
> > +/**
> > + * qcom_scm_ice_set_key() - Set an inline encryption key
> > + * @index: the keyslot into which to set the key
> > + * @key: the key to program
> > + * @key_size: the size of the key in bytes
> > + * @cipher: the encryption algorithm the key is for
> > + * @data_unit_size: the encryption data unit size, i.e. the size of each
> > + *                 individual plaintext and ciphertext.  Given in 512-byte
> > + *                 units, e.g. 1 = 512 bytes, 8 = 4096 bytes, etc.
> > + *
> > + * Program a key into a keyslot of Qualcomm ICE (Inline Crypto Engine), where it
> > + * can then be used to encrypt/decrypt UFS I/O requests inline.
> > + *
> > + * The UFSHCI standard defines a standard way to do this, but it doesn't work on
> > + * these SoCs; only this SCM call does.
> > + *
> > + * Return: 0 on success; -errno on failure.
> > + */
> > +int qcom_scm_ice_set_key(u32 index, const u8 *key, int key_size,
> > +                        enum qcom_scm_ice_cipher cipher, int data_unit_size)
> 
> Why not make key_size and data_unit_size unsigned?

No reason other than that 'int' is fewer characters and is a good default when
no other particular type is warranted.  But I can change them to 'unsigned int'
if people prefer to make it clearer that they can't be negative.

> 
> > +{
> > +       struct qcom_scm_desc desc = {
> > +               .svc = QCOM_SCM_SVC_ES,
> > +               .cmd = QCOM_SCM_ES_CONFIG_SET_ICE_KEY,
> > +               .arginfo = QCOM_SCM_ARGS(5, QCOM_SCM_VAL, QCOM_SCM_RW,
> > +                                        QCOM_SCM_VAL, QCOM_SCM_VAL,
> > +                                        QCOM_SCM_VAL),
> > +               .args[0] = index,
> > +               .args[2] = key_size,
> > +               .args[3] = cipher,
> > +               .args[4] = data_unit_size,
> > +               .owner = ARM_SMCCC_OWNER_SIP,
> > +       };
> > +       u8 *keybuf;
> > +       dma_addr_t key_phys;
> > +       int ret;
> > +
> > +       keybuf = kmemdup(key, key_size, GFP_KERNEL);
> 
> Is this to make the key physically contiguous? Probably worth a comment
> to help others understand why this is here.

Yes, dma_map_single() requires physically contiguous memory.  I'll add a
comment.

> 
> > +       if (!keybuf)
> > +               return -ENOMEM;
> > +
> > +       key_phys = dma_map_single(__scm->dev, keybuf, key_size, DMA_TO_DEVICE);
> > +       if (dma_mapping_error(__scm->dev, key_phys)) {
> > +               ret = -ENOMEM;
> > +               goto out;
> > +       }
> > +       desc.args[1] = key_phys;
> > +
> > +       ret = qcom_scm_call(__scm->dev, &desc, NULL);
> > +
> > +       dma_unmap_single(__scm->dev, key_phys, key_size, DMA_TO_DEVICE);
> > +out:
> > +       kzfree(keybuf);
> 
> And this is because we want to clear key contents out of the slab? What
> about if the dma_map_single() bounces to a bounce buffer? I think that
> isn't going to happen because __scm->dev is just some firmware device
> that doesn't require bounce buffers but it's worth another comment to
> clarify this.

Yes, in crypto-related code we always try to wipe keys after use.  I don't think
a bounce buffer would actually be used here, though it would be preferable to
wipe the DMA memory too so that we don't rely on that.  But I didn't see how to
do that; I'm not a DMA API expert.  Maybe dma_alloc_coherent()?  This isn't
really performance-critical.

- Eric
