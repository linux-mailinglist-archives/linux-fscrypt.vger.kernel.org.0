Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E0B1B2C80
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Apr 2020 18:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgDUQUl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 21 Apr 2020 12:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgDUQUl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 21 Apr 2020 12:20:41 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEC1C061A10
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Apr 2020 09:20:40 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id r19so2123967qtu.11
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Apr 2020 09:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rW38FexhMDjA843b2OeiU5SANY+HLspLMhvJUppQsrw=;
        b=U3dRbqp4ri8DPKpFkFMtFd2Nhak8NUoeQO4Wnd5B4c2mTvuqnioKJfz7qxkq9okyjt
         h1wCEBv7DTKV648w7Xb5VUJWeussBa6OYaOo6yHyerhYtGyekQz1/jtJkbioaAZNPu2H
         BRLHEwj6+Eau3rWSr9lgNp9Bl6cdgIOV0qz8VTU8/qUaFTIiiRSgeNa3Aw9HtTJKQQL3
         8RvvUEEYV/rEiVXhyc1ZFYRbnRUqfg8rsdPW+ANDRpZgkHV0XsricUyz/8x86y/1DgoA
         mgi1yIqdYYD/WR5H7pMfquuQLhH2IIfiOn3IP5nc2Jx9AizLgBUimWRbXdZ96xf15Fbx
         37PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rW38FexhMDjA843b2OeiU5SANY+HLspLMhvJUppQsrw=;
        b=lgothqJEKt127Qmdrv/XdUFqW5WlPQUVRVFqV4eIZ7couYWdfTpmoRHH+uc8+w7n0F
         zIR5QtI39tbxvCa+aKZ2rpIhV+4hb9lS82jHJDcs99gkglXzYzbzkgH+h8Y4GEP7KKY/
         WKy25kOz152KB1KU+nlQOvoRt9X6CphbZWxLwT6MdIjoXqWk0+s8wWJlCGcltlNa5B+Y
         /cXiSB9VAAgOLl8kHSIrujza3kNXKt4eE0SU7ENo7ezmsAitroGMTrYxWrSp/XABzzsk
         ZrbREotJgDxIsmCpRJ+OhucwoHonoQmCsAwSQAR1GKLYvROg3CfPUbnNfeOhWmK1Vj0L
         E7vg==
X-Gm-Message-State: AGi0PuaIQNgRVn+fI+eS+j88jM08D2Jypl3ksh2SDW2Yx9v+2Cf+vOrp
        fLqWfvbObqg19TdK0DIbkyqGGr9KqeY=
X-Google-Smtp-Source: APiQypLdI6fTzK22TThGj4wagV2ueRhzxi6yooU/FDOmHMdbTiNm2/QveR+dbKyr8szqGci5B+f6/g==
X-Received: by 2002:ac8:554a:: with SMTP id o10mr23137077qtr.221.1587486039888;
        Tue, 21 Apr 2020 09:20:39 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d1::10c4? ([2620:10d:c091:480::1:bf76])
        by smtp.gmail.com with ESMTPSA id n31sm2101382qtc.36.2020.04.21.09.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 09:20:39 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 3/9] Move fsverity_descriptor definition to libfsverity.h
To:     Eric Biggers <ebiggers@kernel.org>, Jes Sorensen <jsorensen@fb.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
 <20200312214758.343212-4-Jes.Sorensen@gmail.com>
 <20200322045722.GC111151@sol.localdomain>
 <ebca4865-60e7-c61e-b335-c2962482643b@fb.com>
 <20200421161611.GA95716@gmail.com>
Message-ID: <dbdd7247-f624-bbee-da12-0dd74bca73bd@gmail.com>
Date:   Tue, 21 Apr 2020 12:20:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421161611.GA95716@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 4/21/20 12:16 PM, Eric Biggers wrote:
> On Tue, Apr 21, 2020 at 12:07:07PM -0400, Jes Sorensen wrote:
>> On 3/22/20 12:57 AM, Eric Biggers wrote:
>>> I thought there was no need for this to be part of the library API?
>>
>> Hi Eric,
>>
>> Been busy working on RPM support, but looking at this again now. Given
>> that the fsverity signature is a hash of the descriptor, I don't see how
>> we can avoid this?
>>
> 
> struct fsverity_descriptor isn't signed directly; it's hashed as an intermediate
> step in libfsverity_compute_digest().  So why would the library user need the
> definition of 'struct fsverity_descriptor'?

Hi Eric,

You're right, I actually moved it to libfsverity_private.h already, but
it's in the new patches I am working on.

I pushed it all to git.kernel.org, but I still need to address some of
the issues you responded about. I'll post an update to this when I have
worked through your list of comments. Most noticeable is that I had to
rework the read API to make it work with RPM, but you can find my
current tree here (libfsverity branch):
https://git.kernel.org/pub/scm/linux/kernel/git/jes/fsverity-utils.git/

Current RPM work is here:
https://github.com/jessorensen/rpm/tree/rpm-fsverity

Cheers,
Jes
