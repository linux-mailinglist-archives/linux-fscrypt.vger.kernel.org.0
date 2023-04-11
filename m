Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD85D6DE0F1
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 18:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDKQ0I (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Apr 2023 12:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjDKQ0H (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Apr 2023 12:26:07 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8593598
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 09:26:03 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 920AC829D8;
        Tue, 11 Apr 2023 12:26:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681230363; bh=320Wq2c0K5+ky6rjbgE3I9uhxlxlPSGQ1eeOctgr3wY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=d9CgqAr7Ani/0WipcZJlo5yaUuVUMe0oKE5gqMmPgR8pNORTedEmDZJY1UjEwCJgy
         OnPr0SYt5W4iIHKqFfwu3jBrY2VeygKz0ChWSFlQeekbrIyOHRFXKiwKECAdvZT+id
         hVygfrU7NIwLl/SYkc1eO8dPwYgkY3QsbG5zqqHg6fBBZjCvSuNX6lMY0JMTGTltRx
         bGFH4uCEWzDCNP+dDYqHwmDh8s9lZoVh6vEUhVmIkqlbkXj0XuU/ZBsH2L1LGGuUg0
         xp6iGH7IUjYFbTkIeDrNlF6ysLj/KcjlT9/2QL2g5XUS8d2wDf81HHZpwV39PzSFuZ
         IEkYA5Y95BLoQ==
Message-ID: <221037b3-d1eb-0011-dd49-8022e3d77350@dorminy.me>
Date:   Tue, 11 Apr 2023 12:26:01 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v2 06/11] fscrypt: make infos have a pointer to prepared
 keys
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
 <49da55a9d6787c1d3b900f48f15c09da505581ad.1681155143.git.sweettea-kernel@dorminy.me>
 <20230411034408.GF47625@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <20230411034408.GF47625@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 4/10/23 23:44, Eric Biggers wrote:
> On Mon, Apr 10, 2023 at 03:39:59PM -0400, Sweet Tea Dorminy wrote:
>> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
>> index 8b32200dbbc0..f07e3b9579cf 100644
>> --- a/fs/crypto/keysetup.c
>> +++ b/fs/crypto/keysetup.c
>> @@ -181,7 +181,11 @@ void fscrypt_destroy_prepared_key(struct super_block *sb,
>>   int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
>>   {
>>   	ci->ci_owns_key = true;
>> -	return fscrypt_prepare_key(&ci->ci_enc_key, raw_key, ci);
>> +	ci->ci_enc_key = kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
>> +	if (!ci->ci_enc_key)
>> +		return -ENOMEM;
>> +
>> +	return fscrypt_prepare_key(ci->ci_enc_key, raw_key, ci);
>>   }
> 
> Any idea how much this will increase the per-inode memory usage by, in the
> per-file keys case?  (Counting the overhead of the slab allocator.)

For just this change, the object gets allocated from the 8 or 16 byte 
slab cache, so it's just the 8 bytes of pointer, plus the slab cache 
overhead. The slab allocator, as far as I understand it, has 64-byte 
'struct slab's, and for 8/16/32 byte allocations, those come out of page 
size slabs; so that's amortized over 512/256/128 objects. So that's 8 
1/8th or 8 1/4th extra bytes from this change, I think.

Later changes bump the object up to the next size cache, 16 or 32, 
wasting 6 or 14 more bytes. I should probably add something imitating 
struct bio's bi_inline_vecs, adding a ci_inline_prepkey[] member for 
allocation only by per-file key infos.


> 
>> -	else if (ci->ci_owns_key)
>> +	else if (ci->ci_owns_key) {
>>   		fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
>> -					     &ci->ci_enc_key);
>> +					     ci->ci_enc_key);
>> +		kfree(ci->ci_enc_key);
> 
> Use kfree_sensitive() here, please.  Yes, it's not actually needed here because
> the allocation doesn't contain the keys themselves.  But I want to code
> defensively here.

Ah, I argued with myself on whether I needed it, happy to do so.
