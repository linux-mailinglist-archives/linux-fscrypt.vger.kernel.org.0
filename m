Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D584E0BA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Jun 2019 09:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfFUHBS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Jun 2019 03:01:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34180 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfFUHBR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Jun 2019 03:01:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id k11so5439622wrl.1;
        Fri, 21 Jun 2019 00:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4KMprRjDkqaX/nBTD4F9dj74OEsT3XaTb81JxjBVwvY=;
        b=UlilboFg7BeJFCE4D3sVPo/yeOhKANMZOzg3G9kVRRTN/eH32FNY1qe8FOe5pZ9F6p
         +oB7l5FOpdIiOkVJb/N3NqepSLDx8OJz7WjNbZnMtoEtuFj8Ci71aQmnCAoxMA6AFi5v
         1IHPhFDqWSoMsJ3l/JLGA0s3GOeAc4cVOmbzbLHduqBBp4jEJbMtMWAosxF/yVuaTFC9
         +0OeY4Q2SMcM6XUl0tBhgmV8mWrhc3xxFpoS60UMCmWaCzGR1WUcm4jV6zrTlO7OGJaQ
         Qk1AEVvKs1UDe1GqUNFDCooVoD7itFcWi6yfSAgNaRylbfmdmnpDEgETmvOF+MZ+GonO
         Zpjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4KMprRjDkqaX/nBTD4F9dj74OEsT3XaTb81JxjBVwvY=;
        b=IaiDqXRpMD54/xfaseyJcyVFLKp30ONmqBaKg4WxTHkjOSndz/xqFjZa46Fb7a7xUE
         pkeldKE849NCu47nCQ9uSddH5SqLFxijgKBmzKFySDhgezeAL7XQ0KzMUZ519LHVk9Rc
         aodYDuYf2bwFUs+28UPFg6M3ttA+LmOXpsi4JrIukCfb8EZPIJj6qfavLriZ/ezLueP3
         X9FsyDJW6dl+ai0DXM4GZzJV/nzqDYlbTgheSFiwRttTDwaIjc7YyUD1z3ijVu8bhHcD
         2sALzRqk+QWseFmpgDIZmP0WA1Rs2nVjgeWhjw2TaOZ1DVt+V7o2nX7R4DbqREFRkARA
         QaRQ==
X-Gm-Message-State: APjAAAVhM/nAGKmZGKPgs+gHWlpayaqvI4zqbKhGWfFlFVWshUeWuwg9
        /h7u07l+HF7mBR9UpgsTdg8=
X-Google-Smtp-Source: APXvYqzklnbarC3we/vpMGSUchNlhOAkOEL6RTgbhzsSAci6o3C+LFoOGD35h1kjQiYZLYngT/aD5Q==
X-Received: by 2002:adf:eecf:: with SMTP id a15mr19805448wrp.354.1561100475547;
        Fri, 21 Jun 2019 00:01:15 -0700 (PDT)
Received: from [192.168.8.100] (37-48-48-91.nat.epc.tmcz.cz. [37.48.48.91])
        by smtp.gmail.com with ESMTPSA id w2sm1555056wrr.31.2019.06.21.00.01.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 00:01:15 -0700 (PDT)
Subject: Re: [PATCH v3 0/6] crypto: switch to crypto API for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <459f5760-3a1c-719d-2b44-824ba6283dd7@gmail.com>
 <CAKv+Gu9jk8KxWykTcKeh6k0HUb47wgx7iZYuwwN8AUyErFLXxA@mail.gmail.com>
 <075cddec-1603-4a23-17c4-c766b4bd9086@gmail.com>
 <6a45dfa5-e383-d8a3-ebf1-abdc43c95ebd@gmail.com>
 <CAKv+Gu-ZETNJh2VzUkpbQUmYv6Zqb7nVj91bxuxKoNAJwgON=w@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <b635b78d-cfe8-3fa4-d9b2-6cf4185dac71@gmail.com>
Date:   Fri, 21 Jun 2019 09:01:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu-ZETNJh2VzUkpbQUmYv6Zqb7nVj91bxuxKoNAJwgON=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 20/06/2019 15:52, Ard Biesheuvel wrote:
>>>> Does this include configurations that combine authenc with essiv?
>>>
>>> Hm, seems that we are missing these in luks2-integrity-test. I'll add them there.
>>>
>>> I also used this older test
>>> https://gitlab.com/omos/dm-crypt-test-scripts/blob/master/root/test_dmintegrity.sh
>>>
>>> (just aes-gcm-random need to be commented out, we never supported this format, it was
>>> written for some devel version)
>>>
>>> But seems ESSIV is there tested only without AEAD composition...
>>>
>>> So yes, this AEAD part need more testing.
>>
>> And unfortunately it does not work - it returns EIO on sectors where it should not be data corruption.
>>
>> I added few lines with length-preserving mode with ESSIV + AEAD, please could you run luks2-integrity-test
>> in cryptsetup upstream?
>>
>> This patch adds the tests:
>> https://gitlab.com/cryptsetup/cryptsetup/commit/4c74ff5e5ae328cb61b44bf99f98d08ffee3366a
>>
>> It is ok on mainline kernel, fails with the patchset:
>>
>> # ./luks2-integrity-test
>> [aes-cbc-essiv:sha256:hmac-sha256:128:512][FORMAT][ACTIVATE]sha256sum: /dev/mapper/dmi_test: Input/output error
>> [FAIL]
>>  Expecting ee501705a084cd0ab6f4a28014bcf62b8bfa3434de00b82743c50b3abf06232c got .
>>
>> FAILED backtrace:
>> 77 ./luks2-integrity-test
>> 112 intformat ./luks2-integrity-test
>> 127 main ./luks2-integrity-test
>>
> 
> OK, I will investigate.
> 
> I did my testing in a VM using a volume that was created using a
> distro kernel, and mounted and used it using a kernel with these
> changes applied.
> 
> Likewise, if I take a working key.img and mode-test.img, i can mount
> it and use it on the system running these patches.
> 
> I noticed that this test uses algif_skcipher not algif_aead when it
> formats the volume, and so I wonder if the way userland creates the
> image is affected by this?

Not sure if I understand the question, but I do not think userspace even touch data area here
(except direct-io wiping after the format, but it does not read it back).

It only encrypts keyslots - and here we cannot use AEAD (in fact it is already
authenticated by a LUKS digest).

So if the data area uses AEAD (or composition of length-preserving mode and
some authentication tag like HMAC), we fallback to non-AEAD for keyslot encryption.

In short, to test it, you need to activate device (that works ok with your patches)
and *access* the data, testing LUKS format and just keyslot access will never use AEAD.

So init the data by direct-io writes, and try to read them back (with dd).

For testing data on dm-integrity (or dm-crypt with AEAD encryption stacked oved dm-integrity)
I used small utility, maybe it could be useful https://github.com/mbroz/dm_int_tools 

Milan
