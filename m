Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6481051B75C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 May 2022 07:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiEEFMU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 May 2022 01:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiEEFMS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 May 2022 01:12:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0DC21821;
        Wed,  4 May 2022 22:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3D9561ADE;
        Thu,  5 May 2022 05:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFC3C385A4;
        Thu,  5 May 2022 05:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651727319;
        bh=lBK8/trxgvR1f4DEH1CbdWJ4Y+Fce8JnB+5d9H6RVS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=suSziVbVT9y/3fYePbKPNEptGZeRtOsVOFwhAm+gaQTOpu2HbcFR6CdEGNm3Xiolx
         wyDNW+cVr3bW8fUTb0JjVCKscsjlkrhj+3wLACt7cFD4CJnPVY0e/06E58IQPGkvQK
         9cT2ALQqC8XuyuDB7peO/lCupdbzCR1f9c+ICnAWvYfjISd4PRYlms6y3xZU+ebN49
         lUnnA44MyGDnvec6LYVkImKIQ1QaBr0mFFnlYenBI0LyovtQi/Ibue/gBtm0c7DeD/
         WFHoN3v9CBjzjXKVv2OAG1EWSzDp+Y9dWbx2gylVnOvkdkC0EqhAdLQ9nowJyIzmKE
         pPMYQSOIw0MWA==
Date:   Wed, 4 May 2022 22:08:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v6 7/9] crypto: x86/polyval: Add PCLMULQDQ accelerated
 implementation of POLYVAL
Message-ID: <YnNb1Quo3CAGQmHA@sol.localdomain>
References: <20220504001823.2483834-1-nhuck@google.com>
 <20220504001823.2483834-8-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504001823.2483834-8-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 04, 2022 at 12:18:21AM +0000, Nathan Huckleberry wrote:
> +.macro schoolbook1_iteration i xor_sum
> +	movups (16*\i)(MSG), %xmm0
> +	.if (\i == 0 && \xor_sum == 1)
> +		pxor SUM, %xmm0
> +	.endif
> +        vpclmulqdq $0x01, (16*\i)(KEY_POWERS), %xmm0, %xmm2
> +        vpclmulqdq $0x00, (16*\i)(KEY_POWERS), %xmm0, %xmm1
> +        vpclmulqdq $0x10, (16*\i)(KEY_POWERS), %xmm0, %xmm3
> +        vpclmulqdq $0x11, (16*\i)(KEY_POWERS), %xmm0, %xmm4
> +        vpxor %xmm2, MI, MI
> +        vpxor %xmm1, LO, LO
> +        vpxor %xmm4, HI, HI
> +        vpxor %xmm3, MI, MI
> +.endm

The 8 lines above are indented with spaces.  They should use tabs, like
everywhere else.

> + * So our final computation is: T = T_1 : T_0 = g*(x) * P_0 V = V_1 : V_0 =
> + * g*(x) * (P_1 + T_0) p(x) / x^{128} mod g(x) = P_3 + P_1 + T_0 + V_1 : P_2 +
> + * P_0 + T_1 + V_0

This part is unreadable now -- it looks like you formatted it as regular text?
The three equations should be on their own lines, like how it was before.

> +__maybe_unused static const struct x86_cpu_id pcmul_cpu_id[] = {
> +	X86_MATCH_FEATURE(X86_FEATURE_PCLMULQDQ, NULL),
> +	X86_MATCH_FEATURE(X86_FEATURE_AVX, NULL),
> +	{}
> +};
> +MODULE_DEVICE_TABLE(x86cpu, pcmul_cpu_id);
> +
> +static int __init polyval_clmulni_mod_init(void)
> +{
> +	if (!x86_match_cpu(pcmul_cpu_id))
> +		return -ENODEV;
> +
> +	return crypto_register_shash(&polyval_alg);
> +}
> +
> +static void __exit polyval_clmulni_mod_exit(void)
> +{
> +	crypto_unregister_shash(&polyval_alg);
> +}

This won't work as intended; it's registering the algorithm (and autoloading the
module) if PCLMUL *or* AVX is available, rather than PCLMUL *and* AVX.

I think the way to go is to just have X86_FEATURE_PCLMULQDQ in the table, like
before, and add a check for boot_cpu_has(X86_FEATURE_AVX) in the init function.

- Eric
