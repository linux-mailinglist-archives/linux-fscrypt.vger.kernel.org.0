Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1002D21F6F0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jul 2020 18:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgGNQPS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jul 2020 12:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgGNQPS (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jul 2020 12:15:18 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C83E22071B;
        Tue, 14 Jul 2020 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594743318;
        bh=3u3sAAsyBAscZ5XuMCYsNQr30YL+BOY723HpDMvsq8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hUD3xxUguOoPiwI3jSHd7vEraS4XgAqW5XGbHyoudHB4kheUEs2U4nKJNhmrBcEi/
         FEd892tRGLFIfJp18+l7i1osF8VW4FaeK+u6zBoNz1FKbM2R9YAIfXMRaIMAtdHCsj
         vHu8y7aopTyUSfLOB2T9JU7k8pVpqjF5Y4FOEeVA=
Date:   Tue, 14 Jul 2020 09:15:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: Re: [PATCH v6 3/5] arm64: dts: sdm845: add Inline Crypto Engine
 registers and clock
Message-ID: <20200714161516.GA1064009@gmail.com>
References: <20200710072013.177481-1-ebiggers@kernel.org>
 <20200710072013.177481-4-ebiggers@kernel.org>
 <yq1ft9uqj6u.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1ft9uqj6u.fsf@ca-mkp.ca.oracle.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jul 14, 2020 at 10:16:04AM -0400, Martin K. Petersen wrote:
> 
> Eric,
> 
> > Add the vendor-specific registers and clock for Qualcomm ICE (Inline
> > Crypto Engine) to the device tree node for the UFS host controller on
> > sdm845, so that the ufs-qcom driver will be able to use inline crypto.
> 
> I would like to see an Acked-by for this patch before I merge it.
> 

Andy, Bjorn, or Rob: can you give Acked-by?

- Eric
