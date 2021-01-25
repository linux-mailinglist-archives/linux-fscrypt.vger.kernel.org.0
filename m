Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09352302D92
	for <lists+linux-fscrypt@lfdr.de>; Mon, 25 Jan 2021 22:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbhAYVZ4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 Jan 2021 16:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732677AbhAYVZM (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Jan 2021 16:25:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 267162083E;
        Mon, 25 Jan 2021 21:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611609871;
        bh=BQmRoCf9UgnBypY4VSGA9SENtbX6P/faYN0pfSbAMKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N9usCiz4ZTVjgfNpNh/njxv7jldtlIQOCwjWgvTkxSUIdcrSlpuwj/89woSbbtcCy
         GMtvrxVGmsbW32w0KwoToY/3xj+oYQeBw9o0dfHCX5aeZx4udCwjZdMC8DlLM6GSn4
         XIT6lmEcso+BSOqgkacp2LMUQxJpqKrx2/QiskNtOkQzm/UJ+h5S/yZ91wXBXjSN8B
         dml+3NUyNU0WFkZx4Q04LJTU4F9tRrdeci/wB2hz75LQXrsU3qQlTvoGRsmM5i2tYo
         F9Xp+G6/SQlnOWujGZfEwAi5iQBV0gxU2MRO8w5NI2OxZn2ZfeH5idKiGEsnPhyLnP
         Ev13yk+YwlBZQ==
Date:   Mon, 25 Jan 2021 13:24:29 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: Re: [PATCH v6 3/9] mmc: cqhci: initialize upper 64 bits of 128-bit
 task descriptors
Message-ID: <YA83DS1v7V4WKP6o@gmail.com>
References: <20210125183810.198008-1-ebiggers@kernel.org>
 <20210125183810.198008-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125183810.198008-4-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 25, 2021 at 10:38:04AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Move the task descriptor initialization into cqhci_prep_task_desc().
> In addition, make it explicitly initialize all 128 bits of the task
> descriptor if the host controller is using 128-bit task descriptors,
> rather than relying on the implicit zeroing from dmam_alloc_coherent().
> 
> This is needed to prepare for CQHCI inline encryption support, which
> requires 128-bit task descriptors and uses the upper 64 bits.
> 
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Satya Tangirala <satyat@google.com>
> Reviewed-and-tested-by: Peng Zhou <peng.zhou@mediatek.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Apparently only patches 3 and 8 made it to the list.  No idea why; all sends
were successful.  If they don't show up soon, I'll resend the patchset again...

- Eric
