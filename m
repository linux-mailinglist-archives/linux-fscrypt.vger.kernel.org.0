Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF822CFD47
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Dec 2020 19:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387396AbgLES33 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 5 Dec 2020 13:29:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbgLES3Z (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 5 Dec 2020 13:29:25 -0500
Date:   Sat, 5 Dec 2020 10:20:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607192419;
        bh=ZwQDbSEdzb7GXeWylHYiplKthM8XNJZ/HWpc2n5Sv4A=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=fSwtSoT9E0frjRyC4b1OFfz4qojW2+jMqOMhaOxLTwkPtECVLc9fsL7UkovHew4ma
         dnRoTdzfPBZIqxUDuwx18YL+CFeWcU1RgT6mk0eepnYZGAzLkYIDuPY1cY1+WBfhUF
         GRnO/S+i1/EvuNeRr/xlOAe66XX6cFfpYitrv+aqJKJ8P386iSNEi6iLzyFqyfCGuD
         ezuanSd3n00yoCO5mmi1QuB9xjmHG+g8XepQ8dGhLYzWLs0iKW9dyjF86Bme0ZsnOi
         fQJQZkL/BTtYYyejCOqp3nF1Jw2RxcGIwTTw7ZPCIgV0onu9dI0KPWVF6BAgUjPinl
         PxhLBvxY1VNHQ==
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
Subject: Re: [PATCH v2 4/9] mmc: cqhci: add support for inline encryption
Message-ID: <X8vPYAkCj/MlwZAk@sol.localdomain>
References: <20201203020516.225701-1-ebiggers@kernel.org>
 <20201203020516.225701-5-ebiggers@kernel.org>
 <X8toD7QtwCnzK5Ly@google.com>
 <X8t+JLxNSYFCdpXR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8t+JLxNSYFCdpXR@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Dec 05, 2020 at 12:33:40PM +0000, Satya Tangirala wrote:
> > The version of code from Qualcomm on AOSP reprogrammed all keyslots from
> > cqhci_recovery_finish(). I notice that this patch drops that - I'm guessing
> > that was intentional? Other than that, this patch looks good to me :).
> For reference, the code I'm referring to is at
> https://android-review.googlesource.com/c/kernel/common/+/1269702/9

Yes, it's intentional.  Reprogramming the keys should only be needed when the
hardware is reset, which patch 1 handles via mmc_set_initial_state().  The CQE
recovery procedure normally just "stops" the hardware, not reset it.  So
cqhci_recovery_finish() doesn't seem like the right place to reprogram the keys.

- Eric
