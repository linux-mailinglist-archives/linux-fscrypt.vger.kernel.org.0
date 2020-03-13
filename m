Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10A3184DBD
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Mar 2020 18:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCMRhq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Mar 2020 13:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbgCMRhq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Mar 2020 13:37:46 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77F53206B7;
        Fri, 13 Mar 2020 17:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584121065;
        bh=AHmdZYCCPLvPulAFzp7ZsIrC78Len1/3kZ2BmQWRnyg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Urpp+NQh338DeUMNJUNtv7W+P0mxs4E0vLtoV0nX905bFFCOGQCvjetcazLhYmoEU
         9YUoSImbN1OPeRuonDkwtIbkRYn/8g1JvQS+zeZDm59sqBqi1LbQkbN8cqeHq9SKRv
         dEPQ3LTmOhiWpehbW49SFsKiuVTuxMvVW0Uz2MpQ=
Date:   Fri, 13 Mar 2020 10:37:44 -0700
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
Message-ID: <20200313173744.GA55327@gmail.com>
References: <20200312171259.151442-1-ebiggers@kernel.org>
 <20200312171259.151442-5-ebiggers@kernel.org>
 <BY5PR02MB65778B0D07AA92F6AB5E39E8FFFD0@BY5PR02MB6577.namprd02.prod.outlook.com>
 <20200312190541.GB6470@sol.localdomain>
 <BY5PR02MB6577DA7FD4425C8D7F318E2BFFFA0@BY5PR02MB6577.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR02MB6577DA7FD4425C8D7F318E2BFFFA0@BY5PR02MB6577.namprd02.prod.outlook.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Mar 13, 2020 at 05:05:35PM +0000, Barani Muthukumaran wrote:
> Hi Eric,
> 
> The crypto_variant_ops exposed were not a guess, we had worked with Satya to
> add the functionality that is required.

As far as I can tell, my patch works fine with just the new ->program_key()
variant op.

Note that I'm also taking advantage of some of the existing, non-crypto-specific
variant ops.  For example, I didn't need to add a ->crypto_resume() operation
because there's already ufs_hba_variant_ops::resume().

I understand that the old downstream ICE code defined and used a lot of crypto
variant ops, which did give the impression that a lot more would be needed.  But
ultimately I found that most of them were unnecessary or could be replaced with
the existing non-crypto-specific variant ops.

> Can we define the below crypto_variant_ops that exposes the same functionality
> you have added, this allows us to extend this in the future in a seamless
> manner. As an example QC implementation uses 'debug', 'suspend' and we can add
> that when we upstream the implementation in the next few weeks once our
> validation is complete. Thanks.
> 
> struct ufs_hba_crypto_variant_ops {
> int (*hba_init_crypto)(struct ufs_hba *hba,
>        const struct keyslot_mgmt_ll_ops *ksm_ops);
> void (*enable)(struct ufs_hba *hba);
> int (*resume)(struct ufs_hba *hba);
> int (*program_key(struct ufs_hba *hba,
>       const union ufs_crypto_cfg_entry *cfg, int slot);
> };

To re-iterate, upstream doesn't add hooks with no in-tree users.

It's great to hear that you'll be sending out a patchset soon.  Just send out
the hooks you need along with them, so that they can all be properly reviewed.

- Eric
