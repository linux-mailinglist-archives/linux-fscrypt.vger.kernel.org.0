Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA70C1DC145
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 23:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgETVUa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 17:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgETVU3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 17:20:29 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C2DC061A0E
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 14:20:29 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id v4so3854302qte.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 14:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ITnnnSC5pD1e3shTryvCLzat7s93EQ9MItns1YTxP5c=;
        b=Rxn1r0KxyM2w8yMIuPFp/P/dYexc8Tbnxn1YCxix919FNrGMuepQgcg13gcJNi3OQM
         k5Uk+rKYMLiGdzSxUfcYcGXX901p7rLUE65pQ0jHN5yxL23PkQKiue6JB75Ibr87YFE8
         nmDH+kSDlpAD0qNrEbl55OCCqrpv6ynHeGjVQHmUY6z8QuZ/wBws2zoRcNdD1BNGIO8p
         vT3Lw7JIGP3TjLo2XYPURH9qZ7c1xwCxOlPOArWweoO/Cownw7eSLdZQUYoSZnUibvvk
         NcBrPm4mNEJ9iHKwPSiwASjMF5wSNzfH+GS2uuINQPIvr6r9oLn9lHOTchhwm98WF+l8
         yuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ITnnnSC5pD1e3shTryvCLzat7s93EQ9MItns1YTxP5c=;
        b=cVYAgYDPy1rICf8xSiQj+KAsszXjtYoJ/gcxogllFo+shOWPqBQdxSR44ErXAznxkV
         gUIdCyX+SpisVkPAsRiivqiGycd+vAaVse9kKmXAjhDyBFOqx9+FlLy/fmY05eOm0jY0
         a+sRATeAtnwALEFW0ezYQvmC+r/VFJOQe0Ekqh6hoh2Svz7XNhge3VRMWaAiiDk6l+JI
         21htDP5lbJYBTeGjvdxXvEzppG6FRlqlMxnpqpXau2JYj4srM6WfME5l1uiMAWNt7XeE
         26UGb6KfY5rvsVK3KZfN8Gyg0wiMCpkYWWvmsNYKm1sQ8SeVIvIv6/KFkRciRJAMe/oD
         tmZQ==
X-Gm-Message-State: AOAM532dq2+e9SBuI96VAOu/Ywmp5kQAf+MmWU30iFT5iE5N8OlnpNBW
        KUDShcn1FYbYBfzYRTJAM1x0IqlR
X-Google-Smtp-Source: ABdhPJzOBdjJE8WUbwFlL/n7s+rPrgB9CzbJQyt8K33Su+8ph26lTD0CbQfVwhgnGwP6ngFBwzW3xA==
X-Received: by 2002:ac8:3f3a:: with SMTP id c55mr7658449qtk.112.1590009628579;
        Wed, 20 May 2020 14:20:28 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d9::10af? ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id l15sm3462468qti.83.2020.05.20.14.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 14:20:27 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 2/2] Let package manager override CFLAGS and CPPFLAGS
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
References: <20200520200811.257542-1-Jes.Sorensen@gmail.com>
 <20200520200811.257542-3-Jes.Sorensen@gmail.com>
 <20200520210622.GB218475@gmail.com>
Message-ID: <28bc7cbd-2f28-fa97-6393-56478d3dc345@gmail.com>
Date:   Wed, 20 May 2020 17:20:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520210622.GB218475@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/20/20 5:06 PM, Eric Biggers wrote:
> On Wed, May 20, 2020 at 04:08:11PM -0400, Jes Sorensen wrote:
>> From: Jes Sorensen <jsorensen@fb.com>
>>
>> Package managers such as RPM wants to build everything with their
>> preferred flags, and we shouldn't hard override flags.
>>
>> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
>> ---
>>  Makefile | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index e7fb5cf..7bcd5e4 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -32,15 +32,14 @@ cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
>>  #### Common compiler flags.  You can add additional flags by defining CFLAGS
>>  #### and/or CPPFLAGS in the environment or on the 'make' command line.
> 
> The above comment is still being made outdated.  IMO, just remove it.

Good point, I'll send out a v3.

>>  
>> -override CFLAGS := -O2 -Wall -Wundef				\
>> +CFLAGS := -O2 -Wall -Wundef				\
>>  	$(call cc-option,-Wdeclaration-after-statement)		\
>>  	$(call cc-option,-Wmissing-prototypes)			\
>>  	$(call cc-option,-Wstrict-prototypes)			\
>>  	$(call cc-option,-Wvla)					\
>> -	$(call cc-option,-Wimplicit-fallthrough)		\
>> -	$(CFLAGS)
>> +	$(call cc-option,-Wimplicit-fallthrough)
>>  
>> -override CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
>> +CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> 
> On the other thread you ageed that CPPFLAGS should be left as-is, but here you
> removed 'override'.  I think always using -D_FILE_OFFSET_BITS=64 is what we
> want, since it avoids incorrect builds on 32-bit platforms.  Right?

That should work I think, I read your response as agreeing with me,
hence leaving the change in place.

Cheers,
Jes
