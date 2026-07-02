Return-Path: <linux-fscrypt+bounces-1708-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id CxKDDBkDRmpgHwsAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1708-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 08:20:09 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9760A6F3C09
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 08:20:08 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=RSAtWAnR;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1708-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1708-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8A1AB3030D56
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jul 2026 06:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3A8386C3E;
	Thu,  2 Jul 2026 06:20:01 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6D6385509
	for <linux-fscrypt@vger.kernel.org>; Thu,  2 Jul 2026 06:19:56 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782973201; cv=none; b=a5eZ9pzEH+MkmD5STamg7W9XPmUnawzzVD0VZazl4W1pu7Fk7W+B+MDljTbyf7tSACfCMpyrL7Xn63/KC5tu/G2ykFGYIei4Ct/F4ASzPmdzJBR9/UNn5s0pC6YlqM8LRqlczNvZgz/l8fWcljJVlmJPqwroGvmleU6nrFgt2yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782973201; c=relaxed/simple;
	bh=6asIS1kdosYI3hJjie83OOnmP5nV/dvRv9ZKme0rVCE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pDHiFApElfhTk/mjCrdOg1MolBgv6PzE5ppVheFbnNu7V4S/DixyO8Ap1D1LpL/oZpJzv6PtRc0QY+UhswQucHITj3V/XSdGfKWNXO6Cx0xLGEHFKSenMi4pLfQOUT46sBLD2M3pT0k8UVBF5XF2S6ndTFK0QX3LEsU3rKE19ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RSAtWAnR; arc=none smtp.client-ip=209.85.128.45
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493bb510ce4so10210125e9.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Jul 2026 23:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782973194; x=1783577994; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=N9Kk/Q1G7DG2Lf8I5bwAQLC8TgAuIECL4GsJF+QZ+WE=;
        b=RSAtWAnRIL2mziYfBBWnjHUjzp3lT1Sejys4chMzQ1Yi/HoCqvj/xbJ6H9R/Hm9brs
         SmTIemlHuOrbkT28KqCtN3Z6jOh+g6xAtK/lMEvVQUjIOOn4PUK2m5QWr/noEj9cOkN8
         waP8s1BPSROxmrWR6Truo35kYMejZoMhKX7SpqGdLkMDGRWgo/6rOhB+h/nkCjND6nI3
         9AxX1dK5p80pUIik0m3rK0drKh1so5jbzZgT+1GUvm/riv8HWRdAG16cWp+Qfy5Je0EL
         15LxiukjTLxNoBNSMj+G2OiR3YG1xVqde1S8aDI0xUwIdnnYWiJWLKbmcvoHzuiKv1Rt
         Uz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782973194; x=1783577994;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N9Kk/Q1G7DG2Lf8I5bwAQLC8TgAuIECL4GsJF+QZ+WE=;
        b=FFLDQB66EPMHmXpEz6xsaimN1NUtiyrrLzbc6Hgeewl9simwxJdr76jippnat+ErBQ
         OnMJHjrcQhHkOItmHXYZs5s56jiewht/rqTY+QU57iR60ZaEy0vItnpQUk4Q3tdn3WLw
         nZNGwsRRytZp4lraPa/GDw5MgYAzGxTT/yj5wOqV1aopV28FjgvqVPlW+eacdef0C1kD
         zgnWCKCNxJPOX0MgTONOwDRj68FVF7mdkPV7v2iL2T0tkCaE9cqqpqRdTEyD5n2NJcNQ
         IeWvEdYhV41gaRZ1Eecffpp/D/en/vhUf6dHZiPx3i1oJVeNGigUvwVFNs2/JJFKtqMb
         oNIg==
X-Forwarded-Encrypted: i=1; AFNElJ/3jM8AC0z9X0vnl0p6pni/8Ol/M9vvRT/U430dulGfdjMF5Ilp1losLFdTJfG91n6EjtLORDCppJ+oBhhi@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwoc7AIh/88zYnYUsCz8ATxg3cIITa8Fwd8ePgtqdZ2G5Xi+vE
	pC0BmeNB5zIcb1nejBhhFJSBnWJTrLi19LCfKi08vxir+vkexEFDHKLGfiiZTLoHa0c=
X-Gm-Gg: AfdE7cnEhOW2qKK3r0L0i4KJOXY2XSsIiEluHa1B8Uk9iSkDH3Xwewc7HsXb7VNafZk
	HWHRdPvJxn+ofJa8nQ/JxxBGF9MMePCNKbxaDrkzCQQ9Jeq4N2I6L51Nxx6ygY2jnVhjlJXTyS4
	TUJz7CWNi6w2r+3hsBrwtjNUKS5lfn0iHlUDvekxcEVBAswmdsU+JxXEvmjAV7U6Inh2pyUzb/H
	KFIjXPW+4cFJzXcJUImHsbRchDStaqnSVP1ZnhEjepi8piAomCVAwrqwx9QDjhYE899DbZUeveh
	ANVgsfm3beqzszUrj4Lf1NkwG62T82mOrg2ki62I2aZBOPsROVgLB5GNGnLRR3cnZOv4j3GTTb8
	sahyY0lre4X3cSn3k7CatqjCHWjCq1/0l9QvMk+pAmKfrZZRlUdkUUypvxdw6AdxY1h7dlfNLLT
	CigKFiKEi7rIsOpZIuBoAwG3JDdZW6RLdjjNEzDRU=
