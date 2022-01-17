Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CDB49112E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jan 2022 22:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243156AbiAQU7y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jan 2022 15:59:54 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:41940 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235739AbiAQU7y (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jan 2022 15:59:54 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1n9Z68-0002gK-TR; Mon, 17 Jan 2022 21:59:28 +0100
Message-ID: <392d28fa-7a2c-867a-5fbb-640064461eb7@maciej.szmigiero.name>
Date:   Mon, 17 Jan 2022 21:59:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>, dhowells@redhat.com,
        dwmw2@infradead.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.ibm.com, ebiggers@kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
 <YeV+jkGg6mpQdRID@zx2c4.com> <20220117165933.l3762ppcbj5jxicc@meerkat.local>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
In-Reply-To: <20220117165933.l3762ppcbj5jxicc@meerkat.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 17.01.2022 17:59, Konstantin Ryabitsev wrote:
> On Mon, Jan 17, 2022 at 03:34:54PM +0100, Jason A. Donenfeld wrote:
>> If you're looking for a simple signature mechanism to replace the use of
>> X.509 and all of that infrastructure, may I suggest just coming up with
>> something simple using ed25519, similar to signify or minisign? Very
>> minimal code in the kernel, in userspace, and very few moving parts to
>> break.
> 
> I am concerned that ed25519 private key management is very rudimentary -- more
> often than not it is just kept somewhere on disk, often without any passphrase
> encryption.
> 
> With all its legacy warts, GnuPG at least has decent support for hardware
> off-load via OpenPGP smartcards or TPM integration in GnuPG 2.3, but the best
> we have with ed25519 is passhprase protection as implemented in minisign (and

I am not sure that I understood your point here correctly, but GnuPG
already supports ed25519 keys, including stored on a smartcard - for
example, on a YubiKey [1].

While the current software support for ed25519 might be limited, there
is certainly progress being made, RFC 8410 allowed these algos for X.509
certificates.
Support for such certificates is already implemented in OpenSSL [2].

ECDSA, on the other hand, is very fragile with respect to random number
generation at signing time.
We know that people got burned here in the past.

Thanks,
Maciej

[1]: https://developers.yubico.com/PGP/YubiKey_5.2.3_Enhancements_to_OpenPGP_3.4.html
[2]: https://blog.pinterjann.is/ed25519-certificates.html
