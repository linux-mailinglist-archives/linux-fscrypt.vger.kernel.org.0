Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A096A740C9B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Jun 2023 11:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjF1JYU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 05:24:20 -0400
Received: from dfw.source.kernel.org ([139.178.84.217]:34600 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbjF1JEt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 05:04:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEA926130E;
        Wed, 28 Jun 2023 06:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBDEC433C8;
        Wed, 28 Jun 2023 06:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687934312;
        bh=hIaK5MMZGhPP0WIwXVhK5SME6ZluWkRCOQFxos9q7yo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I8ua108wM9nVnxl66nOGDyuQnEeDyCv1Lt9xUx3PvvrSFEyRKVVsoCEhtZe5OkjJj
         K8PV1w6/2hv7iFGo9RIXX4tJ65+EOyV/k1I5pDcWGlCR1xSfvx++iL7DcAu4Lww9wl
         4UMPqtN8Mfr+9RAAJ72Oen2S6f9NBtKagv3+F/GbYc9NyuyXDkH8j8pSKsxtmZ53ug
         cYMwpr9SeoYocFqOd3gccdDDwqFMy4UbNYX88v1uFnfJehK0wgikDju1OEy//LzXLo
         IpAyRn0Fnyz3YMYboSJJ92ReN/WU6M2Vw8rpeN/oYMZxWucdGEe1xctpK6zN+2bG+5
         aXhcdu7sDEPbg==
Date:   Tue, 27 Jun 2023 23:38:30 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dongsoo Lee <letrhee@nsr.re.kr>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-crypto@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] fscrypt: Add LEA-256-XTS, LEA-256-CTS support
Message-ID: <20230628063830.GA7920@sol.localdomain>
References: <20230626084703.907331-1-letrhee@nsr.re.kr>
 <20230626084703.907331-5-letrhee@nsr.re.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626084703.907331-5-letrhee@nsr.re.kr>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jun 26, 2023 at 05:47:03PM +0900, Dongsoo Lee wrote:
> when SIMD instructions are available, it performs even faster.

This will only be true once there is actually an applicable implementation of
LEA-XTS and LEA-CTS using SIMD instructions included in the kernel.

Perhaps it is your plan to go through and accelerate LEA-XTS and LEA-CTS for the
common CPU architectures.  However, it is not included in this patchset yet, so
it should not be claimed in the documentation yet.

> Particularly, it outperforms AES when the dedicated crypto
> +instructions for AES are unavailable, regardless of the presence of SIMD
> +instructions. However, it is not recommended to use LEA unless there is
> +a clear reason (such as the absence of dedicated crypto instructions for
> +AES or a mandatory requirement) to do so. Also, to enable LEA support,
> +it needs to be enabled in the kernel crypto API.

I think I'd prefer that you omit the mention of the "absence of dedicated crypto
instructions" use case for now.  fscrypt already supports another algorithm that
fulfills exactly that use case (Adiantum), and that algorithm already has
optimized implementations for arm32, arm64, and x86_64.  LEA does not have that
yet.  So it does not really bring anything new to the table.  I'm also unsure it
would be appropriate to recommend a "lightweight" cipher at this point...

That would leave "mandatory requirement" as the rationale, at least for now,
similar to SM4.

- Eric
