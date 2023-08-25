Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869FC7884AD
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Aug 2023 12:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbjHYKUc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Aug 2023 06:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243866AbjHYKUH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Aug 2023 06:20:07 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F05C2690
        for <linux-fscrypt@vger.kernel.org>; Fri, 25 Aug 2023 03:19:44 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-9a2185bd83cso91225666b.0
        for <linux-fscrypt@vger.kernel.org>; Fri, 25 Aug 2023 03:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692958783; x=1693563583;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8hmeN79sYGm2yupcg1U1ZPEVlv8mSwCgTnsR3HDlFcg=;
        b=P1oUEbW6Avm1OcDDYWJCLmKiBo8QGj9EuaqkPpWDnihUz9zA78OWflrSORwwLycFFe
         +hzuHp1q1lpm/Pt43kAvQvoVhHQd1Gt9IoNLMVAqkfa9inOi3g451+u9nKAOF4uvzfM7
         w6YBMQZd0bdA8CokkDkOVw00zhPitOpLevFM8O5KTeV6qmF5XPxe6nPc/ctTqrZGH2Im
         dUaI6+kpgRMaxoEgUk0xHP5G8TpB6idTW8qsN4VxK4X9T5SiGZGAasGtb6tyGtMN0uDd
         za9gsaGZRzZ3LVzjqYEg0ljOelY8Ix3GmiMTbyi5RgQi4zAGzF66kk/HzC0k+uw1WZTC
         NYRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692958783; x=1693563583;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8hmeN79sYGm2yupcg1U1ZPEVlv8mSwCgTnsR3HDlFcg=;
        b=MrLdpYgCHeNcsJGopWx/UdGWn6hvKzDuL2DSu+cNpo8Zs+m7Lq+yPlxm9YY+j5lTM3
         rIejUmYgyTj5Dg9R1eaSEqRHWx6yWJct5OYZbPhj6BSaNTz36slU4DjLQZx9BBxKfxHC
         0WhOuojS7OKr8DjrtunBnh523cqTxY1kidEplgaoo9cNYNgezDlrg2uERHONP5rHC+I9
         qvh9scQKcOwZ/uXsVnqmcSawIoNSgfK8LBRB046ykLxykkCfD6nKgjLgWKKPLpeW3+mn
         OQbW0cXfzN2XdqmCU3goGrpcGxwzj4HDxqxXk7g3xjsF7mB2vScUAN6F6G41nVB3Rx6s
         oGfA==
X-Gm-Message-State: AOJu0YzMdpaJrg5025qxGyibTunpg3mehuCx7qIwq5a4pSI++IV5nsSv
        Q327NxFrfM+MYuu7nn2W2+BTUA==
X-Google-Smtp-Source: AGHT+IFLSi2VQHJDpvE/O9nRgSIMhEaB16ib6oXZqIwxs7UTphQws++T+eBZGRZa8TvD2hXubHxxqw==
X-Received: by 2002:a17:906:220f:b0:9a3:faf:7aa8 with SMTP id s15-20020a170906220f00b009a30faf7aa8mr2104632ejs.10.1692958782813;
        Fri, 25 Aug 2023 03:19:42 -0700 (PDT)
Received: from [192.168.1.195] ([5.133.47.210])
        by smtp.googlemail.com with ESMTPSA id z7-20020a17090655c700b00992f309cfe8sm810217ejp.178.2023.08.25.03.19.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Aug 2023 03:19:42 -0700 (PDT)
