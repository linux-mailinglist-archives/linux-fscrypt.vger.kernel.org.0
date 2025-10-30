Return-Path: <linux-fscrypt+bounces-887-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F50DC1EAC7
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 Oct 2025 08:04:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5EE5E4E73B5
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 Oct 2025 07:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21917334C3F;
	Thu, 30 Oct 2025 07:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fo8V8ZuG"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED9A335BA6
	for <linux-fscrypt@vger.kernel.org>; Thu, 30 Oct 2025 07:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761807831; cv=none; b=lABz2i3UX3nNPyN4horB/IkWhIog/u7N/xob4ri+Bpq+8jbHUCpf2XR7jnDZAcJKOfzHp7uunyrvitUldbr9BcuxXWVwmw+RuGQO3HcAAQwkHq2M/3+VFmzsiWct3hh9nI1ZkyAO1CKoG7Qni8GLgm27JmnxwiIj9RYIPcPmdYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761807831; c=relaxed/simple;
	bh=30YyUiBw0QFhahpAaF14VLOaPHw3uzIL+mv7Wic5tR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gRkoTAkVVQbWnLYasmC3HR3r620ZbqJqcrggXP0XwvPuFABR6nENCQykd1HtvwgwtNosrYu8kJHSM+BMECqFxeC8aNBuXyiZP+E0vkzQOabZtXznjG07Z0rOZK+AXEX5MzZdVYSgF8Nq8xKjSSLuKWTSRKOeT5I1Y+9mPbnr10c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fo8V8ZuG; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b5a631b9c82so430426a12.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 30 Oct 2025 00:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761807826; x=1762412626; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B++BWqh9Bt5q69FtkAKZFZmamCnFf53V2ybbC30w47A=;
        b=fo8V8ZuGaSgwfnJB3wbz1yeYWTeN00CZpgCa3O4agVjhc2Fj+9+mfHfdEEKt/oL279
         SfgdnX41PO9jGJY9v88k2+Uw6PJvEW+vgJeX8mN/XAZgrwnCSGTwvJs9MzS+Fc/6/aT6
         mNxKIZmgzuj/7iWQFmj73ujksgDtaVNObTZeHajhkgcPDcDS8FOD76Eqak4UqO+dQ7jY
         UPWxC9h6mricAhg223w+n0BIycJxwZ7MoPqxnnwusnkGt1H0FGlZeKF/4n90y6/MXgcg
         AzSGsdWhC+diuZfQFOoU1hjnIMVVBlxxNAO2nU/CO0AwNK79/v4L+S/+rd10oRPEs96g
         LHDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761807826; x=1762412626;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B++BWqh9Bt5q69FtkAKZFZmamCnFf53V2ybbC30w47A=;
        b=CUSCiZW/4yS4IDD8vxtioXCeqPhNORDo1I4+vrxIcfN+GLY6+BmXW1g1yHBwjLhTfE
         0iMO0N3jUIxecklboJP3k9+4k9Y71bBhJN8lIF3eFBSFEogx4VSSWRvYwQ8DdYZon9dm
         rVydY0wdOQDHO5pztBNXc9yoPFH5iUID9PFSt7Z3zO3ieUQndAwORL/1znE+ZOE4rg5E
         4nZ1t0/HJcsqAQGsgRTgl1YCH7bO/G6hNN4LMjCnQkCCIRKYLeKYngxEkp5P3f8Hedvy
         QhkLW2Lq7iKwJ8vlpYAUkrrM9r/mxcmz8WuQpwrcV8Ild0afgtMW9920c1s/1FVVJ0qG
         yVhg==
X-Forwarded-Encrypted: i=1; AJvYcCWEg5HxdWZi8w1LR9mca5Z8ILyHzTD9Zim3CTEfwc1eta/rD11ffCtwmmFqrDJI5SUwb1jCNbEzRcsqRBss@vger.kernel.org
X-Gm-Message-State: AOJu0YyiHYXW6Kgy1Se77J+LIEg183uCOyfF5Mk3nb3CyfchXxdAsW2P
	2LPU2zYEriQa8f9oTlM7MTP2o/BkL1cvCAKc844f1Z49cpqoVcn23sih
