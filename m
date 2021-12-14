Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B4F473A8B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Dec 2021 03:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbhLNCE5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Dec 2021 21:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243875AbhLNCEz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Dec 2021 21:04:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FE5C061574;
        Mon, 13 Dec 2021 18:04:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FF17612FA;
        Tue, 14 Dec 2021 02:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A1EC34603;
        Tue, 14 Dec 2021 02:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639447494;
        bh=UPsBsbPQs/kwfYKXLqfJN2VwsqD4UNmhnl6cOthFoR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z75uRFaRl/lU86lcMIB2+BRFLb0z1Bece9e1BIQY2jVnhbOAKmLLaO7ZisGmiq7EK
         DjjRqyLIkzSjSvseYlGq/BTmUMjMtJMOzzGJmzbSNZGgDHEV/xWCWED7fDZU4FHUdX
         7cIIErMtNi/0gR9TSH0jVBoh9uYCg34kXejgEQeIRd7fQ1aQee946aqbg1pJAevyX7
         i6dcAJACqOLWBwMWLB9lctA3/IJPGVmYp/dbo8bjkNcuqZ8FLcnk8WyyQJ93LA7K2q
         AMI0U3o0Utx6zEQt91MgU4YQQF3RZ92NgkeG8BJLTuGpHHTISRZrK2pn01vPZ5iuFG
         bg4a/rhS+yPpQ==
Date:   Mon, 13 Dec 2021 18:04:52 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        quic_neersoni@quicinc.com, dineshg@quicinc.com
Subject: Re: [PATCH 09/10] soc: qcom: support for generate, import and
 prepare key
Message-ID: <Ybf7xI3YDF3B0zAf@gmail.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <20211206225725.77512-10-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206225725.77512-10-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 06, 2021 at 02:57:24PM -0800, Gaurav Kashyap wrote:
> Implements the vops for generate, prepare and import key
> apis and hooks it up the scm calls defined for them.
> Key management has to be done from Qualcomm Trustzone as only
> it can interface with HWKM.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/scsi/ufs/ufs-qcom-ice.c   | 22 ++++++++
>  drivers/scsi/ufs/ufs-qcom.c       |  3 ++
>  drivers/scsi/ufs/ufs-qcom.h       | 12 +++++
>  drivers/soc/qcom/qti-ice-common.c | 89 ++++++++++++++++++++++++++++---
>  include/linux/qti-ice-common.h    |  8 +++
>  5 files changed, 128 insertions(+), 6 deletions(-)

Similarly to patch 6, it would be preferable to change qti-ice-common in a
separate patch that precedes the ufs-qcom changes, if it's possible.

If this is starting to result in too many patches, you might consider combining
the patches that add generate/import/prepare with the patches that add
derive_sw_secret.  Splitting up patches between subsystems (when possible) is
more important than splitting up the wrapped key feature itself, IMO.

- Eric
