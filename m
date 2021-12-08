Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0DB46C89A
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Dec 2021 01:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239976AbhLHA0u (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Dec 2021 19:26:50 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53508 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242784AbhLHA0t (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Dec 2021 19:26:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 275DFCE1ECD;
        Wed,  8 Dec 2021 00:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1151DC341C3;
        Wed,  8 Dec 2021 00:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638922994;
        bh=0ZNt76/nvy/Rqz+ZKBk5k6H1mK9LdC/GVtTbQ4FcSLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Isx9oospbcHINu/yBa+FlYf26Ceaq8XFoWJ5pUqYhBY9t0eMc4FGLJuUTrJma/UwH
         0+3Ye9kjKtg+uqEMSmOVP/t7TApEJcGU+RHDtGRJqH3D8ZHVbiX26fVCigHZfXSwQg
         l8ijbht+pecHIkJNCy43T8tuGQ0P1j1jNiEe5bZJ+m4d/GGvaew1+TbocpUIpbOj1l
         xr/3RByIR06tfvIx1cH0sSFlf7G+vRCwv5dPhsCY/q11Y9vaJ8qquLKa3bu0iiOovM
         AzZVmLQ4FLjce4+OPJOe46AljvQhQwDSM21ccGbG909BXMTCA6xpkGAIbPZHVnFUmI
         RLlCwYmeuHlRg==
Date:   Tue, 7 Dec 2021 16:23:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <gaurkash@qti.qualcomm.com>
Cc:     "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "thara.gopinath@linaro.org" <thara.gopinath@linaro.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
Subject: Re: [PATCH 0/4] Adds wrapped key support for inline storage
 encryption
Message-ID: <Ya/68GveS/hWhJD3@sol.localdomain>
References: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
 <YYRjbCDhEt8Vh1xv@gmail.com>
 <BYAPR02MB4071BFEFB87D0B2E4FC98C9EE26F9@BYAPR02MB4071.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR02MB4071BFEFB87D0B2E4FC98C9EE26F9@BYAPR02MB4071.namprd02.prod.outlook.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 08, 2021 at 12:09:03AM +0000, Gaurav Kashyap wrote:
> Hey Eric, here are the answers to some of the questions across all the patches
> 
> > Also, at runtime, does any of the Qualcomm hardware support multiple key
> > types, and if so can they be used at the same time?
> 
> Currently, with hardware key manager data path, there is no support for
> standard keys. So, when HWKM is being used, only wrapped keys are supported.
> If standard keys need to be supported, it can be, but modifications are
> required within trustzone.

Do the SoCs support both key types though, just not at the same time?  E.g. when
the ufs_qcom driver loads on SM8350, could it choose to expose either standard
key support or wrapped key support, or is it predetermined by the hardware
and/or firmware?  If the driver has a choice, then there should be a kernel
module parameter (module_param()) that controls it, so that the user can choose
which key type they want when they boot their kernel.

- Eric
