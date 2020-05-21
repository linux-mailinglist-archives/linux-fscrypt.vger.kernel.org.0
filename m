Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BE91DD407
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 May 2020 19:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgEURNT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 May 2020 13:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728581AbgEURNS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 May 2020 13:13:18 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2C0C061A0F
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 May 2020 10:13:18 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id m44so6066393qtm.8
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 May 2020 10:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iqCQdckviE1jP+HGadDqzeKBMrG6h/Wav6RQ9imYgVk=;
        b=iaWDBU1c0gLaBuHHmiRsK+TjXBHO9LJCgqywqHncGACOCDkbwXb5Un0VkU5G3Ao1qc
         lWLFbanstvAh7yx269wa6++WAcGdd7szcqyWjETAKJ57/gqqEVB4nIJRZ5dHlcExPElu
         f9En2vdzGhs/J4ffK2FI23TSnVwGkDLPMMq3tKWDpLl6/LbaGKTkr3tl99DYl43kCQPr
         vOcThrXcH0OuTtRrQ7Mhpv8es0BRc6Zyi9UBoxGYTLNpiFl0TCXKRyVseeoyTZ7M9L5i
         +HTJ+lSFuWD5nHvFnMzPyugPqhoLFK82nwMbtqMV8yLKWGwydvdH0Zq/KNkTdrNqZITW
         2ghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iqCQdckviE1jP+HGadDqzeKBMrG6h/Wav6RQ9imYgVk=;
        b=FR1+d+EiB+447VREpq5r24YmZ3uGJmBHXy+tuKJ88MMQS1TFafgtHxL0zDUBjIDnvf
         J4g5gIqobc1qm7xGO1q9f3sQ8kD0yVQTiHOosDaW9vzQapNpdlIDUtu73Ka0Orh/5w69
         QsGI/Ng7ZFGl3dcP0Xhr81BlHs+cFwyoPiuLyRZCUbrC2ExUjaNnVLvhL/Lsw1T2PUK3
         6qKN8Xg8cW/MsCQie+ModgYF+mod/1YpyWnE/VG8hxVpXFrbaFUzRLt44TC80Mx6nKfb
         gRqjaK1d9fr8rv6VVi81654upGqk8tGlmOsQbO9w4hQiYR8hEehOcOa+8ULC/sCUOVj8
         bYyA==
X-Gm-Message-State: AOAM530iLPls+SYxPNd9CzJJAXLC8KCCdDGb639qWDwjzUsmgqhW/ggF
        tnD/9CfEUUyiXasiSDVtQZA=
X-Google-Smtp-Source: ABdhPJzs6Jr0H71zI5Ye5pYNYVH09F3uHstbdLp4eyE2BqegZXRvx3c3QIQo58SI32cS9xQhEZoDsQ==
X-Received: by 2002:aed:2ac5:: with SMTP id t63mr11972931qtd.245.1590081197410;
        Thu, 21 May 2020 10:13:17 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d9::10af? ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id g11sm4981969qkk.106.2020.05.21.10.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 10:13:16 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 2/3] Introduce libfsverity
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, jsorensen@fb.com, kernel-team@fb.com
References: <20200515041042.267966-1-ebiggers@kernel.org>
 <20200515041042.267966-3-ebiggers@kernel.org>
 <5818763c-f8e0-f5d3-d054-4818f3c4b2b3@gmail.com>
 <20200521160804.GA12790@gmail.com>
 <2b2a2747-93e7-3a86-5d7f-86ec9fd5b207@gmail.com>
 <20200521165941.GB12790@gmail.com>
Message-ID: <0079bdb8-dc8b-bd3e-718a-b994602e9a07@gmail.com>
Date:   Thu, 21 May 2020 13:13:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521165941.GB12790@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/21/20 12:59 PM, Eric Biggers wrote:
> On Thu, May 21, 2020 at 12:45:57PM -0400, Jes Sorensen wrote:
>>>> My biggest objection is the export of kernel datatypes to userland and I
>>>> really don't think using u32/u16/u8 internally in the library adds any
>>>> value. I had explicitly converted it to uint32_t/uint16_t/uint8_t in my
>>>> version.
>>>
>>> I prefer u64/u32/u16/u8 since they're shorter and easier to read, and it's the
>>> same convention that is used in the kernel code (which is where the other half
>>> of fs-verity is).
>>
>> I like them too, but I tend to live in kernel space.
>>
>>> Note that these types aren't "exported" to or from anywhere but rather are just
>>> typedefs in common/common_defs.h.  It's just a particular convention.
>>>
>>> Also, fsverity-utils is already using this convention prior to this patchset.
>>> If we did decide to change it, then we should change it in all the code, not
>>> just in certain places.
>>
>> I thought I did it everywhere in my patch set?
> 
> No, they were still left in various places.

I see, I thought I had only left the __u32 ones in place, but just goes
to show I didn't do my job properly.

>>>> I also wonder if we should introduce an
>>>> libfsverity_get_digest_size(alg_nr) function? It would be useful for a
>>>> caller trying to allocate buffers to store them in, to be able to do
>>>> this prior to calculating the first digest.
>>>
>>> That already exists; it's called libfsverity_digest_size().
>>>
>>> Would it be clearer if we renamed:
>>>
>>> 	libfsverity_digest_size() => libfsverity_get_digest_size()
>>> 	libfsverity_hash_name() => libfsverity_get_hash_name()
>>
>> Oh I missed you added that. Probably a good idea to rename them for
>> consistency.
> 
> libfsverity_digest_size() was actually in your patchset too.

Whoops egg on face :)

> I'll add the "get" to the names so that all function names start with a verb.

Sounds good!

>>>>> +static void *xmalloc(size_t size)
>>>>> +{
>>>>> +	void *p = malloc(size);
>>>>> +
>>>>> +	if (!p)
>>>>> +		libfsverity_error_msg("out of memory");
>>>>> +	return p;
>>>>> +}
>>>>> +
>>>>> +void *libfsverity_zalloc(size_t size)
>>>>> +{
>>>>> +	void *p = xmalloc(size);
>>>>> +
>>>>> +	if (!p)
>>>>> +		return NULL;
>>>>> +	return memset(p, 0, size);
>>>>> +}
>>>>
>>>> I suggest we get rid of xmalloc() and libfsverity_zalloc(). libc
>>>> provides perfectly good malloc() and calloc() functions, and printing an
>>>> out of memory error in a generic location doesn't tell us where the
>>>> error happened. If anything those error messages should be printed by
>>>> the calling function IMO.
>>>>
>>>
>>> Maybe.  I'm not sure knowing the specific allocation sites would be useful
>>> enough to make all the callers handle printing the error message (which is
>>> easily forgotten about).  We could also add the allocation size that failed to
>>> the message here.
>>
>> My point is mostly at this point, this just adds code obfuscation rather
>> than adding real value. I can see how it was useful during initial
>> development.
> 
> It's helpful to eliminate the need for callers to print the error message.
> 
> We also still need libfsverity_memdup() anyway, unless we hard-code
> malloc() + memcpy().
> 
> I also had in mind that we'd follow the (increasingly recommended) practice of
> initializing all heap memory.  This can be done by only providing allocation
> functions that initialize memory.
> 
> I'll think about it.

It's not a showstopper, my primary interest is a working release :)

Cheers,
Jes


