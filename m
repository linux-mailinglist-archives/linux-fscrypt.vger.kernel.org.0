Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888DB1F9FC2
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jun 2020 20:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbgFOS6J (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Jun 2020 14:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731179AbgFOS6J (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Jun 2020 14:58:09 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E678D20656;
        Mon, 15 Jun 2020 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592247488;
        bh=Fl5W9I2OhhgjaA4OO9wCci0K4DTcx1xK2ig/rm+EdlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DNefsVw/lFzCGd1Dnt0NvSfDbwWAKX4ug4TOHb1HG9MuOil4WektjXPZwiIU3zn8J
         gs6qvLj7OalE9q+U+Tb7ahO1YlBL0ysLtw/myVr1ITi5TpE74ILFZhpNBLuj9NlHAY
         weV9C0kLnnnnXV1POZo8IE2DvyO3HkItNZZ2zF1M=
Date:   Mon, 15 Jun 2020 11:58:06 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Thara Gopinath <thara.gopinath@linaro.org>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
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
Message-ID: <20200615185806.GC85413@gmail.com>
References: <20200501045111.665881-1-ebiggers@kernel.org>
 <20200501045111.665881-5-ebiggers@kernel.org>
 <31fa95e5-7757-96ae-2e86-1f54959e3a6c@linaro.org>
 <20200507180435.GB236103@gmail.com>
 <20200507180838.GC236103@gmail.com>
 <150ddaaf-12ec-231e-271a-c65b1d88d30f@kali.org>
 <20200508202513.GA233206@gmail.com>
 <1aa17b19-0ca7-1ff1-b945-442e56ef942a@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1aa17b19-0ca7-1ff1-b945-442e56ef942a@kali.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jun 12, 2020 at 01:04:33PM -0500, Steev Klimaszewski wrote:
> 
> On 5/8/20 3:25 PM, Eric Biggers wrote:
> > On Fri, May 08, 2020 at 03:18:23PM -0500, Steev Klimaszewski wrote:
> >> On 5/7/20 1:08 PM, Eric Biggers wrote:
> >>> On Thu, May 07, 2020 at 11:04:35AM -0700, Eric Biggers wrote:
> >>>> Hi Thara,
> >>>>
> >>>> On Thu, May 07, 2020 at 08:36:58AM -0400, Thara Gopinath wrote:
> >>>>> On 5/1/20 12:51 AM, Eric Biggers wrote:
> >>>>>> From: Eric Biggers <ebiggers@google.com>
> >>>>>>
> >>>>>> Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.
> >>>>>>
> >>>>>> The standards-compliant parts, such as querying the crypto capabilities
> >>>>>> and enabling crypto for individual UFS requests, are already handled by
> >>>>>> ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
> >>>>>> However, ICE requires vendor-specific init, enable, and resume logic,
> >>>>>> and it requires that keys be programmed and evicted by vendor-specific
> >>>>>> SMC calls.  Make the ufs-qcom driver handle these details.
> >>>>>>
> >>>>>> I tested this on Dragonboard 845c, which is a publicly available
> >>>>>> development board that uses the Snapdragon 845 SoC and runs the upstream
> >>>>>> Linux kernel.  This is the same SoC used in the Pixel 3 and Pixel 3 XL
> >>>>>> phones.  This testing included (among other things) verifying that the
> >>>>>> expected ciphertext was produced, both manually using ext4 encryption
> >>>>>> and automatically using a block layer self-test I've written.
> >>>>> Hello Eric,
> >>>>>
> >>>>> I am interested in testing out this series on 845, 855 and if possile on 865
> >>>>> platforms. Can you give me some more details about your testing please.
> >>>>>
> >>>> Great!  You can test this with fscrypt, a.k.a. ext4 or f2fs encryption.
> >>>>
> >>>> A basic manual test would be:
> >>>>
> >>>> 1. Build a kernel with:
> >>>>
> >>>> 	CONFIG_BLK_INLINE_ENCRYPTION=y
> >>>> 	CONFIG_FS_ENCRYPTION=y
> >>>> 	CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
> >>> Sorry, I forgot: 'CONFIG_SCSI_UFS_CRYPTO=y' is needed too.
> >>>
> >>> - Eric
> >>
> > The original patchset is at
> > https://lkml.kernel.org/r/20200430115959.238073-1-satyat@google.com/
> >
> > Yes, v12 is the latest version, and yes that's a bug.  The export needs double
> > underscores.  Satya will fix it when he sends out v13.
> >
> > - Eric
> 
> Hi Eric,
> 
> 
> I've been testing this on a Lenovo Yoga C630 installed to a partition on
> the UFS drive, using a 5.7(ish) kernel with fscrypt/inline-encryption
> and a few patches on top that are still in flux for c630 support.  The
> sources I use can be found at
> https://github.com/steev/linux/tree/linux-5.7.y-c630-fscrypt and the
> config I'm using can be found at
> https://dev.gentoo.org/~steev/files/lenovo-yoga-c630-5.7.0-rc7-fs-inline-encryption.config.
> 
> 
> Everything seems to be working here.  I've run the tests you've
> mentioned and haven't seen any issues.
> 

Great!  Can I add your Tested-by when I send out this patchset again?

- Eric
