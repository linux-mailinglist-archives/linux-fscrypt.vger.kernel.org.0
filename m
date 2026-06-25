Return-Path: <linux-fscrypt+bounces-1680-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id o3g2N9i+PWp+6AgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1680-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Jun 2026 01:50:48 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7146C92D9
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Jun 2026 01:50:48 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=Qu8jnSCs;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1680-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1680-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB663301D33E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Jun 2026 23:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9917B3164AA;
	Thu, 25 Jun 2026 23:50:46 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341CA2459C5
	for <linux-fscrypt@vger.kernel.org>; Thu, 25 Jun 2026 23:50:45 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782431446; cv=none; b=MxNRs2vq9E0qQwkheCsahuAUyNXtkNRPK2pQzD3uv3AP1Gg8GMSDHKxkTRji6QLH8rufbNEq21RqWro8zJzBvxMODFAvSExACqfmfzqAItsqDBUPNpkTymbRzpjqeOcJrOXz9AEkmKOnP2mdxIYvIx6/l8cfeziR1YGlOYVv1Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782431446; c=relaxed/simple;
	bh=nT5ippKbARbEmf7+nZfwlljdT4pcoLoJ6SYFvIBYTzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AszFyI6NnBIudBLrgniaoiC38UQF+hvwQtXluZTUjX6TVsy5cv+Elt1dQUxEv4vwAVpkpHth5YwpnyXvDVWaeZohnmbEOLOgbbHOQ2AnH/igDG0AKEFmLTRSGDNiEOmGSfWBC/r25fhk6KhCPfvVS94XW8ZTSYHvDBknMju76y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qu8jnSCs; arc=none smtp.client-ip=209.85.128.43
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490ac357c55so3302995e9.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 25 Jun 2026 16:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782431444; x=1783036244; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E0PvYjpYa6mb+iHjFo6oq0Zkj+l2qZIqxdP1OVCfZgI=;
        b=Qu8jnSCs3wIiiuHvZxqSNuzaSKg8c2yilSxV5Xp47woee+FjCYUISaD+1hNjR/vgZN
         m2H3UEDwEF0+H/ZjMKEAGj84D+3ERN82BeU1wR8/SWzYrGs4BXGGU3mMXQJ8TQ6z2746
         gV7Hpzkb7HpezLk2NKJ0Y+bYpw8qTakkOvcMHTQ8fM5ekKitgVrvJVALGfxqfNatKpbH
         Acy9kUxZtRSSyca99SOKZl5xn/5KU3w8AniRbvKCGTS0UgavSEUvPLLbTFQigqaM3MOW
         FrdvKaLM6k/W/PZUpyEOBnSXId9T6j6NXZhLDHwaostE011Y01vG+0ZowDnUmLx477dx
         cESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782431444; x=1783036244;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E0PvYjpYa6mb+iHjFo6oq0Zkj+l2qZIqxdP1OVCfZgI=;
        b=jn/bik/fPGmw8wimsVqXTrZlne6M2DorkLOdBpvVappzE5ZfIXdUwe/EHrphaQU9B4
         bpjEZP4mcR1WSwCofuyH+M8u0nb+gn7TG3xyZRw7y9ds0exifGi/OBwPhAGVf5OCaK6V
         ZDjeUmcQGYiLKWvo8YFWWJB7rAXphjwZSaJfJ2tYl5KHOIeiUjl9a6J741E7R4KRjRKe
         oivjNdlHgQBYpBFx1g8xG87bemqDzqEK9JXKmmNl6GzZf2hQQKO+EstKPm0FDIzPEH7F
         cvBKwsxo+wGVvnhAd+cQ8LsOPktOaC+Z1O4WFiCWykY14KiMC1zaUVakMIcbcYCmIX4f
         y5Ng==
