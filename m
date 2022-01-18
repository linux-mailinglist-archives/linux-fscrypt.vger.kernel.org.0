Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EA1492FC8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Jan 2022 21:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349285AbiARU5q (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Jan 2022 15:57:46 -0500
Received: from chameleon.vennard.ch ([37.35.107.252]:52638 "EHLO
        chameleon.vennard.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245609AbiARU5q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Jan 2022 15:57:46 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2022 15:57:44 EST
Received: from localhost (localhost [IPv6:::1])
        by chameleon.vennard.ch (Postfix) with ESMTP id BA7F9120BBF;
        Tue, 18 Jan 2022 20:50:37 +0000 (GMT)
Received: from chameleon.vennard.ch ([IPv6:::1])
        by localhost (chameleon.vennard.ch [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id ooQvYuX_Bke6; Tue, 18 Jan 2022 20:50:32 +0000 (GMT)
Received: from localhost (localhost [IPv6:::1])
        by chameleon.vennard.ch (Postfix) with ESMTP id 6A7B2120BF2;
        Tue, 18 Jan 2022 20:50:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.10.3 chameleon.vennard.ch 6A7B2120BF2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vennard.ch;
        s=9ECFC226-3425-11E4-849C-FD7C69C5B08C; t=1642539032;
        bh=h9L8ml/Dr+9Otc4vSQsu7LfWauQMaE0fP0OWB1a411E=;
        h=From:To:Message-ID:Date:MIME-Version;
        b=fVEfEhlpeNjsHYFnpFu3wB4XxSwlSACTv2MSWsmmDB92fE0zvL8m9j+/gw3Y4+HgZ
         eG8K1weO39zugC808b8Dd0jM/h5egUD6NKoqptNcDksDs6KvS4MvpAV0SqA1eWSrD2
         XkCrGKKOjbFpQYYzX/CVpukf3eEW3t6vp4+D8Ijz/Tg0HRxuTGOckh7zbpToAw6Zwk
         b1Chf3ONUzVqQ83gitdTkDmzmIUjSZJdCoYMmATpRYPZYOxqwclgxPOKY+v//yPUA0
         hvxXijEwlJEs/z/CAmRQay9qr0xs2u3y1m+VYbCnkDLDSz8heX9AWCCWv8MzKpgGPw
         ERz40MpvfIYxW+ieirDsP7Txxn6dnGa/e7le5RqFU/oLcX5tvdvNblybTj4soB+XeU
         27IiONqAwA38Otq+sLwnrv4eD5hMEgGKmEqHZimbtTX4fDlgLHHXZXqCn6oSHwb0r9
         G1Chq9PVUxXsIwr0oSyjEmM9E5EhErGrUIQzS1JhhteRz/L8dJiinu0LXplJfHpDQy
         +8V2UILXIm9pNdhENzSHVywRYd1l8VUBXZMDM43NgwfSq73LzqO2ZhX5jBet1yF2u6
         LJkkkHza4DsVu8HauHhGqzU9agMt2GO5xcGzTYRWVSf0pqdyC3qdbgTziUnIhjKcqg
         yheNz5YbYIAbPRekG6fYSSoQ=
X-Virus-Scanned: amavisd-new at vennard.ch
Received: from chameleon.vennard.ch ([IPv6:::1])
        by localhost (chameleon.vennard.ch [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id xHHYNI3omkmN; Tue, 18 Jan 2022 20:50:23 +0000 (GMT)
Received: from [IPV6:2001:470:26:1b7::8a8a] (unknown [IPv6:2001:470:26:1b7::8a8a])
        by chameleon.vennard.ch (Postfix) with ESMTPSA id 249EE120BBF;
        Tue, 18 Jan 2022 20:50:20 +0000 (GMT)
Authentication-Results: chameleon.vennard.ch; dkim=none
From:   Antony Vennard <antony@vennard.ch>
Subject: Re: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
Cc:     dhowells@redhat.com, dwmw2@infradead.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.ibm.com,
        ebiggers@kernel.org
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
 <YeV+jkGg6mpQdRID@zx2c4.com>
 <d92912bba61ee37e42d04b64073b9031604acc0f.camel@HansenPartnership.com>
Message-ID: <079f10b9-060b-3a36-2224-fa1b483cbad5@vennard.ch>
Date:   Tue, 18 Jan 2022 21:50:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
MIME-Version: 1.0
In-Reply-To: <d92912bba61ee37e42d04b64073b9031604acc0f.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


Hi All,

On 17/01/2022 16:02, James Bottomley wrote:
> On Mon, 2022-01-17 at 15:34 +0100, Jason A. Donenfeld wrote:
>> Hi,
>>
>> While it looks like you put a lot of work into this patchset, I think
>> the general idea of adding PGP *to the kernel* is a pretty daunting
>> proposition. The general consensus in the crypto engineering world is
>> that PGP ought to be on its way out. We definitely don't want to
>> perpetuate this project-on-life-support into the permanence of kernel
>> code. Some quick Google searches will reveal a litany of blog posts
>> to the tune of, "why oh why are people still using this?" Here's one
>> from 2019:
>> https://latacora.micro.blog/2019/07/16/the-pgp-problem.html . I
>> think these are arguments to take seriously. And even if you disagree
>> with some parts, you may want to consider whether the remaining parts
>> warrant a bit of pause before adding this to the kernel and
>> perpetuating PGP's design further.

So while I understand why this is being proposed and clearly effort has=20
gone into it, I also think it is not the right approach. It seems this=20
proposal is to include a full PGP packet parser and verification logic=20
in the kernel as an equivalent to allow PGP signatures to be submitted=20
via FS_IOC_ENABLE_VERITY:

"FS_IOC_ENABLE_VERITY accepts a pointer to a PKCS#7 formatted detached=20
signature in DER format of the file=E2=80=99s fs-verity digest."

I may be misinterpreting, but as I understand it logic for X.509/PKCS=20
validation already exists in-kernel because of UEFI and module signing,=20
so this signature would be verified up to trusted roots. The proposal is=20
to duplicate all of this logic but in terms of PGP-formatted keys.

I believe this is unnecessary. Since it seems to require both a=20
signature and verification up to a root, and distributions like Fedora=20
already deal with x509 module signing keys for their kernel modules, I=20
can't see the merit in including the full PGP system too. The=20
least-effort approach, I would suggest, is to include an x509=20
representation of the signature in the RPM and use the existing API to=20
push that up into the kernel, with the trust anchor the same as is used=20
for module signing keys, or whatever distributions prefer (they, after=20
all, control the kernel trust anchors).

I understand this requires some effort, but so too does maintaining a=20
fully fledged PGP packet parser as privileged code for all time, and I=20
think maintaining this in userspace is a) easier and b) less costly than=20
doing it in kernel. As an added bonus, a PGP-parsing library in a=20
memory-safe language could be used in userspace.

A slightly more drastic step would be to wholesale move to PKCS=20
signatures for packaging. Linux distributions could be their own trusted=20
roots for this purpose if they so desired, and since they control=20
certificate bundles anyway they've no need to add them to the browser=20
list if that is a concern, and can issue certs without SSL Client/SSL=20
Server types and OIDs.

> The reason is simple though: for all the detractors and whining, no-
> one's actually been able to come up with a more usable replacement.
> Very few people who complain about GPG actually submit patches to fix
> it.  A few come up with their own infrastructure which tends to have
> even more problems.

Probably replacing with PKCS is a non-starter, but it is at least=20
possible and it is highly likely distros package one or more tools=20
capable of validating such signatures in their base installs.

There are multiple problems with PGP that receive complaints. They are:

  1) No forward secrecy in messaging-based crypto.
  2) The data format.
  3) Outdated cryptography still supported.
  4) UX.

