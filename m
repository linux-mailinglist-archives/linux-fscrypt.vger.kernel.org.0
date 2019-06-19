Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6968F4B8BB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jun 2019 14:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbfFSMhK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jun 2019 08:37:10 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40367 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731711AbfFSMhK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jun 2019 08:37:10 -0400
Received: by mail-io1-f66.google.com with SMTP id n5so37713890ioc.7
        for <linux-fscrypt@vger.kernel.org>; Wed, 19 Jun 2019 05:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mgVxtVWZcVB028eaS05O6WDA2Si5Lt8jvgQG053v8G0=;
        b=T2L1mRC5K4CgcLXaSNPvZIX4o9VmWKKxbydy9xutoy2tJr618gUSuibD1lrMnlqLih
         70gXC/IinKSNu6f2LS36r6nve2/1yghvKjMEu3I4Bhn4N8LLv3DlAMah7xHbt1JFusGd
         Dtx2ZW+V7qLsconPkoImg3LaW/dWdJHA123HYc7b0L7Of6Li4eDix1gph6QeBNfZJRBX
         1eJBxmKSgxwaltZrC0VxK92+Uryd0dP6SxmG59cOBtCbeuX4HtR7LAwVr7pU9WmE+DSv
         5aylDkjRcmPOuLBnBlDGQPIKATsG2/HiyilgZj1bR/VFD214fChwwxALm4in9qFQju05
         UkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mgVxtVWZcVB028eaS05O6WDA2Si5Lt8jvgQG053v8G0=;
        b=UxMBezpR/rkCUV6HLYEtKPt/Rici0OEjl4b+nU84oh25b5yuPTuo48Lmyv/kLA4nix
         gO3Khc9HvQbcMJnDsz7+Qz7IVT3sxrO+4q9gzGfs0XZFTEPvgobWfR+JgAZlrDzq9XoS
         N9/Q+vxzHtnfPKUXX3ZV7uR+cNnYVX2NLrnGUNbM+j1MyboDjMRDLt9LjKOkV4pAopkB
         aj3rX7qfhqzSKHqGC+QbxEnut7Mtq157g/NbNgETqIdlXgzoY3J3/b93q1uzK+6nONb5
         eONw6MhIPWiX0eUCnV0sFSSRUJaaCLDLy+HAvzy6ddHI96BRtRxK1yhkiN3spfs+W/eU
         92GQ==
X-Gm-Message-State: APjAAAVVNZnXkZoemWdQdCuntwizXNGSryoL4IHKkwb1zXcVpjVB0QC1
        YnBE0YT9GKYEwA/YgT7GimfOJUeTJlE4O5CsNieEKQ==
X-Google-Smtp-Source: APXvYqxMxKkPcl/yA9aguHRLzAnHjH3llgRx2DCNZ9zjDa/sKgKiBIZ7WxIzikao9ypX0z7ouAc5ukdn7ykrPxBiZ2U=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr10302944jar.2.1560947829635;
 Wed, 19 Jun 2019 05:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
 <099346ee-af6e-a560-079d-3fb68fb4eeba@gmail.com> <CAKv+Gu9MTGSwZgaHyxJKwfiBQzqgNhTs5ue+TC1Ehte-+VBXqg@mail.gmail.com>
 <CAKv+Gu9q5qTgEeTLCW6ZM6Wu6RK559SjFhsgWis72_6-p6RrZA@mail.gmail.com>
 <f5de99dd-0b6a-9f7e-46b7-cd3c5ed3100e@gmail.com> <CAKv+Gu9NW2H-TDd66quKSUMpEWGwqEjN-vmf_zueo1tEJLa-xg@mail.gmail.com>
 <b5b013eb-9cab-4985-9c24-563cc57c140e@gmail.com>
In-Reply-To: <b5b013eb-9cab-4985-9c24-563cc57c140e@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 19 Jun 2019 14:36:57 +0200
Message-ID: <CAKv+Gu91RHpwE6XzdFYcsN77DRJ-4OsFRjxNAyKk92Q3q6dCYw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] crypto: switch to crypto API for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 19 Jun 2019 at 13:33, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 19/06/2019 13:16, Ard Biesheuvel wrote:
> >> Try
> >>   cryptsetup open --type plain -c null /dev/sdd test -q
> >> or
> >>   dmsetup create test --table " 0 417792 crypt cipher_null-ecb - 0 /dev/sdd 0"
> >>
> >> (or just run full cryptsetup testsuite)
> >>
> >
> > Is that your mode-test script?
> >
> > I saw some errors about the null cipher, but tbh, it looked completely
> > unrelated to me, so i skipped those for the moment. But now, it looks
> > like it is related after all.
>
> This was triggered by align-test, mode-test fails the same though.
>
> It is definitely related, I think you just changed the mode parsing in dm-crypt.
> (cipher null contains only one dash I guess).
>

On my unpatched 4.19 kernel, mode-test gives me

$ sudo ./mode-test
aes                            PLAIN:[table OK][status OK]
LUKS1:[table OK][status OK] CHECKSUM:[OK]
aes-plain                      PLAIN:[table OK][status OK]
LUKS1:[table OK][status OK] CHECKSUM:[OK]
null                           PLAIN:[table OK][status OK]
LUKS1:[table OK][status OK] CHECKSUM:[OK]
cipher_null                    PLAIN:[table FAIL]
 Expecting cipher_null-ecb got cipher_null-cbc-plain.
FAILED at line 64 ./mode-test

which is why I commented out those tests in the first place.

I can reproduce the crash after I re-enable them again, so I will need
to look into that. But something seems to be broken already.
Note that this is running on arm64 using a kconfig based on the Debian kernel.
