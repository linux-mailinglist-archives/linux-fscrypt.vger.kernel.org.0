Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AA32CFE84
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Dec 2020 20:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgLEToF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 5 Dec 2020 14:44:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgLEToE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 5 Dec 2020 14:44:04 -0500
Date:   Sat, 5 Dec 2020 11:43:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607197404;
        bh=mZONoqc0lPkPL1MqQfLfD5mq8tRoa7RCx26VR0bTPLM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQvGzIhTTUGbkL6jYDGNClM6hQ5l1BZUfKbZlzX7pFdus/V2YmkITn3CrN+D52RQZ
         xYu4fqO7ISikguNZTYu2PKTqGI5/mTtkApg+nZ0ch8JWgaHiWZIQmAlrEAF4s57TZ9
         bGJfy0zhllaA+0ARlSaEzCQJhi7Z12fPpYzpkSR/XpKV18W+vrb1HhM+jSx4wlJWWC
         4JzFMgUjNmNo5381W3v1aukbHVB+j33lYvrybsmHQa6c08e0DWFSn2aOItSNeIxZ1j
         wq8KvBXZ50EZWHoT5poGDcSwYIj07TbSVSEYvqHCUNj721xlGsuk7kTWSvdvmw7SId
         YzPkW9W27nkOQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
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
Subject: Re: [PATCH v2 9/9] mmc: sdhci-msm: add Inline Crypto Engine support
Message-ID: <X8vi2R0DYd74VCXr@sol.localdomain>
References: <20201203020516.225701-1-ebiggers@kernel.org>
 <20201203020516.225701-10-ebiggers@kernel.org>
 <X8t4bLOc3vRbDSo5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8t4bLOc3vRbDSo5@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Dec 05, 2020 at 12:09:16PM +0000, Satya Tangirala wrote:
> > +static void sdhci_msm_ice_enable(struct sdhci_msm_host *msm_host)
> > +{
> > +	if (!(msm_host->mmc->caps2 & MMC_CAP2_CRYPTO))
> > +		return;
> > +	sdhci_msm_ice_low_power_mode_enable(msm_host);
> > +	sdhci_msm_ice_optimization_enable(msm_host);
> > +	sdhci_msm_ice_wait_bist_status(msm_host);
> If sdhci_msm_ice_wait_bist_status() fails, should we really ignore the
> error and continue en/decrypting with ICE? I'm not sure what the BIST
> failing might really mean, but if it means it's possible that the ICE
> en/decrypts incorrectly it would be bad to continue to use it.....

The "built-in self-test" that the ICE hardware does seems to be a FIPS
compliance thing which never actually fails in practice.

If it does fail, then according to
https://csrc.nist.gov/CSRC/media/projects/cryptographic-module-validation-program/documents/security-policies/140sp2588.pdf
(which is the closest thing I have to any documentation for ICE, other than the
eMMC standard), then the hardware itself will reject any crypto requests.  So
rejecting them in software too should be redundant.

It's also worth noting that just because a hardware-level self-test passes
doesn't mean that the actual end-to-end storage encryption is working correctly.
To verify that you need to run something like Android's
vts_kernel_encryption_test, or the ciphertext verification tests in xfstests.
The hardware itself is really the wrong place to be testing the encryption.

It would be possible to add some code that sets a flag in the cqhci_host if the
ICE hardware test fails, and make cqhci_request() fail any crypto-enabled
requests if that flag is set.  It just doesn't seem necessary, and I think we
should error on the side of less complexity for now.

What I was actually worried about is what happens if ICE needs to be used but
its self-test is still running, so it doesn't want to accept requests yet.  I'm
not sure that's really a thing or not (one might hope the MMC host doesn't say
it's done resetting until the ICE tests are done), but that's why I left in the
code that waits for the tests to complete, which the downstream driver had.

Neeraj and Barani, if you have any additional insight or suggestions on this, or
know of anything I may be overlooking, that would be greatly appreciated.

Otherwise I just plan to add a comment that summarizes what I said above.

> > @@ -2531,12 +2785,15 @@ static __maybe_unused int sdhci_msm_runtime_resume(struct device *dev)
> >  	 * Whenever core-clock is gated dynamically, it's needed to
> >  	 * restore the SDR DLL settings when the clock is ungated.
> >  	 */
> > -	if (msm_host->restore_dll_config && msm_host->clk_rate)
> > +	if (msm_host->restore_dll_config && msm_host->clk_rate) {
> >  		ret = sdhci_msm_restore_sdr_dll_config(host);
> > +		if (ret)
> > +			return ret;
> > +	}
> >  
> >  	dev_pm_opp_set_rate(dev, msm_host->clk_rate);
> >  
> > -	return ret;
> > +	return sdhci_msm_ice_resume(msm_host);
> >  }
> Doesn't this modify existing behaviour if
> sdhci_msm_restore_sdr_dll_config() returns a non-zero value? Previously,
> dev_pm_opp_set_rate() would always be called regardless of ret, but now
> it's not called on non-zero ret value.

Yes but I don't think it matters.  IIUC, if a device's ->runtime_resume()
callback fails, then Linux's runtime power management framework keeps the device
in an error state and doesn't consider it to be resumed.

So if resuming a device involves N different things, and one of them fails, I
don't think we need to worry about trying to still do the other N-1 things; we
can just return an error on the first failure.

- Eric
