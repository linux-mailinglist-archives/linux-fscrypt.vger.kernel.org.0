Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB7674404
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Jul 2019 05:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388645AbfGYDdw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 23:33:52 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45674 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388244AbfGYDdw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 23:33:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so21961720pfq.12;
        Wed, 24 Jul 2019 20:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=sw6tBsPcv34E66OKScouxVLQwbujUa08SXNCR8pqae4=;
        b=kSjK6C4cXGK6dqd7g3ciI2qf+ZDeCTnGhZMsyllKENS544LjmVRVVVnM5PnubW/YLH
         n8L+8tLv8+R8COXPy5Cj/7MzOxRoZusROQMH3sWvDBw9LHDJjeF27H6orPpAz1UvuTqB
         Ly29FTjpxUH5pvmOD+dHBvfRgEHO9T+OQGVSGXShlN8BGAcOZ1RKOFNNrEEFRXYPPncK
         7XZ0BXB9CNXQhdlUbRzkEmi/NnGgjMTB7S6k8blNAskgNISncsfOZ/QSy1YQXO7Woswu
         6qjvHcJmY/iSEPNF6j643NLG1qXsVtlua/WKPr96u517N9EXxCyVB4VS5lcHmSMqN63y
         +8yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sw6tBsPcv34E66OKScouxVLQwbujUa08SXNCR8pqae4=;
        b=bDYn03DIvGvORUn8d0z3A3ByeAM8S3akbg9NDp2BrzOnAW1A+THgCdHQgX8FOzw3lg
         SSL2SWnq+1BSXtqMa5aSDjKhkeoH2Fze+B8efvFaWY6SVBqweaoYb7EaivQlIsb5L9lL
         fvVfhRWdxvxZxN0o4JtlmuKqW0XCDr9OpBi1VCnQn20E74axgEgMUrGBrG2Jr00YnIlG
         CxQOXRqX0DxF4uWJXC/ijOHNNN4quwFBQlOxZFPSf4zDoQgpdiUhfN3jcZwEZoNCt7vj
         AJMvHJviNZfmEkivcU82dG5M3tfZkcyc9FxyeuM0+qvOA211qpnu3/gMpXtnMjHQPT1V
         mXSA==
X-Gm-Message-State: APjAAAVAlvNOBcVEoooWQJfc4A/yhnN4CAhuT+6BBxVOKigpeWJcYo3V
        q4jJk5GjCl4MF4jQGWCNKTckR8RX5WM=
X-Google-Smtp-Source: APXvYqzHWN0RMleSviilXLZ7dQeF9w5fiy/3Dkdk3JglejH9DjM/yQHxNtYUwhJfOMpX8fFAVgum/A==
X-Received: by 2002:a17:90a:1b48:: with SMTP id q66mr86891392pjq.83.1564025631704;
        Wed, 24 Jul 2019 20:33:51 -0700 (PDT)
Received: from ?IPv6:2402:f000:4:72:808::177e? ([2402:f000:4:72:808::177e])
        by smtp.gmail.com with ESMTPSA id 137sm58646122pfz.112.2019.07.24.20.33.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 20:33:51 -0700 (PDT)
Subject: Re: [PATCH] fs: crypto: keyinfo: Fix a possible null-pointer
 dereference in derive_key_aes()
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org
References: <20190724100204.2009-1-baijiaju1990@gmail.com>
 <20190724160711.GB673@sol.localdomain>
 <3d206c43-994e-6134-3f28-b4a500472760@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Message-ID: <9740973d-6e59-e4df-7097-4e5d0da89235@gmail.com>
Date:   Thu, 25 Jul 2019 11:33:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3d206c43-994e-6134-3f28-b4a500472760@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Sorry, I forgot to send to Eric, so send it again.

