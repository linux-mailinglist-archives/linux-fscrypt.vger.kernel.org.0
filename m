Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC7958947F
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Aug 2022 00:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbiHCWmn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 3 Aug 2022 18:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiHCWmn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 3 Aug 2022 18:42:43 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C7B17A95
        for <linux-fscrypt@vger.kernel.org>; Wed,  3 Aug 2022 15:42:42 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id r14so20405472ljp.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 03 Aug 2022 15:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ZTC8pqnrrWrVXkLaGQrW0Mi6fvjHzMsYZgeoNR5c7Xk=;
        b=ghCsBaGRN7NASruqI7lhfwUTZQUCbOzpvP8io/1rI0/bMsZmbloWcYtD7n7/IfiYPB
         BUbObP8qhUbzu49ghHR0xHoq3F9nd7GUDpzyqDashy2AIrpo2tYEiDITExdqgn5RyAKD
         NGcGKnicjt5zWuZs0tC3Ym5fAa28sR2pKCIYCKrPzRGF1hJxe82I0sxhO3wcXDLxsvMk
         gDRzpxXz99Kh+U2XQW4kEEAEnO1jWe1osi/USnt08aGB0tVlXpEM8EwEs4FKAfdPMN3O
         F4u0x9Q816EVOoMyC3vSU6fnPQkAjHSvKPBSeqzp+DbMZRxvy1Dtk0ezi8tuVnJbI2ly
         Qy9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ZTC8pqnrrWrVXkLaGQrW0Mi6fvjHzMsYZgeoNR5c7Xk=;
        b=htx/hiirOQsgd824nVu5kLH5tZS1Z6I9Aq6OC74q56A86/PGcjhA1Zn+p/KOSSn8bv
         ye97DAgmbPJZSkskEp5b4qj18DINcPG4h57IpRY+rfWaQr+LMtwnpmMkSiPlTuwRCHjZ
         aPiMR1u5Jwm0777qMrymQ7PWZKvlLtYllL4hRaKdlOIzRb5uNZieJtMB5p9KA02xUBe1
         P5I61I0jxvCAwfjrdd7smdX/jn99lEROyo68JFEOWy47rLHcQpEcdN5WlxbHdQVzlP6y
         C9Szab4pl9m/KyRzn/kAYH9Cz6BZGCho9RnBI3yr5PDGRbKOu7vk+FMHrssSPsKsmtYK
         1UYA==
X-Gm-Message-State: AJIora+lL6h0/FGvovRHGgJUAtRiUcCQYjYhEn9m+ryXxI/hdPSA18Ye
        RQsjBf7bZ5QtRZHohEufBumTY7m26STDytvjurvJ8g==
X-Google-Smtp-Source: AGRyM1sS3D+36i3ULxDy7oZWSbBf1r5kMqPnKHsEckihriqkGQmKe5vFAmu6KuyMr4ohPwCQKTi2L0a6MEK3kCTGrxg=
X-Received: by 2002:a2e:9444:0:b0:25d:91c1:caa3 with SMTP id
 o4-20020a2e9444000000b0025d91c1caa3mr9029485ljh.190.1659566560588; Wed, 03
 Aug 2022 15:42:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220803224121.420705-1-nhuck@google.com>
In-Reply-To: <20220803224121.420705-1-nhuck@google.com>
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Wed, 3 Aug 2022 15:42:29 -0700
Message-ID: <CAJkfWY7kJDqBzqnGD_X4vVKZc3tfnDShC=AbFOjyra+8o1shvw@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] generic: test HCTR2 filename encryption
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 3, 2022 at 3:41 PM Nathan Huckleberry <nhuck@google.com> wrote:
>
> This patchset is not intended to be accepted yet.  It is reliant on HCTR2
> support in the kernel which has not yet been accepted.  See the HCTR2 patchset
> here: https://lore.kernel.org/all/20220520181501.2159644-1-nhuck@google.com/

Oops, I need to remove this.

>
> HCTR2 is a new wide-block encryption mode that can used for filename encryption
> in fscrypt.  This patchset adds a reference implementation of HCTR2 to the
> fscrypt testing utility and adds tests for filename encryption with HCTR2.
>
> More information on HCTR2 can be found here: "Length-preserving encryption with
> HCTR2": https://ia.cr/2021/1441
>
> Changes in v5:
> * Added links to relevant references for POLYVAL and HCTR2
> * Removed POLYVAL partial block handling
> * Referenced HCTR2 commit in test
>
> Changes in v4:
> * Add helper functions for HCTR2 hashing
> * Fix accumulator alignment bug
> * Small style fixes
>
> Changes in v3:
> * Consolidate tests into one file
>
> Changes in v2:
> * Use POLYVAL multiplication directly instead of using GHASH trick
> * Split reference implementation and tests into two patches
> * Remove v1 policy tests
> * Various small style fixes
>
> Nathan Huckleberry (2):
>   fscrypt-crypt-util: add HCTR2 implementation
>   generic: add tests for fscrypt policies with HCTR2
>
>  common/encrypt           |   2 +
>  src/fscrypt-crypt-util.c | 358 ++++++++++++++++++++++++++++++++-------
>  tests/generic/900        |  31 ++++
>  tests/generic/900.out    |  16 ++
>  4 files changed, 350 insertions(+), 57 deletions(-)
>  create mode 100755 tests/generic/900
>  create mode 100644 tests/generic/900.out
>
> --
> 2.37.1.455.g008518b4e5-goog
>
