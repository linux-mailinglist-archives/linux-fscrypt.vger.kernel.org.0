Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316FA64F6E7
	for <lists+linux-fscrypt@lfdr.de>; Sat, 17 Dec 2022 03:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiLQCEU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 16 Dec 2022 21:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLQCET (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 16 Dec 2022 21:04:19 -0500
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DF376154;
        Fri, 16 Dec 2022 18:04:15 -0800 (PST)
Received: by mail-qv1-f43.google.com with SMTP id mn15so2771528qvb.13;
        Fri, 16 Dec 2022 18:04:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tcPbsVl3cOtu0VxF4tk4pBw4lW90yLxGMNm2VAvKhL8=;
        b=J6uz71edS7BwoLIaz6cEpiN40nTGoWaJ7x7TsY++DPTN30+i33IWcEKpC9PLgjqrut
         Dy4gxn02n9wxG+WNZK9ZPFU7wIg3MGOMbcdzWbOZPN3TTLGv77VbYeHYsz763o2B22py
         fV9yed1swbEItfNMHhIj+chkrJRSO+A9tNtr7Bv6zZ1tJIirXkoZYSK3tkscJB+QKdn3
         DJPXN7R5V6mWP1PKhHmbsOHChNNwdraGgEu6x4UZ6usilhbqfU2CFb2Ytvr/Q2fOTtGP
         kL8R+BgHoz9o1FRaH9NuPWfGB3A+J3Xv6MwRC0rxEre29JI6ZvKP0VYgXLxBvlQschK1
         dY0g==
X-Gm-Message-State: ANoB5pluRdz9WwMbSRCXxSSxclXjVfNSC4g2/IA7ipo8UxdvzGhKlf5d
        FLPuKx3+jah1IIzJJxmF2z6s/Jut4De4Wg==
X-Google-Smtp-Source: AA0mqf5aAXsvv8vJun6600GLa/coLhNBpiTcukP+zw0WKaJvoU4j5Zi0NnFK1StacY60Pl86dVHVFg==
X-Received: by 2002:a0c:fde3:0:b0:4bc:176f:a516 with SMTP id m3-20020a0cfde3000000b004bc176fa516mr40541992qvu.8.1671242654789;
        Fri, 16 Dec 2022 18:04:14 -0800 (PST)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id w22-20020a05620a0e9600b006fab416015csm2617330qkm.25.2022.12.16.18.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 18:04:14 -0800 (PST)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-3bf4ade3364so57135927b3.3;
        Fri, 16 Dec 2022 18:04:13 -0800 (PST)
X-Received: by 2002:a81:ff06:0:b0:3ab:6ff4:a598 with SMTP id
 k6-20020a81ff06000000b003ab6ff4a598mr7952254ywn.425.1671242653731; Fri, 16
 Dec 2022 18:04:13 -0800 (PST)
MIME-Version: 1.0
References: <20221208033548.122704-1-ebiggers@kernel.org> <eea9b4dc9314da2de39b4181a4dac59fda8b0754.camel@debian.org>
 <Y5JPRW+9dt28JpZ7@sol.localdomain> <00c7b6b0e2533b2bf007311c2ede64cb92a130db.camel@debian.org>
 <Y5zbNtaadNGPGHQb@sol.localdomain>
In-Reply-To: <Y5zbNtaadNGPGHQb@sol.localdomain>
From:   Luca Boccassi <bluca@debian.org>
Date:   Sat, 17 Dec 2022 02:04:02 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnQNJjKVAf9xafashv8diab2Xg92M1+wNT3A37RMBVwR2Q@mail.gmail.com>
Message-ID: <CAMw=ZnQNJjKVAf9xafashv8diab2Xg92M1+wNT3A37RMBVwR2Q@mail.gmail.com>
Subject: Re: [PATCH] fsverity: mark builtin signatures as deprecated
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        Jes Sorensen <jsorensen@meta.com>,
        Victor Hsieh <victorhsieh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 16 Dec 2022 at 20:55, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Dec 08, 2022 at 09:37:29PM +0000, Luca Boccassi wrote:
> >
> > The second question is easy: because the kernel is the right place for
> > our use case to do this verification and enforcement, exactly like dm-
> > verity does.
>
> Well, dm-verity's in-kernel signature verification support is a fairly new
> feature.  Most users of dm-verity don't use it, and will not be using it.

I'm not sure what you mean by "most users" - systemd has support for
dm-verity signatures all over the place, libcryptsetup/veritysetup
supports them, and even libmount has native first-class mount options
for them.

> > Userspace is largely untrusted, or much lower trust anyway.
>
> Yes, which means the kernel is highly trusted.  Which is why parsing complex
> binary formats, X.509 and PKCS#7, in C code in the kernel is not a great idea...

Maybe, but it's there and it's used for multiple purposes and
userspace relies on it. If you want to add a new alternative and
optional formats I don't think it would be a problem, I certainly
wouldn't mind.

Kind regards,
Luca Boccassi
