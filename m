Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74E1228FA3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Jul 2020 07:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgGVFZo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 22 Jul 2020 01:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGVFZo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 22 Jul 2020 01:25:44 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 525A420792;
        Wed, 22 Jul 2020 05:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595395543;
        bh=+8+3ynaf3hYB3oQcCs6OC0hpH4ApFIYLOFpwrQLUXEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sxk6whZ3gSGtpY8p/PyLIn8aDijtyPbE5UUZ84zymmMdAzvmD2fbbGOxC7SJ9DhY4
         Qq2xgzYkHqt7qvrTGSxQ68vqYHLimHutrZey20kIobjxXRsMUkN9qBAamc8OLf8ux+
         PMe9yykQ2EyZO5/703MmMlcmUNwivMCxCETVQtJY=
Date:   Tue, 21 Jul 2020 22:25:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Elliot Berman <eberman@codeaurora.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Satya Tangirala <satyat@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        linux-fscrypt@vger.kernel.org, Andy Gross <agross@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>
Subject: Re: [PATCH v6 0/5] Inline crypto support on DragonBoard 845c
Message-ID: <20200722052541.GB39383@sol.localdomain>
References: <20200710072013.177481-1-ebiggers@kernel.org>
 <159539205429.31352.16564389172198122676.b4-ty@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159539205429.31352.16564389172198122676.b4-ty@oracle.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Martin,

On Wed, Jul 22, 2020 at 12:28:29AM -0400, Martin K. Petersen wrote:
> On Fri, 10 Jul 2020 00:20:07 -0700, Eric Biggers wrote:
> 
> > This patchset implements UFS inline encryption support on the
> > DragonBoard 845c, using the Qualcomm Inline Crypto Engine (ICE)
> > that's present on the Snapdragon 845 SoC.
> > 
> > This is based on top of scsi/5.9/scsi-queue, which contains the
> > ufshcd-crypto patches by Satya Tangirala.
> > 
> > [...]
> 
> Applied to 5.9/scsi-queue, thanks!
> 
> [1/5] scsi: firmware: qcom_scm: Add support for programming inline crypto keys
>       https://git.kernel.org/mkp/scsi/c/e10d24786adb
> [2/5] scsi: ufs-qcom: Name the dev_ref_clk_ctrl registers
>       https://git.kernel.org/mkp/scsi/c/12700db4f9f7
> [4/5] scsi: ufs: Add program_key() variant op
>       https://git.kernel.org/mkp/scsi/c/a5fedfacb402
> [5/5] scsi: ufs-qcom: Add Inline Crypto Engine support
>       https://git.kernel.org/mkp/scsi/c/de9063fbd769

Seems that something went wrong when you applied patch 5.  It's supposed to add
the file ufs-qcom-ice.c, but the committed version doesn't have that file.

- Eric
