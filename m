Return-Path: <linux-fscrypt+bounces-1704-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id eBhML0KTRWqmCQsAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1704-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 00:22:58 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 084926F20DE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 00:22:58 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b=FQ7Vj5fY;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1704-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1704-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=gmx.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6FEEF302C9E0
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Jul 2026 22:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3ED53BE155;
	Wed,  1 Jul 2026 22:22:55 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903EA3546FD;
	Wed,  1 Jul 2026 22:22:53 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782944575; cv=none; b=PF2lo4sNf7YoqB7Ws5zNSyVAXrpo6oHZQ/3lLL3gqCRN8vZzqL5z1U/OgNF4ezamSm90XObMqThMe3Wmk8VCssui6es5sx7eti/WYtUTnb9QnZYLmcxjh9TTbwv8Z3LT63jsscFMYii4QNkQCmUScu/rXOKwuG6mlOa5ShdJ9SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782944575; c=relaxed/simple;
	bh=MNOGfkTMgonyNqAj8nAGCIAavJ5ByckO9dC3aCwoPjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LuroSLD8PYBv8a926G+dOL9NkdJXiaFO6WybcnnBwanUOFnPObaKuqaGfqrbpWakTkM1/0xrzoid0iu5JgrEnEHGsChwhKysd865wbcVJt3Wkn5ceVv0qgRvs19rlW24KquUZyy2MgYtGBVbjaTnZ0kIt6iigFJPtkUhA2N2iF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=FQ7Vj5fY; arc=none smtp.client-ip=212.227.17.21
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782944571; x=1783549371; i=quwenruo.btrfs@gmx.com;
	bh=qE9t+w/zlVXzKpcAgJz+lx5jVLucUbw/9HaNwW8DFSQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=FQ7Vj5fYAM2o+4AVbo0lWq8U7CJSpboaokbbPaQNSJoiHTFOYW5Y5jviuG1oDScX
	 NB2eS7zmVRyrmB8lFByqQ9b+j//FSs7mfBYLXgWTe3huIhFCYiohiyH3xs91hitGZ
	 gcBXnEPhpHcTMtQuLrEUviufOG7RSGyy7APvZuaVzQWWRRPEoOBr6vcNxupW3WgA1
	 D7WPAnJRGk0eHt/Ay8+Ti2A+pjhHHinysMcZDVMKnNXTBSiWGk24DbPaRJsSjhdQ7
	 Ix+7o81CUIth7J2dtHZt03m5ZI/Jd6ol47bGSGI0qzqYrLD+2SAp1jyOQhXlFoAXA
	 9pUv4hdpVh1Ricd6Kw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MY6Cb-1wbZl142En-00XOgP; Thu, 02
 Jul 2026 00:22:51 +0200
