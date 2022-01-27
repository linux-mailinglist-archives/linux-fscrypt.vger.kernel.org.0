Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FF349D6F8
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jan 2022 01:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiA0AvZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Jan 2022 19:51:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53086 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiA0AvZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Jan 2022 19:51:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E2EA61B60;
        Thu, 27 Jan 2022 00:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92875C340E3;
        Thu, 27 Jan 2022 00:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643244683;
        bh=4Mfk12KQfEEtPKhz5q6wmn/51AroOcN3gjCZnA6JALI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tJ2g3KAU1gh48p97de8DlKNDKULc0D7dZ+zKnvFrJVx5VzYeuPpKZ3f/emBbFQQyb
         7Q9QUN6h2yerWnY4PPDdviQJT4AOXTGYtCHg0fxukUux66gfKxHq4hZCVmB+yRBocL
         TuWNvNGnCsUcJrQPda9IRFJq+7zf1LOYCSLrG4H/4AchxSDkFEyk1x6wWzYwqrgKHF
         wv9g7wVHD8WkFd3VD0jgGQdb/ADZ/ppxdvKx/xOnVjrQv+2GwQ/GTNJyI4sRQINki1
         +QKi3pozZw4Ow3PfCNr8MWU6X37xwqz3JaY5et9pIaTvCqnwb7RXGY206z04pFk+fY
         yhTPXC8Y/XD2Q==
Date:   Wed, 26 Jan 2022 16:51:22 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <gaurkash@qti.qualcomm.com>
Cc:     "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "thara.gopinath@linaro.org" <thara.gopinath@linaro.org>,
        "Neeraj Soni (QUIC)" <quic_neersoni@quicinc.com>,
        Dinesh Garg <dineshg@quicinc.com>
Subject: Re: [PATCH 00/10] Add wrapped key support for Qualcomm ICE
Message-ID: <YfHsimSOxedhRBdI@sol.localdomain>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <YddHbRx2UGeAOhji@sol.localdomain>
 <BYAPR02MB4071D51F6DFB371E46E424ACE24C9@BYAPR02MB4071.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR02MB4071D51F6DFB371E46E424ACE24C9@BYAPR02MB4071.namprd02.prod.outlook.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Gaurav,

On Thu, Jan 06, 2022 at 09:14:22PM +0000, Gaurav Kashyap wrote:
> Hey Eric
> 
> > Have you tested that QCOM_SCM_ES_DERIVE_SW_SECRET is working properly?
> 
> - You will need updated trustzone build for that (as I was missing a minor detail in the original one pertaining to SW secret) , please request again on the same ticket for the updated build.
> - I have reminded the people in Qualcomm too to provide you the build.
> - Note that with the new build you should be using the correct directions, i.e QCOM_SCM_RO where intended
> 
> Warm Regards
> Gaurav Kashyap
> 

I verified that the latest TrustZone build is working; thanks for the help!

Note, these are the branches I'm using for now:

  * Kernel patches: https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git/log/?h=wip-wrapped-keys
  * fscryptctl tool and test scripts: https://github.com/ebiggers/fscryptctl/tree/wip-wrapped-keys

The kernel branch is based on v5.17-rc1.  I haven't changed your patches from
your latest series other than rebasing them and adding a fix
"qcom_scm: fix return values" on top.

Note that v5.16-rc5 and later have a bug where the UFS controller on SM8350
isn't recognized.  Therefore, my branch contains a fix from Bjorn Andersson for
that bug, which I applied from the mailing list.

One oddity I noticed is that if I import the same raw key twice, the long-term
wrapped key blob is the same.  This implies that the key encryption algorithm
used by the Qualcomm hardware is deterministic, which is unexpected.  I would
expect the wrapped key to contain a random nonce.  Do you know why deterministic
encryption is used?  This probably isn't much of a problem, but it's unexpected.

Besides that, I think the next steps are for you to address the comments I've
left on this series, and for me to get started on adding ciphertext verification
tests for this to xfstests (alongside the other fscrypt ciphertext verification
tests that are already there) so that we can prove this feature is actually
encrypting the data as intended.

- Eric
