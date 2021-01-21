Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B762FF353
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Jan 2021 19:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbhAUS0E (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Jan 2021 13:26:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727457AbhAUSS2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Jan 2021 13:18:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A83423A3A;
        Thu, 21 Jan 2021 18:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611253054;
        bh=K7MU5q7tdkr5vyIPyOgPh9VwES77OWz5XH2UBN04YNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gr1KnQqIE58OCbsdj+RYzLgiqTk2+MQv3Nt7Li3FKrHYGLN0p8GZieJHo68vXnuRf
         Qycv1yW1F6e7dpkLF+MacJ4GqHUSFUE7aEDRkHhskBexkDX9Ix+Y+5+83iqGw7vlqj
         grajGkIvNu4iPlxrqBR7NK/SjMbTKhAuMpymIjwXj39J9J8kKuL9/Tv90t7eC2PmkZ
         grQFrwKosKzYFsf/G4fcbISkDSVUYprsXQlz+aDOm4EpfMcjcJElqYcgR1fzNjqhYw
         ujNrVlQU6RRPlf9qNCGjCrCKx3flmJ31OplyBYCGUw+8RkQcirPFcV7Ad6UI+Vkcs0
         OYQGmHGEO9MyQ==
Date:   Thu, 21 Jan 2021 10:17:32 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: Re: [PATCH v5 4/9] mmc: cqhci: add support for inline encryption
Message-ID: <YAnFPC0f4vJsKbuL@sol.localdomain>
References: <20210121090140.326380-1-ebiggers@kernel.org>
 <20210121090140.326380-5-ebiggers@kernel.org>
 <CAPDyKFqCz=N9R6RpEoMO+zoKhJbds1rbvgzHJ2z+6k2U2Wq6Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFqCz=N9R6RpEoMO+zoKhJbds1rbvgzHJ2z+6k2U2Wq6Yg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jan 21, 2021 at 02:04:37PM +0100, Ulf Hansson wrote:
> > +#else /* CONFIG_MMC_CRYPTO */
> > +
> > +static inline int cqhci_crypto_init(struct cqhci_host *host)
> > +{
> > +       return 0;
> 
> The host calling this function may have MMC_CAP2_CRYPTO set for it.
> 
> When CONFIG_MMC_CRYPTO is set, cqhci_crypto_init() may unset
> MMC_CAP2_CRYPTO if initialization fails. It seems like we should unset
> MMC_CAP2_CRYPTO in this stub function as well, right?

The code in sdhci-msm.c that sets MMC_CAP2_CRYPTO is conditional on
CONFIG_MMC_CRYPTO.  So, MMC_CAP2_CRYPTO won't be set when !CONFIG_MMC_CRYPTO.

I suppose we might as well do something to stop other drivers from accidentally
getting that wrong, though.

How about just defining the flag to 0 when !CONFIG_MMC_CRYPTO:

#ifdef CONFIG_MMC_CRYPTO
#define MMC_CAP2_CRYPTO         (1 << 27)       /* Host supports inline encryption */
#else
#define MMC_CAP2_CRYPTO         0
#endif

That would be more reliable than relying on the flag getting cleared by
something.

- Eric
