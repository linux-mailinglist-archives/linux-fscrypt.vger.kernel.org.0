Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6784246AF17
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Dec 2021 01:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbhLGA2C (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Dec 2021 19:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhLGA2C (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 19:28:02 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF05C061746;
        Mon,  6 Dec 2021 16:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=7UgHLxAwB+zONRj21LgECxYuL6NnuK4jfF/f8ftEa0c=; b=nxZWrU5Y8KGF29cav9NBxYV1Y/
        eCcz82NJcSyiM3U9yfnuHsm8iezcOmuTAv7+TSxhg7GNZEAs7vKojk2fbw18BvnorWilRaxtJJIST
        boxuKvkk9ynu6deI0W6oFZxK6TKTQJ02O7QXlxbarzrPzQQvXGnXu1l6BNL1ikQZvOXIFemak1T+Q
        g7YFqSE+3wcvCj37a+kavJOQxyow+NeBC9eIwKarkopmD48VgXi53bdf/2yB2RZP8iKlFZrJfmTjY
        qyzo49RV8zNte1gtnsQAcp1iEgAvYd2ussGi2XTEM5+1Emaf2mp3y6Z0UH3oSLjR1Sz63drX3vHLN
        knYDdv8A==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1muOHW-002fCg-3n; Tue, 07 Dec 2021 00:24:30 +0000
Message-ID: <6605ed9e-7cae-fd65-e39c-bc708d1df7ef@infradead.org>
Date:   Mon, 6 Dec 2021 16:24:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 01/10] soc: qcom: new common library for ICE functionality
Content-Language: en-US
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        quic_neersoni@quicinc.com, dineshg@quicinc.com
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <20211206225725.77512-2-quic_gaurkash@quicinc.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20211206225725.77512-2-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

Since I have no idea what "ICE" means in this context:

On 12/6/21 14:57, Gaurav Kashyap wrote:
> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> index 79b568f82a1c..a900f5ab6263 100644
> --- a/drivers/soc/qcom/Kconfig
> +++ b/drivers/soc/qcom/Kconfig
> @@ -209,4 +209,11 @@ config QCOM_APR
>  	  application processor and QDSP6. APR is
>  	  used by audio driver to configure QDSP6
>  	  ASM, ADM and AFE modules.
> +
> +config QTI_ICE_COMMON
> +	tristate "QTI common ICE functionality"

please do something like (just an example!):

	tristate "QTI common ICE (internal compiler error) functionality"

> +	depends on ARCH_QCOM
> +	help
> +	  Enable the common ICE library that can be used
> +	  by UFS and EMMC drivers for ICE functionality.
>  endmenu

thanks.
-- 
~Randy
