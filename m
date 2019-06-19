Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F284B697
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jun 2019 13:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfFSLBS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jun 2019 07:01:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55888 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfFSLBS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jun 2019 07:01:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so1252782wmj.5;
        Wed, 19 Jun 2019 04:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x2X3n8XSQziFMnKt/w2zwh+U+Dl1utfi0mDvOWX3BxI=;
        b=aNuKNkXa+TolShT9Z6UUZ3S8MUndFAF7P3On82mkNQZmyukwm78kvM4Z2z+UQJBHSD
         Q+YY5MD3avZRuh+OnFwBvgrJoaeYHTfs/wdUZdpZNkhg+31XXNLqDWB19FAknqOhWFqk
         rxZKppYQJDKja97Ne7LhH9EyJTqwrXjz0yCDydTKjUA/KY4ZVkx2Ag4wMtS+EAWYODnl
         mZS/2t8gazrwGpWXCUnhxUbvV5QDT4exP1ws85LShWDdYCVFwFF3HyAS7fd3H73jCyec
         ko1/eL+b1dNXiDrlvJRt5Kbnm2LRePu/5WMscnOSXEK7de2X6PMr1LvfhOoleUvPL1yo
         ONoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x2X3n8XSQziFMnKt/w2zwh+U+Dl1utfi0mDvOWX3BxI=;
        b=VPJMbJHfUuugaq3+CzmGyMHmly4LcaYZqOBl81tJV5OgP3idnAm8BcQDARQJjAxQKt
         jMqWfXDCw/V1IenyuGwGoAm4ZeUY5WpFoHtTqoIZyBBWbwpiU1zFy2KoX6Jm1qZdikAX
         rjLC346R4wPyAZdUqCQEwjryPReGH6yYAzE2iVBE7yBuRmoyvOfSqEaJUWVRgzdaeNS0
         34KkZBUVUKhaoa5P2T4k1LrOzGWvwwxkbHrsyg3NBsfXfBKYk+vLHiuKKU5b/etqAV7t
         ucYoJpOgJk99IzA9NPibh76iqT0ruVIwycvfcbAou+uFnML2bZcC9jfHz5YK+jgM+rnd
         mZdQ==
X-Gm-Message-State: APjAAAUGYeoqbF/cILQDikdLk7nKbqLGCJPeVj4omBEV7MhQEue1EA9H
        2c0Vl9EOwHS1bpCC8+AOXe4=
X-Google-Smtp-Source: APXvYqzbi/iw8SjHaxzRpGlQyJSqfJ8G1hR0Pf6gvsLq2noK6yiW2rRwxGdi34j7bDGmlzFbE8O4GQ==
X-Received: by 2002:a1c:e009:: with SMTP id x9mr7719166wmg.5.1560942076262;
        Wed, 19 Jun 2019 04:01:16 -0700 (PDT)
Received: from [10.43.17.224] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z6sm19814770wrw.2.2019.06.19.04.01.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 04:01:15 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] crypto: switch to crypto API for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Milan Broz <gmazyland@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
 <099346ee-af6e-a560-079d-3fb68fb4eeba@gmail.com>
 <CAKv+Gu9MTGSwZgaHyxJKwfiBQzqgNhTs5ue+TC1Ehte-+VBXqg@mail.gmail.com>
 <CAKv+Gu9q5qTgEeTLCW6ZM6Wu6RK559SjFhsgWis72_6-p6RrZA@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <f5de99dd-0b6a-9f7e-46b7-cd3c5ed3100e@gmail.com>
Date:   Wed, 19 Jun 2019 13:01:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9q5qTgEeTLCW6ZM6Wu6RK559SjFhsgWis72_6-p6RrZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 19/06/2019 11:14, Ard Biesheuvel wrote:
> Apologies, this was a rebase error on my part.
> 
> Could you please apply the hunk below and try again?
> 
> diff --git a/crypto/essiv.c b/crypto/essiv.c
> index 029a65afb4d7..5dc2e592077e 100644
> --- a/crypto/essiv.c
> +++ b/crypto/essiv.c
> @@ -243,6 +243,8 @@ static int essiv_aead_encrypt(struct aead_request *req)
>  static int essiv_skcipher_decrypt(struct skcipher_request *req)
>  {
>         struct essiv_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
> +
> +       essiv_skcipher_prepare_subreq(req);
>         return crypto_skcipher_decrypt(&rctx->blockcipher_req);
>  }

