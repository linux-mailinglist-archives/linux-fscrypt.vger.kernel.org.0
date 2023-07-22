Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C670F75D97E
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Jul 2023 05:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjGVDxO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Jul 2023 23:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjGVDxN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Jul 2023 23:53:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3815A3A97;
        Fri, 21 Jul 2023 20:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC2ED61D9F;
        Sat, 22 Jul 2023 03:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F394C433C7;
        Sat, 22 Jul 2023 03:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689997991;
        bh=FsQ4Aty6yqS0xno9gXu4ET27J/HI6Y5a9Iv9QwNcYHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZgbDSUQ5YtRmniPjJNwl0s5wASP14S7Ri2d1MF7JIP9yBYFeKvmWEPxbqf5OZr1W4
         te8D/WqQwtjQ5RHjc/DXFtdUH7aHsU1IvbvJyKOZKm2vmseUviXcfpVyW9HVbdk9f6
         h6h+WLbgY3X7cmI5iGhMMj9wqPKUB9Wr5oaSdV5okMRTpKeQOowHtmf2n/9YmAnMvr
         iDLgoF+FHhX4ywN192oqNinxbXeYzRYqbjV7a/LEhSyUkLy2ZbHXIzZ/lF+4pxl0hr
         pMWpWAC0O5VLsgUragY4dzGc0T2UlaZBFOdpngjSuxaCuXPTEtJusWTtXm9D6YjlaR
         ANt4rJ2c7wF1w==
Date:   Fri, 21 Jul 2023 20:56:29 -0700
From:   Bjorn Andersson <andersson@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ebiggers@google.com, linux-mmc@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        omprsing@qti.qualcomm.com, quic_psodagud@quicinc.com,
        avmenon@quicinc.com, abel.vesa@linaro.org,
        quic_spuppala@quicinc.com
Subject: Re: [PATCH v2 09/10] soc: qcom: support for generate, import and
 prepare key
Message-ID: <4v6hjakyfg4jmo2jrx7qxfphfcsagqdwoedk3tqsryqxkgssi7@h2ydsatot6ot>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230719170423.220033-10-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719170423.220033-10-quic_gaurkash@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 19, 2023 at 10:04:23AM -0700, Gaurav Kashyap wrote:
> Implements the ICE apis for generate, prepare and import key
> apis and hooks it up the scm calls defined for them.
> Key management has to be done from Qualcomm Trustzone as only
> it can interface with HWKM.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/soc/qcom/ice.c | 72 ++++++++++++++++++++++++++++++++++++++++++
>  include/soc/qcom/ice.h |  8 +++++
>  2 files changed, 80 insertions(+)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 33f67fcfa1bc..16f7af74ddb0 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -19,6 +19,13 @@
>  
>  #define AES_256_XTS_KEY_SIZE			64
>  
> +/*
> + * Wrapped key sizes from HWKm is different for different versions of
> + * HW. It is not expected to change again in the future.
> + */
> +#define QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(v)	\
> +	((v) == 1 ? 68 : 100)
> +
>  /* QCOM ICE registers */
>  #define QCOM_ICE_REG_VERSION			0x0008
>  #define QCOM_ICE_REG_FUSE_SETTING		0x0010
> @@ -412,6 +419,71 @@ int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wrapped_key[],
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_derive_sw_secret);
>  
> +/**
> + * qcom_ice_generate_key() - Generate a wrapped key for inline encryption
> + * @longterm_wrapped_key: wrapped key that is generated, which is
> + *                        BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
> + *
> + * Make a scm call into trustzone to generate a wrapped key for storage
> + * encryption using hwkm.
> + *
> + * Return: 0 on success; err on failure.
> + */
> +int qcom_ice_generate_key(struct qcom_ice *ice,
> +	u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])

Please run "./scripts/checkpatch.pl --strict *" on your patches, and fix
all relevant warnings and errors.

Please consider revisiting the naming in this patch as well.

Regards,
Bjorn
