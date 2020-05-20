Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B471DBFBB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 22:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgETUAh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 16:00:37 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17128 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgETUAg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 16:00:36 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1590004826; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Zk5SV3kHNSOO0hxqoMAyFI1PvogboO93q1mw9f9cosX1c/aR/XJ3jVXcBwesTKcGuZcLQsw8IY1KUC32thZvMifFbUSFEn114yDC48+bn4abLGXlc5BOIuXUZetqJ+5h3sGHLRVpDuxuSbuf565MqHwppq+WuY+yn4hiT5LGmGI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1590004826; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=UBuDNzqKTyo2LumDwutyHo6YDmEEbfx3UZA1yR0IaSM=; 
        b=WBoe2/fQKLJZ/bQteKdv8A4NwjW8V29+boCgtZYFHZR8k4iZ1iifcKA9XnKpKl2B1o31XVOBs+GEvhtRmEFqIGmAfdj9J2Vhgef41KaY5BMxNddA26WDnSk95TFRvNmoBH7aFMc1HqA5OsO7D9QXaHq4GemxOR89X1KX/WBUZwk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [100.109.105.145] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1590004825852524.7824924859126; Wed, 20 May 2020 22:00:25 +0200 (CEST)
Subject: Re: [PATCH 2/2] Let package manager override CFLAGS and CPPFLAGS
To:     Eric Biggers <ebiggers@kernel.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
References: <20200515205649.1670512-1-Jes.Sorensen@gmail.com>
 <20200515205649.1670512-3-Jes.Sorensen@gmail.com>
 <20200520025445.GB3510@sol.localdomain>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <b68911dc-cd2b-b97a-8068-9fee05a08014@trained-monkey.org>
Date:   Wed, 20 May 2020 16:00:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520025445.GB3510@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/19/20 10:54 PM, Eric Biggers wrote:
> On Fri, May 15, 2020 at 04:56:49PM -0400, Jes Sorensen wrote:
>> From: Jes Sorensen <jsorensen@fb.com>
>>
>> Package managers such as RPM wants to build everything with their
>> preferred flags, and we shouldn't hard override flags.
>>
>> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
>> ---
>>  Makefile | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index c5f46f4..0c2a621 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -32,7 +32,7 @@ cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
>>  #### Common compiler flags.  You can add additional flags by defining CFLAGS
>>  #### and/or CPPFLAGS in the environment or on the 'make' command line.
> 
> The above comment needs to be updated.

I'll fix that

>> -override CFLAGS := -O2 -Wall -Wundef				\
>> +CFLAGS := -O2 -Wall -Wundef				\
>>  	$(call cc-option,-Wdeclaration-after-statement)		\
>>  	$(call cc-option,-Wmissing-prototypes)			\
>>  	$(call cc-option,-Wstrict-prototypes)			\
>> @@ -40,7 +40,7 @@ override CFLAGS := -O2 -Wall -Wundef				\
>>  	$(call cc-option,-Wimplicit-fallthrough)		\
>>  	$(CFLAGS)
> 
> The user's $(CFLAGS) is already added at the end, so the -O2 can already be
> overridden, e.g. with -O0.  Is your concern just that this is bad practice?

I do think it's bad practice to hard add them, we should make
recommendations, but not policy. However, more importantly rpm fails the
build. It uses specific CFLAGS to do debug builds, and if the binary
ends up with build flags that do not match, it fails.

> Also, did you intentionally leave $(CFLAGS) at the end, rather than remove it as
> might be expected?

That was an oversight, I'll fix that.

>> -override CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
>> +CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> 
> -D_FILE_OFFSET_BITS=64 is required for correctness.
> So I think this part is good as-is.

Sounds good!

I'll send out an updated patchset shortly.

Cheers,
Jes


