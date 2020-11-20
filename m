Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96F72BB5B8
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Nov 2020 20:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgKTTow (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 20 Nov 2020 14:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbgKTTov (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 20 Nov 2020 14:44:51 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67868206B6;
        Fri, 20 Nov 2020 19:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605901490;
        bh=U0R2L6SLf4RlCEnDC+EL/JGmb0bqclzNqE0fv9JhD9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=milKTEWesqBTPEPTOJKPvfjdpUqAUUm1tobPFHoLIGdmBVbaw3zUsC0HDgqO8Uu1o
         DXQXUdPzL7agRO97w6EDYWt/F17d/6PWv7sxoHZlDRr/60E4JZeCt7TVMLF3xR1OAl
         t8BzScTFkyLBhUcNOabkz9ZWNgW7UPvbyJTw16qc=
Date:   Fri, 20 Nov 2020 11:44:48 -0800
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
Subject: Re: [PATCH 0/8] eMMC inline encryption support
Message-ID: <X7gcsC6IS80sUy4K@sol.localdomain>
References: <20201112194011.103774-1-ebiggers@kernel.org>
 <X7gQ9Y44iIgkiM64@sol.localdomain>
 <ea904bcc-3f01-d968-2a16-f9ff9f012968@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea904bcc-3f01-d968-2a16-f9ff9f012968@intel.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Adrian,

On Fri, Nov 20, 2020 at 09:29:59PM +0200, Adrian Hunter wrote:
> I haven't had a chance to look at it properly, but I do have a couple of
> dumb questions.  How do you ensure the host controller is not runtime
> suspended when the key is programmed?

This is handled by the block layer, in block/keyslot-manager.c.  It ensures that
the device is resumed before calling blk_ksm_ll_ops::keyslot_program() or
blk_ksm_ll_ops::keyslot_evict().  See blk_ksm_hw_enter().

> Are the keys lost when the host controller is reset, and then how do you know
> the host controller does not get reset after the key is programmed but before
> the I/O is submitted?

As with UFS, keys might be lost when the host controller is reset, so we're
reprogramming all the keys when that happens.  See patch 1:

    mmc_set_initial_state()
        mmc_crypto_set_initial_state()
            blk_ksm_reprogram_all_keys()

(That's the intent, at least.  For MMC, I'm not sure if resets were properly
covered by the testing I've done so far.  But the code looks right to me.)

- Eric
