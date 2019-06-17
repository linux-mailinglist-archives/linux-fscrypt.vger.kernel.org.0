Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480DC48ACE
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jun 2019 19:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFQRwj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jun 2019 13:52:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36602 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFQRwj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jun 2019 13:52:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so2860813wrs.3;
        Mon, 17 Jun 2019 10:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FMNyAGci+1vv5qg7rKwKydEtDLbo9Wlt1X0ych19Ewc=;
        b=urmUSgh9tF3F62J4bEZmojsMD4JAHsM3KUMy4kiZL62eDAvkdCtyuPW/UKA3Ica0uW
         0ZTLGLk+2Z1otWThtmM2jSTJCg6gIuDD9p2loMDnCEJjcgYvh1CYxWhD1FzuAhtuGp/z
         SiAoGTI8xItGjWpW5D/uL0U+ZbRRXhT6bE9ihyJLQblbgEFvExO6WO1xp+mxTMCKv5Ff
         b7EzOfK2aAYRmqttRzor8ZPw7jiGCAsjp6naQt7282xLNZHjLHrnN/nmrgfVghrIBx3k
         X4SFiWzKEbg5tuCgUH0+XTdfHN9uzvUp4iwCVTyHyG3O+sBbD21yYQk5p7ycHi4f/eJZ
         fIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FMNyAGci+1vv5qg7rKwKydEtDLbo9Wlt1X0ych19Ewc=;
        b=KHFvJhAlnKDW6TSoUzPIj1IFiaw4st0ReOpl4TDqp4/sc3MCQ0BPM5sCor2gaERJvV
         R6Fhk39U8Oi2YyQRbXdUCmImTL7tF0MWiMLNI/mL77AE8M6lpZz1m3XjIi9E7D1cQAoR
         XxXRL9C9gmV8lBYEKqyWsUzDYAqtEVPd/LBn2vYraoNBn28HlYWL0smKEXw+a11B7ygb
         coMAviXmKe+l/GRlGnDeD4i+spGm4vXc4yrQvRBe5ugHjOnF8QRus2zviEFOym1rGCU9
         cTzRgNTsl6csJ3LNBv7HBCsxMwvNfUL2yT7gaiRakApaUbRh5kQ4NQkmcd0mwv0GNp1h
         +7Fw==
X-Gm-Message-State: APjAAAVYyqFjJhmfNmzK560IM0CB1e+Dlq8jVEFvkAFSBub/u/PVwSTl
        t/Y4w/TM9nyOcz83TVQ5nrS6uY1qQQJRMg==
X-Google-Smtp-Source: APXvYqxr6IIazoq3qaPHcNh1UDqgm+Shl1gva0JzuijN+e5bVTSaFJL7YdibRGjKUNadAIAgDpEGlA==
X-Received: by 2002:a5d:4d84:: with SMTP id b4mr25495595wru.242.1560793956857;
        Mon, 17 Jun 2019 10:52:36 -0700 (PDT)
Received: from [192.168.2.28] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id u2sm292638wmc.3.2019.06.17.10.52.35
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 10:52:36 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain>
 <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
 <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
 <8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com>
 <CAKv+Gu9sb0t6EC=MwVfqTw5TKtatK-c8k3ryNUhV8O0876NV7g@mail.gmail.com>
 <CAKv+Gu-LFShLW-Tt7hwBpni1vQRvv7k+L_bpP-wU86x88v+eRg@mail.gmail.com>
 <90214c3d-55ef-cc3a-3a04-f200d6f96cfd@gmail.com>
 <CAKv+Gu82BLPWrX1UzUBLf7UB+qJT6ZPtkvJ2Sa9t28OpXArhnw@mail.gmail.com>
 <af1b7ea1-bc98-06ff-e46c-945e6bae20d8@gmail.com>
 <CAKv+Gu-37P+_4=Men92wR7S7LQS7U-4L2-ZaPdEN18TWAa3QaQ@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <900cdd2e-eccc-3188-fdb0-911e713e0cda@gmail.com>
Date:   Mon, 17 Jun 2019 19:52:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu-37P+_4=Men92wR7S7LQS7U-4L2-ZaPdEN18TWAa3QaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 17/06/2019 19:29, Ard Biesheuvel wrote:
> On Mon, 17 Jun 2019 at 19:05, Milan Broz <gmazyland@gmail.com> wrote:
>>
>> On 17/06/2019 16:39, Ard Biesheuvel wrote:
>>>>
>>>> In other words, if you add some additional limit, we are breaking backward compatibility.
>>>> (Despite the configuration is "wrong" from the security point of view.)
>>>>
>>>
>>> Yes, but breaking backward compatibility only happens if you break
>>> something that is actually being *used*. So sure,
>>> xts(aes)-essiv:sha256 makes no sense but people use it anyway. But is
>>> that also true for, say, gcm(aes)-essiv:sha256 ?
>>
>> These should not be used.  The only way when ESSIV can combine with AEAD mode
>> is when you combine length-preserving mode with additional integrity tag, for example
>>
>>   # cryptsetup luksFormat -c aes-cbc-essiv:sha256 --integrity hmac-sha256 /dev/sdb
>>
>> it will produce this dm-crypt cipher spec:
>>   capi:authenc(hmac(sha256),cbc(aes))-essiv:sha256
>>
>> the authenc(hmac(sha256),cbc(aes)) is direct crypto API cipher composition, the essiv:sha256
>> IV is processed inside dm-crypt as IV.
>>
>> So if authenc() composition is problem, then yes, I am afraid these can be used in reality.
>>
>> But for things like gcm(aes)-essiv:sha256 (IOW real AEAD mode with ESSIV) - these are
>> not supported by cryptsetup (we support only random IV in this case), so these should
>> not be used anywhere.
>>
> 
> OK, understood. Unfortunately, that means that the essiv template
> should be dynamically instantiated as either a aead or a skcipher
> depending on the context, but perhaps this is not a big deal in
> reality, I will check.
> 
> One final question before I can proceed with my v2: in
> crypt_ctr_blkdev_cipher(), do you think we could change the code to
> look at the cipher string rather than the name of the actual cipher?
> In practice, I don't think they can be different, but in order to be
> able to instantiate
> 'essiv(authenc(hmac(sha256),cbc(aes)),sha256,aes)', the cipher part
> needs to be parsed before the TFM(s) are instantiated.

You mean to replace crypto_tfm_alg_name() with the cipher string
from the device-mapper table constructor?

I hope I am not missing anything, but it should be ok. It just could
fail later (in tfm init).
The constructor is de-facto atomic step for device-mapper, I think
it does not matter when it fails, the effect of failure is the same
for userspace.

Milan
