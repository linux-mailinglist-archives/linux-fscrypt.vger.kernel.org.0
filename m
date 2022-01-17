Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB05490A89
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jan 2022 15:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiAQOfE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jan 2022 09:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbiAQOfD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jan 2022 09:35:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03800C06173E;
        Mon, 17 Jan 2022 06:35:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 933536127C;
        Mon, 17 Jan 2022 14:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF947C36AEC;
        Mon, 17 Jan 2022 14:35:00 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="o5lUIVek"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642430099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aaW0Uk+9BWDfg75RNXbu9puufapoNx/hbgFAFnNlHpA=;
        b=o5lUIVekFU/CMlMWfbMSHPWg3Y+AO+IBjHDVYdA4/1ehvadLmE47x9mx9KjUg/tkH4n+Bm
        BXhisVCv73+46A0QTAGsXfhxrC1ZK3iUOitweRNXQFU5+mIYZMAN/69ypY5yjIg2Nqu6Ho
        mxekyYSnnO6ZTQrb9NaxbRW0auHiYl4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 70f2d64c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 17 Jan 2022 14:34:58 +0000 (UTC)
Date:   Mon, 17 Jan 2022 15:34:54 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     dhowells@redhat.com, dwmw2@infradead.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.ibm.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
Message-ID: <YeV+jkGg6mpQdRID@zx2c4.com>
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220111180318.591029-1-roberto.sassu@huawei.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

While it looks like you put a lot of work into this patchset, I think
the general idea of adding PGP *to the kernel* is a pretty daunting
proposition. The general consensus in the crypto engineering world is
that PGP ought to be on its way out. We definitely don't want to
perpetuate this project-on-life-support into the permanence of kernel
code. Some quick Google searches will reveal a litany of blog posts to
the tune of, "why oh why are people still using this?" Here's one from
2019: https://latacora.micro.blog/2019/07/16/the-pgp-problem.html . I
think these are arguments to take seriously. And even if you disagree
with some parts, you may want to consider whether the remaining parts
warrant a bit of pause before adding this to the kernel and perpetuating
PGP's design further.

If you're looking for a simple signature mechanism to replace the use of
X.509 and all of that infrastructure, may I suggest just coming up with
something simple using ed25519, similar to signify or minisign? Very
minimal code in the kernel, in userspace, and very few moving parts to
break.

Jason
