Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1ED1179A72
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2020 21:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgCDUwg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Mar 2020 15:52:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgCDUwg (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Mar 2020 15:52:36 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA56D21739;
        Wed,  4 Mar 2020 20:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583355155;
        bh=Yy7g0WHmMA+XvHq358KrlIHYS689IGU12Jg+T87EMl4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RdDkH6qnZW24r4KJJz4t3+U0AYVsR//20noWdX275RBGC9HRBgUtYJI4dkyJ8lO7D
         /RXYxuJTc1oxcTcpZmw9dFXVcG+p5qVVpVTNwHpua6nGX9uTm7izuj5SIoClkXxQt6
         ipZYufGVGN+Fi3rit1ebkYFvd+NxjKE+FCUEo15E=
Date:   Wed, 4 Mar 2020 12:52:33 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     bmuthuku@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        'Alim Akhtar' <alim.akhtar@samsung.com>,
        'Andy Gross' <agross@kernel.org>,
        'Avri Altman' <avri.altman@wdc.com>,
        'Barani Muthukumaran' <bmuthuku@qti.qualcomm.com>,
        'Bjorn Andersson' <bjorn.andersson@linaro.org>,
        'Can Guo' <cang@codeaurora.org>,
        'Elliot Berman' <eberman@codeaurora.org>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        Neeraj Soni <neersoni@qti.qualcomm.com>,
        Gaurav Kashyap <gaurkash@qti.qualcomm.com>,
        Ravi Pathuru <spathuru@qti.qualcomm.com>
Subject: Re: [RFC PATCH v2 3/4] scsi: ufs: add program_key() variant op
Message-ID: <20200304205233.GB1005@sol.localdomain>
References: <20200304064942.371978-1-ebiggers@kernel.org>
 <20200304064942.371978-4-ebiggers@kernel.org>
 <000301d5f262$0d0dc260$27294720$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301d5f262$0d0dc260$27294720$@codeaurora.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Barani,

On Wed, Mar 04, 2020 at 12:18:20PM -0800, bmuthuku@codeaurora.org wrote:
> Eric, I strongly recommend not to support the old mechanism of calling into
> TEE to set keys as this has been deprecated and will not work with newer
> hardware. 

Actually, I've also verified that this driver works nearly as-is on Snapdragon
865 and Snapdragon 765.  (Those SoCs currently lack upstream support, but I
tested with downstream kernels.)  IIUC, this is the latest Qualcomm hardware in
the real world.  Lots of phones will be shipping with those SoCS this year.

So your position is that crypto support for current Qualcomm hardware shouldn't
be added, and instead we should wait years for new hardware that hasn't even
been announced/released yet and has no upstream kernel support at all yet?
Snapdragon 845 (via DragonBoard 845c) already has upstream support.

We can easily support multiple hardware versions in the driver, so I don't see
why this is an issue.

In particular, if Qualcomm releases new hardware that just complies with the UFS
standard and doesn't require these weird vendor-specific SCM calls, we can just
conditionally skip the quirks when standard hardware is detected.

> There are few issues with this patch, it adds all the code within
> UFS and we would have to reimplement all the common ICE code for eMMC as
> well.

The downstream solution of having a separate ICE "device" and "driver" is really
horrendous and results in lots of layering violations and unnecessary code,
since as far as I can tell ICE is actually part of the UFS and eMMC controllers
and not a separate device.

So I think starting with the ICE logic in ufs-qcom is the right approach.

If it turns out that sdhci-msm needs similar ICE management code, we can put it
in a library.  Though, note that after I removed all the unneeded stuff, we're
only talking about ~200 lines of code, so it may not even be worthwhile.

However, an issue with eMMC is that the eMMC crypto standard hasn't actually
been published yet.  And I haven't heard of any vendors implementing it besides
Qualcomm, nor do I know of any upstream SoC we can use to develop it.

So if you want eMMC crypto support, you're going to have to help with it.

> For clearing a key, the patch uses program_key to set zeroes to the
> keyslot, without going into details (since newer hardware is not yet public)
> this will not work.

That's incorrect; this patch uses the SCM call QCOM_SCM_ES_INVALIDATE_ICE_KEY to
evict keys.  That's exactly what the downstream driver does.

Of course, when we add support for newer hardware we can use whatever keyslot
management method works on that hardware.  Hopefully, it's the standard UFS
method and not another weird vendor-specific method.

> We have a plan to upstream ICE support with the new hardware along with the
> framework to support wrapped keys and add sdhci/cqhci-crypto support.

Great, what's the timeline on this?  Are there patches you can point to
anywhere?  How would one get ahold of this hardware, and does it / will it have
upstream kernel support like sda845 does?

- Eric
