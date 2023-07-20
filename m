Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3004F75A48E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jul 2023 04:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjGTCzq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jul 2023 22:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjGTCzp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jul 2023 22:55:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786A6172A;
        Wed, 19 Jul 2023 19:55:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D22360ED0;
        Thu, 20 Jul 2023 02:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1722EC433C8;
        Thu, 20 Jul 2023 02:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689821743;
        bh=o/YV+k4xqo8X8+NVHObuTllSS7QCYEY/VdOiYZmmdSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s4OPQ7U/Ojvxhh6WRwAonmOOoe4/WMAmN+KaT/qJ9vss9Y7CSmkKStaVe2DEDXQHf
         DY+KAAakCNpwRmdi6k2pWSE4fJXvN9QVPQU/WJ+01TlVQvNsEoNfUh0wiSgVI+sV0S
         vzQ7YfVU8S4+HRoSKeW64EbOiMFIUKafWbSbq9ZQ4e69WRSN+a5ByoKRJqilk1V0nI
         8KAI/K7Qumy6EuH8gKtY1Nhsmfw/Fxlh3vMJcYAo2iI9pKv+l3kNXW82Ro6+Fu+521
         O9mZaqwlVcsgZLNoym1sHni6nv5uN6dQT+Ce7Oh0TGM7+cFYPxP4ZiMa6DG7JAfXW1
         8WbYbQtmqpLKw==
Date:   Wed, 19 Jul 2023 19:55:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
Subject: Re: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Message-ID: <20230720025541.GA2607@sol.localdomain>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Gaurav,

On Wed, Jul 19, 2023 at 10:04:14AM -0700, Gaurav Kashyap wrote:
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
>       Patch 3, 4, 8, 10 will have MMC equivalents.
> 
> Testing:
> Test platform: SM8550 MTP
> Engineering trustzone image is required to test this feature only
> for SM8550. For SM8650 onwards, all trustzone changes to support this
> will be part of the released images.
> The engineering changes primarily contain hooks to generate, import and
> prepare keys for HW wrapped disk encryption.
> 
> The changes were tested by mounting initramfs and running the fscryptctl
> tool (Ref: https://github.com/ebiggers/fscryptctl/tree/wip-wrapped-keys) to
> generate and prepare keys, as well as to set policies on folders, which
> consequently invokes disk encryption flows through UFS.
> 
> Gaurav Kashyap (10):
>   ice, ufs, mmc: use blk_crypto_key for program_key
>   qcom_scm: scm call for deriving a software secret
>   soc: qcom: ice: add hwkm support in ice
>   soc: qcom: ice: support for hardware wrapped keys
>   ufs: core: support wrapped keys in ufs core
>   ufs: host: wrapped keys support in ufs qcom
>   qcom_scm: scm call for create, prepare and import keys
>   ufs: core: add support for generate, import and prepare keys
>   soc: qcom: support for generate, import and prepare key
>   ufs: host: support for generate, import and prepare key
> 
>  drivers/firmware/qcom_scm.c            | 292 +++++++++++++++++++++++
>  drivers/firmware/qcom_scm.h            |   4 +
>  drivers/mmc/host/cqhci-crypto.c        |   7 +-
>  drivers/mmc/host/cqhci.h               |   2 +
>  drivers/mmc/host/sdhci-msm.c           |   6 +-
>  drivers/soc/qcom/ice.c                 | 309 +++++++++++++++++++++++--
>  drivers/ufs/core/ufshcd-crypto.c       |  92 +++++++-
>  drivers/ufs/host/ufs-qcom.c            |  63 ++++-
>  include/linux/firmware/qcom/qcom_scm.h |  13 ++
>  include/soc/qcom/ice.h                 |  18 +-
>  include/ufs/ufshcd.h                   |  25 ++
>  11 files changed, 797 insertions(+), 34 deletions(-)


Thank you for continuing to work on this!

According to your cover letter, this feature requires a custom TrustZone image
to work on SM8550.  Will that image be made available outside Qualcomm?

Also according to your cover letter, this feature will work on SM8650 out of the
box.  That's great to hear.  However, SM8650 does not appear to be publicly
available yet or have any upstream kernel support.  Do you know approximately
when a SM8650 development board will become available to the general public?

Also, can you please make available a git branch somewhere that contains your
patchset?  It sounds like this depends on
https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=wrapped-keys-v7, but
actually a version of it that you've rebased, which I don't have access to.
Without being able to apply your patchset, I can't properly review it.

Thanks!

- Eric
