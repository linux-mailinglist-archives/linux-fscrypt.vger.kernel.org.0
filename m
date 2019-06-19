Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0074B717
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jun 2019 13:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfFSLdT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jun 2019 07:33:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56167 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfFSLdT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jun 2019 07:33:19 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so1368715wmj.5;
        Wed, 19 Jun 2019 04:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GGMWcYLCV7t4/9cNcGVR3MQcrhQTdeMjAQRXmJAFNwo=;
        b=WObqFvoMzYeNXzXTnHP+4wMK//dCk2xLMAXfsF4OvhjmqMLropZ4q+W0PZfDAAUD0P
         8sbSQ2c+8OQGArlIV3VpEmi2k1bZCsAMbN84uIeFq3GEcewSAAWzatTPgeQYCHi4XQ6c
         E9UAL916Ane4FG52htNRZn0fmvGaQbWh+w/DL475EtpgJ7f44Nl15UeudP1jof62yT5n
         KEfKtYX1LmyOrWWPbpJg0FvbzZWSiWNPvkZRrXJlC6ezmoxrqdA6bs7YyndxBi4BqIlW
         Onp6oVrxLatfrcxg/Plw9/kPuNJFvyuWHgNlkWwHdGgzsufo8L4L2PyNW/N/1oy2b7eA
         mPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GGMWcYLCV7t4/9cNcGVR3MQcrhQTdeMjAQRXmJAFNwo=;
        b=M0h798KhdyyPmCZScC47f4CBlumNmCz0WZ0StDGCRSO6Vo6Uf1pqIubsyuahcEi1Cw
         fZlzFa/EHdCcl/Zijy6sV37Y6tGEjFoAympmuiyBX5+9VM6Ha3JX79hBicdatto6lmkH
         xSubDmIUsqGd1vRoyx+OROwIQgQWMJhMPjG2XABv2pfW1Pa0BEM4smIVb8HFIeXbavc6
         K/0BwopYPVNW3TfPbX+uSvL63aEYz2yv8xXC37RUQo7W0tzy5lZnN3KwZp7JiB0tcPDM
         fvYtuSzhBp2Z0Latm+YhOXGQaLWsnQNDy6OsOP2dOz/YOqcvVVlx//qKixqWasw61x7B
         kcrw==
X-Gm-Message-State: APjAAAX54Jho/xeOSWrp1HOCaTzrB9c14mLzWpRj1xArLNMqf5gaT3ll
        5k4mO4Dodas1mdhdWZfRgKA=
X-Google-Smtp-Source: APXvYqz/e5QiGPcuvAiHUBfYuK6SN6vOh4fhuQyaJKVRKci6IWE0sYGx9o2/Tw+mjMmz66aMGvaXGQ==
X-Received: by 2002:a1c:ab06:: with SMTP id u6mr7808241wme.125.1560943996514;
        Wed, 19 Jun 2019 04:33:16 -0700 (PDT)
Received: from [10.43.17.224] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y19sm1596666wmc.21.2019.06.19.04.33.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 04:33:15 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] crypto: switch to crypto API for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
 <099346ee-af6e-a560-079d-3fb68fb4eeba@gmail.com>
 <CAKv+Gu9MTGSwZgaHyxJKwfiBQzqgNhTs5ue+TC1Ehte-+VBXqg@mail.gmail.com>
 <CAKv+Gu9q5qTgEeTLCW6ZM6Wu6RK559SjFhsgWis72_6-p6RrZA@mail.gmail.com>
 <f5de99dd-0b6a-9f7e-46b7-cd3c5ed3100e@gmail.com>
 <CAKv+Gu9NW2H-TDd66quKSUMpEWGwqEjN-vmf_zueo1tEJLa-xg@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <b5b013eb-9cab-4985-9c24-563cc57c140e@gmail.com>