Of these, all four could be levelled against PKCS standards and related=20
tools too (except TLS protocols for the first point), and only 2 and 3=20
are relevant here since we are concerned with signature validation only.

I'm not "against" PGP per se, but I'm not convinced by the idea of=20
adding PGP support just for fs-verity.

>> If you're looking for a simple signature mechanism to replace the use
>> of X.509 and all of that infrastructure, may I suggest just coming up
>> with something simple using ed25519,
>=20
> Please, no, use universally supported crypto that we can use TPM
> hardware for, which for EC currently means P-256.  It may be possible
> to get the TCG and the other security bodies to add Edwards signatures
> but the rate of progression of quantum means that Grover's Algorithm
> will likely get there first and we'll need P-521 or X448.

I agree: whatever is chosen should in my view have decent support for=20
hardware-backed keys, because I strongly hope that is what distribution=20
key storage looks like. If not I might need to move to Gentoo.

The current RPM signing keys for Fedora are RSA-4096, which in my=20
opinion does not actually meet the bar for "good hardware support for=20
algorithm". RSA-2048 tokens are common, but 4096 much less so.

Unfortunately for this reason signify/minisign is not ideal as tools: so=20
far as I can see it has no support for hardware-backed keys. That's not=20
to say they couldn't, although they both use ed25519.

I am not sure if we'll end up in the situation where Grover's algorithm=20
is efficient but Shor is not, but this is all guesswork until we get=20
closer to a quantum computer with enough logical Qubits. But your=20
substantive point I think is valid: hardware vendors are disappointingly=20
slow at adopting edwards curves.

>>   similar to signify or minisign? Very minimal code in the kernel, in
>> userspace, and very few moving parts to break.
>=20
> Heh, this is the classic cryptographers dilemma: go for something
> pejorative which can be minimal but which has only a relatively small
> set of possible use cases and no future proofing or go for something
> extensible which ends up more complex and others then criticize as
> being a "swiss army knife".

I think this is the wrong framing for the problem. We already have one=20
extensible system that is complicated in the kernel. This patch proposes=20
to add a second one achieving the same purpose instead of a userspace=20
solution to take advantage of the existing code, which I think would be=20
preferable and safer.

Antony
