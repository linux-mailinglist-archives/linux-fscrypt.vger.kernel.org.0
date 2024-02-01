Return-Path: <linux-fscrypt+bounces-159-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3BA6844DC9
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Feb 2024 01:26:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5A241C21D79
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Feb 2024 00:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE904184;
	Thu,  1 Feb 2024 00:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q12SluHY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20928626
	for <linux-fscrypt@vger.kernel.org>; Thu,  1 Feb 2024 00:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706747173; cv=none; b=UxeG7v5Zv0FHeRx5Tv/5ejVlr6glVOs2DhV/l7/BMj8KS5o12xYa1usDFgNseIqAICYNpX3Ac2XslBlcwqw5fNbZGC/Ywh+Z+XYLqQl5czRi3OBDT8s1+dNYKiG6ihyHPyRuBJd06NnIakup1vgh7mYNtEc4Ua7ARQvu3Wtb0EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706747173; c=relaxed/simple;
	bh=3jQfyxCUmbYgMag6DLXoDWZodwkuBz+a0egfu7gu12Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q9a3Y5wfAw1kX8j9aUHRBmeQy+RF5lzHct/FoN6vH550N3pCSJbe1x0mXudhA7s5vzPw1jFPIR0lacipCn8SBM2QLcpQ39bK3PXHwM8o9c4E4SHp0r6b3MHqi+mLr4ozgXk0/y0eFYFJbCskdqlYsiuNGIe5BzMsuR32d3ds8L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q12SluHY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706747171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vHOXrV3Wiv6Jv3OmanQRBteZrjHiu4ynfoOlkoDIri4=;
	b=Q12SluHYWaMvce90wcER2XxjcHFI1GW+F+4ZRp2Q27A78iIl+AmVMTomaCYdT2vC0tDLPn
	bqHkCvvASaC1Pf1H1jMU8EC4msAwzTTvSj5i5RLE3duyBIh8PVrcUfdlddDIwpFNySKdkM
	WYnNEYSxkWm1C8IgjwU6SPnvO6tlBQ8=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-VwUutnJnMVK6tvYUco1eBg-1; Wed, 31 Jan 2024 19:26:09 -0500
X-MC-Unique: VwUutnJnMVK6tvYUco1eBg-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3bd3eb9643dso563256b6e.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 31 Jan 2024 16:26:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706747168; x=1707351968;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vHOXrV3Wiv6Jv3OmanQRBteZrjHiu4ynfoOlkoDIri4=;
        b=cFBZWe2s3nBjYKShIknRpJVVgORDJUprzBQ/Vp8xIHbmyOPnyv8dyv8jenCKctJI6G
         fJfe83g2JUL+J8AUkg1npg8ME2KdKwATAPeSWZFwVYifbMwwndU4tK5cNdoZzqzUOREN
         LbPYREsG/TSpzYtDgNK9BrKoJVWSksZjFzIi94vJVcGy0KEbv0agKbliPEruALfVtZfY
         YRXxhpWSlM2ChAYXBTkenTgOETdct+U7KtjC7M2UsU//w/qbDd8iuSTEzavJVwHsnPAm
         u4fz6eEuqPyd+u4jOIrsbBgbVwAjOstnhOUaKa/SBttAbM+9NG+Cr96wKbuC19Xo0upw
         dymg==
X-Gm-Message-State: AOJu0YxUqZg9dokBcDw7RQTRKLV4zPxVNzxeLOeyCCx+IfwwhQOJEikU
	0iMN4wVV55zu6gEWyuTg4BA634dXDUqTSFcpM85WqNZGgeeRBVSBbY8vnDPB/elHJU/eQOkdz0z
	K/iuty/wBFD+0eC5cvatMMnl+IxntzL66XCk6asBqZJYk6Xw1ulrFoMyB2eNRGUA=
X-Received: by 2002:a05:6808:23c2:b0:3bd:e011:fc8a with SMTP id bq2-20020a05680823c200b003bde011fc8amr810421oib.42.1706747168603;
        Wed, 31 Jan 2024 16:26:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLWxgDltGr/OA2YFHx9+M/uDzQyHC1ofpUnUtwaxeXCQyVz8cY4uWTlWRO/sey1RCSPS0KMA==
