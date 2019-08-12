Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2978C8A094
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 16:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfHLOTo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 10:19:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51801 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfHLOTn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 10:19:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so12352824wma.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 12 Aug 2019 07:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rjvKcpCdQy4Fb58ugbqz4IBMCEH2qfwlqKGn/IbXyKU=;
        b=yLeiwepqLD+fzOmGB/TMVxXWqsg3LGD/Cy06GePwEfqZyBsQqvcRzYytHbubf9vGzJ
         UeQ6AiHpX+UcjO0lvm/+A0PBPQthqa+VDCNMuaR2jeS//V48OwMA9DyEN23wTBL+NQiS
         LIaLMhAVDcg/ZCW68Qkl8BrZBKsxPEAlhcMtBSEw4BVgfsq9j68BMbpvO2hO0zHN63Jv
         OLoEUWsQkXqv+sQ22DecHcDZF57LLQiQrfG0r3edOgvFpVeQQv0TgdW/czCr1Vw0thzW
         6OR98OuImqfAOK3t32AfccRgC0XAjeJzEkeHMylCHcfk5RFyD0otVSJtLfIg24DOCa30
         7Rsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rjvKcpCdQy4Fb58ugbqz4IBMCEH2qfwlqKGn/IbXyKU=;
        b=hV49tQw6MHgn99BgHZLnkNY0M3Uw/2qhgbI1iANJnOUm8CCluHqOXTRXEHSEFRIOwg
         qWO7EsIO+SPLwVsJ4CUMGt5uxW3nqBxNXpStX/iy5hFGu05q7lZUVHKunfNDOiAz2DWj
         ld14yWhzo4SISp7huuERXryASfDVMhzoCvFcazP1heQvjXSH/FHOZ/t85FwBf7R8jxUB
         gvsIzG2yqSdHWpcE8KeVhH2BZNMOKQTsNaYoiKFQG9acBbggXw78yEgN+FsyRp04mRls
         sdmmuiQkiif2KsMRNGPYniS+GRvv0TMoDsr9e2R4CKZxHFIsUHJfr6L/Nv4OZydSxnlc
         mabw==
X-Gm-Message-State: APjAAAXlQ7GNRw15NBtFTQ4HTHehXFWw/qoJLNdbLwFvkQu+an8wG8Gz
        j7TIKUCVM3yljPO/uNoGJbVY6ixcMhfQBG6OncWGww==
X-Google-Smtp-Source: APXvYqznI6bUbr7GlJMRPRCyx9+eTwBaPF6WjOHdOQu8SNnMZHNCH7GhZfj8X8bjavC3mQnpvz/6J5R4WNNWk4Lk8u4=
X-Received: by 2002:a05:600c:231a:: with SMTP id 26mr13970077wmo.136.1565619581427;
 Mon, 12 Aug 2019 07:19:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190810094053.7423-1-ard.biesheuvel@linaro.org>
 <20190810094053.7423-4-ard.biesheuvel@linaro.org> <8679d2f5-b005-cd89-957e-d79440b78086@gmail.com>
 <CAKv+Gu-ZPPR5xQSR6T4o+8yJvsHY2a3xXZ5zsM_aGS3frVChgQ@mail.gmail.com>
 <82a87cae-8eb7-828c-35c3-fb39a9abe692@gmail.com> <CAKv+Gu_d+3NsTKFZbS+xeuxf5uCz=ENmPX-a=s-2kgLrW4d7cQ@mail.gmail.com>
 <7b3365a9-42ca-5426-660f-e87898bb9f7a@gmail.com>
In-Reply-To: <7b3365a9-42ca-5426-660f-e87898bb9f7a@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 12 Aug 2019 17:19:29 +0300
Message-ID: <CAKv+Gu_V+i=j9u-vZABN_ArWtwVbXPVjG=xOdj-RDWWHs2w08Q@mail.gmail.com>
Subject: Re: [PATCH v9 3/7] md: dm-crypt: switch to ESSIV crypto API template
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

On Mon, 12 Aug 2019 at 16:51, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 12/08/2019 09:50, Ard Biesheuvel wrote:
> > On Mon, 12 Aug 2019 at 10:44, Milan Broz <gmazyland@gmail.com> wrote:
> >>
> >> On 12/08/2019 08:54, Ard Biesheuvel wrote:
> >>> On Mon, 12 Aug 2019 at 09:33, Milan Broz <gmazyland@gmail.com> wrote:
> >>>> Try for example
> >>>> # cryptsetup luksFormat /dev/sdc -c aes-cbc-essiv:sha256 --integrity hmac-sha256 -q -i1
> >>>>
> >>>> It should produce Crypto API string
> >>>>   authenc(hmac(sha256),essiv(cbc(aes),sha256))
> >>>> while it produces
> >>>>   essiv(authenc(hmac(sha256),cbc(aes)),sha256)
> >>>> (and fails).
> >>>>
> >>>
> >>> No. I don't know why it fails, but the latter is actually the correct
> >>> string. The essiv template is instantiated either as a skcipher or as
> >>> an aead, and it encapsulates the entire transformation. (This is
> >>> necessary considering that the IV is passed via the AAD and so the
> >>> ESSIV handling needs to touch that as well)
> >>
> >> Hm. Constructing these strings seems to be more confusing than dmcrypt mode combinations :-)
> >>
> >> But you are right, I actually tried the former string (authenc(hmac(sha256),essiv(cbc(aes),sha256)))
> >> and it worked, but I guess the authenticated IV (AAD) was actually the input to IV (plain sector number)
> >> not the output of ESSIV? Do I understand it correctly now?
> >>
> >
> > Indeed. The former string instantiates the skcipher version of the
> > ESSIV template, and so the AAD handling is omitted, and we end up
> > using the plain IV in the authentication rather than the encrypted IV.
> >
> > So when using the latter string, does it produce any error messages
> > when it fails?
>
> The error is
> table: 253:1: crypt: Error decoding and setting key
>
> and it is failing in crypt_setkey() int this  crypto_aead_setkey();
>
> And it is because it now wrongly calculates MAC key length.
> (We have two keys here - one for length-preserving CBC-ESSIV encryption
> and one for HMAC.)
>
> This super-ugly hotfix helps here... I guess it can be done better :-)
>

Weird. It did work fine before, but now that I have dropped the 'md:
dm-crypt: infer ESSIV block cipher from cipher string directly' patch,
we are probably taking a different code path and hitting this error.

I'll try to fix this cleanly. Thanks for doing the diagnosis.


> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index e9a0093c88ee..7b06d975a2e1 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2342,6 +2342,9 @@ static int crypt_ctr_auth_cipher(struct crypt_config *cc, char *cipher_api)
>         char *start, *end, *mac_alg = NULL;
>         struct crypto_ahash *mac;
>
> +       if (strstarts(cipher_api, "essiv(authenc("))
> +               cipher_api += strlen("essiv(");
> +
>         if (!strstarts(cipher_api, "authenc("))
>                 return 0;
>
> Milan
