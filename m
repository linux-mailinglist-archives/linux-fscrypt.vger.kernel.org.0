Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ACB2E8FA4
	for <lists+linux-fscrypt@lfdr.de>; Mon,  4 Jan 2021 04:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbhADDqa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 3 Jan 2021 22:46:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbhADDq1 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 3 Jan 2021 22:46:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961562087E;
        Mon,  4 Jan 2021 03:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609731946;
        bh=6ARBT7fFQGUTWuwnrfa5PJ/9w9tyLns+HdyLR3NXCPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YZC1dXHL+EmCdKCQ4V/QzikM849gh3LL7x0oeyt/hBrM2tgOOQc7UGu9R/BM0Bw/h
         xfw3l6gG2s4ezllPRVVAYDuK+wfI4OsrsklFYVD76PuQdU/KgoH4PP2n9M68itaJqf
         RyLA2uRT8qxqBMb6Up8KzEdZ2i6opg/f1Cp/PjyfhJAp14Zyjj7mJwkaPq6uHTwnvd
         16v5fTnexkktHb/lJGLsISrBZqbag5G9tSEV430b5OlEJ5d9MYgx/YdhdGuTXWRR8W
         ePSdgSdhoLhHRHxNMRGQ+j4Jm1DQe6wv82vMPu34OLhgYybXwZQMDw9uIYdTdKCRQT
         eN/E7LYVMc/MA==
Date:   Sun, 3 Jan 2021 19:45:45 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: clean up post-read processing
Message-ID: <X/KPaX7Z0WDEXhBM@sol.localdomain>
References: <20201228232612.45538-1-ebiggers@kernel.org>
 <a43158eb-114e-7f7f-871a-7bd9c70639d6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a43158eb-114e-7f7f-871a-7bd9c70639d6@huawei.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 04, 2021 at 11:35:58AM +0800, Chao Yu wrote:
> On 2020/12/29 7:26, Eric Biggers wrote:
> > +	if (ctx && (ctx->enabled_steps & (STEP_DECRYPT | STEP_DECOMPRESS))) {
> > +		INIT_WORK(&ctx->work, f2fs_post_read_work);
> > +		queue_work(ctx->sbi->post_read_wq, &ctx->work);
> 
> Could you keep STEP_DECOMPRESS_NOWQ related logic? so that bio only includes
> non-compressed pages could be handled in irq context rather than in wq context
> which should be unneeded.
> 
> Thanks,
> 

That's already handled; I made it so that STEP_DECOMPRESS is only enabled when
it's actually needed.

- Eric