X-Received: by 2002:a05:6808:23c2:b0:3bd:e011:fc8a with SMTP id bq2-20020a05680823c200b003bde011fc8amr810404oib.42.1706747168333;
        Wed, 31 Jan 2024 16:26:08 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUyxE87UjAAbxVbvp3ua7m84sjYQ3UxgQNkw9U0sDU6fKmPBmNDsBR++zFmSg7YtKgpCJKdVEDGZhBLlK1Uhd2HNgXzMNMTHF9EV7nNi3I7f7449pvPB8WHWo2n33bReTpSgnJiTd6DB/9MdluzQKWuZO+BX9JfBzg5ri5Niq6l052CumuX/Fuk+p0OZLIq64dtM8yfVJ0M3oE4ToXQdmIaKTk2kiJxkqIo1a++B82L7yw3nHEg2ok/SITRKm2EUPmOjA3MYwXqtw==
Received: from [10.72.112.67] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t15-20020a056a0021cf00b006dd6c439996sm10470629pfj.161.2024.01.31.16.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 16:26:08 -0800 (PST)
Message-ID: <6cc9dca0-52f6-44f8-87d4-9a937e3f83e6@redhat.com>
Date: Thu, 1 Feb 2024 08:26:02 +0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fscrypt: to make sure the inode->i_blkbits is correctly
 set
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
 linux-kernel@vger.kernel.org, idryomov@gmail.com,
 ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com
References: <20240125044826.1294268-1-xiubli@redhat.com>
 <20240127063754.GA11935@sol.localdomain>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240127063754.GA11935@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/27/24 14:37, Eric Biggers wrote:
> On Thu, Jan 25, 2024 at 12:48:25PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The inode->i_blkbits should be already set before calling
>> fscrypt_get_encryption_info() and it will be used this to setup the
>> ci_data_unit_bits.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/crypto/keysetup.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
>> index d71f7c799e79..909187e52bae 100644
>> --- a/fs/crypto/keysetup.c
>> +++ b/fs/crypto/keysetup.c
>> @@ -702,6 +702,9 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
>>   /**
>>    * fscrypt_prepare_new_inode() - prepare to create a new inode in a directory
>>    * @dir: a possibly-encrypted directory
>>    * @inode: the new inode.  ->i_mode must be set already.
>>    *         ->i_ino doesn't need to be set yet.
> Maybe just change the above to "->i_mode and ->i_blkbits", instead of adding a
> separate paragraph?

Just back from PTO.

Yeah, this sounds much better. I will fix it.

Thanks

- Xiubo


>>    * @encrypt_ret: (output) set to %true if the new inode will be encrypted
>>    *
>>    * If the directory is encrypted, set up its ->i_crypt_info in preparation for
>>    * encrypting the name of the new file.  Also, if the new inode will be
>>    * encrypted, set up its ->i_crypt_info and set *encrypt_ret=true.
>>    *
>>    * This isn't %GFP_NOFS-safe, and therefore it should be called before starting
>>    * any filesystem transaction to create the inode.  For this reason, ->i_ino
>>    * isn't required to be set yet, as the filesystem may not have set it yet.
>>    *
>>    * This doesn't persist the new inode's encryption context.  That still needs to
>>    * be done later by calling fscrypt_set_context().
>>    *
>> + * Please note that the inode->i_blkbits should be already set before calling
>> + * this and later it will be used to setup the ci_data_unit_bits.
>> + *
>>    * Return: 0 on success, -ENOKEY if the encryption key is missing, or another
>>    *	   -errno code
>>    */
>> @@ -717,6 +720,9 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
>>   	if (IS_ERR(policy))
>>   		return PTR_ERR(policy);
>>   
>> +	if (WARN_ON_ONCE(inode->i_blkbits == 0))
>> +		return -EINVAL;
>> +
> Thanks,
>
> - Eric
>


