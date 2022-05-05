Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D4751B835
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 May 2022 08:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbiEEGxi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 May 2022 02:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbiEEGxh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 May 2022 02:53:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C813447045;
        Wed,  4 May 2022 23:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FEBFB82BED;
        Thu,  5 May 2022 06:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D23C385AF;
        Thu,  5 May 2022 06:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651733396;
        bh=lSak+gmChtT3mVmwO91xlHv2YotCvHVAYhtgGKNtJLs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BJeaTFgBMtc827q5iN0XaqC+bBv4lM3hCw8P9T4lvdecp8b0Yv/ZbEJyZ39qfxE0f
         44gmSi01ufjd+Nmcu0cfRwzIF5Est7GPKWIAJ7G/tMSXbGX22ZgSPo7B+SMXx+j0vm
         prczYpWMfZOvTZM1FEjpyZdBJ0kFuSqnTRL0qik0ES5vhLgrj1gifH7tEe/d6GCyk4
         ibZ1/WBCoHkaplGMegq2L83DNNEzK1nb9TUo0jJ6AatU4ouo6fkLBJnq+BLWwumRpP
         1IjjnEuBsdTtbyTWnMB5vqqw+A8ZFhArjRiVl0BQa0Y77wLfEPBDf7/K4e+I+S/cNP
         hLWEnCZTw8oZg==
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-e656032735so3430642fac.0;
        Wed, 04 May 2022 23:49:55 -0700 (PDT)
X-Gm-Message-State: AOAM531s5tW7WlQg5FXOIb3kWHWCva5qC1o0z61Wlyz4vbatEymrh+w2
        sD2neejrYo79PDkwWTU3NyTCr2Y7eShHXl3gZAU=
X-Google-Smtp-Source: ABdhPJxKnLWrnW1L8yR8uq2dbFpGPLDOMqX/j2YHJT0b9PPSxEa7WCkjxaZnMHtPpVjRqb3muybU9BS2nvfQcu68aFA=
X-Received: by 2002:a05:6870:468e:b0:ed:de90:fa80 with SMTP id
 a14-20020a056870468e00b000edde90fa80mr1544477oap.126.1651733395046; Wed, 04
 May 2022 23:49:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220504001823.2483834-1-nhuck@google.com> <20220504001823.2483834-7-nhuck@google.com>
In-Reply-To: <20220504001823.2483834-7-nhuck@google.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 5 May 2022 08:49:44 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEBEkGqEx3PaFV0jnufQEkZxe0oiXoxoB2PYwz9BQJmEw@mail.gmail.com>
Message-ID: <CAMj1kXEBEkGqEx3PaFV0jnufQEkZxe0oiXoxoB2PYwz9BQJmEw@mail.gmail.com>
Subject: Re: [PATCH v6 6/9] crypto: arm64/aes-xctr: Improve readability of
 XCTR and CTR modes
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Nathan,

Thanks for cleaning this up.

On Wed, 4 May 2022 at 02:18, Nathan Huckleberry <nhuck@google.com> wrote:
>
> Added some clarifying comments, changed the register allocations to make
> the code clearer, and added register aliases.
>
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

