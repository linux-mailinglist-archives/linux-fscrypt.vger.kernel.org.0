Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4149948CCFB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Jan 2022 21:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350777AbiALUPy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 Jan 2022 15:15:54 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:55462 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350686AbiALUPy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 Jan 2022 15:15:54 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1n7k24-0005Dj-Rb; Wed, 12 Jan 2022 21:15:44 +0100
Message-ID: <ab3d2bda-a704-f5d3-adee-e52b7d0a4641@maciej.szmigiero.name>
Date:   Wed, 12 Jan 2022 21:15:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
 <ab29dd6f-1301-e012-8898-9c739ca511a3@maciej.szmigiero.name>
 <b37f9c0e9bf941f0b778c6949538835d@huawei.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
In-Reply-To: <b37f9c0e9bf941f0b778c6949538835d@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 12.01.2022 10:16, Roberto Sassu wrote:
>> From: Maciej S. Szmigiero [mailto:mail@maciej.szmigiero.name]
>> Sent: Tuesday, January 11, 2022 9:33 PM
>> On 11.01.2022 19:03, Roberto Sassu wrote:
>>> Support for PGP keys and signatures was proposed by David long time ago,
>>> before the decision of using PKCS#7 for kernel modules signatures
>>> verification was made. After that, there has been not enough interest to
>>> support PGP too.
>>>
>>> Lately, when discussing a proposal of introducing fsverity signatures in
>>> Fedora [1], developers expressed their preference on not having a separate
>>> key for signing, which would complicate the management of the distribution.
>>> They would be more in favor of using the same PGP key, currently used for
>>> signing RPM headers, also for file-based signatures (not only fsverity, but
>>> also IMA ones).
>>
>> Aren't PGP keys simply RSA / ECC / EdDSA keys with additional metadata?
>> Can't they be unwrapped from their (complex) PGP format in userspace and
>> loaded raw into the kernel, in a similar way as they are sometimes used
>> for SSH authentication?
> 
> Probably, this would be possible by introducing a new asymmetric
> key subtype parsing PGP keys and signatures in a more simple format,
> after conversion by user space. But still, a parser would be required.
> To be honest, I would prefer to implement (actually David did) a
> parser following an RFC, than developing a new one.

A parser in userspace is preferred to one in kernel since if there is
a bug somewhere its consequences are much less severe.
And experience shows that parsers are especially prone to bugs.
A userspace implementation can also be tightly sandboxed for extra
security.

There are many existing OpenPGP parsing libraries to choose from.

>> This will save us from having to add complex parsers (a well-known source
>> of bugs) into the kernel - I guess there aren't any plans to add an
>> in-kernel PGP Web of Trust implementation.
> 
> I extensively tested the implementation with an ad-hoc fault injector,
> to see if the code can correctly handle errors. I also developed a
> fuzzer to corrupt the data before it is read by the kernel. Finally,
> I checked that there are not memory leaks. But I agree, there could
> still be bugs.
> 
> If you mean that a key can be added to the kernel if is vouched for
> by another key in the built-in keyring, I actually implemented this
> (was missing in the original implementation). Some keyrings, e.g. .ima,
> have this restriction.
> 
> The way this works is that, whenever you add a PGP key to the
> kernel, the parser takes not only the public key and the user ID,
> but also its signature by the same or another PGP key.
> 
> The signature is verified when the key is added to the keyring
> with that restriction, and only if the verification is successful
> the key can be added.

I understand but it would be great to make use as much as possible of
the existing in-kernel signature verification mechanisms.

> Roberto

Thanks,
Maciej

