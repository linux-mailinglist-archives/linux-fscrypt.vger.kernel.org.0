Return-Path: <linux-fscrypt+bounces-1712-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id pXg1JYkPRmqQIgsAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1712-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 09:13:13 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0352C6F40D7
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 09:13:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b="Xol/dzJ3";
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1712-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1712-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=gmx.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E164930684D9
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jul 2026 07:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A629539022B;
	Thu,  2 Jul 2026 07:11:31 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681E838F92A;
	Thu,  2 Jul 2026 07:11:28 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782976291; cv=none; b=LVbDqMhIV5zEfhPSpIbdSlmnHzU8fa3W1rZukZYEyfiQKLECqW6qZVG/487dm16jaT4uk7LjL8ya8znZUIvQ3Igb1OsH8jJJi8j1eVDJ+RZSpVg6hQysaRh8Sa6R8FYyhB6OSGIYh3zMwDSRIl3MqmJEFB+FE3Kxxu6f5ujM22Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782976291; c=relaxed/simple;
	bh=Vlx67pWH1VIYl7ru93DPEOR74/3bxUInKqrrZd6t2Hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ScT0kGC7vx3rUhaMoLaPLIrZzd1IGk8vFpjil4O1nIjEZAUAHFqouc9cBrnE0V5vY0xxBrfLS66u4mZTZhuQ74DrRDZmVS69p7MYXpC+jasYIO8lrHC2HazpgGGcsqoRKhNRjf9jraFFD8qOgdcbPlsN5UHJ52g+SxMaQ+GztMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Xol/dzJ3; arc=none smtp.client-ip=212.227.17.20
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782976284; x=1783581084; i=quwenruo.btrfs@gmx.com;
	bh=Vlx67pWH1VIYl7ru93DPEOR74/3bxUInKqrrZd6t2Hc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Xol/dzJ3RVZE1KydFwKf9VIpxe6ZwQuXEVljKfYe11SN6YLUk3JJYIu9SJE6FbA1
	 rEA17mKtY3UeIzdwjINVsgNZ6e7w6SDK65yxGLWX17zx1HLElr9BMbG7cL/47vw9q
	 t8xBi1uqneKe/72pSCrlloga3HmVxdymFPjsse82uRaU1XAKQjOwxIY2/lSNNLpQG
	 LeUFWlvHeHf9IxJL1a1nqnrAfx5HJnnsM/Dus1mCeDuqWtJ3ffXftZbIDmOpi+wTV
	 Vwtgv3LD4IaUWgFIMxJSomhi2Zf80y8thkjI9dNNQOSvHGyCVLJ7vQnq3eozI9XuM
	 h9UpzUuTsSgO2a997g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mo6ux-1xTgYK36FP-00qj3x; Thu, 02
 Jul 2026 09:11:24 +0200
Message-ID: <1cb04346-a607-4253-add8-614de783a0f2@gmx.com>
Date: Thu, 2 Jul 2026 16:41:18 +0930
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file
 extents
To: Daniel Vacek <neelx@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
 linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260624165144.556908-1-neelx@suse.com>
 <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com>
 <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
 <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com>
 <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
 <5a8f027b-420e-41be-b852-a27fb084c32f@suse.com>
 <CAPjX3Ff_iG5B=uJp9uJZPVGGbAhp9fErVkHxdOLr5EZNGPMZXg@mail.gmail.com>
 <628d90f5-f2d5-4b67-929f-ad7835e7fd89@gmx.com>
 <CAPjX3FdzjXTR7q8RjOUdu_8h6V5wkBjsUKM+=_9VV=rcg+3FdA@mail.gmail.com>
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
In-Reply-To: <CAPjX3FdzjXTR7q8RjOUdu_8h6V5wkBjsUKM+=_9VV=rcg+3FdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pGWEg8Hd4P2bfvQyU6C42KfWy8PVusoHavVVke2eSjc8Qg3gPZX
 8V2YvvSTk+bnskGzHMLzD6qSiMitlKgf6KQdRNSZhgy+Q0Lg4+FWVcRUAbaaaoIs8Ho7ZdV
 2VyWrt671qHVyIB3j/pIDbcz4lOk4iBj+UMRgsp5QSX97paEaZmFDakywHT8GtxK6mhggvR
 mwuhfwBkDbi7zsFVeDOJA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:aeqwy6JR5Z0=;t8zqr8VG0zJkDD8O8UTHi1WQnEZ
 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
 sGFXKg==
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
	TAGGED_FROM(0.00)[bounces-1712-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:neelx@suse.com,m:wqu@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,gmx.com:dkim,gmx.com:mid,gmx.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0352C6F40D7



=E5=9C=A8 2026/7/2 16:35, Daniel Vacek =E5=86=99=E9=81=93:
[...]
>>
>> A simple tree dump can always show which range is hole and which is
>> preallocated.
>=20
> Yeah, that's true. I'm curious how other FSes handle this. Let me see.
> Or do you know from the top of your head?

Sorry, not familiar with other fscrypt implementation at all.
You may want to try to experiment on ext4 to see how it's implemented.

I guess they do nothing special and just expose hole/prealloc info.

As the other path would be always filling hole with zero filled regular=20
extents (before encryption), and disable preallocation completely.
That looks over-killed and may take a lot of extra space.