With one comment below addressed:

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm64/crypto/aes-modes.S | 193 ++++++++++++++++++++++------------
>  1 file changed, 128 insertions(+), 65 deletions(-)
>
> diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
> index 55df157fce3a..da7c9f3380f8 100644
> --- a/arch/arm64/crypto/aes-modes.S
> +++ b/arch/arm64/crypto/aes-modes.S
> @@ -322,32 +322,60 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
>          * This macro generates the code for CTR and XCTR mode.
>          */
>  .macro ctr_encrypt xctr
> +       // Arguments
> +       OUT             .req x0
> +       IN              .req x1
> +       KEY             .req x2
> +       ROUNDS_W        .req w3
> +       BYTES_W         .req w4
> +       IV              .req x5
> +       BYTE_CTR_W      .req w6         // XCTR only
> +       // Intermediate values
> +       CTR_W           .req w11        // XCTR only
> +       CTR             .req x11        // XCTR only
> +       IV_PART         .req x12
> +       BLOCKS          .req x13
> +       BLOCKS_W        .req w13
> +
>         stp             x29, x30, [sp, #-16]!
>         mov             x29, sp
>
> -       enc_prepare     w3, x2, x12
> -       ld1             {vctr.16b}, [x5]
> +       enc_prepare     ROUNDS_W, KEY, IV_PART
> +       ld1             {vctr.16b}, [IV]
>
> +       /*
> +        * Keep 64 bits of the IV in a register.  For CTR mode this lets us
> +        * easily increment the IV.  For XCTR mode this lets us efficiently XOR
> +        * the 64-bit counter with the IV.
> +        */
>         .if \xctr
> -               umov            x12, vctr.d[0]
> -               lsr             w11, w6, #4
> +               umov            IV_PART, vctr.d[0]
> +               lsr             CTR_W, BYTE_CTR_W, #4
>         .else
> -               umov            x12, vctr.d[1] /* keep swabbed ctr in reg */
> -               rev             x12, x12
> +               umov            IV_PART, vctr.d[1]
> +               rev             IV_PART, IV_PART
>         .endif
>
>  .LctrloopNx\xctr:
> -       add             w7, w4, #15
> -       sub             w4, w4, #MAX_STRIDE << 4
> -       lsr             w7, w7, #4
> +       add             BLOCKS_W, BYTES_W, #15
> +       sub             BYTES_W, BYTES_W, #MAX_STRIDE << 4
> +       lsr             BLOCKS_W, BLOCKS_W, #4
>         mov             w8, #MAX_STRIDE
> -       cmp             w7, w8
> -       csel            w7, w7, w8, lt
> +       cmp             BLOCKS_W, w8
> +       csel            BLOCKS_W, BLOCKS_W, w8, lt
>
> +       /*
> +        * Set up the counter values in v0-v4.
> +        *
> +        * If we are encrypting less than MAX_STRIDE blocks, the tail block
> +        * handling code expects the last keystream block to be in v4.  For
> +        * example: if encrypting two blocks with MAX_STRIDE=5, then v3 and v4
> +        * should have the next two counter blocks.
> +        */
>         .if \xctr
> -               add             x11, x11, x7
> +               add             CTR, CTR, BLOCKS
>         .else
> -               adds            x12, x12, x7
> +               adds            IV_PART, IV_PART, BLOCKS
>         .endif
>         mov             v0.16b, vctr.16b
>         mov             v1.16b, vctr.16b
> @@ -355,16 +383,16 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
>         mov             v3.16b, vctr.16b
>  ST5(   mov             v4.16b, vctr.16b                )
>         .if \xctr
> -               sub             x6, x11, #MAX_STRIDE - 1
> -               sub             x7, x11, #MAX_STRIDE - 2
> -               sub             x8, x11, #MAX_STRIDE - 3
> -               sub             x9, x11, #MAX_STRIDE - 4
> -ST5(           sub             x10, x11, #MAX_STRIDE - 5       )
> -               eor             x6, x6, x12
> -               eor             x7, x7, x12
> -               eor             x8, x8, x12
> -               eor             x9, x9, x12
> -               eor             x10, x10, x12
> +               sub             x6, CTR, #MAX_STRIDE - 1
> +               sub             x7, CTR, #MAX_STRIDE - 2
> +               sub             x8, CTR, #MAX_STRIDE - 3
> +               sub             x9, CTR, #MAX_STRIDE - 4
> +ST5(           sub             x10, CTR, #MAX_STRIDE - 5       )
> +               eor             x6, x6, IV_PART
> +               eor             x7, x7, IV_PART
> +               eor             x8, x8, IV_PART
> +               eor             x9, x9, IV_PART
> +               eor             x10, x10, IV_PART
>                 mov             v0.d[0], x6
>                 mov             v1.d[0], x7
>                 mov             v2.d[0], x8
> @@ -381,9 +409,9 @@ ST5(                mov             v4.d[0], x10                    )
>                 ins             vctr.d[0], x8
>
>                 /* apply carry to N counter blocks for N := x12 */

Please update this comment as well. And while at it, it might make
sense to clarify that doing a conditional branch here is fine wrt time
invariance, given that the IV is not part of the key or the plaintext,
and this code rarely triggers in practice anyway.

> -               cbz             x12, 2f
> +               cbz             IV_PART, 2f
>                 adr             x16, 1f
> -               sub             x16, x16, x12, lsl #3
> +               sub             x16, x16, IV_PART, lsl #3
>                 br              x16
>                 bti             c
>                 mov             v0.d[0], vctr.d[0]
> @@ -398,71 +426,88 @@ ST5(              mov             v4.d[0], vctr.d[0]              )
>  1:             b               2f
>                 .previous
>
> -2:             rev             x7, x12
> +2:             rev             x7, IV_PART
>                 ins             vctr.d[1], x7
> -               sub             x7, x12, #MAX_STRIDE - 1
> -               sub             x8, x12, #MAX_STRIDE - 2
> -               sub             x9, x12, #MAX_STRIDE - 3
> +               sub             x7, IV_PART, #MAX_STRIDE - 1
> +               sub             x8, IV_PART, #MAX_STRIDE - 2
> +               sub             x9, IV_PART, #MAX_STRIDE - 3
>                 rev             x7, x7
>                 rev             x8, x8
>                 mov             v1.d[1], x7
>                 rev             x9, x9
> -ST5(           sub             x10, x12, #MAX_STRIDE - 4       )
> +ST5(           sub             x10, IV_PART, #MAX_STRIDE - 4   )
>                 mov             v2.d[1], x8
>  ST5(           rev             x10, x10                        )
>                 mov             v3.d[1], x9
>  ST5(           mov             v4.d[1], x10                    )
>         .endif
> -       tbnz            w4, #31, .Lctrtail\xctr
> -       ld1             {v5.16b-v7.16b}, [x1], #48
> +
> +       /*
> +        * If there are at least MAX_STRIDE blocks left, XOR the plaintext with
> +        * keystream and store.  Otherwise jump to tail handling.
> +        */
> +       tbnz            BYTES_W, #31, .Lctrtail\xctr
> +       ld1             {v5.16b-v7.16b}, [IN], #48
>  ST4(   bl              aes_encrypt_block4x             )
>  ST5(   bl              aes_encrypt_block5x             )
>         eor             v0.16b, v5.16b, v0.16b
> -ST4(   ld1             {v5.16b}, [x1], #16             )
> +ST4(   ld1             {v5.16b}, [IN], #16             )
>         eor             v1.16b, v6.16b, v1.16b
> -ST5(   ld1             {v5.16b-v6.16b}, [x1], #32      )
> +ST5(   ld1             {v5.16b-v6.16b}, [IN], #32      )
>         eor             v2.16b, v7.16b, v2.16b
>         eor             v3.16b, v5.16b, v3.16b
>  ST5(   eor             v4.16b, v6.16b, v4.16b          )
> -       st1             {v0.16b-v3.16b}, [x0], #64
> -ST5(   st1             {v4.16b}, [x0], #16             )
> -       cbz             w4, .Lctrout\xctr
> +       st1             {v0.16b-v3.16b}, [OUT], #64
> +ST5(   st1             {v4.16b}, [OUT], #16            )
> +       cbz             BYTES_W, .Lctrout\xctr
>         b               .LctrloopNx\xctr
>
>  .Lctrout\xctr:
>         .if !\xctr
> -               st1             {vctr.16b}, [x5] /* return next CTR value */
> +               st1             {vctr.16b}, [IV] /* return next CTR value */
>         .endif
>         ldp             x29, x30, [sp], #16
>         ret
>
>  .Lctrtail\xctr:
> +       /*
> +        * Handle up to MAX_STRIDE * 16 - 1 bytes of plaintext
> +        *
> +        * This code expects the last keystream block to be in v4.  For example:
> +        * if encrypting two blocks with MAX_STRIDE=5, then v3 and v4 should
> +        * have the next two counter blocks.
> +        *
> +        * This allows us to store the ciphertext by writing to overlapping
> +        * regions of memory.  Any invalid ciphertext blocks get overwritten by
> +        * correctly computed blocks.  This approach avoids extra conditional
> +        * branches.
> +        */

Nit: Without overlapping stores, we'd have to load and store smaller
quantities and use a loop here, or bounce it via a temp buffer and
memcpy() it from the C code. So it's not just some extra branches.

>         mov             x16, #16
> -       ands            x6, x4, #0xf
> -       csel            x13, x6, x16, ne
> +       ands            w7, BYTES_W, #0xf
> +       csel            x13, x7, x16, ne
>
> -ST5(   cmp             w4, #64 - (MAX_STRIDE << 4)     )
> +ST5(   cmp             BYTES_W, #64 - (MAX_STRIDE << 4))
>  ST5(   csel            x14, x16, xzr, gt               )
> -       cmp             w4, #48 - (MAX_STRIDE << 4)
> +       cmp             BYTES_W, #48 - (MAX_STRIDE << 4)
>         csel            x15, x16, xzr, gt
> -       cmp             w4, #32 - (MAX_STRIDE << 4)
> +       cmp             BYTES_W, #32 - (MAX_STRIDE << 4)
>         csel            x16, x16, xzr, gt
> -       cmp             w4, #16 - (MAX_STRIDE << 4)
> +       cmp             BYTES_W, #16 - (MAX_STRIDE << 4)
>
> -       adr_l           x12, .Lcts_permute_table
> -       add             x12, x12, x13
> +       adr_l           x9, .Lcts_permute_table
> +       add             x9, x9, x13
>         ble             .Lctrtail1x\xctr
>
> -ST5(   ld1             {v5.16b}, [x1], x14             )
> -       ld1             {v6.16b}, [x1], x15
> -       ld1             {v7.16b}, [x1], x16
> +ST5(   ld1             {v5.16b}, [IN], x14             )
> +       ld1             {v6.16b}, [IN], x15
> +       ld1             {v7.16b}, [IN], x16
>
>  ST4(   bl              aes_encrypt_block4x             )
>  ST5(   bl              aes_encrypt_block5x             )
>
> -       ld1             {v8.16b}, [x1], x13
> -       ld1             {v9.16b}, [x1]
> -       ld1             {v10.16b}, [x12]
> +       ld1             {v8.16b}, [IN], x13
> +       ld1             {v9.16b}, [IN]
> +       ld1             {v10.16b}, [x9]
>
>  ST4(   eor             v6.16b, v6.16b, v0.16b          )
>  ST4(   eor             v7.16b, v7.16b, v1.16b          )
> @@ -477,30 +522,48 @@ ST5(      eor             v7.16b, v7.16b, v2.16b          )
>  ST5(   eor             v8.16b, v8.16b, v3.16b          )
>  ST5(   eor             v9.16b, v9.16b, v4.16b          )
>
> -ST5(   st1             {v5.16b}, [x0], x14             )
> -       st1             {v6.16b}, [x0], x15
> -       st1             {v7.16b}, [x0], x16
> -       add             x13, x13, x0
> +ST5(   st1             {v5.16b}, [OUT], x14            )
> +       st1             {v6.16b}, [OUT], x15
> +       st1             {v7.16b}, [OUT], x16
> +       add             x13, x13, OUT
>         st1             {v9.16b}, [x13]         // overlapping stores
> -       st1             {v8.16b}, [x0]
> +       st1             {v8.16b}, [OUT]
>         b               .Lctrout\xctr
>
>  .Lctrtail1x\xctr:
> -       sub             x7, x6, #16
> -       csel            x6, x6, x7, eq
> -       add             x1, x1, x6
> -       add             x0, x0, x6
> -       ld1             {v5.16b}, [x1]
> -       ld1             {v6.16b}, [x0]
> +       /*
> +        * Handle <= 16 bytes of plaintext
> +        */
> +       sub             x8, x7, #16
> +       csel            x7, x7, x8, eq
> +       add             IN, IN, x7
> +       add             OUT, OUT, x7
> +       ld1             {v5.16b}, [IN]
> +       ld1             {v6.16b}, [OUT]
>  ST5(   mov             v3.16b, v4.16b                  )
>         encrypt_block   v3, w3, x2, x8, w7
> -       ld1             {v10.16b-v11.16b}, [x12]
> +       ld1             {v10.16b-v11.16b}, [x9]
>         tbl             v3.16b, {v3.16b}, v10.16b
>         sshr            v11.16b, v11.16b, #7
>         eor             v5.16b, v5.16b, v3.16b
>         bif             v5.16b, v6.16b, v11.16b
> -       st1             {v5.16b}, [x0]
> +       st1             {v5.16b}, [OUT]
>         b               .Lctrout\xctr
> +
> +       // Arguments
> +       .unreq OUT
> +       .unreq IN
> +       .unreq KEY
> +       .unreq ROUNDS_W
> +       .unreq BYTES_W
> +       .unreq IV
> +       .unreq BYTE_CTR_W       // XCTR only
> +       // Intermediate values
> +       .unreq CTR_W            // XCTR only
> +       .unreq CTR              // XCTR only
> +       .unreq IV_PART
> +       .unreq BLOCKS
> +       .unreq BLOCKS_W
>  .endm
>
>         /*
> --
> 2.36.0.464.gb9c8b46e94-goog
>
