Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D92D5206D8
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 May 2022 23:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiEIVsK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 May 2022 17:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiEIVsJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 May 2022 17:48:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182D12421BB;
        Mon,  9 May 2022 14:44:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4B1D616CD;
        Mon,  9 May 2022 21:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D69C385BA;
        Mon,  9 May 2022 21:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652132654;
        bh=OrpYST3eh9LQhsA/mepy9kiYu9eAXLw7s6pP10mWGCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o+lUDrb8wqHZOpKJE926dscuSEUWeQI0+AP5lcM9mwrBpw7gaTtxhiZPgRcYgkNcL
         76cqppg/QPzuM8EkFt0VB76e+QHWu236Z8PgVzuKriRH6ZYXzBYnkyJJSfFXH5kSw3
         xncL646ZEt1FAlUeUbnnD26qOK/aPq6a9Y6V86AnrQ4yNUa7jrkI6fSkMzrK0mjpAv
         M457SKaFA+nAqzx1BbPNHj1J12i0tr7WlRSCkqb0cJ4uSlwzbUrx1SUC2STsRpnQ1E
         l2DzUcwXq2NzFjcOXc/LMeRueLG1CbDHZZwuxgAbhe6XhY1l7wdDCTr2Kwun+vRI7R
         Hqh3gmKYGVWJQ==
Date:   Mon, 9 May 2022 14:44:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v7 7/9] crypto: x86/polyval: Add PCLMULQDQ accelerated
 implementation of POLYVAL
Message-ID: <YnmLLEKTBoYLjiqm@sol.localdomain>
References: <20220509191107.3556468-1-nhuck@google.com>
 <20220509191107.3556468-8-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509191107.3556468-8-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 09, 2022 at 07:11:05PM +0000, Nathan Huckleberry wrote:
> diff --git a/arch/x86/crypto/polyval-clmulni_asm.S b/arch/x86/crypto/polyval-clmulni_asm.S
[...]
> +/*
> + * Computes the product of two 128-bit polynomials at the memory locations
> + * specified by (MSG + 16*i) and (KEY_POWERS + 16*i) and XORs the components of
> + * the 256-bit product into LO, MI, HI.
> + *
> + * Given:
> + *   X = [X_1 : X_0]
> + *   Y = [Y_1 : Y_0]
> + *
> + * We compute:
> + *   LO += X_0 * Y_0
> + *   MI += (X_0 + X_1) * (Y_0 + Y_1)
> + *   HI += X_1 * Y_1

The above comment (changed in v7) is describing Karatsuba multiplication, but
the actual code is using schoolbook multiplication.

Otherwise this looks good:

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