Message-ID: <2da4b215-165f-4bd6-a2da-07c9012586b7@gmx.com>
Date: Thu, 2 Jul 2026 07:52:45 +0930
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] btrfs-progs: check: fix max inline extent size
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20260624165144.556908-1-neelx@suse.com>
 <20260624165144.556908-2-neelx@suse.com>
 <7d4ab06d-6cd0-4eb6-a355-d2b51d132713@suse.com>
 <CAPjX3FdE8REFdGT06k2RehJMfETgrxPzHZ3+V7FPaM_c1UwfcQ@mail.gmail.com>
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
In-Reply-To: <CAPjX3FdE8REFdGT06k2RehJMfETgrxPzHZ3+V7FPaM_c1UwfcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uc/mpct0u9sAvGnAZaidfmoJXpX0Z9CeTW5MLNm8eKLe6QDcnp5
 lQY2texzKaITOOF3lVN9vFuDQRRz9mxCphJaW27xb1RWXZ0yvC6qEqnarg1j8ZYFX4uszQ+
 LSB9+OwECyzsa2Jv2/vCTzqR20WhWzzQ0Ln95ZvmhkuSP9v6TdR4Cq9NOVwsEm+puPbumah
 k4DK9oa4dxbdpQDJ2Y1tQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:r1BXPU+WB/g=;NuW2YVfz/BgghJ8QpuNOwpuN07M
 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
 GJhwyUV/8=
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmx.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmx.com:s=s31663417];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-1704-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:neelx@suse.com,m:wqu@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:josef@toxicpanda.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[quwenruo.btrfs@gmx.com,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,suse.com:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,gmx.com:dkim,gmx.com:mid,gmx.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 084926F20DE



=E5=9C=A8 2026/7/2 01:17, Daniel Vacek =E5=86=99=E9=81=93:
> On Fri, 26 Jun 2026 at 01:41, Qu Wenruo <wqu@suse.com> wrote:
>> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
>>> From: Josef Bacik <josef@toxicpanda.com>
>>>
>>> Fscrypt will use our entire inline extent range for symlinks, which
>>> uncovered a bug in btrfs check where we set the maximum inline extent
>>> size to
>>>
>>> min(sectorsize - 1, BTRFS_MAX_INLINE_DATA_SIZE)
>>>
>>> which isn't correct, we have always allowed sectorsize sized inline
>>> extents, so fix check to use the correct maximum inline extent size.
>>
>> No, we only allow sector sized inline extent when it is compressed.
>> The de-compressed size can be sector sized, but the compressed size
>> still can not reach sector size.
>>
>> So this doesn't seems correct to me.
>=20
> With encryption it's the other way around. Even shorter data (symlink
> path) is always padded to multiple of the cipher block size (16 bytes
> with AES). Inlining a full sector size is perfectly valid. The dump
> from my test looks like this:
>=20
> ~~~
>      item 45 key (290 DIR_ITEM 3363472967) itemoff 11425 itemsize 62
>          location key (300 INODE_ITEM 0) type SYMLINK
>          transid 14 data_len 0 name_len 32
>          name: \243\365@;\312\321\240\367\377\234_{\245\vW\
> \035\rS\222ryN\323\031g\243\nt3\321+
>=20
>      item 58 key (290 DIR_INDEX 11) itemoff 10077 itemsize 62
>          location key (300 INODE_ITEM 0) type SYMLINK
>          transid 14 data_len 0 name_len 32
>          name: \243\365@;\312\321\240\367\377\234_{\245\vW\
> \035\rS\222ryN\323\031g\243\nt3\321+
>=20
>      item 86 key (300 INODE_ITEM 0) itemoff 7197 itemsize 160
>          generation 14 transid 14 size 4096 nbytes 4096
>          block group 0 mode 120777 links 1 uid 0 gid 0 rdev 0
>          sequence 1829 flags 0x1000(ENCRYPT)
>          atime 1782916271.8000000 (2026-07-01 16:31:11)
>          ctime 1782916271.8000000 (2026-07-01 16:31:11)
>          mtime 1782916271.8000000 (2026-07-01 16:31:11)
>          otime 1782916271.8000000 (2026-07-01 16:31:11)
>      item 87 key (300 INODE_REF 290) itemoff 7155 itemsize 42
>          index 11 namelen 32 name:
> \243\365@;\312\321\240\367\377\234_{\245\vW\
> \035\rS\222ryN\323\031g\243\nt3\321+
>      item 88 key (300 FSCRYPT_INODE_CTX 0) itemoff 7115 itemsize 40
>          value: 02010403000000005f0642cd89f66ce3ed930fe3ac518b7381bcd760=
0f7ae1f08195bda44461ed5d
>      item 89 key (300 EXTENT_DATA 0) itemoff 2998 itemsize 4117
>          generation 14 type 0 (inline)
>          inline extent data size 4096 ram_bytes 4096 compression 0 (none=
)
> ~~~
>=20
> Perhaps this would better be folded into patch 7?
>=20
> Or do you rather mean special-casing for compression (with the limits
> as you mentioned) and encryption (with full sector size allowed)?

In that case, I'd prefer the limit to be only loosen for encryption.

So we won't have unexpected non-encrypted inlined extents to reach the=20
limit.

BTW, it would be great if the progs dump-tree also prints encryption=20
value for the inlined extent.

Thanks,
Qu

>=20
> --nX
>=20
>>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>>> Signed-off-by: Daniel Vacek <neelx@suse.com>
>>> ---
>>>    check/main.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/check/main.c b/check/main.c
>>> index 5e29e2c5..dedb4db4 100644
>>> --- a/check/main.c
>>> +++ b/check/main.c
>>> @@ -1720,7 +1720,7 @@ static int process_file_extent(struct btrfs_root=
 *root,
>>>        u64 disk_bytenr =3D 0;
>>>        u64 extent_offset =3D 0;
>>>        u64 mask =3D gfs_info->sectorsize - 1;
>>> -     u32 max_inline_size =3D min_t(u32, mask,
>>> +     u32 max_inline_size =3D min_t(u32, gfs_info->sectorsize,
>>>                                BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
>>>        u8 compression;
>>>        int extent_type;
>>
>=20


