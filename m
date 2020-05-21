Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FC61DD33E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 May 2020 18:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgEUQqB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 May 2020 12:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgEUQqA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 May 2020 12:46:00 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4608AC061A0E
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 May 2020 09:46:00 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id p12so5966372qtn.13
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 May 2020 09:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lV5nVl90QdXT7V7J/OyvrBTm3a327hAkz9C58So3Cvc=;
        b=pKKRb2ALoGxe9KFLozjrSBLOlZHaJVAeGJ9w6jGPyX4LxbZazm6hbiitC1E1li0N+l
         B9g9jkDzXDJI3NsZSiQROBuKbpX8cIPxXPOWdzQF0V8Xyey6k2fium+NCrArKiFVqnaD
         2Yhy+H1KgG5MQuti1uZWmDG9hEsa4bmqfHHGJTVa73S6rtqXa1NX140k1g2+z5f3vipD
         P0+ayhBW9j9J8qh6yL0NSvo6wpk9rOAIhk64ygZYE9JNmrHuuSuN/WBIfT0DnOZ2XYX2
         MMlkW77Y6bpLE0ScHGYNsFRuswRBUhWnQO20PTaGDGfL8zlVflAKuUMaPa8fN2veOsVb
         lYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lV5nVl90QdXT7V7J/OyvrBTm3a327hAkz9C58So3Cvc=;
        b=At+pnYHibTCJZNCzAGiTmRlN7qKWStDF04GwDg/qyDz31wI/b1/qREZKLroxR7eLre
         zQRnG3cxSYMpK6+Bh6MlHgaIAV5konV6e+N8+UUX5o9G6RNspSZI24068xVF6PdMTwvL
         YnWEllCpOqQlDYnSGi95FXjkp4DzIgzwSJ82lguKQGT1lqEZOLG29MLHao9HMCfyojS9
         9N0ZI7XVJ1S6M02Ww7coomMmn/ResVJC7Y7k1HbOAyH0lBCTinlBBpGiTPe+sLhBSoBA
         NPLDiGtACVo9sm0mQSYmpodMvwVtjSl6cvTTam1SYEjYU7s9y6UupeHljS9oFaGMaIIY
         A2CA==
X-Gm-Message-State: AOAM533EAw7AOdsOpv0Fk5HK+3p80Is7X1aiKuRfE+iWDyo0V3l5mTDY
        eTbOUfzMUKrWyh3xv72Od18=
X-Google-Smtp-Source: ABdhPJyt9GtQ0nRWJeo6uvS4M9w2iCymy9bZu0RYzlr75Wh536rX7hpQ0tRrz4xt1gLZVbhNQK08ZA==
X-Received: by 2002:ac8:17fd:: with SMTP id r58mr10884062qtk.210.1590079559108;
        Thu, 21 May 2020 09:45:59 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d9::10af? ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id z25sm5752725qtj.75.2020.05.21.09.45.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 09:45:58 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 2/3] Introduce libfsverity
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, jsorensen@fb.com, kernel-team@fb.com
References: <20200515041042.267966-1-ebiggers@kernel.org>
 <20200515041042.267966-3-ebiggers@kernel.org>
 <5818763c-f8e0-f5d3-d054-4818f3c4b2b3@gmail.com>
 <20200521160804.GA12790@gmail.com>
Message-ID: <2b2a2747-93e7-3a86-5d7f-86ec9fd5b207@gmail.com>
Date:   Thu, 21 May 2020 12:45:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521160804.GA12790@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/21/20 12:08 PM, Eric Biggers wrote:
> On Thu, May 21, 2020 at 11:24:34AM -0400, Jes Sorensen wrote:

