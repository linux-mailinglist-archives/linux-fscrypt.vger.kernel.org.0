Return-Path: <linux-fscrypt+bounces-1753-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id FtoNIFbZTWpT/AEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1753-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 08 Jul 2026 07:00:06 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D05EF721A97
	for <lists+linux-fscrypt@lfdr.de>; Wed, 08 Jul 2026 07:00:05 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=bsHL+dcp;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1753-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1753-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A6C5B30207D1
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jul 2026 05:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 074C63B3884;
	Wed,  8 Jul 2026 05:00:04 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCC818B0A
	for <linux-fscrypt@vger.kernel.org>; Wed,  8 Jul 2026 05:00:01 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783486803; cv=none; b=tD3f6nSo3R4IMaEGhDyrxsEfMvpjKnClMeLhDWBOEmUFWfM1WY8ikJ9v20JcIMhqYxdRBj5TIeIwWTawHVdB7S+VfN4nkkrMNxsPp0GuQMSFgkWRT83lhwnQYnK8FsIad9AADAsSjjOKtHLjKqidmwoIerBOsrDK5rj/kmQ9JoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783486803; c=relaxed/simple;
	bh=aiRvngYu0wQzvd5NIwJdWcVTbb1MK6lqsUlROSLAJGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cd76hPgu6yNGLbJICHvHBUYByuUCdHh0CWqu+adfyyzR/7xvoQtkIs24W9nLfE9+unyJx1a+llo/OVmW3JRt7m4HuIkG3sX1A8Mq7LZ5KTDTVtQa7YT3QPjYabmCzcNN+5q5G+Hxz7pYLKib+zcozrIcg1891uHkVotmnCDvB18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bsHL+dcp; arc=none smtp.client-ip=209.85.221.43
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-471eeac43bfso232136f8f.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 07 Jul 2026 22:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783486800; x=1784091600; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ons391aOclsitBsK8iiaHFgob/0VEgooq6ORYm8rMog=;
        b=bsHL+dcpVC+DhlIDqfOxoFms/ikVSTkvOeA8W1lnm8iSWBj8qW59H2gh+E4v3JmAGE
         yr73w+R63puhzFLHP8tdfcMMrzKZ7iOxDai4vcC4q64d6JD49+gELl+d7vRVXAfmx5hQ
         x/4/jVMLo48K5xM9PYR7qcJoNqUE3G7GclFAen1gXjiMzPPDk2ak1T+QHIFHezuooCCk
         aXZO9VUmBFJaU/C99gf1fcC8mzP39d+TDNs2SZGdh7S2mK4m7XzRJW4gtyY5zfdXr44g
         ZQ4dgYUs5uW8m/NHQNWpy4fhfeZeohIhrhQQk9usvkA9QtMLs2xYCG8SXBJgHqEJUmEP
         HpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783486800; x=1784091600;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ons391aOclsitBsK8iiaHFgob/0VEgooq6ORYm8rMog=;
        b=V6ne9Ym9KHA2GdbzBkP7qNwFFHkGocFNBGSA60PuB35OE2YmR8BoH14UpSyBJPl/Q0
         /V0KtGzKiHmR5datR2s3EVGeATs2GZ3NdTS6G15Rfw16/dTgdcgBI2YFdyOQ1OOfrgdW
         JsBuxux5QWZQuZWs5+BikwGJGduHjxK6uAdyU3FRla42/z3f+F7m7ecB6pKtUwEoL4LL
         QdMOU81oijWNE0LCcQ4mBmgwkI6YlR875baPZt3893ZDdPEZOAAq/QxjWWIJZCNeqGQR
         gbipgVHxRxPLufW7YIf26NuyJCNkxZW4wuE9WbdvtQx/POgvoyhC6kXagPf0IdbpKae+
         O7fg==
X-Gm-Message-State: AOJu0YwSERU6NY3lESWAll+1STtuIl0ynehCWFt9J2wsjExasU2XkSWY
	Fz9ZnNFb/P7M9qHJGREma7/uv2jAML26J3jI7x+K8z2RZi595MZXPZRVvDYiGd66HjQ=
