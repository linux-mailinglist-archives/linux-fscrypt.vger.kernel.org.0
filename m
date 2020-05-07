Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F4E1C98D8
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 May 2020 20:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgEGSIl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 May 2020 14:08:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgEGSIl (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 May 2020 14:08:41 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11DEB2063A;
        Thu,  7 May 2020 18:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588874920;
        bh=ogm2y8+K+v2K66fHhaAiUJiOq2VE5Hw0MhEMf6zPjTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IeDrIHQeraPu/jewQkQ/jl9TDO111AwfRXJnUvQ8hZ4pZ3QFDc/lyev4hN8G+IE/u
         etaQbsiso8A/HIjKrHJ6yQtPuo9uD9FPpQ2EKO9AKThRlPtFlk7W/5j0Hy4udDT+xk
         Br/N+An7o8n/faGCKnPUapfPcfEDrJAHQmBMEZRI=
Date:   Thu, 7 May 2020 11:08:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [RFC PATCH v4 4/4] scsi: ufs-qcom: add Inline Crypto Engine
 support
Message-ID: <20200507180838.GC236103@gmail.com>
References: <20200501045111.665881-1-ebiggers@kernel.org>
 <20200501045111.665881-5-ebiggers@kernel.org>
 <31fa95e5-7757-96ae-2e86-1f54959e3a6c@linaro.org>
 <20200507180435.GB236103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507180435.GB236103@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, May 07, 2020 at 11:04:35AM -0700, Eric Biggers wrote:
> Hi Thara,
> 
> On Thu, May 07, 2020 at 08:36:58AM -0400, Thara Gopinath wrote:
> > 
> > 
> > On 5/1/20 12:51 AM, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.
> > > 
> > > The standards-compliant parts, such as querying the crypto capabilities
> > > and enabling crypto for individual UFS requests, are already handled by
> > > ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
> > > However, ICE requires vendor-specific init, enable, and resume logic,
> > > and it requires that keys be programmed and evicted by vendor-specific
> > > SMC calls.  Make the ufs-qcom driver handle these details.
> > > 
> > > I tested this on Dragonboard 845c, which is a publicly available
> > > development board that uses the Snapdragon 845 SoC and runs the upstream
> > > Linux kernel.  This is the same SoC used in the Pixel 3 and Pixel 3 XL
> > > phones.  This testing included (among other things) verifying that the
> > > expected ciphertext was produced, both manually using ext4 encryption
> > > and automatically using a block layer self-test I've written.
> > Hello Eric,
> > 
> > I am interested in testing out this series on 845, 855 and if possile on 865
> > platforms. Can you give me some more details about your testing please.
> > 
> 
> Great!  You can test this with fscrypt, a.k.a. ext4 or f2fs encryption.
> 
> A basic manual test would be:
> 
> 1. Build a kernel with:
> 
> 	CONFIG_BLK_INLINE_ENCRYPTION=y
> 	CONFIG_FS_ENCRYPTION=y
> 	CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y

Sorry, I forgot: 'CONFIG_SCSI_UFS_CRYPTO=y' is needed too.

- Eric
