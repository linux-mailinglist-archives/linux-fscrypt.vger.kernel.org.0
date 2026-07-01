Return-Path: <linux-fscrypt+bounces-1705-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id f5H1D1CVRWoyCgsAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1705-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 00:31:44 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 639416F21C0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 00:31:43 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b="YBAWf/Qg";
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1705-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1705-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=gmx.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AA8003080316
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Jul 2026 22:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512AE420E8B;
	Wed,  1 Jul 2026 22:26:17 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC3F39E9AD;
	Wed,  1 Jul 2026 22:26:14 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782944777; cv=none; b=BvyJr6Y12nObZ/fbFXPvRifgppVOnxvPXsgVyEjSJhWvfrF+5a+amypI1/01ceFH+bYYXdS5vv4+YvgQuAOB47lSwYtwaV+jJBIG3Rg5HGeuoPv3hQz+nK2f3gioHdyM03yvT81sifgkqqIDrbSeArGa90JpZXlt+Fxp+PRNezM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782944777; c=relaxed/simple;
	bh=CiCc+gxyFQCxQYEJTMyFrtXjWwbteWBUNHI/ajDsvL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IHtYaBnyNXTbbg4gzP7RZ6nsY99+rK6GzRd48aY2xIyMJDHePqvlErKQMu1kexLHwfHLKs2P9SXK7/bcdSC//Gg36hRQ2B6xbQiz2EjoOIPQkidY68iOG+0aiEjiXYC7XSPUbfd3ANEpqjCNxJUjF9NnYwQnxJOHQsaP6U2PNxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=YBAWf/Qg; arc=none smtp.client-ip=212.227.17.21
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782944772; x=1783549572; i=quwenruo.btrfs@gmx.com;
	bh=Xbla/4L4MeyEqny540ZinC3Z7WAyNkW5AP0+r1sKi5M=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=YBAWf/QgbiViZTaPsDDTHYvA4lrJkbJC2n+a3GRIiZ4yBbftstX6xgoaP27GyAYp
	 Zcm12bOEre5Ok9pENUA+tV/wVzVcMJp76UqizVUnnxALfo6AgRvYtUlNA6U9jzfU4
	 mjeij7/TSpn0CbWoeZRP37v8KO++lVwlcjroB/568kuzmVRB4fyHuBCeTaagvkRKO
	 FxN7TLhfkAOmZ5XIy9Gkgz8tz5vlFYEIFJhi8P8gaS3731Ldj7NPNBtUpAHbD4qr9
	 3jtegfCwbbEOnrBBh1Ex7HY6/LGezWjAVaY0lMoCgQVcnZGj/LLySduXBRrkm5G0O
	 4wdJxk01FVmar5GeFw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MSKu0-1wYZA33Lk8-00ToU8; Thu, 02
 Jul 2026 00:26:12 +0200
Message-ID: <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com>
Date: Thu, 2 Jul 2026 07:56:06 +0930
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file
 extents
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260624165144.556908-1-neelx@suse.com>
 <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com>
 <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qSUlUFvU+J4CF4P1MilUylrSTulGr4VMF5RoyjoYbtrCBi/6XzZ
 gbXmOPxrTbge3s2THAdJ1mXvoBN00Jc5iSybNmZJh0egwrczCUWsPD/ObIL9huWmngVP2rL
 u5B6jrVSeeM6m6+Ckmde2WAlXfGgmmqzmQj3isjeZJJV1taLUXD+J1UEzHUGhLlpbYzZYNR
 Gk8/ROMWvdFThGRzATRYw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+y/OTFtEToQ=;atV15cYH/c8WrTqcDA4svd1vlj8
 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
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmx.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmx.com:s=s31663417];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-1705-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[quwenruo.btrfs@gmx.com,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:neelx@suse.com,m:wqu@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[gmx.com:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmx.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[quwenruo.btrfs@gmx.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,gmx.com:dkim,gmx.com:mid,gmx.com:from_mime,vger.kernel.org:from_smtp,suse.com:email,dorminy.me:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 639416F21C0



=E5=9C=A8 2026/7/2 01:29, Daniel Vacek =E5=86=99=E9=81=93:
> On Fri, 26 Jun 2026 at 01:50, Qu Wenruo <wqu@suse.com> wrote:
>> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
>>> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>>>
>>> Encrypted file extents now have the 'encryption' field set to an
>>> encryption type.  Let's print it.
>>>
>>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>>> Signed-off-by: Daniel Vacek <neelx@suse.com>
>>> ---
>>>    check/main.c               | 1 -
>>>    kernel-shared/print-tree.c | 2 ++
>>>    2 files changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/check/main.c b/check/main.c
>>> index dedb4db4..a32247b3 100644
>>> --- a/check/main.c
>>> +++ b/check/main.c
>>> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_root=
 *root,
>>>                        rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
>>>                if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC &&
>>>                    (btrfs_file_extent_compression(eb, fi) ||
>>> -                  btrfs_file_extent_encryption(eb, fi) ||
>>
>> May I ask why preallocated file extent would have encryption value set?
>>
>> My common sense says that encryption policy should only be set for
>> regular file extents.
>=20
> There's nothing wrong with pre-allocating encrypted files. Unlike
> compression, the exact size is known beforehand.

IN that case, does it mean even a hole will have encryption value set?

This looks weird. Is there any special reason for setting encryption=20
value for hole/preallocated range?

Can't we only set the encryption value only for regular,=20
non-preallocated extents?

Thanks,
Qu

>=20
> Simillar to NOCOW, the encrypted data will be stored with the next write=
.
>=20
> --nX
>=20
>> Thanks,
>> Qu
>>
>>>                     btrfs_file_extent_other_encoding(eb, fi)))
>>>                        rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
>>>                if (compression && rec->nodatasum)
>>> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
>>> index 0afa3696..159f0825 100644
>>> --- a/kernel-shared/print-tree.c
>>> +++ b/kernel-shared/print-tree.c
>>> @@ -471,6 +471,8 @@ static void print_file_extent_item(struct extent_b=
uffer *eb,
>>>        printf("\t\textent compression %hhu (%s)\n",
>>>                        btrfs_file_extent_compression(eb, fi),
>>>                        compress_str);
>>> +     printf("\t\textent encryption %hhu\n",
>>> +                     btrfs_file_extent_encryption(eb, fi));
>>>    }
>>>
>>>    /* Caller should ensure sizeof(*ret) >=3D 16("DATA|TREE_BLOCK") */
>>
>=20


