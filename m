Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C0E2FE448
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Jan 2021 08:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbhAUHqr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Jan 2021 02:46:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbhAUHqe (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Jan 2021 02:46:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 367BC2396F;
        Thu, 21 Jan 2021 07:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611215153;
        bh=jaWMXBe7gnB8W5jif/JfABLr8mo1KpxJERzgLN9oXZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OIDIMftRkRi5Tl0tyXx+ZfQIiktUN9xr0cGBGwWiV3B05YmzMI7mQh/rqhcdylAk2
         1Sx9vkp4ogpH4hgwRwG/MRGCdmgSw42h+/aLshnTE+Pz3sYTsh6vjN9GOsY9jjkMvB
         KsR5DjRqcQ8QKqwTJrk5D68VwH7eE6Hd2b0y5xTsi70MkOejjM3G4k3gMqgzXhT8ou
         GawbG31BRe0AgsWemiWFo7HlHfgRyjIvQ/++wn5al8FF0ny9XFqKVwSYetumffqwK9
         nHOkG54I3m7qaWH8hgmhvGlbNk25E9pHnCZT6EvEEWlkzVs+fNUJW1Ryx48ORKNJQo
         Lk5ldJLBn0vsw==
Date:   Wed, 20 Jan 2021 23:45:51 -0800
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
Subject: Re: [PATCH v4 1/9] mmc: add basic support for inline encryption
Message-ID: <YAkxLx4JiAtSlx1E@sol.localdomain>
References: <20210104184542.4616-1-ebiggers@kernel.org>
 <20210104184542.4616-2-ebiggers@kernel.org>
 <CAPDyKFq717teu2HPZLCn9QVxLOwZHdi_iS+Ji69S0kYX1o52PQ@mail.gmail.com>
 <YAHXPREJaKjK/z7+@sol.localdomain>
 <CAPDyKFopKy6dwENJ6YQQ0KRPQdT25R_zmhrNH7jyu=+p6bKpNA@mail.gmail.com>
 <YAdGbqU12cbJr78K@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAdGbqU12cbJr78K@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jan 19, 2021 at 12:52:00PM -0800, Eric Biggers wrote:
> > To free up the data structures, blk_ksm_destroy() is called from
> > mmc_free_host().
> > 
> > To me, this can be made more consistent. For example, it looks like
> > blk_ksm_destroy() could be called, even if blk_ksm_init() hasn't been
> > called (depending on the probe error path of the mmc host).
> 
> blk_ksm_destroy() is a no-op on an all-zeroed struct, so it's fine to call it
> unnecessarily.  We could call it unconditionally, if that would be clearer.
> 
> > There are a couple of options to better deal with this.
> > 1) Extend the blk_ksm interface with a devm_blk_ksm_init() function
> > (thus let it deal with lifecycle problems for us) and simply drop the
> > call to blk_ksm_destroy().
> 
> This would require adding APIs to devm to support zeroing buffers on free and to
> use kvmalloc() instead of kmalloc().  It looks like these new APIs wouldn't be
> useful for many drivers (since almost everyone else just wants regular kmalloc
> with no special behavior on free), so they don't seem worth adding yet.

Actually devres is more flexible than I thought; it's possible to register
custom actions to be executed.  I'll send out a patchset that adds
devm_blk_ksm_init() and converts the UFS driver to use it.

- Eric