>> Eric,
>>
>> Here is a more detailed review. The code as we have it seems to work for
>> me, but there are some issues that I think would be right to address:
> 
> Thanks for the feedback!
> 
>>
>> I appreciate that you improved the error return values from the original
>> true/false/assert handling.
>>
>> As much as I hate typedefs, I also like the introduction of
>> libfsverity_read_fn_t as function pointers are somewhat annoying to deal
>> with.
>>
>> My biggest objection is the export of kernel datatypes to userland and I
>> really don't think using u32/u16/u8 internally in the library adds any
>> value. I had explicitly converted it to uint32_t/uint16_t/uint8_t in my
>> version.
> 
> I prefer u64/u32/u16/u8 since they're shorter and easier to read, and it's the
> same convention that is used in the kernel code (which is where the other half
> of fs-verity is).

I like them too, but I tend to live in kernel space.

> Note that these types aren't "exported" to or from anywhere but rather are just
> typedefs in common/common_defs.h.  It's just a particular convention.
> 
> Also, fsverity-utils is already using this convention prior to this patchset.
> If we did decide to change it, then we should change it in all the code, not
> just in certain places.

I thought I did it everywhere in my patch set?

>> I also wonder if we should introduce an
>> libfsverity_get_digest_size(alg_nr) function? It would be useful for a
>> caller trying to allocate buffers to store them in, to be able to do
>> this prior to calculating the first digest.
> 
> That already exists; it's called libfsverity_digest_size().
> 
> Would it be clearer if we renamed:
> 
> 	libfsverity_digest_size() => libfsverity_get_digest_size()
> 	libfsverity_hash_name() => libfsverity_get_hash_name()

Oh I missed you added that. Probably a good idea to rename them for
consistency.

>>> diff --git a/lib/compute_digest.c b/lib/compute_digest.c
>>> index b279d63..13998bb 100644
>>> --- a/lib/compute_digest.c
>>> +++ b/lib/compute_digest.c
>>> @@ -1,13 +1,13 @@
>> ... snip ...
>>> -const struct fsverity_hash_alg *find_hash_alg_by_name(const char *name)
>>> +LIBEXPORT u32
>>> +libfsverity_find_hash_alg_by_name(const char *name)
>>
>> This export of u32 here is problematic.
> 
> It's not "exported"; this is a .c file.  As long as we use the stdint.h name in
> libfsverity.h (to avoid polluting the library user's namespace), it is okay.
> u32 and uint32_t are compatible; they're just different names for the same type.

I would still keep it consistent avoid relying on assumptions that types
are identical.

>>> +struct fsverity_signed_digest {
>>> +	char magic[8];			/* must be "FSVerity" */
>>> +	__le16 digest_algorithm;
>>> +	__le16 digest_size;
>>> +	__u8 digest[];
>>> +};
>>
>> I don't really understand why you prefer to manage two versions of the
>> digest, ie. libfsverity_digest and libfsverity_signed_digest, but it's
>> not a big deal.
> 
> Because fsverity_signed_digest has a specific endianness, people will access the
> fields directly and forget to do the needed endianness conventions -- thus
> producing code that doesn't work on big endian systems.  Using a
> native-endianness type for the intermediate struct avoids that pitfall.
> 
> I think keeping the byte order handling internal to the library is preferable.

Fair enough

>>> +static void *xmalloc(size_t size)
>>> +{
>>> +	void *p = malloc(size);
>>> +
>>> +	if (!p)
>>> +		libfsverity_error_msg("out of memory");
>>> +	return p;
>>> +}
>>> +
>>> +void *libfsverity_zalloc(size_t size)
>>> +{
>>> +	void *p = xmalloc(size);
>>> +
>>> +	if (!p)
>>> +		return NULL;
>>> +	return memset(p, 0, size);
>>> +}
>>
>> I suggest we get rid of xmalloc() and libfsverity_zalloc(). libc
>> provides perfectly good malloc() and calloc() functions, and printing an
>> out of memory error in a generic location doesn't tell us where the
>> error happened. If anything those error messages should be printed by
>> the calling function IMO.
>>
> 
> Maybe.  I'm not sure knowing the specific allocation sites would be useful
> enough to make all the callers handle printing the error message (which is
> easily forgotten about).  We could also add the allocation size that failed to
> the message here.

My point is mostly at this point, this just adds code obfuscation rather
than adding real value. I can see how it was useful during initial
development.

Cheers,
Jes


