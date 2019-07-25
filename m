Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27EFE74421
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Jul 2019 05:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390151AbfGYDwG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 23:52:06 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33148 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390150AbfGYDwG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 23:52:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id f20so13041663pgj.0;
        Wed, 24 Jul 2019 20:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Q/98t+M2Y8cT5VRhI3CXJllAGvqhT13uQ4iFZGPeAKQ=;
        b=TDriAVm9iNGKXqNyY9jNLT67/TAZxSgx1zvErjGKOnYp4i3vmCPs51kg4wyBv5sNXW
         9u2ToLoPJcyMJOK0cH/VvWhw+kgFLrV5aSlaYpmYgnipRFVBF7VSK6bhuw/b5D3ESIVe
         wm6hsZ+L1oM8SP6oh7Tb6MfHOWQf/yyKO6UvInwdgQCj0YneqYLajq6kyiqvJbC5oKyk
         n0e7Moam56yuIoMHnwIjnH3LeRU+85F65f4vzHfGFmII8JI+rYPldKP29ADzahfh8rgY
         7ARHhdqfQM7JxIhPnTm8k/wTb7OxKhT2tkWb9n8nK0TrVLzCOg7HayVmr2y2KHuXpDzN
         Em7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Q/98t+M2Y8cT5VRhI3CXJllAGvqhT13uQ4iFZGPeAKQ=;
        b=hx3Opncb8LwrB8OBPOKNtc4rRTRtB/9CssEPkxTjASyloNVrI1y3L367Nf1aMOoMy8
         zk8S4Q78GOHN2/nxF4KTVdOu7TAI2nB3C+uFn2VfR0qVir0ljQNToWyrXG1PSsJrXOr2
         DZX7swVULjZVVqXORWot+CeNZrOETEuELAX5gt2BqdWYDupPZk3HztJihQR4CBb+nwJD
         HwuY97T/VFQx+OoiM1sdb0B10GbqoosKnO3nWJG1H39TN1pEEm1r3ubCvleL9vqInygJ
         s9OxJeqaSsFot5Op8y+EeQwQb12AhS3FXHwt5dP0RM0RGcAjlIYxGFR+7gttvC6r1P2+
         xvhA==
X-Gm-Message-State: APjAAAXt2Wud2xmm545EFv512fpK0TFd+pwlIvlKW91pRiEVZfPJ1f+F
        X31XuUudgprYurhwKXpQ0gFeYW27WqU=
X-Google-Smtp-Source: APXvYqxPCChHRFanP/sFGlhVTRTI3yWFc7fZq6TDXEsUJclACOL+YZ7jSqEE28G9RJ/P3W29GbPl0Q==
X-Received: by 2002:a65:6108:: with SMTP id z8mr53000362pgu.289.1564026725425;
        Wed, 24 Jul 2019 20:52:05 -0700 (PDT)
Received: from ?IPv6:2402:f000:4:72:808::177e? ([2402:f000:4:72:808::177e])
        by smtp.gmail.com with ESMTPSA id z6sm19026125pgk.18.2019.07.24.20.52.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 20:52:05 -0700 (PDT)
Subject: Re: [PATCH] fs: crypto: keyinfo: Fix a possible null-pointer
 dereference in derive_key_aes()
To:     tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org
References: <20190724100204.2009-1-baijiaju1990@gmail.com>
 <20190724160711.GB673@sol.localdomain>
 <3d206c43-994e-6134-3f28-b4a500472760@gmail.com>
 <9740973d-6e59-e4df-7097-4e5d0da89235@gmail.com>
 <20190725033951.GA677@sol.localdomain>
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <33ae3693-9792-a793-5e9e-aca845c427a5@gmail.com>
Date:   Thu, 25 Jul 2019 11:52:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725033951.GA677@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 2019/7/25 11:39, Eric Biggers wrote:
> On Thu, Jul 25, 2019 at 11:33:53AM +0800, Jia-Ju Bai wrote:
>> Sorry, I forgot to send to Eric, so send it again.
>>
>> On 2019/7/25 11:30, Jia-Ju Bai wrote:
>>>
>>> On 2019/7/25 0:07, Eric Biggers wrote:
>>>> [+Cc linux-crypto]
>>>>
>>>> On Wed, Jul 24, 2019 at 06:02:04PM +0800, Jia-Ju Bai wrote:
>>>>> In derive_key_aes(), tfm is assigned to NULL on line 46, and then
>>>>> crypto_free_skcipher(tfm) is executed.
>>>>>
>>>>> crypto_free_skcipher(tfm)
>>>>>       crypto_skcipher_tfm(tfm)
>>>>>           return &tfm->base;
>>>>>
>>>>> Thus, a possible null-pointer dereference may occur.
>>>> This analysis is incorrect because only the address &tfm->base is taken.
>>>> There's no pointer dereference.
>>>>
>>>> In fact all the crypto_free_*() functions are no-ops on NULL
>>>> pointers, and many
>>>> other callers rely on it.  So there's no bug here.
>>> Thanks for the reply :)
>>> I admit that "&tfm->base" is not a null-pointer dereference when tfm is
>>> NULL.
>>> But I still think crypto_free_skcipher(tfm) can cause security problems
>>> when tfm is NULL.
>>>
>>> Looking at the code:
>>>
>>> static inline void crypto_free_skcipher(struct crypto_skcipher *tfm)
>>> {
>>>      crypto_destroy_tfm(tfm, crypto_skcipher_tfm(tfm));
>>> }
>>>
>>> static inline struct crypto_tfm *crypto_skcipher_tfm(
>>>      struct crypto_skcipher *tfm)
>>> {
>>>      return &tfm->base;
>>> }
>>>
>>> void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
>>> {
>>>      struct crypto_alg *alg;
>>>
>>>      if (unlikely(!mem))
>>>          return;
> When the original pointer is NULL, mem == NULL here so crypto_destroy_tfm() is a
> no-op.

I overlooked this if statement, thanks for the pointer.

>
>>> Besides, I also find that some kernel modules check tfm before calling
>>> crypto_free_*(), such as:
>>>
>>> drivers/crypto/vmx/aes_xts.c:
>>>      if (ctx->fallback) {
>>>          crypto_free_skcipher(ctx->fallback);
>>>          ctx->fallback = NULL;
>>>      }
>>>
>>> net/rxrpc/rxkad.c:
>>>      if (conn->cipher)
>>>          crypto_free_skcipher(conn->cipher);
>>>
>>> drivers/crypto/chelsio/chcr_algo.c:
>>>      if (ablkctx->aes_generic)
>>>          crypto_free_cipher(ablkctx->aes_generic);
>>>
>>> net/mac80211/wep.c:
>>>      if (!IS_ERR(local->wep_tx_tfm))
>>>          crypto_free_cipher(local->wep_tx_tfm);
>>>
> Well, people sometimes do that for kfree() too.  But that doesn't mean it's
> needed, or that it's the preferred style (it's not).

Okay.


Best wishes,
Jia-Ju Bai
