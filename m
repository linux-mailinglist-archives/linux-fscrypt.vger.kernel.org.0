Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02D91B3186
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Apr 2020 23:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgDUVAO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 21 Apr 2020 17:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725850AbgDUVAN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 21 Apr 2020 17:00:13 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA863C0610D5
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Apr 2020 14:00:13 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id w29so12854334qtv.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Apr 2020 14:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MsMgm+oaFW0Y93ssDMILczpRMoqdMbigrzNzX1C8H+M=;
        b=kI+2wcVmy9BlO+M1gRX3nzRnYt+tJzOZjHMxZA1sQcJWDL79B6hNcqdPJonft64CLI
         S4bSgf7etLgOJfX95YJtm+s2f0+i5rx3XKHFVLY7zzBHV8eOBHuzh/WCz0XBS58P4nf8
         4NOAmsoD3lF/py8epohXKQH1wyea1+MN+/hwxWkKy1ETCUh8LpSuGdxuq81ZUuLlUIp5
         P2YwZutIDQjM3Hz1TnLcX7Nx7mJuO96OgTvQt3k7qPEzWhIg0Gc5vTids3g2mZ1j/orl
         vLPcgMLCyd0vedxOE2rxAo/Bx6BlQQKVcOBO6M33W4aCSI15ySubVSWcGH/t0I2cT8R0
         /jtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MsMgm+oaFW0Y93ssDMILczpRMoqdMbigrzNzX1C8H+M=;
        b=L7Xo84x3+O8UvR9FIIEMsaIXvQQafyF5EqhT5A6AB0rPxxtd+A0fQvVwJcx8v0sY2m
         WLCQ1I/dKPLilSFq1sOHfUD/HJ7pLuvk8klPPrrrUDNyb+UR5k9C7AXYsBLLXbwVXHte
         GsBRRUWFxF6gMrUfd/3Kjz1T2eKYp56ugbkDsuvoK3BWEQlC9VF5gjfT/kvcorFVdx3N
         Y5KhyABDCGxPcFfurKnnE/ojWEVDvkGgkLtoVmD8f6uWPWoXn5Fl3ScsfYxHc+Bia5O1
         56jk312GxI05iFr3G8RgEra2vOekhw9LOiIDznxxZNoElBULcV2snkYcvCS2mD3FIKiq
         TUaw==
X-Gm-Message-State: AGi0PuYRwglnrWHlWscB5J7cCheEIr7NMPnB3pQtIPjzFhrTAQ/b0W0X
        8ClHMDUdkXTLYoiyIYJgexk=
X-Google-Smtp-Source: APiQypKnP8S1UIEEwZ0ZULIgK2doIE+Bh3w5lVCMwXUz37AZIrABtldoAHXzeCaY10NepN0GFGNdbQ==
X-Received: by 2002:ac8:39a2:: with SMTP id v31mr22898592qte.373.1587502812639;
        Tue, 21 Apr 2020 14:00:12 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d1::10c4? ([2620:10d:c091:480::1:bf76])
        by smtp.gmail.com with ESMTPSA id n67sm2525715qke.88.2020.04.21.14.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 14:00:11 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 1/9] Build basic shared library framework
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
 <20200312214758.343212-2-Jes.Sorensen@gmail.com>
 <20200322053349.GG111151@sol.localdomain>
Message-ID: <f09aba36-316b-cc42-b3ab-84a94b722fd6@gmail.com>
Date:   Tue, 21 Apr 2020 17:00:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200322053349.GG111151@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 3/22/20 1:33 AM, Eric Biggers wrote:
> On Thu, Mar 12, 2020 at 05:47:50PM -0400, Jes Sorensen wrote:
>> From: Jes Sorensen <jsorensen@fb.com>
>>
>> This introduces a dummy shared library to start moving things into.
>>
>> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
>> ---
>>  Makefile    | 18 +++++++++++++++---
>>  libverity.c | 10 ++++++++++
>>  2 files changed, 25 insertions(+), 3 deletions(-)
>>  create mode 100644 libverity.c
>>
>> diff --git a/Makefile b/Makefile
>> index b9c09b9..bb85896 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1,20 +1,32 @@
>>  EXE := fsverity
>> +LIB := libfsverity.so
>>  CFLAGS := -O2 -Wall
>>  CPPFLAGS := -D_FILE_OFFSET_BITS=64
>>  LDLIBS := -lcrypto
>>  DESTDIR := /usr/local
>> +LIBDIR := /usr/lib64
> 
> LIBDIR isn't used at all.  I assume you meant for it to be location where the
> library gets installed?  The proper way to handle installation locations
> (assuming we stay with a plain Makefile and not move to another build system)
> would be:
> 
> PREFIX ?= /usr/local
> BINDIR ?= $(PREFIX)/bin
> INCDIR ?= $(PREFIX)/include
> LIBDIR ?= $(PREFIX)/lib
> 
> then install binaries into $(DESTDIR)$(BINDIR), headers into
> $(DESTDIR)$(INCDIR), and libraries into $(DESTDIR)$(LIBDIR).
> This matches the conventions for autoconf.

I pushed a change to git which addresses this, I still need to address
the soname though.

Long term it might be nice to switch to autoconf/automake, at the same
time I love dealing with it about as much as going to the dentist for a
root canal.

Cheers,
Jes
