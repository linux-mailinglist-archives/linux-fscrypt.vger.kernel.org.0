Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7DE48A17
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jun 2019 19:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfFQR3q (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jun 2019 13:29:46 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42864 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQR3q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jun 2019 13:29:46 -0400
Received: by mail-io1-f65.google.com with SMTP id u19so22914710ior.9
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jun 2019 10:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tx+RieQLyQ+lh9UZ5H0F2WZBvGEsSZxqyVbasY51tYI=;
        b=EvlURp56PD/fZX3/f33oR7xEaNAktTY52gbQTnuJRvCuz7+8Heh+Ogh2nsPdyPhnVb
         q9ugzxFcpzIBHr/3vlnj622rRRZNCvwBaTrDgMvzuhqEKsIpNRpwSPJH2A/mAavcwI+c
         t9lV5X0NeJSUF8ZrXKcB/RRwheqdUONQNKnMrhZ9oGfDargEMn9zhcznvPfFtKs0CTY5
         3hLpyAFpTLDmasBUrothylE6kwy0X4ROxGkA31/Q5oZU4w9GcxajQ5tTg9Ua3ut4z2D8
         G5syZjvMh9NeeIIzkkk44nw9+FAciFINwWM/6CRlfOXjjGHN9cXve/6nMvROqwqxWOvn
         zAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tx+RieQLyQ+lh9UZ5H0F2WZBvGEsSZxqyVbasY51tYI=;
        b=LFIM6GhdVfG3UhghoEg0MATWHO034SOHzNTzW9EhCmx/dZwzLScBZ0H4h2mQj6TXwq
         w9PNDscIt8LOG2+oKoWUY97xMqA11D2cZJI3ZlsLWO/86K8YtxRfNy42FNlieutB6mop
         KgjTozre2qryMkkARJ7jqb2TKWb5n2fijhk+rw5To63k256Q8vRBp73x9gMRyrRNSdGB
         grK4+HAibq3BXgMnNZigQw5RMigOfMixpwmHYys+S1D4cAP5TlB5z/N5avs/QjJe4JOT
         KuczDlYDy+ItRMaaEqaHIjI5iWKzMEqyMKKTy5Medbfiva6ZiopRKlM8kWMwmL54ecEg
         Cylw==
X-Gm-Message-State: APjAAAVU2JslZwgBIlybSkwP/fK+Oxih6jfvwsuvKmkYKFLw0msWDwoy
        szAa6Z1pGnuGo+0Xh0cJBQkKz56eoKzQWPBzFJNXlQ==
X-Google-Smtp-Source: APXvYqycFVgNYf56Rc5fCMWC4dEZzi0p52SynbgzsiegdocdCseGuLtCO4YbqRFeNHS67ShUfA/hulHJe9282wYVEoM=
X-Received: by 2002:a5d:9456:: with SMTP id x22mr3034719ior.71.1560792580222;
 Mon, 17 Jun 2019 10:29:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain> <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
 <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
 <8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com> <CAKv+Gu9sb0t6EC=MwVfqTw5TKtatK-c8k3ryNUhV8O0876NV7g@mail.gmail.com>
 <CAKv+Gu-LFShLW-Tt7hwBpni1vQRvv7k+L_bpP-wU86x88v+eRg@mail.gmail.com>
 <90214c3d-55ef-cc3a-3a04-f200d6f96cfd@gmail.com> <CAKv+Gu82BLPWrX1UzUBLf7UB+qJT6ZPtkvJ2Sa9t28OpXArhnw@mail.gmail.com>
 <af1b7ea1-bc98-06ff-e46c-945e6bae20d8@gmail.com>
In-Reply-To: <af1b7ea1-bc98-06ff-e46c-945e6bae20d8@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 17 Jun 2019 19:29:27 +0200
Message-ID: <CAKv+Gu-37P+_4=Men92wR7S7LQS7U-4L2-ZaPdEN18TWAa3QaQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 17 Jun 2019 at 19:05, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 17/06/2019 16:39, Ard Biesheuvel wrote:
> >>
> >> In other words, if you add some additional limit, we are breaking backward compatibility.
> >> (Despite the configuration is "wrong" from the security point of view.)
> >>
> >
> > Yes, but breaking backward compatibility only happens if you break
> > something that is actually being *used*. So sure,
> > xts(aes)-essiv:sha256 makes no sense but people use it anyway. But is
> > that also true for, say, gcm(aes)-essiv:sha256 ?
>
> These should not be used.  The only way when ESSIV can combine with AEAD mode
> is when you combine length-preserving mode with additional integrity tag, for example
>
>   # cryptsetup luksFormat -c aes-cbc-essiv:sha256 --integrity hmac-sha256 /dev/sdb
>
> it will produce this dm-crypt cipher spec:
>   capi:authenc(hmac(sha256),cbc(aes))-essiv:sha256
>
> the authenc(hmac(sha256),cbc(aes)) is direct crypto API cipher composition, the essiv:sha256
> IV is processed inside dm-crypt as IV.
>
> So if authenc() composition is problem, then yes, I am afraid these can be used in reality.
>
> But for things like gcm(aes)-essiv:sha256 (IOW real AEAD mode with ESSIV) - these are
> not supported by cryptsetup (we support only random IV in this case), so these should
> not be used anywhere.
>

OK, understood. Unfortunately, that means that the essiv template
should be dynamically instantiated as either a aead or a skcipher
depending on the context, but perhaps this is not a big deal in
reality, I will check.

One final question before I can proceed with my v2: in
crypt_ctr_blkdev_cipher(), do you think we could change the code to
look at the cipher string rather than the name of the actual cipher?
In practice, I don't think they can be different, but in order to be
able to instantiate
'essiv(authenc(hmac(sha256),cbc(aes)),sha256,aes)', the cipher part
needs to be parsed before the TFM(s) are instantiated.
