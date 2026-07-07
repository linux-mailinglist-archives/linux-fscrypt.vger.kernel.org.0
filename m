Return-Path: <linux-fscrypt+bounces-1750-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id pRw8LdyCTWq51QEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1750-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 08 Jul 2026 00:51:08 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B62772049E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 08 Jul 2026 00:51:08 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b="a/bLCKnP";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1750-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1750-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF52B3037F69
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Jul 2026 22:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FDFB3D567E;
	Tue,  7 Jul 2026 22:40:12 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7643831A55E
	for <linux-fscrypt@vger.kernel.org>; Tue,  7 Jul 2026 22:40:10 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783464012; cv=none; b=V+O6qRgQQdKfnPvssK9c9Gk1ZtYwnX732ac6aJRuiP5yHZIEZxV4KhbqvVnjRTHtvxc9xGLxHADiSS4TgOEKs/fsGQntnRm4j8TaIACPX15F7K4SkXuGUbsdwpyzdCIpkjkAY2d1Rct6G95+sN7GEwz1THjkhVY9Dy3nPFZ9BbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783464012; c=relaxed/simple;
	bh=0xcPQvcCX1wmZ95Zct1sk3TP/FDTF2kQ2zg19l7bLBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SXoRLyRrk9IAw7WfWiA3Al+g9ToHvQ5cExHlm++6KgE22GcGUd2NvXgqTjURLHFUvOTI6Fsf547U3szQIUYXSA/C4ESog994tSkuG5mYH85Byinv3x6jL1REQiLdNqEerYwQsgzWEuWcqOxdK0AQPOPAZ2qtlYk4ctsOElJNPE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a/bLCKnP; arc=none smtp.client-ip=209.85.221.48
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-474303f3c72so37795f8f.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 07 Jul 2026 15:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783464009; x=1784068809; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1JdlkSTFW3hGtg7yS699xZAR0G/OpizsoVpaIbzEm7A=;
        b=a/bLCKnPyysNXAXfyTZCLHOWpzQ0wGIN8AzJ5XVxbYHxuaFqjFS+9pEsso7wl6f8N3
         YtXeG4gvUdtk4QMMmee3lwVCEzGnfFzx3/RbRg8LhQxhVmhc0Lpf8YxERsQqqruEua+4
         eB/mFvhYincBxZgebArrdSATXTHa6LvjLO7VSJodREZrRzAId7vese2RFItXa5env3jC
         Q0mMVd8ZIsnNpUoUtDZBovwY/B415/7Swa5Sa6gRzYCsC5XPWwpXx4YeEdOIJSIqlfKJ
         H/Uq7DVPjEZreWlbTQjZwLwBYATsRlvDg2/5BVYkdGdgfeAxYbor9Y4ajReP1/OG8xoa
         i/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783464009; x=1784068809;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1JdlkSTFW3hGtg7yS699xZAR0G/OpizsoVpaIbzEm7A=;
        b=lU0yEzw58h9zW8cfsKP4N+jwBaaM5RpMsd5YT6myejius+WAraMEf6j9Z4QB+DZFhO
         z4qgdL/CVrsXD/sKbdAMeKAfzb0VnS/fivORzWsqzd5EwH8Mw2NQK83w6fMbIpLL24Xr
         nV4Tmv+clrkIwix6841ykYZEH84hk+v16iwCztYH1jyizGf8ZCocdjAsEtEAUO2oeQJU
         tn40ZStahPfJDgSnSRM3fokf/tyQ0ZNydNu7H4NfW/eiuiabUxHb2VDcVq8T4q8tT//m
         hSU9qKTajIyF/tn2a2Ird/s4d3SnBMMCgqW43uRjIojdik2CZnpPDEMMi6uXRta+bloO
         k+vw==
X-Gm-Message-State: AOJu0Yw243IU9rA49O1Bfl5r0+8mEEvmxrv+KH5TE5l05qSJXSbjAIYf
	rbS/J/pABtHs2oS5eS9ZTpr4MDKU8NXDrbR9UBSCMcXb32JQ8XlQPj2swDf2rYXXDS2B6EGJo/R
	konmqCBU=
