Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB630743FF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Jul 2019 05:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389124AbfGYDa6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 23:30:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37799 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389078AbfGYDa6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 23:30:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so21967574pfa.4;
        Wed, 24 Jul 2019 20:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=IeSJtjeLftjka/NpWEQQGVSdbgP7Yd0adkFaB2SHlA8=;
        b=B1Xnldq/bvzn2qE50bVFpZ1JaqwaQ5cEORN3ZYm3GDq5hhcJWGzCVHE/8D0eNqt7Jk
         hOIRTfTFIiifL1F0G6MkwJl0OdDyuuENvBfWgMxNZFD16lWWJjkbqBRHlbj3j4W2RRf7
         h2hnSqGlQwFZ4vvJJJmyGQly8dCPFIDg2r7fV0ImNS4I5zFuIfazBhodGHe7B1tjpitg
         vowldXo6S5Ky8a7LLdPCYHdIBk0Ah0nNdxGyfFtMozX0+oqyc5fwHELFSiYtB86ev2t8
         960vR/+aG9DhEP5p9A0j5mN5jxdMasl5Ck/bfoABs4PmhmaOUBsCSev9Xb56M3z0UAuT
         uZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IeSJtjeLftjka/NpWEQQGVSdbgP7Yd0adkFaB2SHlA8=;
        b=I0Uf74uKiHU36pnelSj308xAW8ItBb4VnuxSWH9ttE50zabIN6kutkbwQE7kfm1leu
         DgAiIMJrA1+Fms3VUmn60CdhS9MmuV/w8/TAsnevYFMBpLm5/JJ5jzJCLx0zuKqvXN1d
         NvWQqKqfPGPB9rxsDn8IgFT07Q025E84DVWnq3pxxc6IWNkqEkbePAi7KJzehE/G+GjP
         elXoRyQ4DLhKl5Jf/FxnMUWKWYUGuocpt40lzhSMQGqxYPkgWaz9OxvunalEbjkjVTIg
         bSQtvCfZgQSfBKZM8+uuymCV8RHaRPtzFyX2dpcsGPj/8zKbfSNcjnKr5yhRevSJmoeY
         QcSw==
X-Gm-Message-State: APjAAAXGqlHyQ2nkrrIqvOpnzVoCoSn9PHK4DLB1RLImgAmtWEGNcqXu
        Q4HqphnH0eZ7N30LxaiV3pF8wtKBNfw=
X-Google-Smtp-Source: APXvYqz/SdbatXlhu153v16fOkj3mI+fSwIS1GIsUVuXoODJX5lrKa/x3JQJbs5KONCE4tb+z8SsUQ==
X-Received: by 2002:a17:90a:d997:: with SMTP id d23mr86623306pjv.84.1564025457230;
        Wed, 24 Jul 2019 20:30:57 -0700 (PDT)
Received: from ?IPv6:2402:f000:4:72:808::177e? ([2402:f000:4:72:808::177e])
        by smtp.gmail.com with ESMTPSA id u6sm42374748pjx.23.2019.07.24.20.30.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 20:30:56 -0700 (PDT)
Subject: Re: [PATCH] fs: crypto: keyinfo: Fix a possible null-pointer
 dereference in derive_key_aes()
To:     tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20190724100204.2009-1-baijiaju1990@gmail.com>
 <20190724160711.GB673@sol.localdomain>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <3d206c43-994e-6134-3f28-b4a500472760@gmail.com>
Date:   Thu, 25 Jul 2019 11:30:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724160711.GB673@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 2019/7/25 0:07, Eric Biggers wrote:
> [+Cc linux-crypto]
>
> On Wed, Jul 24, 2019 at 06:02:04PM +0800, Jia-Ju Bai wrote:
>> In derive_key_aes(), tfm is assigned to NULL on line 46, and then
>> crypto_free_skcipher(tfm) is executed.
>>
>> crypto_free_skcipher(tfm)
>>      crypto_skcipher_tfm(tfm)
>>          return &tfm->base;
>>
>> Thus, a possible null-pointer dereference may occur.
> This analysis is incorrect because only the address &tfm->base is taken.
> There's no pointer dereference.
>
> In fact all the crypto_free_*() functions are no-ops on NULL pointers, and many
> other callers rely on it.  So there's no bug here.

Thanks for the reply :)
I admit that "&tfm->base" is not a null-pointer dereference when tfm is 
NULL.
But I still think crypto_free_skcipher(tfm) can cause security problems 
when tfm is NULL.

Looking at the code:

static inline void crypto_free_skcipher(struct crypto_skcipher *tfm)
{
     crypto_destroy_tfm(tfm, crypto_skcipher_tfm(tfm));
}

static inline struct crypto_tfm *crypto_skcipher_tfm(
     struct crypto_skcipher *tfm)
{
     return &tfm->base;
}

void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
{
     struct crypto_alg *alg;

     if (unlikely(!mem))
         return;

     alg = tfm->__crt_alg;

     if (!tfm->exit && alg->cra_exit)
         alg->cra_exit(tfm);
     crypto_exit_ops(tfm);
     crypto_mod_put(alg);
     kzfree(mem);
}

The function crypto_skcipher_tfm() may return an uninitialized address 
(&tfm->base) when tfm is NULL.
Then crypto_destroy_tfm() uses this problematic address (tfm), which may 
cause security problems.

Besides, I also find that some kernel modules check tfm before calling 
crypto_free_*(), such as:

drivers/crypto/vmx/aes_xts.c:
     if (ctx->fallback) {
         crypto_free_skcipher(ctx->fallback);
         ctx->fallback = NULL;
     }

net/rxrpc/rxkad.c:
     if (conn->cipher)
         crypto_free_skcipher(conn->cipher);

drivers/crypto/chelsio/chcr_algo.c:
     if (ablkctx->aes_generic)
         crypto_free_cipher(ablkctx->aes_generic);

net/mac80211/wep.c:
     if (!IS_ERR(local->wep_tx_tfm))
         crypto_free_cipher(local->wep_tx_tfm);

Thus, I think it is better to check tfm before calling crypto_free_*().

>
> It appears you've sent the same patch for some of these other callers
> (https://lore.kernel.org/lkml/?q=%22fix+a+possible+null-pointer%22), but none
> are Cc'ed to linux-crypto or another mailing list I'm subscribed to, so I can't
> respond to them.  But this feedback applies equally to them too.

Ah, sorry.
I just ran "get_maintainer.pl" for the kernel modules used 
crypto_free_*(), and forgot to cc to linux-crypto...

>
> Note also that if there actually were a bug here (which again, there doesn't
> appear to be), we'd need to fix it in crypto_free_*(), not in the callers.
>

I think a possible way is to add a check of tfm in crypto_free_*(), such as:
static inline void crypto_free_skcipher(struct crypto_skcipher *tfm)
{
     if (tfm)
         crypto_destroy_tfm(tfm, crypto_skcipher_tfm(tfm));
}

If you think it is okay, I can send a patch for this.


Best wishes,
Jia-Ju Bai