X-Received: by 2002:a05:600c:8590:b0:493:b7a6:3dac with SMTP id 5b1f17b1804b1-493c2ba5810mr49868055e9.33.1782973194021;
        Wed, 01 Jul 2026 23:19:54 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c7fa33asm5650050c88.5.2026.07.01.23.19.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 23:19:51 -0700 (PDT)
Message-ID: <5a8f027b-420e-41be-b852-a27fb084c32f@suse.com>
Date: Thu, 2 Jul 2026 15:49:46 +0930
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file
 extents
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260624165144.556908-1-neelx@suse.com>
 <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com>
 <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
 <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com>
 <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
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
In-Reply-To: <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1708-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:neelx@suse.com,m:quwenruo.btrfs@gmx.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[suse.com,gmx.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[wqu@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wqu@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,suse.com:dkim,suse.com:email,suse.com:mid,suse.com:from_mime,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9760A6F3C09



在 2026/7/2 15:10, Daniel Vacek 写道:
> On Thu, 2 Jul 2026 at 00:26, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> 在 2026/7/2 01:29, Daniel Vacek 写道:
>>> On Fri, 26 Jun 2026 at 01:50, Qu Wenruo <wqu@suse.com> wrote:
>>>> 在 2026/6/25 02:21, Daniel Vacek 写道:
>>>>> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>>>>>
>>>>> Encrypted file extents now have the 'encryption' field set to an
>>>>> encryption type.  Let's print it.
>>>>>
>>>>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>>>>> Signed-off-by: Daniel Vacek <neelx@suse.com>
>>>>> ---
>>>>>     check/main.c               | 1 -
>>>>>     kernel-shared/print-tree.c | 2 ++
>>>>>     2 files changed, 2 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/check/main.c b/check/main.c
>>>>> index dedb4db4..a32247b3 100644
>>>>> --- a/check/main.c
>>>>> +++ b/check/main.c
>>>>> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_root *root,
>>>>>                         rec->errors |= I_ERR_BAD_FILE_EXTENT;
>>>>>                 if (extent_type == BTRFS_FILE_EXTENT_PREALLOC &&
>>>>>                     (btrfs_file_extent_compression(eb, fi) ||
>>>>> -                  btrfs_file_extent_encryption(eb, fi) ||
>>>>
>>>> May I ask why preallocated file extent would have encryption value set?
>>>>
>>>> My common sense says that encryption policy should only be set for
>>>> regular file extents.
>>>
>>> There's nothing wrong with pre-allocating encrypted files. Unlike
>>> compression, the exact size is known beforehand.
>>
>> IN that case, does it mean even a hole will have encryption value set?
>>
>> This looks weird. Is there any special reason for setting encryption
>> value for hole/preallocated range?
>>
>> Can't we only set the encryption value only for regular,
>> non-preallocated extents?
> 
> What's so weird about it? Since the inode is encrypted, related parts are too.

Inodes can have PREALLOC flags, but the file extents are not all 
preallocated.

Inode can also have COMPRESS flag, but the file extents are not all 
compressed either.

Inode flags are independent from file extent flags from the very beginning.

> 
> --nX
> 
>> Thanks,
>> Qu
>>
>>>
>>> Simillar to NOCOW, the encrypted data will be stored with the next write.
>>>
>>> --nX
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>                      btrfs_file_extent_other_encoding(eb, fi)))
>>>>>                         rec->errors |= I_ERR_BAD_FILE_EXTENT;
>>>>>                 if (compression && rec->nodatasum)
>>>>> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
>>>>> index 0afa3696..159f0825 100644
>>>>> --- a/kernel-shared/print-tree.c
>>>>> +++ b/kernel-shared/print-tree.c
>>>>> @@ -471,6 +471,8 @@ static void print_file_extent_item(struct extent_buffer *eb,
>>>>>         printf("\t\textent compression %hhu (%s)\n",
>>>>>                         btrfs_file_extent_compression(eb, fi),
>>>>>                         compress_str);
>>>>> +     printf("\t\textent encryption %hhu\n",
>>>>> +                     btrfs_file_extent_encryption(eb, fi));
>>>>>     }
>>>>>
>>>>>     /* Caller should ensure sizeof(*ret) >= 16("DATA|TREE_BLOCK") */
>>>>
>>>
>>


