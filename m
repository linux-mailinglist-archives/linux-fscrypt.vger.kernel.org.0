Return-Path: <linux-fscrypt+bounces-1710-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 0Y/HGbELRmoUIQsAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1710-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 08:56:49 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DC1B96F3F46
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 08:56:48 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b=hpRWV1lX;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1710-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1710-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=gmx.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E0E2530292C9
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jul 2026 06:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5280538736F;
	Thu,  2 Jul 2026 06:56:47 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39EF38E5C5;
	Thu,  2 Jul 2026 06:56:44 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782975407; cv=none; b=azvANKhTqUKh0AmxCseimfHMG6tCUKIE//NW8YA4X70ZMGplT6IRPUwbDf8J27hoSNDtV1QWhIYRSO6lEXX2ISn2X2VqgMROBf1RSROkA40hWkuiolhTF9v/8SDllNBVrnqPkZKdn/PTdD0gNNwxSUbJzfhy/LFk6XcHagJF71c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782975407; c=relaxed/simple;
	bh=eYON4rmrlGc+XbkVbSsqpvzFeWACL4KVvS6Q+wUJEhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hcl7OT/B/Zq26MsG3AO/zOaTQGOsOB50S249EQxiS/Gw9RQActsYnwYbozW5NSrLnNOP9SVONtqK5NrB3PBBwMmaJM8FQ8K+7hE1KBxp+jai8T8fhhqyt7ncRX3By+3pAsoyceBN55gUSoYipAx5XpSDb+D/h0RD6lD7Jdsjt58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=hpRWV1lX; arc=none smtp.client-ip=212.227.17.21
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782975397; x=1783580197; i=quwenruo.btrfs@gmx.com;
	bh=T/Jvo2P0MrfUWOzaLg1rK3sZyk1nX5OSc0T3LmM+gNo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hpRWV1lXhVF5nZWUjKn9dbPc/84N/wqRsWm1P1imk0NA/exxsyha/Xs0PMOUO8or
	 hdq9g3ELWFSbiHRDhmTKAj8jNZtErH8T58yNhHuPWK+rup5/oG5n7BN1ydGPOvnFL
	 BVkG5XAn4EZZuwz46OpPLt7pcnsDQ3pFkIkwZu4m41BweefSd3Agvk9X5aKLl7z6H
	 HANxlP+C+L8I0V3AfomCq+ARW+iOL7KXrmZIx7JOyzuzMOmoLBDBewNUf3C2XGKks
	 URFvKSpPnUqUR8tXTKsetCjWUG0V4vDjyYe7MuGGRLT8TfLAJcfTFEU+jxvSQ2mmm
	 mpPrXlOLRyPrddD2mg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MtfJX-1wxnvn3mwR-00sAhN; Thu, 02
 Jul 2026 08:56:37 +0200
Message-ID: <628d90f5-f2d5-4b67-929f-ad7835e7fd89@gmx.com>
Date: Thu, 2 Jul 2026 16:26:31 +0930
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
 <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com>
 <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
 <5a8f027b-420e-41be-b852-a27fb084c32f@suse.com>
 <CAPjX3Ff_iG5B=uJp9uJZPVGGbAhp9fErVkHxdOLr5EZNGPMZXg@mail.gmail.com>
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
In-Reply-To: <CAPjX3Ff_iG5B=uJp9uJZPVGGbAhp9fErVkHxdOLr5EZNGPMZXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MQ8jCQu6CANOIoW2KKlUp3OSZO2ZDO1faSqg83kM1d5T4dAFyc3
 uN3eI3xlC42vokWdPphdeM9Y+yvc415SROBB8OUXKsSL3bYBz6Zlkblzb7dzn06AIhCdlaB
 D3UvCXK9e8CaBbOah+oGTYHt8G0oXhNst1qGY6KOLQpOb9M318AR3grDdtZv8b6p3/KL+pu
 Ip5JTX2U4nPTzIQXKgM5w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5AeqD9rv8nI=;XRSTjnCT5fgTLITdC7lwZ3xL22j
 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
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmx.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmx.com:s=s31663417];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-1710-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp,gmx.com:dkim,gmx.com:email,gmx.com:mid,gmx.com:from_mime,suse.com:email,dorminy.me:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DC1B96F3F46



