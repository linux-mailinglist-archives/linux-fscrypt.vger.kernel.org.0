Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7208C2F831C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Jan 2021 18:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbhAOR44 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Jan 2021 12:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbhAOR44 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Jan 2021 12:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA79F22262;
        Fri, 15 Jan 2021 17:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610733375;
        bh=vj26FR8f+iU2PtcYdkiiX4Rofrx/+1bCKnemSD3ZlAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JBsK2t1VzsBu7KmHfRB8fFQdKPeEXnjNV8szW2jRZ4QDkGhXgm0jdcVxgilxe9p4n
         3rr27iUbtfupeVQ9dSztg52vZ+fqiF5Ttg75ixVu2Lvbu50jVCt8kYGzkOhia4psYj
         uOvJvb3YOwdvG7agAGkKP6W2DfqhlHuM+a0NRLQFu+Y4mRQR2ck9zbXfOyG53Yu0TO
         R8OBrPn6JClmTKnHxfX7MInKY5GFT6fNowCH7A5VjTF9kPc3k2FDlCzVg5UYjyx/Pk
         tq0rw2Dzn10iP4FC6v4i6FDJ+0+5VgTyrUJz3OsrN8AIVDGK5sc9H+SYtmRF59xAD6
         SUv6kieT6g8lw==
Date:   Fri, 15 Jan 2021 09:56:13 -0800
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
Message-ID: <YAHXPREJaKjK/z7+@sol.localdomain>
References: <20210104184542.4616-1-ebiggers@kernel.org>
 <20210104184542.4616-2-ebiggers@kernel.org>
 <CAPDyKFq717teu2HPZLCn9QVxLOwZHdi_iS+Ji69S0kYX1o52PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFq717teu2HPZLCn9QVxLOwZHdi_iS+Ji69S0kYX1o52PQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jan 15, 2021 at 10:22:03AM +0100, Ulf Hansson wrote:
> On Mon, 4 Jan 2021 at 19:48, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > In preparation for adding CQHCI crypto engine (inline encryption)
> > support, add the code required to make mmc_core and mmc_block aware of
> > inline encryption.  Specifically:
> >
> > - Add a capability flag MMC_CAP2_CRYPTO to struct mmc_host.  Drivers
> >   will set this if the host and driver support inline encryption.
> >
> > - Embed a blk_keyslot_manager in struct mmc_host.  Drivers will
> >   initialize this if the host and driver support inline encryption.
> >   mmc_block registers this keyslot manager with the request_queue of any
> >   MMC card attached to the host.  mmc_core destroys this keyslot manager
> >   when freeing the mmc_host.
> >
> > - Make mmc_block copy the crypto keyslot and crypto data unit number
> >   from struct request to struct mmc_request, so that drivers will have
> >   access to them.
> >
> > - If the MMC host is reset, reprogram all the keyslots to ensure that
> >   the software state stays in sync with the hardware state.
> >
> > Co-developed-by: Satya Tangirala <satyat@google.com>
> > Signed-off-by: Satya Tangirala <satyat@google.com>
> > Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> > Reviewed-by: Satya Tangirala <satyat@google.com>
> > Reviewed-and-tested-by: Peng Zhou <peng.zhou@mediatek.com>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Eric, again, my apologies for the delay. Overall, I think this looks good.
> 
> My only hesitation to merge this as is, is that I want to make sure
> you have thought of the life cycle issues for the struct
> blk_keyslot_manager ksm. It's being used both from the mmc core/block
> device driver and the mmc host driver. I am looking at this right now
> and will get back to you very soon, if I find some issues with it.
> 
> If you have some time, feel free to elaborate around how this is
> intended to work.
> 
> Kind regards
> Uffe

The blk_keyslot_manager is initialized early on when the other host structures
(struct mmc_host, struct cqhci_host, struct sdhci_host, struct sdhci_msm_host)
are initialized, prior to mmc_add_host().

It is destroyed when the struct mmc_host is freed by mmc_free_host().

So it should just work; it's the same lifecycle as the existing host structures.
Is there something you think I'm overlooking?

- Eric