On 2019/7/25 11:30, Jia-Ju Bai wrote:
>
>
> On 2019/7/25 0:07, Eric Biggers wrote:
>> [+Cc linux-crypto]
>>
>> On Wed, Jul 24, 2019 at 06:02:04PM +0800, Jia-Ju Bai wrote:
>>> In derive_key_aes(), tfm is assigned to NULL on line 46, and then
>>> crypto_free_skcipher(tfm) is executed.
>>>
>>> crypto_free_skcipher(tfm)
>>>      crypto_skcipher_tfm(tfm)
>>>          return &tfm->base;
>>>
>>> Thus, a possible null-pointer dereference may occur.
>> This analysis is incorrect because only the address &tfm->base is taken.
>> There's no pointer dereference.
>>
>> In fact all the crypto_free_*() functions are no-ops on NULL 
>> pointers, and many
>> other callers rely on it.  So there's no bug here.
>
> Thanks for the reply :)
> I admit that "&tfm->base" is not a null-pointer dereference when tfm 
> is NULL.
> But I still think crypto_free_skcipher(tfm) can cause security 
> problems when tfm is NULL.
>
> Looking at the code:
>
> static inline void crypto_free_skcipher(struct crypto_skcipher *tfm)
> {
>     crypto_destroy_tfm(tfm, crypto_skcipher_tfm(tfm));
> }
>
> static inline struct crypto_tfm *crypto_skcipher_tfm(
>     struct crypto_skcipher *tfm)
> {
>     return &tfm->base;
> }
>
> void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
> {
>     struct crypto_alg *alg;
>
>     if (unlikely(!mem))
>         return;
>
>     alg = tfm->__crt_alg;
>
>     if (!tfm->exit && alg->cra_exit)
>         alg->cra_exit(tfm);
>     crypto_exit_ops(tfm);
>     crypto_mod_put(alg);
>     kzfree(mem);
> }
>
> The function crypto_skcipher_tfm() may return an uninitialized address 
> (&tfm->base) when tfm is NULL.
> Then crypto_destroy_tfm() uses this problematic address (tfm), which 
> may cause security problems.
>
> Besides, I also find that some kernel modules check tfm before calling 
> crypto_free_*(), such as:
>
> drivers/crypto/vmx/aes_xts.c:
>     if (ctx->fallback) {
>         crypto_free_skcipher(ctx->fallback);
>         ctx->fallback = NULL;
>     }
>
> net/rxrpc/rxkad.c:
>     if (conn->cipher)
>         crypto_free_skcipher(conn->cipher);
>
> drivers/crypto/chelsio/chcr_algo.c:
>     if (ablkctx->aes_generic)
>         crypto_free_cipher(ablkctx->aes_generic);
>
> net/mac80211/wep.c:
>     if (!IS_ERR(local->wep_tx_tfm))
>         crypto_free_cipher(local->wep_tx_tfm);
>
> Thus, I think it is better to check tfm before calling crypto_free_*().
>
>>
>> It appears you've sent the same patch for some of these other callers
>> (https://lore.kernel.org/lkml/?q=%22fix+a+possible+null-pointer%22), 
>> but none
>> are Cc'ed to linux-crypto or another mailing list I'm subscribed to, 
>> so I can't
>> respond to them.  But this feedback applies equally to them too.
>
> Ah, sorry.
> I just ran "get_maintainer.pl" for the kernel modules used 
> crypto_free_*(), and forgot to cc to linux-crypto...
>
>>
>> Note also that if there actually were a bug here (which again, there 
>> doesn't
>> appear to be), we'd need to fix it in crypto_free_*(), not in the 
>> callers.
>>
>
> I think a possible way is to add a check of tfm in crypto_free_*(), 
> such as:
> static inline void crypto_free_skcipher(struct crypto_skcipher *tfm)
> {
>     if (tfm)
>         crypto_destroy_tfm(tfm, crypto_skcipher_tfm(tfm));
> }
>
> If you think it is okay, I can send a patch for this.
>
>
> Best wishes,
> Jia-Ju Bai