X-Gm-Gg: AfdE7ckp1WRhNCPfvQXHkJDweHW5ZHm9hhWs5mgEAad3PXYLBLT1B4XjqrI+ddvF/7y
	FG4YIYJ6FwOJd2qdI29hbQ9cN+runKjUR4/XBOCJJLp+mLnWBvbF/JU9jF5Psx8wADSSeLOB2KI
	ZTheOWg5IYebhvL9i1gTEF1LSLYJG5d36a0woPd2A8OiysNjD8zQAtDduXxjglTmog5igvniPNv
	ZjkdalMBCiVDPvgLxjxY2MQPzWgr3PlMq2zQEXfh+WpFPQhmedqrDBZBikF2TurulD060DWiZUY
	+Nl7IdtEbC0kusuDoW7u2haNHMfsKMhbIE/btfuZimKXfm7CqO/Ub0F6BcW/x7cJ06bIhkhAg26
	7Bg9uf8/NhgRFQCWVLwwKtK1C6EoS3S9wIkBDfm0VvQfgjSPAcifouf82skrXhrBUo3QE1EiN1u
	6PIRJJ9A==
X-Received: by 2002:a05:600c:8889:20b0:493:bdf1:fcde with SMTP id 5b1f17b1804b1-493e68c6e44mr4259475e9.19.1783486800335;
        Tue, 07 Jul 2026 22:00:00 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b658a99afsm15687745c88.0.2026.07.07.21.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 21:59:59 -0700 (PDT)
Message-ID: <b7861828-64d1-4fef-b094-86d1c87e32c6@suse.com>
Date: Wed, 8 Jul 2026 14:29:55 +0930
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] btrfs-progs: fscrypt updates
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>
Cc: linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260707142736.2330146-1-neelx@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20260707142736.2330146-1-neelx@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1753-lists,linux-fscrypt=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:neelx@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[wqu@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wqu@suse.com,linux-fscrypt@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,suse.com:from_mime,suse.com:email,suse.com:mid,suse.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D05EF721A97



在 2026/7/7 23:57, Daniel Vacek 写道:
> This series is a rebase of an older set of fscrypt related changes from
> Sweet Tea Dorminy and Josef Bacik found here:
> https://github.com/josefbacik/btrfs-progs/tree/fscrypt
> 
> It passed all my tests. Hopefully nothing blows. Enjoy testing.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Although I still think some corner cases may change in the future, but 
considering it's already hidden behind experimental, we should have 
plenty time before pushing it to end users.

Will push it to devel after a full selftest.

Thanks,
Qu


> 
> v3:
>   * dropped first patch and improved inline extent length checking
>   * correctly squashed the context key definitions into "btrfs-progs: add
>     inode encryption contexts"
>   * inline extents also show the encryption field now in tree dump
> 
> v2: https://lore.kernel.org/linux-btrfs/20260624165144.556908-1-neelx@suse.com/
>   * works with v7 of the kernel fscrypt series
>   * the on-disk format changed and parts of the series had to be reworked
>     - particularly the encryption context is now stored as dedicated item
>       and not glued onto extent data item
>   * also parses the ENCRYPT inode item flag
> 
> Daniel Vacek (1):
>    btrfs-progs: recognize ENCRYPT inode item flag
> 
> Sweet Tea Dorminy (6):
>    btrfs-progs: add new FEATURE_INCOMPAT_ENCRYPT flag
>    btrfs-progs: start tracking extent encryption context info
>    btrfs-progs: add inode encryption contexts
>    btrfs-progs: print encryptin type field of file extents
>    btrfs-progs: handle fscrypt context items
>    btrfs-progs: check: update inline extent length checking
> 
>   check/main.c                    | 34 ++++++++++++++++++---------------
>   kernel-shared/ctree.h           |  1 +
>   kernel-shared/print-tree.c      | 28 +++++++++++++++++++++++++--
>   kernel-shared/tree-checker.c    | 17 ++++++++++-------
>   kernel-shared/uapi/btrfs.h      |  1 +
>   kernel-shared/uapi/btrfs_tree.h | 11 +++++++++++
>   libbtrfsutil/btrfs.h            |  1 +
>   7 files changed, 69 insertions(+), 24 deletions(-)
> 


