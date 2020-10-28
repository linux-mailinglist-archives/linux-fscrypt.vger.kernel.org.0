Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4094229D54E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Oct 2020 23:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgJ1WAD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Oct 2020 18:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbgJ1V77 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Oct 2020 17:59:59 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE5CC0613CF
        for <linux-fscrypt@vger.kernel.org>; Wed, 28 Oct 2020 14:59:59 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id h5so428106vsp.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 28 Oct 2020 14:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uck2YNcuuaM9Q4ZPFVSiK7dl3B/KTjxlkFJ58vsXqX0=;
        b=l/Wj1v8+/rolSuumRQDoW1u/m54FmFDB6jRkprXGzcdlgl/cIctml1IprWf7rVsTbA
         jMO7D2FsB0eBEq0Edxki/NlHwET15cnLLT8/Dj4kac+dkeyywTcBHhVDvoA0X+gWS+tn
         cvNRgCD0R/1TIRFZ648lUe+KVWl8NwUJ4KYjJNCWWYHCSTPV1svyOtLV0owlbU9Nk9jF
         KcrVHycSXvvjIElClPKwzqU64GO3Ol18eeagJdX44m+FEdoRO4Lnr944UQrwlX5ORQeU
         I8PEWol14TDerVXFoKYsSuDq3Obv0oGXQtRCYNA+a8wVMd+cN8uwiaRSDj73iB8eyY/q
         Z1kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uck2YNcuuaM9Q4ZPFVSiK7dl3B/KTjxlkFJ58vsXqX0=;
        b=Nm1bLurKhdz27NgpMw/RR1RdgJH2z2X9uPZKT2e0HPzszbJq2W9hBsW+tndQu7j8wJ
         kq885H2RsABnSImxRqIWMldxFwSmwVKUmgV8RS4m2DMJkRNaHQMO6PNBJtWfDfUSW2l2
         fkecS3EX9RUlxd6N0BuP3j3IvuiDRftqf0Rfa56qNMawIlePmJ/Z9Fyz0/ZcbCluXPRl
         uht39WONcQRQficY0CVnzVLOKY9pKJxeTSVhVs7yEreTR1LLQAQUAeJQwUWOVeYOfTQc
         1EyEzXr0vsOR++qbjRodak5f+r9tuZlIVXffhWUh/J82+sOaciIQSTop6gOM21JAQsJp
         I9sA==
X-Gm-Message-State: AOAM530T/j+WFzpOD9cTAkh+L++H3XB18w0EH0C1CY09pxRX4qC51gvz
        rbKTnqUL4+u/iS/baSeqiNhIyEVqMoQ=
X-Google-Smtp-Source: ABdhPJx60hIE6k564kcjEmaSESt+ZH66kG8ynmY6RkdwyZY6WYkSJcFqVbvKOGOR+Karm8s3Y+odMg==
X-Received: by 2002:a05:6214:148a:: with SMTP id bn10mr157075qvb.51.1603903624988;
        Wed, 28 Oct 2020 09:47:04 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:1102::1844? ([2620:10d:c091:480::1:4133])
        by smtp.gmail.com with ESMTPSA id n24sm3258597qtv.39.2020.10.28.09.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 09:47:04 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [fsverity-utils PATCH] override CFLAGS too
To:     Eric Biggers <ebiggers@kernel.org>, luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org, malmond@fb.com
References: <20201026204831.3337360-1-luca.boccassi@gmail.com>
 <20201026221019.GB185792@sol.localdomain>
Message-ID: <7bfc9c61-d847-f7d2-f2fc-c0ba012136c1@gmail.com>
Date:   Wed, 28 Oct 2020 12:47:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201026221019.GB185792@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 10/26/20 6:10 PM, Eric Biggers wrote:
> [+Jes Sorensen]
> 
> On Mon, Oct 26, 2020 at 08:48:31PM +0000, luca.boccassi@gmail.com wrote:
>> From: Romain Perier <romain.perier@gmail.com>
>>
>> Currently, CFLAGS are defined by default. It has to effect to define its
>> c-compiler options only when the variable is not defined on the cmdline
>> by the user, it is not possible to merge or mix both, while it could
>> be interesting for using the app warning cflags or the pkg-config
>> cflags, while using the distributor flags. Most distributions packages
>> use their own compilation flags, typically for hardening purpose but not
>> only. This fixes the issue by using the override keyword.
>>
>> Signed-off-by: Romain Perier <romain.perier@gmail.com>
>> ---
>> Currently used in Debian, were we want to append context-specific
>> compiler flags (eg: for compiler hardening options) without
>> removing the default flags
>>
>>  Makefile | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 6c6c8c9..5020cac 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -35,14 +35,15 @@
>>  cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
>>  	      then echo $(1); fi)
>>  
>> -CFLAGS ?= -O2 -Wall -Wundef					\
>> +override CFLAGS := -O2 -Wall -Wundef				\
>>  	$(call cc-option,-Wdeclaration-after-statement)		\
>>  	$(call cc-option,-Wimplicit-fallthrough)		\
>>  	$(call cc-option,-Wmissing-field-initializers)		\
>>  	$(call cc-option,-Wmissing-prototypes)			\
>>  	$(call cc-option,-Wstrict-prototypes)			\
>>  	$(call cc-option,-Wunused-parameter)			\
>> -	$(call cc-option,-Wvla)
>> +	$(call cc-option,-Wvla)					\
>> +	$(CFLAGS)
>>  
>>  override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> 
> I had it like this originally, but Jes requested that it be changed to the
> current way for rpm packaging.  See the thread:
> https://lkml.kernel.org/linux-fscrypt/20200515205649.1670512-3-Jes.Sorensen@gmail.com/T/#u
> 
> Can we come to an agreement on one way to do it?
> 
> To me, the approach with 'override' makes more sense.  The only non-warning
> option is -O2, and if someone doesn't want that, they can just specify
> CFLAGS=-O0 and it will override -O2 (since the last option "wins").
> 
> Jes, can you explain why that way doesn't work with rpm?

I don't remember all the details and I haven't looked at this in a
while. Matthew Almond has helpfully offered to look into it.

Jes
