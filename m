Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5282CCB8F
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Dec 2020 02:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgLCBSw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Dec 2020 20:18:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbgLCBSv (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Dec 2020 20:18:51 -0500
Date:   Wed, 2 Dec 2020 17:18:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606958291;
        bh=oK49+6uiyYK8qGmcDkTjQpoV00j5lve2FqN328f0oAE=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=bQxsS1KnP0r3tl7/DWrHreFCf+JNdYldbZciAV3i4UDCkOdwEY0Cy0lj6RWgFYk6t
         UWgVc1kYGPASviRlr108xbzGwkwsPO3nJRnyJTOP3MoFcUnZhXVZWDvW8knSWiT4hB
         6CHUPU+nB+EGip8fq695ujwhwQf8kUYGLvbMu3n9sI+6KyNfUuimYLhHjUK1eNPwVn
         PUEWRuZvUyCz+BDdWNplLzs4767n+oIHDLXl5KHiDBC7NUnSKIDq7QkpkKQZ4eHaAU
         yo+y/TcIqNzMegC94L86NNe0szTr+ID3cI7e+sJN8zBjr1EWzCHeuNIuGqhh2Gg38W
         /Tqk7k+3at1rA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: Re: [PATCH 8/8] mmc: sdhci-msm: add Inline Crypto Engine support
Message-ID: <X8g8z8vYtcD3k49S@sol.localdomain>
References: <20201112194011.103774-1-ebiggers@kernel.org>
 <20201112194011.103774-9-ebiggers@kernel.org>
 <77142346-623e-3ca7-6c16-0adca68377f1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77142346-623e-3ca7-6c16-0adca68377f1@intel.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 02, 2020 at 03:56:21PM +0200, Adrian Hunter wrote:
> > +/* Poll until all BIST (built-in self test) bits are reset */
> > +static int sdhci_msm_ice_wait_bist_status(struct sdhci_msm_host *msm_host)
> > +{
> > +	int count;
> > +	u32 reg;
> > +
> > +	for (count = 0; count < 100; count++) {
> > +		reg = sdhci_msm_ice_readl(msm_host, QCOM_ICE_REG_BIST_STATUS);
> > +		if (!(reg & QCOM_ICE_BIST_STATUS_MASK))
> > +			break;
> > +		udelay(50);
> 
> usleep_range ?
> 
> Also could use read_poll_timeout() here
> 

I'll change it to use readl_poll_timeout().

- Eric
