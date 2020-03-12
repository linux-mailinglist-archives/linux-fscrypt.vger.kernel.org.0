Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E35418392C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 20:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgCLTFo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 15:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgCLTFo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 15:05:44 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 318BA206EB;
        Thu, 12 Mar 2020 19:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584039943;
        bh=my91C/jpabKL61IYm+d7tPUONoO7E840xofpkYps+Bc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0WnQv7+f8ZOYA4nFCP9HwikH/A1QktgZc35LyjF1xdqo3lha0nKrwIrhZErO85J83
         Ke3yWRz79xKxL2Lv3B4Hg7+dj1VMMMjd4QfSjEFWeYIO7YdcRv3ZJSzUn6Lbb7qWhO
         bwlNM38ll0vu8kJEuawx4jLLuxzU3zKucv9ACB38=
Date:   Thu, 12 Mar 2020 12:05:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [RFC PATCH v3 4/4] scsi: ufs-qcom: add Inline Crypto Engine
 support
Message-ID: <20200312190541.GB6470@sol.localdomain>
References: <20200312171259.151442-1-ebiggers@kernel.org>
 <20200312171259.151442-5-ebiggers@kernel.org>
 <BY5PR02MB65778B0D07AA92F6AB5E39E8FFFD0@BY5PR02MB6577.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR02MB65778B0D07AA92F6AB5E39E8FFFD0@BY5PR02MB6577.namprd02.prod.outlook.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Barani,

On Thu, Mar 12, 2020 at 06:21:02PM +0000, Barani Muthukumaran wrote:
> Hi Eric,
> 
> I am confused on why you are trying to re-implement functions already present
> within the crypto_vops. Is there a reason why the ICE driver cannot register
> for KSM with its own function for keyslot_program and keyslot_evict and
> register for crypto_vops with its own functions for
> 'init/enable/disable/suspend/resume/debug'. Given that the ufs-crypto has the
> interface to do this why do we have to re-implement the same functionality
> with another set of functions. In addition in the future if for performance
> reasons (with per-file keys) we have to use passthrough KSM and use
> prepare/complete_lrbp_crypto that can easily be added as well.
> 
> IMO the crypto_vops is a clean way for vendors to override the default
> functionality rather than using direct function calls from within the UFS
> driver and this can easily be extended for eMMC.

ufshcd_hba_crypto_variant_ops doesn't exist in the patchset for upstream.

We had to add ufshcd_hba_crypto_variant_ops out-of-tree to the Android common
kernels to unblock vendors implementing their drivers this year, because we
didn't know exactly what functionality they'd need.  So we just had to guess and
add ~10 different operations just in case people needed them.  (Note that some
or all of these may go away next year, once we see what was actually used.)

That's not acceptable for upstream.  For upstream we can only add variant
operations that are actually used by in-tree drivers.

So far the only hardware support actually proposed upstream are my patch for
ufs-qcom, and Stanley's patch for ufs-mediatek.  ufs-qcom only needs
->program_key(), and ufs-mediatek doesn't need any new variant op.

So, that's why only ->program_key() has been proposed upstream thus far: it's
the minimal functionality that's been demonstrated to be needed.

Of course, if someone actually posts patches to support hardware that diverges
from the UFS standard in new and "exciting" ways (whether it's another vendor's
hardware or future Qualcomm hardware) then they'll need to post any variant
operation(s) they need.  They need to be targetted to only the specific quirk(s)
needed, so that drivers don't have to unnecessarily re-implement stuff.

- Eric
