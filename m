Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DAF4CE65
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 15:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbfFTNO4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 09:14:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45518 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfFTNO4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 09:14:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so2951273wre.12;
        Thu, 20 Jun 2019 06:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yUEjeqQ0jNyrj9kyIDpLfI3dn5L2tIgCnprfg5xm1/c=;
        b=ShTJHW6Udd+/LO/fIOr8xO03mRnKoXy3kpjQxkHSCJDlcadPO4WrmNfFwjNYFk75M8
         yr3leADjmiHH1pynhsZgiQYqXu/4DRdLzPapwV+Eb05vLXR4PRThYyxdABLREf+v8FRO
         qesMcdbvenbMowdKbRAsMsNks9rSDvFkGD4txyMngAj54Tp24bFCoO5htf2MHTPSywo8
         ocS1Zu8VrYi5XtcjH9YUsO9sGQ5BEMY/fDAKtjI1LBX/iSyonmS6q2TYI3dq32MWDZG6
         uWY/I+NdkWjKkW5B3BtjZXs5Yw8NMmMjx7KN17n6/u8Q8dO1miDpfCIqYe96O29d2KLo
         kgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yUEjeqQ0jNyrj9kyIDpLfI3dn5L2tIgCnprfg5xm1/c=;
        b=A+LXSAp6Gt/GV7oWqTzbu720+Z7Q/jf7hSZsnBZ5wRkdaGwh3DAPR32eT6KR9SVULi
         atABMXP7CXRRLT8F0KVJ+Mz3Sz55JhidPVEQ7mdI0HF5VT5eVuuYTWJDn0nQvWPmL3sr
         t6nECYgA0JvenLJLBS6WZEHVi06/gXjlgTMkrzQ5KFNagVQzHXIEWjg+6gyTPxZBHb+t
         20PjYnzHGcD1H+j3pr9bE6tD9oXR1w/oSBVKOT5BmarsHiRn1f7CjT086//61SUXvQNJ
         iU5I5vPPK0HHLvNE+HIlx9GmsCwIXz0gf3LZxfoz4z6m/xRFLY6dsqPl1sk8hOdxqlv2
         Pu9Q==
X-Gm-Message-State: APjAAAWwKEAJ/uv/X0CsUyBahTHBBCAtc+HJ75hwnoJywCt5bzfRmN4I
        MkuaRY8DQaRBEB/PkvODCzU=
X-Google-Smtp-Source: APXvYqzkYTONjcOvje7w7mlhrENaLDkyERI+zs7xtF5UEmgBcddzsKV9+lyHCOnmYpjzRy3uQ+K+Qw==
X-Received: by 2002:a5d:4ac9:: with SMTP id y9mr3756893wrs.178.1561036494161;
        Thu, 20 Jun 2019 06:14:54 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id k82sm5780984wma.15.2019.06.20.06.14.53
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 06:14:53 -0700 (PDT)
Subject: Re: [PATCH v3 0/6] crypto: switch to crypto API for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <6a45dfa5-e383-d8a3-ebf1-abdc43c95ebd@gmail.com>
Date:   Thu, 20 Jun 2019 15:14:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <075cddec-1603-4a23-17c4-c766b4bd9086@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 20/06/2019 14:09, Milan Broz wrote:
> On 20/06/2019 13:54, Ard Biesheuvel wrote:
>> On Thu, 20 Jun 2019 at 13:22, Milan Broz <gmazyland@gmail.com> wrote:
>>>
>>> On 19/06/2019 18:29, Ard Biesheuvel wrote:
>>>> This series creates an ESSIV template that produces a skcipher or AEAD
>>>> transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
>>>> (or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
>>>> encapsulated sync or async skcipher/aead by passing through all operations,
>>>> while using the cipher/shash pair to transform the input IV into an ESSIV
>>>> output IV.
>>>>
>>>> This matches what both users of ESSIV in the kernel do, and so it is proposed
>>>> as a replacement for those, in patches #2 and #4.
>>>>
>>>> This code has been tested using the fscrypt test suggested by Eric
>>>> (generic/549), as well as the mode-test script suggested by Milan for
>>>> the dm-crypt case. I also tested the aead case in a virtual machine,
>>>> but it definitely needs some wider testing from the dm-crypt experts.
>>>>
>>>> Changes since v2:
>>>> - fixed a couple of bugs that snuck in after I'd done the bulk of my
>>>>   testing
>>>> - some cosmetic tweaks to the ESSIV template skcipher setkey function
>>>>   to align it with the aead one
>>>> - add a test case for essiv(cbc(aes),aes,sha256)
>>>> - add an accelerated implementation for arm64 that combines the IV
>>>>   derivation and the actual en/decryption in a single asm routine
>>>
>>> I run tests for the whole patchset, including some older scripts and seems
>>> it works for dm-crypt now.
>>>
>>
>> Thanks Milan, that is really helpful.
>>
>> Does this include configurations that combine authenc with essiv?
> 
> Hm, seems that we are missing these in luks2-integrity-test. I'll add them there.
> 
> I also used this older test
> https://gitlab.com/omos/dm-crypt-test-scripts/blob/master/root/test_dmintegrity.sh
> 
> (just aes-gcm-random need to be commented out, we never supported this format, it was
> written for some devel version)
> 
> But seems ESSIV is there tested only without AEAD composition...
> 
> So yes, this AEAD part need more testing.

And unfortunately it does not work - it returns EIO on sectors where it should not be data corruption.

I added few lines with length-preserving mode with ESSIV + AEAD, please could you run luks2-integrity-test
in cryptsetup upstream?

This patch adds the tests:
https://gitlab.com/cryptsetup/cryptsetup/commit/4c74ff5e5ae328cb61b44bf99f98d08ffee3366a

It is ok on mainline kernel, fails with the patchset:

# ./luks2-integrity-test 
[aes-cbc-essiv:sha256:hmac-sha256:128:512][FORMAT][ACTIVATE]sha256sum: /dev/mapper/dmi_test: Input/output error
[FAIL]
 Expecting ee501705a084cd0ab6f4a28014bcf62b8bfa3434de00b82743c50b3abf06232c got .

FAILED backtrace:
77 ./luks2-integrity-test
112 intformat ./luks2-integrity-test
127 main ./luks2-integrity-test

Milan
