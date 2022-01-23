Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036084975A4
	for <lists+linux-fscrypt@lfdr.de>; Sun, 23 Jan 2022 22:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240159AbiAWVAn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 23 Jan 2022 16:00:43 -0500
Received: from chameleon.vennard.ch ([37.35.107.252]:58038 "EHLO
        chameleon.vennard.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240141AbiAWVAm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 23 Jan 2022 16:00:42 -0500
Received: from localhost (localhost [IPv6:::1])
        by chameleon.vennard.ch (Postfix) with ESMTP id 4CBCF120BBF;
        Sun, 23 Jan 2022 21:00:36 +0000 (GMT)
Received: from chameleon.vennard.ch ([IPv6:::1])
        by localhost (chameleon.vennard.ch [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id uhevxyFMwwfF; Sun, 23 Jan 2022 21:00:30 +0000 (GMT)
Received: from localhost (localhost [IPv6:::1])
        by chameleon.vennard.ch (Postfix) with ESMTP id E803D120BF2;
        Sun, 23 Jan 2022 21:00:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.10.3 chameleon.vennard.ch E803D120BF2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vennard.ch;
        s=9ECFC226-3425-11E4-849C-FD7C69C5B08C; t=1642971630;
        bh=wYCS3S8iRLYkdQZ1IN33mUgc56a+EDfAzR7fwxMS9Zo=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=bqbbJtUNsjQUiDHX7Xt909aSY+UOXZPKs9GUAOWxMXoBn96OxoSykyBMkcdO+ccj7
         y2aByqvx1ltq4mtK9O1V3wpeTtcPKLI3yvCZTTunDP1/7sCob1I4Db6Z0NRWHG8bo2
         t5dMcYhblyqoW1RqXmmzAcYT/xP7XgQe1TJcB4OEPLsrEU9m7t8l3N6GwNsbBOGYla
         jLxQ/6he00hOh3HkekBHOTjg18GHywyALwCkmabGqwBa3rR4dlcWrYMqRB5EJY9Txw
         s3Ilat5vgp8ZKnR+myU3YyKIlyG3SF8q35MbyNln/zglDHEL9CuCS6ZhlxIVfE5u+o
         r+1BtYIDg8W05npsr28eOeEkfN8ku/VTpFiDEd7oCVURwiH/PASn08Nu1BRdVMalzo
         f+3mj5zKN4DPe8ghZc+Kzh5UBqEDTv/3UUOPATDRsjp2pMgEPYvWpEW+ptdIS/3Fq5
         T5bewjQcquNnYDMc91GbAE04wO0bp2PCVzmxS4iKoq11+uVec3s8RUbev7ZfA/Og/S
         FEaokvzOKFGVEZySUg+gZ2aVd7+C5NyDNvDy/M0eH5pF3RaJ3nC/dePhN6U9UTXyVY
         2lhOYf3kk0xChgXx5ZJ6B/ic53K/uruuCYITINv6JRAyqthq6IZ1f5AogztL2r5vZZ
         kxwMtSjC/ETEr0EqwJ9ymGwU=
X-Virus-Scanned: amavisd-new at vennard.ch
Received: from chameleon.vennard.ch ([IPv6:::1])
        by localhost (chameleon.vennard.ch [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id MyYrkqBLqrMj; Sun, 23 Jan 2022 21:00:21 +0000 (GMT)
Received: from [IPV6:2001:470:26:1b7::8a8a] (unknown [IPv6:2001:470:26:1b7::8a8a])
        by chameleon.vennard.ch (Postfix) with ESMTPSA id 09456120BBF;
        Sun, 23 Jan 2022 21:00:18 +0000 (GMT)
Authentication-Results: chameleon.vennard.ch; dkim=none
Subject: Re: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Roberto Sassu <roberto.sassu@huawei.com>, dhowells@redhat.com,
        dwmw2@infradead.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.ibm.com
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
 <YeV+jkGg6mpQdRID@zx2c4.com>
 <d92912bba61ee37e42d04b64073b9031604acc0f.camel@HansenPartnership.com>
 <079f10b9-060b-3a36-2224-fa1b483cbad5@vennard.ch>
 <YedHR93wPLS/JEsE@sol.localdomain>
From:   Antony Vennard <antony@vennard.ch>
Message-ID: <24206663-b0ee-8c99-28c3-da4d433dee9d@vennard.ch>
Date:   Sun, 23 Jan 2022 22:00:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
MIME-Version: 1.0
In-Reply-To: <YedHR93wPLS/JEsE@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 19/01/2022 00:03, Eric Biggers wrote:
> On Tue, Jan 18, 2022 at 09:50:21PM +0100, Antony Vennard wrote:
>>
>> Hi All,

> It's worth noting that if fs-verity built-in signatures are used, a trusted
> userspace program is still required to determine and enforce the policy of which
> files are required to be signed.  The kernel only handles the actual signature
> verification.  This was basically a proof-of-concept which reused the kernel's
> module signature verification code (which happens to use PKCS#7).
> 
> I'd encourage new users to either go all-in on a userspace solution, using a
> trusted userspace program to verify signatures of fs-verity file digests;
> *or* go all-in on an in-kernel solution, using the IMA support for fs-verity
> which Mimi Zohar is working on.  A userspace solution could use a simple
> signature format, using a modern algorithm such as Ed25519.  IMA uses a simple
> signature format too, though it uses a complex format (X.509) for public keys.

FWIW I checked some of the options for hardware key storage. Thales HSMs 
support Ed25519, at least according to their marketing materials. 
Similarly Javacard 3.1 supports (will support) X/Ed 25519/448, so when 
tokens supporting this emerge (if they haven't already) hardware support 
for modern algorithms should exist too.

I therefore agree. Use Ed25519.

Antony