X-Gm-Gg: ASbGncvBMnkx+deiNRkiXFAvzJjhOXSpp20922x6j4y5fuNqin4PncE1tH2c30rulDn
	B/8W7Xs2H5F7HO+FOGV947Ava2i9l6rhT1D/snjaX8bWF+660PWSOqYsllS2WTLtSRgg2Mukh0B
	QmkdjS4TYznedqMK3u92Ec2dS//iJ3fT//I9RTrZcELzM3wWnLg+5xt+l8S8EkUUrUQOSKQNiwV
	vkxMEmUIkpseZK3gcHR8uj0n+cei9+bvWlmyy0JVINEQIu+GCTTuhxMT1nbRuzOAfyDmjzo+rRn
	2OtQ9WLmhLBWc+YoEf2tiKgZrpTFRMAtV/z6s1QiNI4C8GfsB7XkeGzh68EEZn6zJ7G/kxj50Nc
	kekeYOGXPl4d7/HoebH+0ohJeZxCbhGv67/NRrC5q3RNzLkL9I3NAYbHMGuu1xG9re23vbj13Gp
	DNbrgm4EcksW249MaatIU=
X-Google-Smtp-Source: AGHT+IGVdfokE5h9WgZFNnbMpYlwwtnulYfmSBW0TJ3r+gKqqjKeMcIb3AA2FxgrOP8KUEWqUuEJdw==
X-Received: by 2002:a17:902:d4c9:b0:269:a2bc:799f with SMTP id d9443c01a7336-294deedabd4mr67814365ad.29.1761807826418;
        Thu, 30 Oct 2025 00:03:46 -0700 (PDT)
Received: from [10.189.138.37] ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d2903csm173849955ad.63.2025.10.30.00.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 00:03:46 -0700 (PDT)
Message-ID: <04ffcdb5-9d9a-450d-a804-104857f25f15@gmail.com>
Date: Thu, 30 Oct 2025 15:03:43 +0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fscrypt: fix left shift underflow when inode->i_blkbits >
 PAGE_SHIFT
To: Eric Biggers <ebiggers@kernel.org>,
 Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
 linux-fscrypt@vger.kernel.org, Yongpeng Yang <yangyongpeng@xiaomi.com>
References: <20251029130608.331477-1-yangyongpeng.storage@gmail.com>
 <20251029164810.GB1603@sol>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <20251029164810.GB1603@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/30/25 00:48, Eric Biggers wrote:
> On Wed, Oct 29, 2025 at 09:06:08PM +0800, Yongpeng Yang wrote:
>> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
>>
>> When simulating an nvme device on qemu with both logical_block_size and
>> physical_block_size set to 8 KiB, a error trace appears during partition
>> table reading at boot time. The issue is caused by inode->i_blkbits being
>> larger than PAGE_SHIFT, which leads to a left shift of -1 and triggering a
>> UBSAN warning.
>>
>> [    2.697306] ------------[ cut here ]------------
>> [    2.697309] UBSAN: shift-out-of-bounds in fs/crypto/inline_crypt.c:336:37
>> [    2.697311] shift exponent -1 is negative
>> [    2.697315] CPU: 3 UID: 0 PID: 274 Comm: (udev-worker) Not tainted 6.18.0-rc2+ #34 PREEMPT(voluntary)
>> [    2.697317] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
>> [    2.697320] Call Trace:
>> [    2.697324]  <TASK>
>> [    2.697325]  dump_stack_lvl+0x76/0xa0
>> [    2.697340]  dump_stack+0x10/0x20
>> [    2.697342]  __ubsan_handle_shift_out_of_bounds+0x1e3/0x390
>> [    2.697351]  bh_get_inode_and_lblk_num.cold+0x12/0x94
>> [    2.697359]  fscrypt_set_bio_crypt_ctx_bh+0x44/0x90
>> [    2.697365]  submit_bh_wbc+0xb6/0x190
>> [    2.697370]  block_read_full_folio+0x194/0x270
>> [    2.697371]  ? __pfx_blkdev_get_block+0x10/0x10
>> [    2.697375]  ? __pfx_blkdev_read_folio+0x10/0x10
>> [    2.697377]  blkdev_read_folio+0x18/0x30
>> [    2.697379]  filemap_read_folio+0x40/0xe0
>> [    2.697382]  filemap_get_pages+0x5ef/0x7a0
>> [    2.697385]  ? mmap_region+0x63/0xd0
>> [    2.697389]  filemap_read+0x11d/0x520
>> [    2.697392]  blkdev_read_iter+0x7c/0x180
>> [    2.697393]  vfs_read+0x261/0x390
>> [    2.697397]  ksys_read+0x71/0xf0
>> [    2.697398]  __x64_sys_read+0x19/0x30
>> [    2.697399]  x64_sys_call+0x1e88/0x26a0
>> [    2.697405]  do_syscall_64+0x80/0x670
>> [    2.697410]  ? __x64_sys_newfstat+0x15/0x20
>> [    2.697414]  ? x64_sys_call+0x204a/0x26a0
>> [    2.697415]  ? do_syscall_64+0xb8/0x670
>> [    2.697417]  ? irqentry_exit_to_user_mode+0x2e/0x2a0
>> [    2.697420]  ? irqentry_exit+0x43/0x50
>> [    2.697421]  ? exc_page_fault+0x90/0x1b0
>> [    2.697422]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>> [    2.697425] RIP: 0033:0x75054cba4a06
>> [    2.697426] Code: 5d e8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 75 19 83 e2 39 83 fa 08 75 11 e8 26 ff ff ff 66 0f 1f 44 00 00 48 8b 45 10 0f 05 <48> 8b 5d f8 c9 c3 0f 1f 40 00 f3 0f 1e fa 55 48 89 e5 48 83 ec 08
>> [    2.697427] RSP: 002b:00007fff973723a0 EFLAGS: 00000202 ORIG_RAX: 0000000000000000
>> [    2.697430] RAX: ffffffffffffffda RBX: 00005ea9a2c02760 RCX: 000075054cba4a06
>> [    2.697432] RDX: 0000000000002000 RSI: 000075054c190000 RDI: 000000000000001b
>> [    2.697433] RBP: 00007fff973723c0 R08: 0000000000000000 R09: 0000000000000000
>> [    2.697434] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
>> [    2.697434] R13: 00005ea9a2c027c0 R14: 00005ea9a2be5608 R15: 00005ea9a2be55f0
>> [    2.697436]  </TASK>
>> [    2.697436] ---[ end trace ]---
>>
>> Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
>> ---
>>   fs/crypto/inline_crypt.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
>> index 5dee7c498bc8..6beb5f490612 100644
>> --- a/fs/crypto/inline_crypt.c
>> +++ b/fs/crypto/inline_crypt.c
>> @@ -333,7 +333,7 @@ static bool bh_get_inode_and_lblk_num(const struct buffer_head *bh,
>>   	inode = mapping->host;
>>   
>>   	*inode_ret = inode;
>> -	*lblk_num_ret = ((u64)folio->index << (PAGE_SHIFT - inode->i_blkbits)) +
>> +	*lblk_num_ret = (((u64)folio->index << PAGE_SHIFT) >> inode->i_blkbits) +
>>   			(bh_offset(bh) >> inode->i_blkbits);
>>   	return true;
> 
> Looks good, but could you clarify in the commit message that this issue
> doesn't occur on an encrypted file but rather a block device inode?
> fscrypt_set_bio_crypt_ctx_bh() runs the above code before checking
> IS_ENCRYPTED(), so that's why it was reached.

Thanks for the review. I’ll add more explanations in v2.

Yongpeng,

> 
> Otherwise the patch seems surprising, since i_blkbits > PAGE_SHIFT isn't
> a case that is supported on encrypted files yet at all.
> 
> - Eric


