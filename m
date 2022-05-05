Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A781A51B73C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 May 2022 06:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240868AbiEEEsq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 May 2022 00:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236408AbiEEEsp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 May 2022 00:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AA246664;
        Wed,  4 May 2022 21:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B91D61ACC;
        Thu,  5 May 2022 04:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA1CC385A4;
        Thu,  5 May 2022 04:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651725905;
        bh=PTaOk+WTUH819ovGW3Jcx/OVdxVUDa4lj5AEtN66c4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iZfuXtnqNPNiCo9t+O8LsLeK1k37cHkSRwwhgyMNZY8Jtu+5vkDW/hyKlRCyxuQF/
         0cPlFztUJzgQDNLRo0TVOgvZ7l/41dkOk4xpKHYp1u9GlNlmHedD1sOTlsGEBFztOt
         tc0Vhv9ozN2cIFGQLwiS5czYZsrQNhHDBLXoTyr2CKG8lzrzb1TUAZDWaTGTT4rJ6I
         JnCvEU5HlDNHmBsKmmXqTUyC5g1+b1tN4wSMLqGmmYAsiyAGDW3xsx/LrjG0Ib8HFE
         BJYGo3mAxEpGnj5ABXqWDNbSVrOcNe4/ujkIojIrt5lQ7Jf1tB6jp1ilozNcyv9lII
         0qr9OhxJiiI2g==
Date:   Wed, 4 May 2022 21:45:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v6 4/9] crypto: x86/aesni-xctr: Add accelerated
 implementation of XCTR
Message-ID: <YnNWT139+XAJ7zC1@sol.localdomain>
References: <20220504001823.2483834-1-nhuck@google.com>
 <20220504001823.2483834-5-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504001823.2483834-5-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 04, 2022 at 12:18:18AM +0000, Nathan Huckleberry wrote:
> Add hardware accelerated versions of XCTR for x86-64 CPUs with AESNI
> support.  These implementations are modified versions of the CTR
> implementations found in aesni-intel_asm.S and aes_ctrby8_avx-x86_64.S.

The commit message still needs to be fixed, as I noted on v5, since there is now
only one implementation being added, and aesni-intel_asm.S isn't being changed.

> 
> More information on XCTR can be found in the HCTR2 paper:
> "Length-preserving encryption with HCTR2":
> https://eprint.iacr.org/2021/1441.pdf
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 232 ++++++++++++++++--------
>  arch/x86/crypto/aesni-intel_glue.c      | 114 +++++++++++-
>  crypto/Kconfig                          |   2 +-
>  3 files changed, 266 insertions(+), 82 deletions(-)

Otherwise this patch looks good:

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
