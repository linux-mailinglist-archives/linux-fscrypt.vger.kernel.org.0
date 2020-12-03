Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32C52CDEBC
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Dec 2020 20:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgLCTYW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Dec 2020 14:24:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbgLCTYW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Dec 2020 14:24:22 -0500
Date:   Thu, 3 Dec 2020 11:23:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607023421;
        bh=dgKZ0GPXALlHJ8HX2WzQ7blAJ5ntasiHe5O/gfXbvTc=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=S6FEgB8jX/1c70EB2oYEoo/CAvEBHADLY8FuQNB5oOG4rV63f6o634o9/9m8gejVC
         k4deXopmHpKWW2htjAJeQK87u3IKCh+1g3QgPlOnDffMwAWTgMAFgDdlbBbWfUqeTd
         sMpndykYU2BSng1r6adQs2xXUCdzK7fm8ztoVzPV3c0Yous7vui7YcFjk23DiFNbOu
         rh7k5Gt7MaBO6bPhD/2Wd2Osh5PZxCZZoQVpbLx6UzEWpivYcLxHBYt1z4a0AfVWSu
         hZqjSsyzYhR55bF1Nx7t0aJQUMTVHlm/vKcupwACm92gqX2/Us+hLTOyNFKCZYF7fw
         DNlU2KrGIc2dw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: Re: [PATCH v2 3/9] mmc: cqhci: initialize upper 64 bits of 128-bit
 task descriptors
Message-ID: <X8k7Oj7e7ARtsmol@gmail.com>
References: <20201203020516.225701-1-ebiggers@kernel.org>
 <20201203020516.225701-4-ebiggers@kernel.org>
 <bf74d785-a88e-f621-24a3-4e68aeeee753@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf74d785-a88e-f621-24a3-4e68aeeee753@intel.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 03, 2020 at 08:45:15AM +0200, Adrian Hunter wrote:
> On 3/12/20 4:05 am, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Move the task descriptor initialization into cqhci_prep_task_desc(), and
> > make it initialize all 128 bits of the task descriptor if the host
> > controller is using 128-bit task descriptors.
> > 
> > This is needed to prepare for CQHCI inline encryption support, which
> > requires 128-bit task descriptors and uses the upper 64 bits.
> > 
> > Note: since some host controllers already enable 128-bit task
> > descriptors, it's unclear why the previous code worked when it wasn't
> > initializing the upper 64 bits.  One possibility is that the bits are
> > being ignored because the features that use them aren't enabled yet.
> > In any case, setting them to 0 won't hurt.
> 
> Coherent allocations are zero-initialized.  So the upper 64-bits stay zero.
> People set 128-bit anyway because the hardware needs it.

Okay, that explains it then -- I didn't realize that dma_alloc_coherent() always
returns zeroed memory.  It isn't mentioned in
Documentation/core-api/dma-api.rst, and there's no kerneldoc comment, so it
wasn't clear.  But apparently it's intentional; see commit 518a2f1925c3
("dma-mapping: zero memory returned from dma_alloc_*").

I'll fix this commit message in the next version.

- Eric