=E5=9C=A8 2026/7/2 16:18, Daniel Vacek =E5=86=99=E9=81=93:
> On Thu, 2 Jul 2026 at 08:19, Qu Wenruo <wqu@suse.com> wrote:
>> =E5=9C=A8 2026/7/2 15:10, Daniel Vacek =E5=86=99=E9=81=93:
>>> On Thu, 2 Jul 2026 at 00:26, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>> =E5=9C=A8 2026/7/2 01:29, Daniel Vacek =E5=86=99=E9=81=93:
>>>>> On Fri, 26 Jun 2026 at 01:50, Qu Wenruo <wqu@suse.com> wrote:
>>>>>> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
>>>>>>> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>>>>>>>
>>>>>>> Encrypted file extents now have the 'encryption' field set to an
>>>>>>> encryption type.  Let's print it.
>>>>>>>
>>>>>>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>>>>>>> Signed-off-by: Daniel Vacek <neelx@suse.com>
>>>>>>> ---
>>>>>>>      check/main.c               | 1 -
>>>>>>>      kernel-shared/print-tree.c | 2 ++
>>>>>>>      2 files changed, 2 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/check/main.c b/check/main.c
>>>>>>> index dedb4db4..a32247b3 100644
>>>>>>> --- a/check/main.c
>>>>>>> +++ b/check/main.c
>>>>>>> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_=
root *root,
>>>>>>>                          rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
>>>>>>>                  if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC=
 &&
>>>>>>>                      (btrfs_file_extent_compression(eb, fi) ||
>>>>>>> -                  btrfs_file_extent_encryption(eb, fi) ||
>>>>>>
>>>>>> May I ask why preallocated file extent would have encryption value =
set?
>>>>>>
>>>>>> My common sense says that encryption policy should only be set for
>>>>>> regular file extents.
>>>>>
>>>>> There's nothing wrong with pre-allocating encrypted files. Unlike
>>>>> compression, the exact size is known beforehand.
>>>>
>>>> IN that case, does it mean even a hole will have encryption value set=
?
>>>>
>>>> This looks weird. Is there any special reason for setting encryption
>>>> value for hole/preallocated range?
>>>>
>>>> Can't we only set the encryption value only for regular,
>>>> non-preallocated extents?
>>>
>>> What's so weird about it? Since the inode is encrypted, related parts =
are too.
>>
>> Inodes can have PREALLOC flags, but the file extents are not all
>> preallocated.
>>
>> Inode can also have COMPRESS flag, but the file extents are not all
>> compressed either.
>>
>> Inode flags are independent from file extent flags from the very beginn=
ing.
>=20
> Encryption is not compression. I'm not sure it makes sense to compare
> them this way.
> We don't want to have some parts of a file encrypted and some plain.
> A file is either fully encrypted or not at all.

Then you're only cheating yourself.

A simple tree dump can always show which range is hole and which is=20
preallocated.

> In that sense we are being a bit more strict than what you may be used t=
o. See?
>=20
> --nX
>=20
>>>
>>> --nX
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> Simillar to NOCOW, the encrypted data will be stored with the next w=
rite.
>>>>>
>>>>> --nX
>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>>                       btrfs_file_extent_other_encoding(eb, fi)))
>>>>>>>                          rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
>>>>>>>                  if (compression && rec->nodatasum)
>>>>>>> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree=
.c
>>>>>>> index 0afa3696..159f0825 100644
>>>>>>> --- a/kernel-shared/print-tree.c
>>>>>>> +++ b/kernel-shared/print-tree.c
>>>>>>> @@ -471,6 +471,8 @@ static void print_file_extent_item(struct exte=
nt_buffer *eb,
>>>>>>>          printf("\t\textent compression %hhu (%s)\n",
>>>>>>>                          btrfs_file_extent_compression(eb, fi),
>>>>>>>                          compress_str);
>>>>>>> +     printf("\t\textent encryption %hhu\n",
>>>>>>> +                     btrfs_file_extent_encryption(eb, fi));
>>>>>>>      }
>>>>>>>
>>>>>>>      /* Caller should ensure sizeof(*ret) >=3D 16("DATA|TREE_BLOCK=
") */
>>>>>>
>>>>>
>>>>
>>
>=20