X-Gm-Message-State: AOJu0YzhQEY/RlTK7jIPBEVjCKPEj9YWyNlT7+S9ofmYPKtcFNURA2Bl
	8qvxUMLan72K2jKHaqRCpDBt4SojAH6l0+wHfLtWY5CGOrBULWX9l1+diUngW+bdoC77pbBBIP+
	rXaeXAuo=
X-Gm-Gg: AfdE7cke1ymvdXVPY82BX1TiWx+jSXyV4aofKRizYlWJ/lAioa5lTznnkXHXBibxRER
	wJGtA+Qm9S2kBSwF69lqvnYoMlD1GHcQak717XMVF+AAIxJ4bhJuavPnYlGDOmSqpGalxlbhrTH
	L9FynFCJ1T3pP31uEqSuFpsF/Yd1NXJA6YgeCTiNOTwoYdX56OuY0TMrGbpUZgMZTO6wf0tYv3E
	Lg8PFhbrFMY+yd8FkIW0po2d7RXXqs0CIGevNXsdzJMeyG8xV98zrHWfHkYtQLd5oAalq5R6txM
	KEfZaklBN0VXIKzBOlWF27JiL34SkSDz0XsXps+OTodLTF4VsdxKgKOFnPQ9l+Y3fe5E15Tnzrm
	IP6O/ZkVgj6HQRe7o6/TQVpahgVRrzm/H2F6FDCAn8rZcHBJXAXtLjrZ3gtUaWVWRzx/N4vhSgL
	jCWgcEStBWTBjsSCTzsTkPSem/k6OOomZ0RVHUm5gyphXg04L6OVM=
X-Received: by 2002:a05:600d:8489:10b0:490:9588:bdae with SMTP id 5b1f17b1804b1-49266899f97mr50891175e9.18.1782431443612;
        Thu, 25 Jun 2026 16:50:43 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d8f77602sm11019674c88.8.2026.06.25.16.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 16:50:42 -0700 (PDT)
Message-ID: <867a944d-3a26-4248-b0aa-f10247196502@suse.com>
Date: Fri, 26 Jun 2026 09:20:37 +0930
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file
 extents
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>
Cc: linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260624165144.556908-1-neelx@suse.com>
 <20260624165144.556908-6-neelx@suse.com>
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
In-Reply-To: <20260624165144.556908-6-neelx@suse.com>
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
	TAGGED_FROM(0.00)[bounces-1680-lists,linux-fscrypt=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:neelx@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[wqu@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,suse.com:from_mime,vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3E7146C92D9



在 2026/6/25 02:21, Daniel Vacek 写道:
> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> 
> Encrypted file extents now have the 'encryption' field set to an
> encryption type.  Let's print it.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
>   check/main.c               | 1 -
>   kernel-shared/print-tree.c | 2 ++
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/check/main.c b/check/main.c
> index dedb4db4..a32247b3 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_root *root,
>   			rec->errors |= I_ERR_BAD_FILE_EXTENT;
>   		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC &&
>   		    (btrfs_file_extent_compression(eb, fi) ||
> -		     btrfs_file_extent_encryption(eb, fi) ||

May I ask why preallocated file extent would have encryption value set?

My common sense says that encryption policy should only be set for 
regular file extents.

Thanks,
Qu

>   		     btrfs_file_extent_other_encoding(eb, fi)))
>   			rec->errors |= I_ERR_BAD_FILE_EXTENT;
>   		if (compression && rec->nodatasum)
> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
> index 0afa3696..159f0825 100644
> --- a/kernel-shared/print-tree.c
> +++ b/kernel-shared/print-tree.c
> @@ -471,6 +471,8 @@ static void print_file_extent_item(struct extent_buffer *eb,
>   	printf("\t\textent compression %hhu (%s)\n",
>   			btrfs_file_extent_compression(eb, fi),
>   			compress_str);
> +	printf("\t\textent encryption %hhu\n",
> +			btrfs_file_extent_encryption(eb, fi));
>   }
>   
>   /* Caller should ensure sizeof(*ret) >= 16("DATA|TREE_BLOCK") */


