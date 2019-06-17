Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B793747E11
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jun 2019 11:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfFQJPO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jun 2019 05:15:14 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38515 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbfFQJPN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jun 2019 05:15:13 -0400
Received: by mail-io1-f67.google.com with SMTP id d12so11615635iod.5
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jun 2019 02:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BBlAq8Hgbk1PhfyJUI7i/pP6QgmDuBb0PZdu9I+mRE8=;
        b=WYpWGUjmF/b5U2DhXFfHaq8D+8s5go2/jFOJkLk2uW4kq/Fv7IjgWsCIoP43Tynt7H
         2blO6czII4FOD+tpOnQXimX+P037O7oXWstll/m5VLtgOnz5kU/beNS0K5g4+DUssMf8
         v127qxFMTsWiy5evx4nnTswUoRAa8OusVmK004aPXfXLNTQ29ioi4+qt3LdgKW5v7Adt
         CrF2/V2eQnw6tmt8vvq7hN31gUyYz8pwsXZajaxSBLTYz5WfRkyePZV4qr+pLxZWYGlC
         dBDm8qNvcoQd4zGwUNIu2drZ6m41Tg2gN6jU6vUjKCRfjbvfnQhz8dfskKQb57+eBbpc
         tY8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BBlAq8Hgbk1PhfyJUI7i/pP6QgmDuBb0PZdu9I+mRE8=;
        b=uJgKPgujLmKE9cV1HQ9JFd2t9+vDOPHy70r8Sz/enTlzNUAk7OBYcx5r3stnuCk0K5
         SY96OFv0rI3BVS6vAp2S+6i6g/nWYHMLJucXj39a9LTm6hcTTrgILDplNV8QUpdOwtJg
         lHAgoc4uwWb8PThd3WN0kkhnStycQs4BTVayojMypJUvIw+5meOonponFnptyRGdP+K2
         wgeEqE7BIc6q4pYKuF94a1X3sQLNC7NRQMsEKcX/aGMnJwgXsG4RcbGni4rptx0CyLD2
         eNxAS+y9ZF9XJEvbC3pqnjl7CPTUXI/9TZNnmWCPcJzlLqnOT5c659AmmcfDN7LY/5Yg
         QdMw==
X-Gm-Message-State: APjAAAXhUfeNlEuCRldrkBZIRyHQP/7p89ZwVsZK0R4+vuxoEsLSevGb
        wjfnhmm4HfniZ1hByRyaB/rCC5bpe4uSiUea6thyyy6oW20=
X-Google-Smtp-Source: APXvYqxHcte7o9+S4aNU6gOiMoSXJgqAwijNG58b3jo5O5B7NSygezT1xkWpPBvKULdZoH6xNXgeQQY7neDGSv8dDwY=
X-Received: by 2002:a02:3308:: with SMTP id c8mr14821917jae.103.1560762912862;
 Mon, 17 Jun 2019 02:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain> <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
In-Reply-To: <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 17 Jun 2019 11:15:01 +0200
Message-ID: <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 17 Jun 2019 at 10:52, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
> On Sun, Jun 16, 2019 at 11:44 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > [+Cc dm-devel and linux-fscrypt]
> >
> > On Fri, Jun 14, 2019 at 10:34:01AM +0200, Ard Biesheuvel wrote:
> > > This series is presented as an RFC for a couple of reasons:
> > > - it is only build tested
> > > - it is unclear whether this is the right way to move away from the use of
> > >   bare ciphers in non-crypto code
> > > - we haven't really discussed whether moving away from the use of bare ciphers
> > >   in non-crypto code is a goal we agree on
> > >
> > > This series creates an ESSIV shash template that takes a (cipher,hash) tuple,
> > > where the digest size of the hash must be a valid key length for the cipher.
> > > The setkey() operation takes the hash of the input key, and sets into the
> > > cipher as the encryption key. Digest operations accept input up to the
> > > block size of the cipher, and perform a single block encryption operation to
> > > produce the ESSIV output.
> ...
> > I agree that moving away from bare block ciphers is generally a good idea.  For
> > fscrypt I'm fine with moving ESSIV into the crypto API, though I'm not sure a
> > shash template is the best approach.  Did you also consider making it a skcipher
> > template so that users can do e.g. "essiv(cbc(aes),sha256,aes)"?  That would
> > simplify things much more on the fscrypt side, since then all the ESSIV-related
> > code would go away entirely except for changing the string "cbc(aes)" to
> > "essiv(cbc(aes),sha256,aes)".
>
> I will also add that going the skcipher route rather than shash will
> allow hardware tfm providers like CryptoCell that can do the ESSIV
> part in hardware implement that as a single API call and/or hardware
> invocation flow.
> For those system that benefit from hardware providers this can be beneficial.
>

Ah yes, thanks for reminding me. There was some debate in the past
about this, but I don't remember the details.

I think implementing essiv() as a skcipher template is indeed going to
be the best approach, I will look into that.
