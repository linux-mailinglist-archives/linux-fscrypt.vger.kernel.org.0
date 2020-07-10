Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5450821AF92
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jul 2020 08:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgGJGjX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Jul 2020 02:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgGJGjX (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Jul 2020 02:39:23 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E495206E2;
        Fri, 10 Jul 2020 06:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594363162;
        bh=VeAdv2zvjhR50/sWd80CD/5NF8lrpjnxOIgtTU/9GAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SkHb+YcX/0UMMaT6iUIFDac/JmeSVmB7ir9SP0EtL3TT4MbPNLNmurGCPZByWQvPj
         N3PdfLM4VZr6zzy8jLuVt+hVV/nBcE2dC1wrOABWZ1PaiWA7Rph2FdEGugJ3sYo8f3
         HwINk5xa+ZMHgU8RicKoNWA2R/X0HZL58gYDtlR0=
Date:   Thu, 9 Jul 2020 23:39:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, cang@codeaurora.org, satyat@google.com,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kuohong.wang@mediatek.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com, light.hsieh@mediatek.com
Subject: Re: [RFC PATCH v2] scsi: ufs-mediatek: add inline encryption support
Message-ID: <20200710063920.GD2805@sol.localdomain>
References: <20200304022101.14165-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304022101.14165-1-stanley.chu@mediatek.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Stanley,

On Wed, Mar 04, 2020 at 10:21:02AM +0800, Stanley Chu wrote:
> Add inline encryption support to ufs-mediatek.
> 
> The standards-compliant parts, such as querying the crypto capabilities
> and enabling crypto for individual UFS requests, are already handled by
> ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
> 
> However MediaTek UFS host requires a vendor-specific hce_enable operation
> to allow crypto-related registers being accessed normally in kernel.
> After this step, MediaTek UFS host can work as standard-compliant host
> for inline-encryption related functions.
> 
> This patch is rebased to below repo and tag:
> 	Repo: https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git
> 	Tag: inline-encryption-v7
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 27 ++++++++++++++++++++++++++-
>  drivers/scsi/ufs/ufs-mediatek.h |  1 +
>  2 files changed, 27 insertions(+), 1 deletion(-)

Now that the ufshcd-crypto patches this depends on are in 5.9/scsi-queue, could
you retest and resend this patch?  It would be nice to have 5.9 support some
real hardware already.  (I'm going to resend my patchset for ufs-qcom too.)

- Eric