That helps, but now the null cipher is broken...
(We use it for debugging and during reencryption from non-encrypted device)

Try
  cryptsetup open --type plain -c null /dev/sdd test -q
or
  dmsetup create test --table " 0 417792 crypt cipher_null-ecb - 0 /dev/sdd 0"

(or just run full cryptsetup testsuite)

kernel: BUG: kernel NULL pointer dereference, address: 00000000
kernel: #PF: supervisor read access in kernel mode
kernel: #PF: error_code(0x0000) - not-present page
kernel: *pde = 00000000 
kernel: Oops: 0000 [#1] PREEMPT SMP
kernel: CPU: 2 PID: 2261 Comm: cryptsetup Not tainted 5.2.0-rc5+ #521
kernel: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
kernel: EIP: strcmp+0x9/0x20
kernel: Code: 00 55 89 c1 89 e5 57 89 c7 56 89 d6 ac aa 84 c0 75 fa 5e 89 c8 5f 5d c3 8d b4 26 00 00 00 00 66 90 55 89 e5 57 89 d7 56 89 c6 <ac> ae 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 5e 5f 5d c3 8d 76
kernel: EAX: 00000000 EBX: ef51016c ECX: 0000000c EDX: f78e585e
kernel: ESI: 00000000 EDI: f78e585e EBP: f238dcb0 ESP: f238dca8
kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210282
kernel: CR0: 80050033 CR2: 00000000 CR3: 30a28000 CR4: 00140690
kernel: Call Trace:
kernel:  crypt_ctr+0x473/0xf4e [dm_crypt]
kernel:  dm_table_add_target+0x15f/0x340 [dm_mod]
kernel:  table_load+0xe9/0x280 [dm_mod]
kernel:  ? retrieve_status+0x200/0x200 [dm_mod]
kernel:  ctl_ioctl+0x1c8/0x400 [dm_mod]
kernel:  ? retrieve_status+0x200/0x200 [dm_mod]
kernel:  ? ctl_ioctl+0x400/0x400 [dm_mod]
kernel:  dm_ctl_ioctl+0x8/0x10 [dm_mod]
kernel:  do_vfs_ioctl+0x3dd/0x790
kernel:  ? trace_hardirqs_on+0x4a/0xf0
kernel:  ? ksys_old_semctl+0x27/0x30
kernel:  ksys_ioctl+0x2e/0x60
kernel:  ? mpihelp_add_n+0x39/0x50
kernel:  sys_ioctl+0x11/0x20
kernel:  do_int80_syscall_32+0x4b/0x1a0
kernel:  ? mpihelp_add_n+0x39/0x50
kernel:  entry_INT80_32+0xcf/0xcf
kernel: EIP: 0xb7f5bbf2
kernel: Code: de 01 00 05 ed 73 02 00 83 ec 14 8d 80 0c ac ff ff 50 6a 02 e8 5f 12 01 00 c7 04 24 7f 00 00 00 e8 ce cd 01 00 66 90 90 cd 80 <c3> 8d b6 00 00 00 00 8d bc 27 00 00 00 00 8b 1c 24 c3 8d b6 00 00
kernel: EAX: ffffffda EBX: 00000005 ECX: c138fd09 EDX: 00511080
kernel: ESI: b7b83d40 EDI: b7b785af EBP: 0050dda0 ESP: bf9e1c34
kernel: DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00200286
kernel:  ? mpihelp_add_n+0x39/0x50
kernel: Modules linked in: dm_crypt loop dm_mod pktcdvd crc32_pclmul crc32c_intel aesni_intel aes_i586 crypto_simd cryptd ata_piix
kernel: CR2: 0000000000000000
kernel: ---[ end trace 0d32231f952fd372 ]---

m.
