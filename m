Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AE26C39C3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Mar 2023 20:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjCUTEr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 21 Mar 2023 15:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjCUTEn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 21 Mar 2023 15:04:43 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA0924CBB
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Mar 2023 12:04:14 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y4so63811648edo.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Mar 2023 12:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679425443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=86Y1u5mLe9v/pBUgkOz+GqSgxjFJqe1/jbcXyRYiTnE=;
        b=flGgnsoy2zA9nwYcGJNTRsyctDtIDckL2GqnI2TIwCNHrfNhGbyfl0vzhMEASxp1Fy
         T/A/1w9Kr4ji9Pvl/2AxLUDqc/HU7yq4NQzEHfA0URTc/GmspvlQBsV63VY80iXpBj5l
         zAp2RomfgS+QF2V2+e5DaAVGGqyuYp2aSgJPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679425443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=86Y1u5mLe9v/pBUgkOz+GqSgxjFJqe1/jbcXyRYiTnE=;
        b=4DuJ4ZtwgFDdBFFBkzcTCJbVbJC3GSAs7ttjvRvCGl/X+XMnYpQnLMqgV50SGUEYgZ
         HBbhlZHcBAPUabq3juRecEas9AjBNuqeACdGboUZSxuaSGZjWQ7rirmVOfO2GB0pvU7j
         CkS7ppFnZqj3bKr/rKD5L4GDe2JjaKZW31JDxNbZv/iOX1/xCj9A8fGYXSQQ2Up1WjTU
         bm3xdgeSxBhf5xSUOzviKpJUQNGN1gjDg0aQBv9xH1uySuIjfushAl2HqAfrXONOz7Ut
         wFxdrk3BEvw/Qo6Ujnmu8KYi+FJDPyjL9p1V/jx5DVcAyVDRbMKSnu4vXNJvADX7vb1K
         r8cg==
X-Gm-Message-State: AO0yUKXLV6GueSqDxB3LT2BaDvUGsKwdAbzRoQy8fZOTwkXlMY+owz9F
        jvsTFHcCyRjETJGmlVJfqyeC4s6lEvGQNc8om/vtPLWr
X-Google-Smtp-Source: AK7set/Q2UaeNn7zAS7Uq/UPcP6frYhhDqJMGzUsYnKmwIDsWcUvwkf29ZiXd3gyvjga8tge1YcrCg==
X-Received: by 2002:a17:906:7008:b0:8b1:32b0:2a24 with SMTP id n8-20020a170906700800b008b132b02a24mr4351164ejj.47.1679425443307;
        Tue, 21 Mar 2023 12:04:03 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id l16-20020a1709061c5000b00939ad35d521sm1373773ejg.77.2023.03.21.12.04.02
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 12:04:02 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id w9so63781593edc.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Mar 2023 12:04:02 -0700 (PDT)
X-Received: by 2002:a17:907:9b03:b0:932:da0d:9375 with SMTP id
 kn3-20020a1709079b0300b00932da0d9375mr2435070ejc.4.1679425442225; Tue, 21 Mar
 2023 12:04:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230320205617.GA1434@sol.localdomain> <CAHk-=whefxRGyNGzCzG6BVeM=5vnvgb-XhSeFJVxJyAxAF8XRA@mail.gmail.com>
 <20230320225934.GB21979@sol.localdomain> <20230321020313.GA108653@mit.edu>
In-Reply-To: <20230321020313.GA108653@mit.edu>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 21 Mar 2023 12:03:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjVTfej6+D62rzedjY_wzBVFqH0+U5vbq+ava8VhYPH3g@mail.gmail.com>
Message-ID: <CAHk-=wjVTfej6+D62rzedjY_wzBVFqH0+U5vbq+ava8VhYPH3g@mail.gmail.com>
Subject: Re: [GIT PULL] fscrypt fix for v6.3-rc4
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 20, 2023 at 7:03=E2=80=AFPM Theodore Ts'o <tytso@mit.edu> wrote=
:
>
> Another option is WARN_RATELIMITED.

I don't think that exists.

There's 'pr_warn_ratelimited()', but honestly, the rate limiting is a
joke. It's fine for things that never happen, but if you can flood
things without the rate limiting, you can still flood things with the
rate limiting.

The default rate limiting is "max five reports every five seconds".

For some "this should never happen", a reasonable rate limit might be
"once every 24 hours" or something like that. Just make sure that if
the machine stays up for months or years at a time, it doesn't get
hidden in all the *other* noise.

Our rate limiting sucks. The only thing that really saves it is that
rate limiting is used for things that never happen in the first place,
and the default values are basically picked for "this is a network DoS
attempt, let's make sure it stands out in the logs without completely
bogging down the machine".

So no. Please don't use "ratelimited" for "this shouldn't happen".
It's still going to suck. We had that *exact* thing just a couple of
weeks ago:

   https://lore.kernel.org/all/CAHk-=3DwjTMgB0=3DPQt8synf1MRTfetVXAWWLOibnM=
Kvv1ETn_1uw@mail.gmail.com/

where the networking people thought that ratelimiting would be a good idea.

It's not a good idea.

                    Linus
