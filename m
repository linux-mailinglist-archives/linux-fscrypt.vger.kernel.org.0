Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B68451D0D6
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 May 2022 07:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbiEFFos (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 6 May 2022 01:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242042AbiEFFor (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 6 May 2022 01:44:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C3613F90;
        Thu,  5 May 2022 22:41:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9F32B83137;
        Fri,  6 May 2022 05:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9CEC385AA;
        Fri,  6 May 2022 05:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651815662;
        bh=YU3kHHc9yTMaXiVCK6PqwUW5BRxgHzvMtgGhbF8A9/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ry11ZpM2K6ciEsw6sU2I3HXXAB/Kl4OUHw773f+6tBsQg3Zz2WxLvDcdPbNXvogEm
         YmLnQoHh6vAHUGWSxkrH0rW5VIzgKdDNrlEbMF4CiuhUAgiT9wqPZ22vRTlMv4Fbv4
         +1ct2q59QYPZYo9gDG+PK/HbDoEtrF2FcDp1c878foA1HTg0On/yDgOK3s9o6ExNeM
         nFxkP+Ajz7iXIa9sGbAHTt1S//68tvUP4D9duClL/ubjcp7+UuXjsaqTvMcjjHew5S
         Is68Aq0ZbiovNWFIhSbOug+6dUEM8RWE+CX2QAhbp4Ja7hinJeHjA6sS/r2cprmbh/
         fsRqv7EMSX5PQ==
Date:   Thu, 5 May 2022 22:41:00 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v6 6/9] crypto: arm64/aes-xctr: Improve readability of
 XCTR and CTR modes
Message-ID: <YnS07JPEoeFlsRAQ@sol.localdomain>
References: <20220504001823.2483834-1-nhuck@google.com>
 <20220504001823.2483834-7-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504001823.2483834-7-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 04, 2022 at 12:18:20AM +0000, Nathan Huckleberry wrote:
> Added some clarifying comments, changed the register allocations to make
> the code clearer, and added register aliases.
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

I was a bit surprised to see this after the xctr support patch rather than
before.  Doing the cleanup first would make adding and reviewing the xctr
support easier.  But it's not a big deal; if you already tested it this way you
can just leave it as-is if you want.

A few minor comments below.

> +	/*
> +	 * Set up the counter values in v0-v4.
> +	 *
> +	 * If we are encrypting less than MAX_STRIDE blocks, the tail block
> +	 * handling code expects the last keystream block to be in v4.  For
> +	 * example: if encrypting two blocks with MAX_STRIDE=5, then v3 and v4
> +	 * should have the next two counter blocks.
> +	 */

The first two mentions of v4 should actually be v{MAX_STRIDE-1}, as it is
actually v4 for MAX_STRIDE==5 and v3 for MAX_STRIDE==4.

> @@ -355,16 +383,16 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
>  	mov		v3.16b, vctr.16b
>  ST5(	mov		v4.16b, vctr.16b		)
>  	.if \xctr
> -		sub		x6, x11, #MAX_STRIDE - 1
> -		sub		x7, x11, #MAX_STRIDE - 2
> -		sub		x8, x11, #MAX_STRIDE - 3
> -		sub		x9, x11, #MAX_STRIDE - 4
> -ST5(		sub		x10, x11, #MAX_STRIDE - 5	)
> -		eor		x6, x6, x12
> -		eor		x7, x7, x12
> -		eor		x8, x8, x12
> -		eor		x9, x9, x12
> -		eor		x10, x10, x12
> +		sub		x6, CTR, #MAX_STRIDE - 1
> +		sub		x7, CTR, #MAX_STRIDE - 2
> +		sub		x8, CTR, #MAX_STRIDE - 3
> +		sub		x9, CTR, #MAX_STRIDE - 4
> +ST5(		sub		x10, CTR, #MAX_STRIDE - 5	)
> +		eor		x6, x6, IV_PART
> +		eor		x7, x7, IV_PART
> +		eor		x8, x8, IV_PART
> +		eor		x9, x9, IV_PART
> +		eor		x10, x10, IV_PART

The eor into x10 should be enclosed by ST5(), since it's dead code otherwise.

> +	/*
> +	 * If there are at least MAX_STRIDE blocks left, XOR the plaintext with
> +	 * keystream and store.  Otherwise jump to tail handling.
> +	 */

Technically this could be XOR-ing with either the plaintext or the ciphertext.
Maybe write "data" instead.

>  .Lctrtail1x\xctr:
> -	sub		x7, x6, #16
> -	csel		x6, x6, x7, eq
> -	add		x1, x1, x6
> -	add		x0, x0, x6
> -	ld1		{v5.16b}, [x1]
> -	ld1		{v6.16b}, [x0]
> +	/*
> +	 * Handle <= 16 bytes of plaintext
> +	 */
> +	sub		x8, x7, #16
> +	csel		x7, x7, x8, eq
> +	add		IN, IN, x7
> +	add		OUT, OUT, x7
> +	ld1		{v5.16b}, [IN]
> +	ld1		{v6.16b}, [OUT]
>  ST5(	mov		v3.16b, v4.16b			)
>  	encrypt_block	v3, w3, x2, x8, w7

w3 and x2 should be ROUNDS_W and KEY, respectively.

This code also has the very unusual property that it reads and writes before the
buffers given.  Specifically, for bytes < 16, it access the 16 bytes beginning
at &in[bytes - 16] and &dst[bytes - 16].  Mentioning this explicitly would be
very helpful, particularly in the function comments for aes_ctr_encrypt() and
aes_xctr_encrypt(), and maybe in the C code, so that anyone calling these
functions has this in mind.

Anyway, with the above addressed feel free to add:

	Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
