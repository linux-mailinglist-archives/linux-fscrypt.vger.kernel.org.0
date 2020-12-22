Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEE22E0351
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 01:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgLVAMz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 19:12:55 -0500
Received: from mail-lf1-f45.google.com ([209.85.167.45]:37892 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgLVAMy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 19:12:54 -0500
Received: by mail-lf1-f45.google.com with SMTP id h205so27877810lfd.5
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 16:12:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VRofcbXFvc1hUhp2qFoHcVgVrhSjefbwxtLI70s8NfM=;
        b=uoRkPwqeKrqlkVMRRF9KjBy7ELRDE9vsiCSu4+7osmNccyVxdCI27O1nyKKsb+GyVT
         xYpA3wZJ9BU6VNqVOH3bpUBvVbL+s8TU5z47cRHv0WKougLlD0q1EW16Lfz4OgqjhqQF
         hpiqASgWGbFskE78EkRt1Lg7NMesENn1PWxdj0U6r0koqosMZN29/lTUE6144yJxe6OX
         NrVukG0pLhyRBd2oJsLSLp2udHL/HsICLNsdc/egSann5h+gWJiCs6n91kgxnOKxufVi
         9A9Zdj1Jr9EmL7P5EDMdHXe6cMLGVhIvZvSzrW+zepDmpd03xIlUbo0hNNJwRaTYX4ah
         oPPw==
X-Gm-Message-State: AOAM532o1+p4P5YuQYO7hSM9XxRAaShID2EhEEdgpiz0/+4QV2V8FMgc
        Ht7x6CEWZvryjwfrkmK7ijW9VeIumXd5gg==
X-Google-Smtp-Source: ABdhPJy20L2gYpDMqBasjLB2uEkKvcGkA9LxgudZUI1L8LVl//HSoSK7+Q98/qmK+f57yUD878K9zQ==
X-Received: by 2002:a19:6447:: with SMTP id b7mr7706169lfj.206.1608595932420;
        Mon, 21 Dec 2020 16:12:12 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id v5sm2525590ljj.135.2020.12.21.16.12.12
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 16:12:12 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id y19so27752302lfa.13
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 16:12:12 -0800 (PST)
X-Received: by 2002:a05:6512:48d:: with SMTP id v13mr3729856lfq.546.1608595932070;
 Mon, 21 Dec 2020 16:12:12 -0800 (PST)
MIME-Version: 1.0
References: <20201221221953.256059-1-bluca@debian.org> <20201221232428.298710-1-bluca@debian.org>
 <X+E3LDjQOMMVUuEv@sol.localdomain>
In-Reply-To: <X+E3LDjQOMMVUuEv@sol.localdomain>
From:   Luca Boccassi <bluca@debian.org>
Date:   Tue, 22 Dec 2020 00:12:00 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnSxbC=qSZR-N+qAgcNsac__-XvQMTMC_noQRmRxzws4Sw@mail.gmail.com>
Message-ID: <CAMw=ZnSxbC=qSZR-N+qAgcNsac__-XvQMTMC_noQRmRxzws4Sw@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] Move -D_GNU_SOURCE to CPPFLAGS
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 22 Dec 2020 at 00:00, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Dec 21, 2020 at 11:24:26PM +0000, Luca Boccassi wrote:
> > Ensures it is actually defined before any include is preprocessed.
>
> It was already at the beginning of the .c file, so this isn't a very good
> explanation.  A better explanation would be "Use _GNU_SOURCE consistently in
> every file rather than in just one file.  This is needed for the Windows build
> in order to consistently get the MinGW version of printf.".

Ok, copied verbatim in v7.

> > diff --git a/Makefile b/Makefile
> > index bfe83c4..f1ba956 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -47,7 +47,7 @@ override CFLAGS := -Wall -Wundef                            \
> >       $(call cc-option,-Wvla)                                 \
> >       $(CFLAGS)
> >
> > -override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> > +override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE $(CPPFLAGS)
> >
> >  ifneq ($(V),1)
> >  QUIET_CC        = @echo '  CC      ' $@;
>
> Can you add -D_GNU_SOURCE to ./scripts/run-sparse.sh too?
> Otherwise I get errors when running scripts/run-tests.sh:
>
> [Mon Dec 21 03:52:15 PM PST 2020] Run sparse
> ./lib/utils.c:71:13: error: undefined identifier 'vasprintf'
> ./lib/utils.c:78:21: error: undefined identifier 'asprintf'

Sure, done in v7.

Kind regards,
Luca Boccassi
