Return-Path: <linux-fscrypt+bounces-1679-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 9FJhEdG8PWo46AgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1679-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Jun 2026 01:42:09 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C0FB46C926C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Jun 2026 01:42:08 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=CLMekx8v;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1679-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1679-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0322C3072579
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Jun 2026 23:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202EA373BE7;
	Thu, 25 Jun 2026 23:41:08 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75837305698
	for <linux-fscrypt@vger.kernel.org>; Thu, 25 Jun 2026 23:41:05 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782430868; cv=none; b=iTC2K1QJ3lFZqzbqoa07mh3747U6KXwykEDo7T1iutqkoLOGNLkuGKaNs4DataWjkk9QywJN99FEh5t9JkUqyc/1aCE8cqDJn89Qq1Mb930uR32C5Y8opd4O7kw30cpH/R9vMMAsGxgTgvf8/xh3u/h+MBE3DZMzxAgwNROf5Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782430868; c=relaxed/simple;
	bh=XfbZbU4hnyAc5+KdGNxe2ruPtG8EqMmSWSCqT62Y0S8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l2BnB5SANrVjiTgsD69TF+Qii2WBRtY2F1xOGi6LI+Ql2LZGIDLr5S/JUSlYKi8ZHnW2q87sjqIcCY5E0s8SzCHBDOmKkhJGoytofTItVIL8aE7a3q6Jumi3wa87VWTKIAXUmXEIr2420e56QIPjOlM29wWTNAhfM13oQ/Dc1cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CLMekx8v; arc=none smtp.client-ip=209.85.128.43
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so2772365e9.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 25 Jun 2026 16:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782430864; x=1783035664; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JzRXNZAIz+cFbURiea9LciZT93qfxVdXq7/EPTmkpVo=;
        b=CLMekx8vQrjs5DHVdatqcoa6gVCtR8TtNy4butuSdeBLnrqn0Fi9/d+dC+AYQUi+Xz
         5f1gTT9pLZEkTGuQD+KeYJbpxphhEDaxZPN/04Ayk3M/Zrd99M/p7DdDlMgBwCmIq+VF
         qEgM5P8FkF4Kh72V6AGTyaATSSzTebNKrVPU8l43Qtn7un0/+XCeYnCHdT/e3/UHbqOP
         oR+zT8iSnDY/dXNtGCexJZdRm0vQIhVBjROEEFBR2fZPonIzEBJAZx/OFZRE7GhraPXa
         4oXmpSq7tGEoqQnCiYQqtHEJrhCxcvWMN7BQNgGZJ6Q+lUjxAdGG1y8l9ySLrTWVXMUa
         cHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782430864; x=1783035664;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzRXNZAIz+cFbURiea9LciZT93qfxVdXq7/EPTmkpVo=;
        b=NMllOZXmn6T3l+uGnE9buzwiioRl9x60nb/MDZYcApbp+hhlzDLryFeW1Y1FVS6P3w
         9L8rCImQ99/X7JnQNhk7QcM5Bi8PEwzL/tbs9WqJkIUHFjYbUIhB1dKq+zTnhrQzTu07
         VYc5QTMqyIZoiRiM+luae395s0CTWxEWn9yBULpS8h+iDMAEBmtwXWeMpWxAwckbN+kD
         idwe1W06oqUCuHSI/JNnDQiXIjP6acQr27Z6k/d3pPE++Ge5qwaTu3OvIN+pSscp8MgQ
         b5CR0Gm1571JYaxlLldzAFuCZeLiYBdfipRGXJpH2LMKAaolKVJTD1i6V+Zekp2R4UtE
         oEqg==
X-Gm-Message-State: AOJu0Yzu50YHHwUy23b9jq/NZwjcy7J+ama+xeryGanwxjKhw2JUWzr/
	nLKppBM9xBlTYFHcU/Y7m6hIU8UNi520wz8pjnP57yG1Tg0S02TgPX98IfTCBM7+pRw=
X-Gm-Gg: AfdE7cmbgKIfwqucAh3TVOE49LCiv1gEOZ5mbQhtOi9MdqjN8Ob9dQJt473PiiDzGL2
	QW9epdNp3BV3LsiNM6CBsj6c5FFmm+n/LyNMYUae+rUhKCbYjnceaNQbGSFNoNaYWEev+AipCtd
	JSeKs+/tQ5w84qo1iv39ZHS5Xp+7lKK4TfBBjn7YC54w5X+pm1jPfTmMh6c+HiRjixA3e3mVU5g
	E0/bpaeO0PEgEpFFl3ZS4UwHOTdZ27R90QGRe0YjGAoykQxC8scFgInmRdegw0Y2ZK3wQVp82Kz
	jwH3XNfpTOSOX7c91XO/Zc+s13saiiCrzPSbZbZyF0j2mKhqQHRdHv5M+vHkFRpFPhUKYuHqYia
	mSuMOq49M1JB4kMqfD3y4eOrUTetgg7qn7QYqZaZlSzC6G55Ww+a8ifEgy0N4JQTsQNFpqaOxOv
	fCVfWQCzRgT0jIX0KnRpcOSW2kJ+ma9wKjoalU9Qxn
X-Received: by 2002:a05:600c:a12:b0:492:5e22:ef18 with SMTP id 5b1f17b1804b1-4926685a81emr70142705e9.9.1782430863872;
        Thu, 25 Jun 2026 16:41:03 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d912197bsm18914891c88.15.2026.06.25.16.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 16:41:02 -0700 (PDT)
Message-ID: <7d4ab06d-6cd0-4eb6-a355-d2b51d132713@suse.com>
Date: Fri, 26 Jun 2026 09:10:57 +0930
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] btrfs-progs: check: fix max inline extent size
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>
Cc: linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20260624165144.556908-1-neelx@suse.com>
 <20260624165144.556908-2-neelx@suse.com>
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
In-Reply-To: <20260624165144.556908-2-neelx@suse.com>
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
	TAGGED_FROM(0.00)[bounces-1679-lists,linux-fscrypt=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:neelx@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:josef@toxicpanda.com,s:lists@lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,suse.com:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,toxicpanda.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C0FB46C926C



在 2026/6/25 02:21, Daniel Vacek 写道:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Fscrypt will use our entire inline extent range for symlinks, which
> uncovered a bug in btrfs check where we set the maximum inline extent
> size to
> 
> min(sectorsize - 1, BTRFS_MAX_INLINE_DATA_SIZE)
> 
> which isn't correct, we have always allowed sectorsize sized inline
> extents, so fix check to use the correct maximum inline extent size.

No, we only allow sector sized inline extent when it is compressed.
The de-compressed size can be sector sized, but the compressed size 
still can not reach sector size.

So this doesn't seems correct to me.

> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
>   check/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 5e29e2c5..dedb4db4 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1720,7 +1720,7 @@ static int process_file_extent(struct btrfs_root *root,
>   	u64 disk_bytenr = 0;
>   	u64 extent_offset = 0;
>   	u64 mask = gfs_info->sectorsize - 1;
> -	u32 max_inline_size = min_t(u32, mask,
> +	u32 max_inline_size = min_t(u32, gfs_info->sectorsize,
>   				BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
>   	u8 compression;
>   	int extent_type;


