Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB0C5206D0
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 May 2022 23:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiEIVpp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 May 2022 17:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiEIVpp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 May 2022 17:45:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C11E13B8CB;
        Mon,  9 May 2022 14:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F0BBB81983;
        Mon,  9 May 2022 21:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7E2C385BF;
        Mon,  9 May 2022 21:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652132507;
        bh=JGlBPfdBmX6S3e0RjP60fFEEB0F2ZpIIebHRPLcV2tY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=laT+QmgJ1p7fyHbjk+My3YfixnoTDLkoDbJm7cBXq1btpqTpilTyLym71A68B84e/
         rxThIhZg/z41gSoQZTEH/a6BAmxfHazztBn5ox0tzXKHQgHqq0AYzqH0/4I9Jyldcq
         F+RQkMW0A/26v3pzdjCaJff/Yv3Fmx7czK78P8wPksCcfSc9XEyQ2SDo3rFk3AT3Hu
         KX1cpgy+wMNcyUJuz91SfG91XLE7iZpqTr5fbzrPB1NNfTp4htlNj1nuo5oNlVg+3R
         BURStAMQJtelCI7d0eorXCBnuNTpiQlmqv/8xqoHBdUIdtShaA9m6mdw452yFPllh3
         5W7JhAygh1maw==
Date:   Mon, 9 May 2022 14:41:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v7 8/9] crypto: arm64/polyval: Add PMULL accelerated
 implementation of POLYVAL
Message-ID: <YnmKmfYbYahvYnrF@sol.localdomain>
References: <20220509191107.3556468-1-nhuck@google.com>
 <20220509191107.3556468-9-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509191107.3556468-9-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 09, 2022 at 07:11:06PM +0000, Nathan Huckleberry wrote:
> Add hardware accelerated version of POLYVAL for ARM64 CPUs with
> Crypto Extensions support.
> 
> This implementation is accelerated using PMULL instructions to perform
> the finite field computations.  For added efficiency, 8 blocks of the
> message are processed simultaneously by precomputing the first 8
> powers of the key.
> 
> Karatsuba multiplication is used instead of Schoolbook multiplication
> because it was found to be slightly faster on ARM64 CPUs.  Montgomery
> reduction must be used instead of Barrett reduction due to the
> difference in modulus between POLYVAL's field and other finite fields.
> 
> More information on POLYVAL can be found in the HCTR2 paper:
> "Length-preserving encryption with HCTR2":
> https://eprint.iacr.org/2021/1441.pdf
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/Kconfig           |   5 +
>  arch/arm64/crypto/Makefile          |   3 +
>  arch/arm64/crypto/polyval-ce-core.S | 361 ++++++++++++++++++++++++++++
>  arch/arm64/crypto/polyval-ce-glue.c | 193 +++++++++++++++
>  4 files changed, 562 insertions(+)
>  create mode 100644 arch/arm64/crypto/polyval-ce-core.S
>  create mode 100644 arch/arm64/crypto/polyval-ce-glue.c

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