X-Gm-Gg: AfdE7clvPVcRo5A1IoP1H1oCgxxgvYqqMHFhNmBrKsNdQ9ghUXhUg6dRyV/vvqZbpUT
	yd4/9CW4rmWIhwwtFgYHDrAMYLyybP3cR7z6KJQnjfZQTlngapLQEwowH1H9at1gIhRSDpRQn0G
	Y/TornZDBOMiDA27SAtt3sA71DrtJnJtcUmu/5YU2aEpJ6yeAoEAb7HSc2y7AasoJ341Z5xDdTW
	iEWBFW++JEB016WuG22aqTZfIL+u023QsuwfFoJpByUskGM5Ae+sZYVTW5xLQWPMdpAxkbiITYz
	yZJ67mVhA4RYn8TBxHyOfAu+dz8WrSDKdukCVB0Iu+x3g4UtB8jqz9WC85WdYygLVVaMX52PAvs
	9v0+rYFhsTcGRez8QmR3wswTX4M3D4iwzhKVmt2fiI4WTU9NwddNFnfwgcj0gg4yci27Zo3cUCs
	+NprkmgQ==
X-Received: by 2002:a05:600c:8a1b:20b0:493:bb23:152a with SMTP id 5b1f17b1804b1-493df09c27dmr64134985e9.34.1783464008847;
        Tue, 07 Jul 2026 15:40:08 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1e0c4sm18475305ad.49.2026.07.07.15.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 15:40:07 -0700 (PDT)
Message-ID: <8ef7b7fa-b3ef-4a7b-b882-d851e9c9eb09@suse.com>
Date: Wed, 8 Jul 2026 08:10:01 +0930
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] btrfs-progs: print encryptin type field of file
 extents
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>
Cc: linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260707142736.2330146-1-neelx@suse.com>
 <20260707142736.2330146-5-neelx@suse.com>
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
In-Reply-To: <20260707142736.2330146-5-neelx@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1750-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,suse.com:from_mime,suse.com:email,suse.com:mid,suse.com:dkim,dorminy.me:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0B62772049E



在 2026/7/7 23:57, Daniel Vacek 写道:
> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> 
> Encrypted file extents now have the 'encryption' field set to an
> encryption type.  Let's print it.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
>   check/main.c               | 1 -
>   kernel-shared/print-tree.c | 7 +++++--
>   2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 5e29e2c5..7f438302 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_root *root,
>   			rec->errors |= I_ERR_BAD_FILE_EXTENT;
>   		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC &&
>   		    (btrfs_file_extent_compression(eb, fi) ||
> -		     btrfs_file_extent_encryption(eb, fi) ||

I think this is a leaf-over change?

Thanks,
Qu

>   		     btrfs_file_extent_other_encoding(eb, fi)))
>   			rec->errors |= I_ERR_BAD_FILE_EXTENT;
>   		if (compression && rec->nodatasum)
> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
> index 0afa3696..2c0168b0 100644
> --- a/kernel-shared/print-tree.c
> +++ b/kernel-shared/print-tree.c
> @@ -445,11 +445,12 @@ static void print_file_extent_item(struct extent_buffer *eb,
>   			extent_type, file_extent_type_to_str(extent_type));
>   
>   	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
> -		printf("\t\tinline extent data size %u ram_bytes %llu compression %hhu (%s)\n",
> +		printf("\t\tinline extent data size %u ram_bytes %llu compression %hhu (%s) encryption %hhu\n",
>   				btrfs_file_extent_inline_item_len(eb, slot),
>   				btrfs_file_extent_ram_bytes(eb, fi),
>   				btrfs_file_extent_compression(eb, fi),
> -				compress_str);
> +				compress_str,
> +				btrfs_file_extent_encryption(eb, fi));
>   		return;
>   	}
>   	if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
> @@ -471,6 +472,8 @@ static void print_file_extent_item(struct extent_buffer *eb,
>   	printf("\t\textent compression %hhu (%s)\n",
>   			btrfs_file_extent_compression(eb, fi),
>   			compress_str);
> +	printf("\t\textent encryption %hhu\n",
> +			btrfs_file_extent_encryption(eb, fi));
>   }
>   
>   /* Caller should ensure sizeof(*ret) >= 16("DATA|TREE_BLOCK") */