Message-ID: <f4b5512b-9922-1511-fc22-f14d25e2426a@linaro.org>
Date:   Fri, 25 Aug 2023 11:19:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Content-Language: en-US
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ebiggers@google.com
Cc:     linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 19/07/2023 18:04, Gaurav Kashyap wrote:
> These patches add support to Qualcomm ICE (Inline Crypto Enginr) for hardware
> wrapped keys using Qualcomm Hardware Key Manager (HWKM) and are made on top
> of a rebased version  Eric Bigger's set of changes to support wrapped keys in
> fscrypt and block below:
> https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=wrapped-keys-v7
> (The rebased patches are not uploaded here)
> 
> Ref v1 here:
> https://lore.kernel.org/linux-scsi/20211206225725.77512-1-quic_gaurkash@quicinc.com/
> 
> Explanation and use of hardware-wrapped-keys can be found here:
> Documentation/block/inline-encryption.rst
> 
> This patch is organized as follows:
> 
> Patch 1 - Prepares ICE and storage layers (UFS and EMMC) to pass around wrapped keys.
> Patch 2 - Adds a new SCM api to support deriving software secret when wrapped keys are used
> Patch 3-4 - Adds support for wrapped keys in the ICE driver. This includes adding HWKM support
> Patch 5-6 - Adds support for wrapped keys in UFS
> Patch 7-10 - Supports generate, prepare and import functionality in ICE and UFS
> 
> NOTE: MMC will have similar changes to UFS and will be uploaded in a different patchset
>        Patch 3, 4, 8, 10 will have MMC equivalents.
> 
> Testing:
> Test platform: SM8550 MTP
> Engineering trustzone image is required to test this feature only
> for SM8550. For SM8650 onwards, all trustzone changes to support this
> will be part of the released images.

AFAIU, Prior to these proposed changes in scm, HWKM was done with help 
of TA(Trusted Application) for generate, import, unwrap ... functionality.

1. What is the reason for moving this from TA to new smc calls?

Is this because of missing smckinvoke support in upstream?

How scalable is this approach? Are we going to add new sec sys calls to 
every interface to TA?

2. How are the older SoCs going to deal with this, given that you are 
changing drivers that are common across these?

Have you tested these patches on any older platforms?

What happens if someone want to add support to wrapped keys to this 
platforms in upstream, How is that going to be handled?

As I understand with this, we will endup with two possible solutions 
over time in upstream.


thanks,
--srini

> The engineering changes primarily contain hooks to generate, import and
> prepare keys for HW wrapped disk encryption.
> 
> The changes were tested by mounting initramfs and running the fscryptctl
> tool (Ref: https://github.com/ebiggers/fscryptctl/tree/wip-wrapped-keys) to
> generate and prepare keys, as well as to set policies on folders, which
> consequently invokes disk encryption flows through UFS.
> 
> Gaurav Kashyap (10):
>    ice, ufs, mmc: use blk_crypto_key for program_key
>    qcom_scm: scm call for deriving a software secret
>    soc: qcom: ice: add hwkm support in ice
>    soc: qcom: ice: support for hardware wrapped keys
>    ufs: core: support wrapped keys in ufs core
>    ufs: host: wrapped keys support in ufs qcom
>    qcom_scm: scm call for create, prepare and import keys
>    ufs: core: add support for generate, import and prepare keys
>    soc: qcom: support for generate, import and prepare key
>    ufs: host: support for generate, import and prepare key
> 
>   drivers/firmware/qcom_scm.c            | 292 +++++++++++++++++++++++
>   drivers/firmware/qcom_scm.h            |   4 +
>   drivers/mmc/host/cqhci-crypto.c        |   7 +-
>   drivers/mmc/host/cqhci.h               |   2 +
>   drivers/mmc/host/sdhci-msm.c           |   6 +-
>   drivers/soc/qcom/ice.c                 | 309 +++++++++++++++++++++++--
>   drivers/ufs/core/ufshcd-crypto.c       |  92 +++++++-
>   drivers/ufs/host/ufs-qcom.c            |  63 ++++-
>   include/linux/firmware/qcom/qcom_scm.h |  13 ++
>   include/soc/qcom/ice.h                 |  18 +-
>   include/ufs/ufshcd.h                   |  25 ++
>   11 files changed, 797 insertions(+), 34 deletions(-)
> 
