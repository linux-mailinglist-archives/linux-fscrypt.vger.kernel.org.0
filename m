Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A13445C64
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Nov 2021 23:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhKDWwL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Nov 2021 18:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhKDWwK (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Nov 2021 18:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D107E60F36;
        Thu,  4 Nov 2021 22:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636066172;
        bh=kYqtI0mPMx4gcviSBi44P510ajI/enNAKDVG0kdjQLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ik7xFatCo+8BVT1paXK/d2Hw/6DPTxNYNUskfzPUK0bHtlWZIAsVOtncSM1Bchtp3
         WTUOFx4+OrOjkxocBiwZxbbQcmqcpjmThB6Y1BRjRBnkACoXWmMuf0cFgGH9XoFOgD
         XFdXd2PvuVY2Jxa/xjRpeIMrQEUTAZfzy6NYr2T/tocBj+J6R6ogIWpLm9vZWLtjIG
         Sju3HWHakRKW8lFwGpRuzcAozD8vG+5LpUpe0YWxnxUL51bHn+To34t6vpEnuEtxct
         McT0/pXFcxRDGnY+DfJ3ymCPriTGdjaFOQy1ZJVIU6AC+ZXMcD2PDV84lIIeV3c4j2
         Qo6AzIb/ftXYQ==
Date:   Thu, 4 Nov 2021 15:49:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        asutoshd@codeaurora.org
Subject: Re: [PATCH 0/4] Adds wrapped key support for inline storage
 encryption
Message-ID: <YYRjbCDhEt8Vh1xv@gmail.com>
References: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Gaurav,

On Wed, Nov 03, 2021 at 04:18:36PM -0700, Gaurav Kashyap wrote:
> This currently has 4 patches with another coming in shortly for MMC.
> 
> 1. Moves ICE functionality to a common library, so that different storage controllers can use it.
> 2. Adds a SCM call for derive raw secret needed for wrapped keys.
> 3. Adds a hardware key manager library needed for wrapped keys.
> 4. Adds wrapped key support in ufs for storage encryption
> 
> Gaurav Kashyap (4):
>   ufs: move ICE functionality to a common library
>   qcom_scm: scm call for deriving a software secret
>   soc: qcom: add HWKM library for storage encryption
>   soc: qcom: add wrapped key support for ICE
> 
>  drivers/firmware/qcom_scm.c       |  61 +++++++
>  drivers/firmware/qcom_scm.h       |   1 +
>  drivers/scsi/ufs/ufs-qcom-ice.c   | 200 ++++++-----------------
>  drivers/scsi/ufs/ufs-qcom.c       |   1 +
>  drivers/scsi/ufs/ufs-qcom.h       |   5 +
>  drivers/scsi/ufs/ufshcd-crypto.c  |  47 ++++--
>  drivers/scsi/ufs/ufshcd.h         |   5 +
>  drivers/soc/qcom/Kconfig          |  14 ++
>  drivers/soc/qcom/Makefile         |   2 +
>  drivers/soc/qcom/qti-ice-common.c | 215 +++++++++++++++++++++++++
>  drivers/soc/qcom/qti-ice-hwkm.c   |  77 +++++++++
>  drivers/soc/qcom/qti-ice-regs.h   | 257 ++++++++++++++++++++++++++++++
>  include/linux/qcom_scm.h          |   5 +
>  include/linux/qti-ice-common.h    |  37 +++++
>  14 files changed, 766 insertions(+), 161 deletions(-)
>  create mode 100644 drivers/soc/qcom/qti-ice-common.c
>  create mode 100644 drivers/soc/qcom/qti-ice-hwkm.c
>  create mode 100644 drivers/soc/qcom/qti-ice-regs.h
>  create mode 100644 include/linux/qti-ice-common.h

Thanks for the patches!  These are on top of my patchset
"[RFC PATCH v2 0/5] Support for hardware-wrapped inline encryption keys"
(https://lore.kernel.org/linux-block/20210916174928.65529-1-ebiggers@kernel.org),
right?  You should mention that in your cover letter, so that it's possible for
people to apply your patches for reviewing or testing, and also to provide
context about what this feature is and why it is important.

As part of that, it would be helpful to specifically mention the documentation
for hardware-wrapped keys in Documentation/block/inline-encryption.rst that I
included in my patchset.  It provides a lot of background information that your
patches are hard to understand without (at least your patches 2-4; your first
patch isn't dependent on the hardware-wrapped keys feature).

Can you include information about how your patches were tested?  That's really
important to include.

Please run './scripts/checkpatch.pl' on your patches, as recommended in
Documentation/process/submitting-patches.rst.  It can catch a lot of issues.

Please use the imperative tense, like "add wrapped key support" rather than
"adds wrapped key support".

I'll leave some more comments on the individual patches.

- Eric