Date:   Wed, 19 Jun 2019 13:33:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9NW2H-TDd66quKSUMpEWGwqEjN-vmf_zueo1tEJLa-xg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 19/06/2019 13:16, Ard Biesheuvel wrote:
>> Try
>>   cryptsetup open --type plain -c null /dev/sdd test -q
>> or
>>   dmsetup create test --table " 0 417792 crypt cipher_null-ecb - 0 /dev/sdd 0"
>>
>> (or just run full cryptsetup testsuite)
>>
> 
> Is that your mode-test script?
> 
> I saw some errors about the null cipher, but tbh, it looked completely
> unrelated to me, so i skipped those for the moment. But now, it looks
> like it is related after all.

This was triggered by align-test, mode-test fails the same though.

It is definitely related, I think you just changed the mode parsing in dm-crypt.
(cipher null contains only one dash I guess).

m.


> 
> 
>> kernel: BUG: kernel NULL pointer dereference, address: 00000000
>> kernel: #PF: supervisor read access in kernel mode
>> kernel: #PF: error_code(0x0000) - not-present page
>> kernel: *pde = 00000000
>> kernel: Oops: 0000 [#1] PREEMPT SMP
>> kernel: CPU: 2 PID: 2261 Comm: cryptsetup Not tainted 5.2.0-rc5+ #521
>> kernel: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
>> kernel: EIP: strcmp+0x9/0x20
>> kernel: Code: 00 55 89 c1 89 e5 57 89 c7 56 89 d6 ac aa 84 c0 75 fa 5e 89 c8 5f 5d c3 8d b4 26 00 00 00 00 66 90 55 89 e5 57 89 d7 56 89 c6 <ac> ae 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 5e 5f 5d c3 8d 76
>> kernel: EAX: 00000000 EBX: ef51016c ECX: 0000000c EDX: f78e585e
>> kernel: ESI: 00000000 EDI: f78e585e EBP: f238dcb0 ESP: f238dca8
>> kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210282
>> kernel: CR0: 80050033 CR2: 00000000 CR3: 30a28000 CR4: 00140690
>> kernel: Call Trace:
>> kernel:  crypt_ctr+0x473/0xf4e [dm_crypt]
>> kernel:  dm_table_add_target+0x15f/0x340 [dm_mod]
>> kernel:  table_load+0xe9/0x280 [dm_mod]
>> kernel:  ? retrieve_status+0x200/0x200 [dm_mod]
>> kernel:  ctl_ioctl+0x1c8/0x400 [dm_mod]
>> kernel:  ? retrieve_status+0x200/0x200 [dm_mod]
>> kernel:  ? ctl_ioctl+0x400/0x400 [dm_mod]
>> kernel:  dm_ctl_ioctl+0x8/0x10 [dm_mod]
>> kernel:  do_vfs_ioctl+0x3dd/0x790
>> kernel:  ? trace_hardirqs_on+0x4a/0xf0
>> kernel:  ? ksys_old_semctl+0x27/0x30
>> kernel:  ksys_ioctl+0x2e/0x60
>> kernel:  ? mpihelp_add_n+0x39/0x50
>> kernel:  sys_ioctl+0x11/0x20
>> kernel:  do_int80_syscall_32+0x4b/0x1a0
>> kernel:  ? mpihelp_add_n+0x39/0x50
>> kernel:  entry_INT80_32+0xcf/0xcf
>> kernel: EIP: 0xb7f5bbf2
>> kernel: Code: de 01 00 05 ed 73 02 00 83 ec 14 8d 80 0c ac ff ff 50 6a 02 e8 5f 12 01 00 c7 04 24 7f 00 00 00 e8 ce cd 01 00 66 90 90 cd 80 <c3> 8d b6 00 00 00 00 8d bc 27 00 00 00 00 8b 1c 24 c3 8d b6 00 00
>> kernel: EAX: ffffffda EBX: 00000005 ECX: c138fd09 EDX: 00511080
>> kernel: ESI: b7b83d40 EDI: b7b785af EBP: 0050dda0 ESP: bf9e1c34
>> kernel: DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00200286
>> kernel:  ? mpihelp_add_n+0x39/0x50
>> kernel: Modules linked in: dm_crypt loop dm_mod pktcdvd crc32_pclmul crc32c_intel aesni_intel aes_i586 crypto_simd cryptd ata_piix
>> kernel: CR2: 0000000000000000
>> kernel: ---[ end trace 0d32231f952fd372 ]---
>>
>> m.
