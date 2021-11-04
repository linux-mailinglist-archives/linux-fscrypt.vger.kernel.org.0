Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07AB445CBF
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Nov 2021 00:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhKDXtO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Nov 2021 19:49:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhKDXtK (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Nov 2021 19:49:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1D2060F02;
        Thu,  4 Nov 2021 23:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636069592;
        bh=NfcKgvRyUI4mm0kWBjGff1rEuSTCRBAgPnRi41K8ioc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EDijRI2oEdBSUJt+coQ0QCuvGA3Hv6ESgUS5V5MMh9A2TcVwewTmx0uxVXmpOKnix
         V9oNdLpyDmiPaTR5mFkmEYdHk72Z2irSJ6DP8UzXqirASbrdjX+9xKbAOIUPhSWkLR
         9oflqoMylK4sMj+wjUAhim9ryZqPjUa664XV93kF7tn03LFkDxhPlPeRCAHEHzvXun
         pc9NjcRvBrKNkk0oQjHMMGSDf7LME5F62ce3i5fxoErYstyER04sp3A6NGteZ7Ph6F
         qRS97NhmhsaHBr6rnMhznd4EzcA67f9W0GnCaK0YVgYX7gmQsHF+/BoJjOpQ5rrwvK
         ZNa80eXWnYPgA==
Date:   Thu, 4 Nov 2021 16:46:30 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        asutoshd@codeaurora.org
Subject: Re: [PATCH 3/4] soc: qcom: add HWKM library for storage encryption
Message-ID: <YYRw1nhgtWPgbtKk@gmail.com>
References: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
 <20211103231840.115521-4-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103231840.115521-4-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 03, 2021 at 04:18:39PM -0700, Gaurav Kashyap wrote:
> Wrapped keys should utilize hardware to protect the keys
> used for storage encryption. Qualcomm's Inline Crypto Engine
> supports a hardware block called Hardware Key Manager (HWKM)
> for key management.
> 
> Although most of the interactions to this hardware block happens
> via a secure execution environment, some initializations for the
> slave present in ICE can be done from the kernel.
> 
> This can also be a placeholder for when the hardware provides more
> capabilites to be acessed from the linux kernel in the future.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/soc/qcom/Kconfig        |   7 ++
>  drivers/soc/qcom/Makefile       |   1 +
>  drivers/soc/qcom/qti-ice-hwkm.c |  77 ++++++++++++++++++++++
>  drivers/soc/qcom/qti-ice-regs.h | 112 ++++++++++++++++++++++++++++++++
>  include/linux/qti-ice-common.h  |   6 ++
>  5 files changed, 203 insertions(+)
>  create mode 100644 drivers/soc/qcom/qti-ice-hwkm.c
> 
> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> index 39f223ed8cdd..d441d5b81c53 100644
> --- a/drivers/soc/qcom/Kconfig
> +++ b/drivers/soc/qcom/Kconfig
> @@ -216,4 +216,11 @@ config QTI_ICE_COMMON
>  	help
>  	  Enable the common ICE library that can be used
>  	  by UFS and EMMC drivers for ICE functionality.
> +
> +config QTI_HW_WRAPPED_KEYS
> +	tristate "QTI HW Wrapped Keys"
> +	depends on QTI_ICE_COMMON
> +	help
> +	  Enable wrapped key functionality for storage
> +	  encryption.

It might be reasonable to just include the hardware-wrapped key support whenever
QTI_ICE_COMMON is enabled.  Note that I'm not planning separate kconfig options
at the block or fscrypt levels.

If we do have this kconfig option, then please make sure that the help text
properly explains it.  That should include linking to the documentation where
the reader can find out more about what this feature is, and hence why they
might want to enable it, or not enable it.

Also this code probably should be part of the qti-ice-common module (which maybe
should be called "qti-ice-lib"?) rather than its own module.  That would mean
making QTI_HW_WRAPPED_KEYS a bool option that controls whether qti-ice-hwkm.c is
built into qti-ice-common, rather than a tristate that controls whether it's
built into its own module.

- Eric
