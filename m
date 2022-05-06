Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EE351E102
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 May 2022 23:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444409AbiEFV0p (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 6 May 2022 17:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444408AbiEFV0o (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 6 May 2022 17:26:44 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425136339A
        for <linux-fscrypt@vger.kernel.org>; Fri,  6 May 2022 14:23:00 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id j4so14599063lfh.8
        for <linux-fscrypt@vger.kernel.org>; Fri, 06 May 2022 14:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qxpYk/i1uMx/9W+J+m0qdABTnqS48FNlgI8p4QJG9kg=;
        b=krrUKq7r9Ve/PfbbgWMQe08vgB7gzJafF4FAvb8xdfkMWPV87Dm7kmN/XGQTHHnaCE
         02aP+pLoB/UW9KxGP9N8mg6lodgHOBnkJ6Dkrjp6hqrGu3cRShXzqTVGYEM1WfrpkRVD
         AMdev99Vk9jW+HwRlkU+J9+77s3iaJNkrtDZnbR+5HUF5A8ZLF5WV9FPWV4RmmgeAFPA
         228SnlwQBDRP4gEeYWoPwIxSptMj9ZWPCnrA96CCc97SKQWg72d4lC1m095yVo8Jdk3h
         n4XtRJC0euV2An3UWY8MTXMQAHC44kkhW1rUXmoNCtOuT/heAtJJRJ0oZHOiBL8yKnoe
         dlXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qxpYk/i1uMx/9W+J+m0qdABTnqS48FNlgI8p4QJG9kg=;
        b=z8xDfa4AN0kdiU6iA+dBf5KkJ3LtO3mfpNrlNhdOmavmrmujlHtMUVBa0madtFjsyH
         hzJXiZqMFDeprbhu/tPLpXiFnoca5LjPWbX7dtOG+ob6cGfxheW+xDVJIyZ9Y0tD3fM+
         JgoFQ7gHdABVIKpGz4r5c/PHIeWeAEHO4OBs5xaQsLTHHYwwfEuqjo6nlwnowG15pzCQ
         PHQ5zLceBUnnJEHtdR/ngVJctqy89vC6U4P9bItGTKhpcHg7lL9c2STylKv76iPD04AL
         4NDYOAWA+mXTudZnVbLcImGsBKC4dkGj94KdB9dBhS7SFWNETLiz+a5axnvMJi3FcsV3
         8llg==
X-Gm-Message-State: AOAM533B+s1g1Gs7WOtAdiCx3eMqhdXV4ujurdg0vVt+0h/arINs7bKB
        8tJ7cLocZ7bsahkA898tc3m6G6l4SJUij8mss/3lKlmVg+Q=
X-Google-Smtp-Source: ABdhPJwtWl922lDNxtpgcPRbGCEUkm78yi8gsQd7xUwx2Ap9G/Q4F/o+IH1eKspy4pPQBMYDUeGtCUHBahsYZet3EtY=
X-Received: by 2002:a05:6512:1051:b0:473:b70c:941a with SMTP id
 c17-20020a056512105100b00473b70c941amr3894879lfb.238.1651872178383; Fri, 06
 May 2022 14:22:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220504001823.2483834-1-nhuck@google.com> <20220504001823.2483834-7-nhuck@google.com>
 <YnS07JPEoeFlsRAQ@sol.localdomain>
In-Reply-To: <YnS07JPEoeFlsRAQ@sol.localdomain>
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Fri, 6 May 2022 16:22:46 -0500
Message-ID: <CAJkfWY4U9C3nAhZH+3Gt-hit9=8SHaCt5vX9ocPjYeABGMr_Mg@mail.gmail.com>
Subject: Re: [PATCH v6 6/9] crypto: arm64/aes-xctr: Improve readability of
 XCTR and CTR modes
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 6, 2022 at 12:41 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, May 04, 2022 at 12:18:20AM +0000, Nathan Huckleberry wrote:
> > Added some clarifying comments, changed the register allocations to make
> > the code clearer, and added register aliases.
> >
> > Signed-off-by: Nathan Huckleberry <nhuck@google.com>
>
> I was a bit surprised to see this after the xctr support patch rather than
> before.  Doing the cleanup first would make adding and reviewing the xctr
> support easier.  But it's not a big deal; if you already tested it this way you
> can just leave it as-is if you want.
>
> A few minor comments below.
>
> > +     /*
> > +      * Set up the counter values in v0-v4.
> > +      *
> > +      * If we are encrypting less than MAX_STRIDE blocks, the tail block
> > +      * handling code expects the last keystream block to be in v4.  For
> > +      * example: if encrypting two blocks with MAX_STRIDE=5, then v3 and v4
> > +      * should have the next two counter blocks.
> > +      */
>
> The first two mentions of v4 should actually be v{MAX_STRIDE-1}, as it is
> actually v4 for MAX_STRIDE==5 and v3 for MAX_STRIDE==4.
>
> > @@ -355,16 +383,16 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
> >       mov             v3.16b, vctr.16b
> >  ST5( mov             v4.16b, vctr.16b                )
> >       .if \xctr
> > -             sub             x6, x11, #MAX_STRIDE - 1
> > -             sub             x7, x11, #MAX_STRIDE - 2
> > -             sub             x8, x11, #MAX_STRIDE - 3
> > -             sub             x9, x11, #MAX_STRIDE - 4
> > -ST5(         sub             x10, x11, #MAX_STRIDE - 5       )
> > -             eor             x6, x6, x12
> > -             eor             x7, x7, x12
> > -             eor             x8, x8, x12
> > -             eor             x9, x9, x12
> > -             eor             x10, x10, x12
> > +             sub             x6, CTR, #MAX_STRIDE - 1
> > +             sub             x7, CTR, #MAX_STRIDE - 2
> > +             sub             x8, CTR, #MAX_STRIDE - 3
> > +             sub             x9, CTR, #MAX_STRIDE - 4
> > +ST5(         sub             x10, CTR, #MAX_STRIDE - 5       )
> > +             eor             x6, x6, IV_PART
> > +             eor             x7, x7, IV_PART
> > +             eor             x8, x8, IV_PART
> > +             eor             x9, x9, IV_PART
> > +             eor             x10, x10, IV_PART
>
> The eor into x10 should be enclosed by ST5(), since it's dead code otherwise.
>
> > +     /*
> > +      * If there are at least MAX_STRIDE blocks left, XOR the plaintext with
> > +      * keystream and store.  Otherwise jump to tail handling.
> > +      */
>
> Technically this could be XOR-ing with either the plaintext or the ciphertext.
> Maybe write "data" instead.
>
> >  .Lctrtail1x\xctr:
> > -     sub             x7, x6, #16
> > -     csel            x6, x6, x7, eq
> > -     add             x1, x1, x6
> > -     add             x0, x0, x6
> > -     ld1             {v5.16b}, [x1]
> > -     ld1             {v6.16b}, [x0]
> > +     /*
> > +      * Handle <= 16 bytes of plaintext
> > +      */
> > +     sub             x8, x7, #16
> > +     csel            x7, x7, x8, eq
> > +     add             IN, IN, x7
> > +     add             OUT, OUT, x7
> > +     ld1             {v5.16b}, [IN]
> > +     ld1             {v6.16b}, [OUT]
> >  ST5( mov             v3.16b, v4.16b                  )
> >       encrypt_block   v3, w3, x2, x8, w7
>
> w3 and x2 should be ROUNDS_W and KEY, respectively.
>
> This code also has the very unusual property that it reads and writes before the
> buffers given.  Specifically, for bytes < 16, it access the 16 bytes beginning
> at &in[bytes - 16] and &dst[bytes - 16].  Mentioning this explicitly would be
> very helpful, particularly in the function comments for aes_ctr_encrypt() and
> aes_xctr_encrypt(), and maybe in the C code, so that anyone calling these
> functions has this in mind.

If bytes < 16, then the C code uses a buffer of 16 bytes to avoid
this. I'll add some comments explaining that because its not entirely
clear what is happening in the C unless you've taken a deep dive into
the asm.

>
> Anyway, with the above addressed feel free to add:
>
>         Reviewed-by: Eric Biggers <ebiggers@google.com>
>
> - Eric
