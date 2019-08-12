Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B8C8980B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 09:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfHLHov (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 03:44:51 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34050 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfHLHov (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 03:44:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id 31so103738051wrm.1;
        Mon, 12 Aug 2019 00:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OhVdiPgQteGnfIdg/BzXWc5BJR5a7K5kl8o5O+S23zA=;
        b=r1jtMvZ9jhoJPy9hDsGIBBNm+hpcmV9G+1pklBjb6Kec5H4LT+5spFLbW9+mYD8lJa
         jLk647pvhccAwgkKS/nWvPNzEAuaRevgM8wFgRNzk/C6P4IXjKj2LC+YG/Zh7HwR+7vT
         J4PdXf11cxfYr+3zK6eGeCzd4Qi3p8ivQ4zukHFB+Cewdp4dD1dpuSidDEfRYNVtRqdi
         oYb8bTDCvqabSwAdyKlns+c5BMNub62RZy7QDkhOAM9AxtiGdfdB5tKGMFRJcWPPbY/A
         9myhrgXnUoEIox5M/NJTzDejt8M1oX+4zP4wO85Sp1yAbV7A80VvSnTYiRUekLYwnynj
         wJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OhVdiPgQteGnfIdg/BzXWc5BJR5a7K5kl8o5O+S23zA=;
        b=ovHF7XRGnbY4woR9ouegZb6dm9NDQQ38mVpaW++U83D4PzGs06xteOc3S7YWq0CV3v
         a/fA88sRm7H/dcTNDUw+guwe4B2l/YMcPLWMYmCM39ZDYEH/lPPxAfw1hds3U4gFN2Cf
         WdJH3qG7kkVAg7WNt3fHTzvK4RO2ONg2uCYDajzHE9FPmN7jBx4wT4X5e8ODQrzS7yiG
         fNNTIDjPg7Mf1NMT8SkYDgytMgSeoFYzj0yg4mFtUoJmAO5vBJMqeqI5CpbddMemp5vi
         36CwOZJHoeiAh1VmAmU/Z9XjRobyT0IWiq4xoHxvBAX82LVc3DwMSHCOb2R7TLlis3Ps
         /0IQ==
X-Gm-Message-State: APjAAAVYqFNhi1Ox4fiZKerAN5P22OKaAQjkLQu7Fku+tBYBlQK8TfXL
        dNm7YRVQSCxirchyElxW4p4=
X-Google-Smtp-Source: APXvYqxlN5d6yAirknE/yDWW8X5nwI1whb4u1/YYAbluKe3IMvHS89FjVjXtmpxFxhpQnsl8qShMNA==
X-Received: by 2002:a5d:494d:: with SMTP id r13mr31737059wrs.82.1565595889035;
        Mon, 12 Aug 2019 00:44:49 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id c15sm50995266wrb.80.2019.08.12.00.44.48
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 00:44:48 -0700 (PDT)
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
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <82a87cae-8eb7-828c-35c3-fb39a9abe692@gmail.com>
Date:   Mon, 12 Aug 2019 09:44:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu-ZPPR5xQSR6T4o+8yJvsHY2a3xXZ5zsM_aGS3frVChgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 12/08/2019 08:54, Ard Biesheuvel wrote:
> On Mon, 12 Aug 2019 at 09:33, Milan Broz <gmazyland@gmail.com> wrote:
>> Try for example
>> # cryptsetup luksFormat /dev/sdc -c aes-cbc-essiv:sha256 --integrity hmac-sha256 -q -i1
>>
>> It should produce Crypto API string
>>   authenc(hmac(sha256),essiv(cbc(aes),sha256))
>> while it produces
>>   essiv(authenc(hmac(sha256),cbc(aes)),sha256)
>> (and fails).
>>
> 
> No. I don't know why it fails, but the latter is actually the correct
> string. The essiv template is instantiated either as a skcipher or as
> an aead, and it encapsulates the entire transformation. (This is
> necessary considering that the IV is passed via the AAD and so the
> ESSIV handling needs to touch that as well)

Hm. Constructing these strings seems to be more confusing than dmcrypt mode combinations :-)

But you are right, I actually tried the former string (authenc(hmac(sha256),essiv(cbc(aes),sha256)))
and it worked, but I guess the authenticated IV (AAD) was actually the input to IV (plain sector number)
not the output of ESSIV? Do I understand it correctly now?

Milan
