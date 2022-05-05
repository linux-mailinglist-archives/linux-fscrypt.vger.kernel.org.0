Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593B751B7A5
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 May 2022 07:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243945AbiEEGAc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 May 2022 02:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiEEGAa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 May 2022 02:00:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A7629C86;
        Wed,  4 May 2022 22:56:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EB1961C16;
        Thu,  5 May 2022 05:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E946C385A4;
        Thu,  5 May 2022 05:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651730211;
        bh=wspa6oBp61T6ZNoZSTb/Ap2SRQOc8RAlZyxMCn+JRkw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N/Ng0JJTyAJ9akPBvDKJ8OHa8b8e58ftOzIhBbGrPbZ1hJcbjA+cbYmwd/dKkiDZl
         Xc6LT9SgvZhI1aV4/TDPOd9jyP3AefN1tlSniKlohkUFEmIjf4oWHwlcnUWxVQl8rq
         69X3nUwu9euQ57XAdD4zfV7pQDi/XsRc1zahHpHjWrOw5gpZd9qUO9qV4sdWndRTfY
         GFUMNHHBdgaBIJ0grPYuZyC5zI9e8l944Op+vy4aoc5/Txa7aSDCPxR8i923lxt27D
         wefNazij/QAHic6ZEcavWTaPn7DozgTwZmoL8CRFEzqpE6E2ti7qI9wFXq7coIplw+
         4y11gFeSWpIRA==
Date:   Wed, 4 May 2022 22:56:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v6 8/9] crypto: arm64/polyval: Add PMULL accelerated
 implementation of POLYVAL
Message-ID: <YnNnIV0P9bFgTkQt@sol.localdomain>
References: <20220504001823.2483834-1-nhuck@google.com>
 <20220504001823.2483834-9-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504001823.2483834-9-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 04, 2022 at 12:18:22AM +0000, Nathan Huckleberry wrote:
> + * X = [X_1 : X_0]
> + * Y = [Y_1 : Y_0]
> + *
> + * The multiplication produces four parts:
> + *   LOW: The polynomial given by performing carryless multiplication of X_0 and
> + *   Y_0
> + *   MID: The polynomial given by performing carryless multiplication of (X_0 +
> + *   X_1) and (Y_0 + Y_1)
> + *   HIGH: The polynomial given by performing carryless multiplication of X_1
> + *   and Y_1
> + *
> + * We compute:
> + *  LO += LOW
> + *  MI += MID
> + *  HI += HIGH

Three parts, not four.  But why not write this as the much more concise:

 * Given:
 *	X = [X_1 : X_0]
 *	Y = [Y_1 : Y_0]
 *
 * We compute:
 *	LO += X_0 * Y_0
 *	MI += (X_0 + X_1) * (Y_0 + Y_1)
 *	HI += X_1 * Y_1

> + * So our final computation is: T = T_1 : T_0 = g*(x) * P_0 V = V_1 : V_0 =      
> + * g*(x) * (P_1 + T_0) p(x) / x^{128} mod g(x) = P_3 + P_1 + T_0 + V_1 : P_2 +   
> + * P_0 + T_1 + V_0                                                               

As on the x86 version, this part is now unreadable.  It was fine in v5.

> + *   [HI_1 : HI_0 + HI_1 + MI_1 + LO_1 : LO_1 + HI_0 + MI_0 + LO_0 : LO_0]
[...]
> + *   [HI_1 : HI_1 + HI_0 + MI_1 + LO_1 : HI_0 + MI_0 + LO_1 + LO_0 : LO_0]
[...]
> +	// TMP_V = T_1 : T_0 = P_0 * g*(x)
> +	pmull	TMP_V.1q, PL.1d, GSTAR.1d
[...]
> +	// TMP_V = V_1 : V_0 = (P_1 + T_0) * g*(x)
> +	pmull2	TMP_V.1q, GSTAR.2d, TMP_V.2d
> +	eor	DEST.16b, PH.16b, TMP_V.16b
[...]
> +	pmull	TMP_V.1q, GSTAR.1d, PL.1d
[...]
> +	pmull2	TMP_V.1q, GSTAR.2d, TMP_V.2d
[...]
> +	eor	SUM.16b, TMP_V.16b, PH.16b

It looks like you didn't fully address my comments on v5 about putting operands
in a consistent order.  Not a big deal, but assembly code is always hard to
read, and anything to make it easier would be greatly appreciated.

> +/*
> + * Handle any extra blocks afer full_stride loop.
> + */

Typo above.

> diff --git a/arch/arm64/crypto/polyval-ce-glue.c b/arch/arm64/crypto/polyval-ce-glue.c
[...]
> +struct polyval_tfm_ctx {
> +	u8 key_powers[NUM_KEY_POWERS][POLYVAL_BLOCK_SIZE];
> +};

This is missing the comment about the order of the key powers that I had
suggested for readability.  It made it into the x86 version but not here.  This
file is very similar to arch/x86/crypto/polyval-clmulni_glue.c, so if you could
diff them and eliminate any unintended differences, that would be helpful.

Other than the above readability suggestions this patch looks good, nice job.

- Eric
