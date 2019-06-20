Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9406D4CD6E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 14:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbfFTMJV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 08:09:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39162 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730596AbfFTMJV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 08:09:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so2772433wrt.6;
        Thu, 20 Jun 2019 05:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5mvPAeiaYnKYEQR24EInixOGLfqaTMkg5VDMI1QMmMg=;
        b=pGQojq13gpTSCFuKobX79+3Cf9Ml5Lo1gq8THOBHUlnhFxv34m3uy/JOF0LlcQFe17
         FJLrcQwDz14qisxiRbhjz2FLNDTMgU3VtVnUs8DwAgrslevzrKlBObNOur4jAsWQeuZz
         cR81mIsxu5qIp/LIZN9elRR/tLAwdDR9abHjj7JIKmOuae+xEba87HrTM3yLkg9hlUbP
         eaVr3hr1M58XPyCyKIZF1h90OGdGpelI8YRwIYG4rhQ3d4m91C540TalmWoXlZFv+kn+
         ECr4O6xxdNeSsebyhocdHAEd4um52Rvx8eaaJ26wz/a8z3OvnQ+LgXTAmIC5wnS85HeJ
         05Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5mvPAeiaYnKYEQR24EInixOGLfqaTMkg5VDMI1QMmMg=;
        b=uV2eE5h/ZgvmX2w/gKihd2/IfgPSl5Hzi5OpXJbmGE9tsAHnUBnmclBzg8MM+wzL5d
         rbOGeYzFSQKG8qtAIbZaG7APRfXWzKlYObEjYCmdriJkVVFMR23Hcczc4audnYF0J4le
         R8WOx9pAFzXwbZz88nGTJ1DQ4CwATVvtZ7eW0lrcXwRSzLYsXOpAQoG4fS9oj8EtL2/D
         E07pE1xNgzwhy9VK/NfRRFsNTkuDmEmYr2DdW9wPOXxIIHWabC51ZwJTgjed7QrOyChk
         Q2vZGHzhw/RvF5LgnTANHIu9DZxsqZLS2ozcZGGJTeLbXLhtVnGs2tk8sJhukSYfvCgK
         dUWA==
X-Gm-Message-State: APjAAAXzvT7IWWMW7htSR48ikAKnNsg0Rah7FcEkf/J7b18tJdFRdEYL
        RSgei5GzJFqql75MpuFi9Po=
X-Google-Smtp-Source: APXvYqyY1DjkAMtvJgSsiPIR9M/m05hvqBQ8unv5XRo45PSSzjG0yRy5CETsPxPn/L1QURVdkuA1jQ==
X-Received: by 2002:adf:e446:: with SMTP id t6mr79712848wrm.115.1561032558831;
        Thu, 20 Jun 2019 05:09:18 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id f204sm6483119wme.18.2019.06.20.05.09.18
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 05:09:18 -0700 (PDT)
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
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <075cddec-1603-4a23-17c4-c766b4bd9086@gmail.com>
Date:   Thu, 20 Jun 2019 14:09:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9jk8KxWykTcKeh6k0HUb47wgx7iZYuwwN8AUyErFLXxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 20/06/2019 13:54, Ard Biesheuvel wrote:
> On Thu, 20 Jun 2019 at 13:22, Milan Broz <gmazyland@gmail.com> wrote:
>>
>> On 19/06/2019 18:29, Ard Biesheuvel wrote:
>>> This series creates an ESSIV template that produces a skcipher or AEAD
>>> transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
>>> (or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
>>> encapsulated sync or async skcipher/aead by passing through all operations,
>>> while using the cipher/shash pair to transform the input IV into an ESSIV
>>> output IV.
>>>
>>> This matches what both users of ESSIV in the kernel do, and so it is proposed
>>> as a replacement for those, in patches #2 and #4.
>>>
>>> This code has been tested using the fscrypt test suggested by Eric
>>> (generic/549), as well as the mode-test script suggested by Milan for
>>> the dm-crypt case. I also tested the aead case in a virtual machine,
>>> but it definitely needs some wider testing from the dm-crypt experts.
>>>
>>> Changes since v2:
>>> - fixed a couple of bugs that snuck in after I'd done the bulk of my
>>>   testing
>>> - some cosmetic tweaks to the ESSIV template skcipher setkey function
>>>   to align it with the aead one
>>> - add a test case for essiv(cbc(aes),aes,sha256)
>>> - add an accelerated implementation for arm64 that combines the IV
>>>   derivation and the actual en/decryption in a single asm routine
>>
>> I run tests for the whole patchset, including some older scripts and seems
>> it works for dm-crypt now.
>>
> 
> Thanks Milan, that is really helpful.
> 
> Does this include configurations that combine authenc with essiv?

Hm, seems that we are missing these in luks2-integrity-test. I'll add them there.

I also used this older test
https://gitlab.com/omos/dm-crypt-test-scripts/blob/master/root/test_dmintegrity.sh

(just aes-gcm-random need to be commented out, we never supported this format, it was
written for some devel version)

But seems ESSIV is there tested only without AEAD composition...

So yes, this AEAD part need more testing.

Milan
