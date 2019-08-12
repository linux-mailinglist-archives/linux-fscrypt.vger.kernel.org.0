Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010BF8A014
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 15:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfHLNvN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 09:51:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38270 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfHLNvM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 09:51:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id m125so7787679wmm.3;
        Mon, 12 Aug 2019 06:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rBbM+UdJ5ZjF04CiXCd6y2tkG1h3M6zsC0WpzRFsUIQ=;
        b=DIKKpbK7MTnkOm83W/loz9snj3ua+vVVx7sWii6rL6U7FiE6ngBOI8ozRpV3njikkE
         2eeQiuTX3UiBBh8WL0OwXy4/EW0AW8Qi95jB0GK2XuQ0q5rq4q/Z7315cE5LKZetPgy+
         0QIuQGM4EMMvHuYvLpRW8q8kJp2xGf3i/bfRjdTLIN5ZyEw0LK7aOXhSxz/n1E1pSknF
         pPISm8xkLwRI/XBPxQNMEo/TGyBLJA1x56OAxr8gyfY4LUFjPUSmw21ScbQiprleWxEr
         SzgVgsTNx0JzUKHxXUN85Sk+tUNaRZ1nBEPjHn9u8TMcSzpJKuTf6xnlX97REZXhvqFT
         Cdjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rBbM+UdJ5ZjF04CiXCd6y2tkG1h3M6zsC0WpzRFsUIQ=;
        b=GagR6Xs85GFSQPF3+XIgwuI1LhYSo/ykuwZG1VGm0j6HGNvZDaqyd2VWYXcKjdNbqW
         6YJr3Eq8v5SXR8etOFLH9gDaotlpR9UKA0e13UV2t0VoOi6uANI+VWqUwauxH5Sg4lIq
         6o7dnOpxNJjk6mvEwfCQd5AZbO0PIN1jBc3KbkFAb71Ueo2/WziKgvI7TPOsQDKQLF63
         nhQyMXgaBigmdiEbgnpdtH3DpbVbfBT7awspPm01R/Q1hsrU74Bh0yJx5Et6hgdZdCYg
         V4pKpNcrB1i/FEwfWvTLct5gkuCVBDhhBDa330gaAYxbZ355gU8YKQODwENfqDvGjAz0
         ja/g==
X-Gm-Message-State: APjAAAXqa3Nhw8oQqrjMUCRTwL7rE6eloutCoVixxWmROKm5Wlv72DS/
        x5nGMnySLxJm7QguIriCDis=
X-Google-Smtp-Source: APXvYqydyG0HxLjtoA5pPzW3JZSa52vifGyk5rD7QL125itbnnPxp17aqg2nTfJDRX/Epo3eoRVuEA==
X-Received: by 2002:a1c:6087:: with SMTP id u129mr27021088wmb.108.1565617870305;
        Mon, 12 Aug 2019 06:51:10 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id e11sm13985393wrc.4.2019.08.12.06.51.08
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 06:51:09 -0700 (PDT)
Subject: Re: [PATCH v9 3/7] md: dm-crypt: switch to ESSIV crypto API template
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190810094053.7423-1-ard.biesheuvel@linaro.org>
 <20190810094053.7423-4-ard.biesheuvel@linaro.org>
 <8679d2f5-b005-cd89-957e-d79440b78086@gmail.com>
 <CAKv+Gu-ZPPR5xQSR6T4o+8yJvsHY2a3xXZ5zsM_aGS3frVChgQ@mail.gmail.com>
 <82a87cae-8eb7-828c-35c3-fb39a9abe692@gmail.com>
 <CAKv+Gu_d+3NsTKFZbS+xeuxf5uCz=ENmPX-a=s-2kgLrW4d7cQ@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <7b3365a9-42ca-5426-660f-e87898bb9f7a@gmail.com>
Date:   Mon, 12 Aug 2019 15:51:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu_d+3NsTKFZbS+xeuxf5uCz=ENmPX-a=s-2kgLrW4d7cQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 12/08/2019 09:50, Ard Biesheuvel wrote:
> On Mon, 12 Aug 2019 at 10:44, Milan Broz <gmazyland@gmail.com> wrote:
>>
>> On 12/08/2019 08:54, Ard Biesheuvel wrote:
>>> On Mon, 12 Aug 2019 at 09:33, Milan Broz <gmazyland@gmail.com> wrote:
>>>> Try for example
>>>> # cryptsetup luksFormat /dev/sdc -c aes-cbc-essiv:sha256 --integrity hmac-sha256 -q -i1
>>>>
>>>> It should produce Crypto API string
>>>>   authenc(hmac(sha256),essiv(cbc(aes),sha256))
>>>> while it produces
>>>>   essiv(authenc(hmac(sha256),cbc(aes)),sha256)
>>>> (and fails).
>>>>
>>>
>>> No. I don't know why it fails, but the latter is actually the correct
>>> string. The essiv template is instantiated either as a skcipher or as
>>> an aead, and it encapsulates the entire transformation. (This is
>>> necessary considering that the IV is passed via the AAD and so the
>>> ESSIV handling needs to touch that as well)
>>
>> Hm. Constructing these strings seems to be more confusing than dmcrypt mode combinations :-)
>>
>> But you are right, I actually tried the former string (authenc(hmac(sha256),essiv(cbc(aes),sha256)))
>> and it worked, but I guess the authenticated IV (AAD) was actually the input to IV (plain sector number)
>> not the output of ESSIV? Do I understand it correctly now?
>>
> 
> Indeed. The former string instantiates the skcipher version of the
> ESSIV template, and so the AAD handling is omitted, and we end up
> using the plain IV in the authentication rather than the encrypted IV.
> 
> So when using the latter string, does it produce any error messages
> when it fails?

The error is
table: 253:1: crypt: Error decoding and setting key

and it is failing in crypt_setkey() int this  crypto_aead_setkey();

And it is because it now wrongly calculates MAC key length.
(We have two keys here - one for length-preserving CBC-ESSIV encryption
and one for HMAC.)

This super-ugly hotfix helps here... I guess it can be done better :-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index e9a0093c88ee..7b06d975a2e1 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2342,6 +2342,9 @@ static int crypt_ctr_auth_cipher(struct crypt_config *cc, char *cipher_api)
        char *start, *end, *mac_alg = NULL;
        struct crypto_ahash *mac;
 
+       if (strstarts(cipher_api, "essiv(authenc("))
+               cipher_api += strlen("essiv(");
+
        if (!strstarts(cipher_api, "authenc("))
                return 0;
 
Milan
