Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8C0234A5B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 Jul 2020 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733194AbgGaRkp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 31 Jul 2020 13:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732973AbgGaRkp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 31 Jul 2020 13:40:45 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49285C061574
        for <linux-fscrypt@vger.kernel.org>; Fri, 31 Jul 2020 10:40:45 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id a19so8483765qvy.3
        for <linux-fscrypt@vger.kernel.org>; Fri, 31 Jul 2020 10:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5b8eKT5y5KskA+QTSo5NaqnD5JNjajpt9hUsqgHyMPA=;
        b=swUCq2zUyU/s9P2gacLhfJB8170Gd6TpjAt25vsyxYyUN58sdSB5A8isqWilFZ0G/X
         jdXXVUi1fA8RQyzKxCfbDNhIKT7KwFtIbj2/U6BcMY0mmCsvlr8wyEu3k90EgEDFl54b
         jACnQ9MuDRBvCsfz+TppWmLMpYr9oKaZiqUk7Uqcv2g8DbYYHEP3k0pEhCzKb4ojtpAO
         6Ik/c/Mijw1KLv3i9Ndl8OoyuJlo/guhA1euzJHQBZDknVoQBbi4oSv9hFFCIKzPtO1I
         cckU5nSin4okaiJNzRdQW/FedcD8IOr0NcCBRs9AkMI8Z0lE7BHaLMjOFfm4x3xbdCAy
         qgtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5b8eKT5y5KskA+QTSo5NaqnD5JNjajpt9hUsqgHyMPA=;
        b=RXZgSphZHeyrCr63WbYP3BlAddFOorfhZdkqEjwkaOTjjc4CGLQUCRYGM8/c3jR5+N
         S3Zm9D5fpQDiO8CscqTpWNx40t0UpqZ2HG5RqvqGO6a+YRdRpUCf+GeYsuj4J5biv2Tp
         7Qr68Eq95LXl67l2mUYo9nA9/Ciz0Pn6FMUz6r3bZuLQ9yax91fPOJ9mRep6Ube9+rlb
         d/dqFRJjrMcLD4pAnKq7kGfCOVgUCrVzZwIEq9ERWihzo9DOTpd/M0oW44J3B520g1QT
         PmpStpSkT8zc8F9yKClAtGeY0oKa5wSkCWkBtLY59/7F/pUwwrL6QoVwGAkPfH8vDv++
         A7mA==
X-Gm-Message-State: AOAM5307RAhDaGixI/ebIwVX4/RLYxoHLxkRJni8iBsH5YM4Im5XfmNw
        nVr6w5zyrG/2c55bW9ke3Ng=
X-Google-Smtp-Source: ABdhPJxAFI8kDlC/3ECdO9ar9GrmSykkH0mms8X7j1NYCondhlBV6izg/zDHDX7D46B3TTrkLjtkPw==
X-Received: by 2002:a05:6214:1910:: with SMTP id er16mr4966181qvb.228.1596217244341;
        Fri, 31 Jul 2020 10:40:44 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11e1::10da? ([2620:10d:c091:480::1:4a2])
        by smtp.gmail.com with ESMTPSA id s5sm8825129qke.120.2020.07.31.10.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 10:40:43 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 0/7] Split fsverity-utils into a shared library
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jes Sorensen <jsorensen@fb.com>, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com, Chris Mason <clm@fb.com>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
 <20200211192209.GA870@sol.localdomain>
 <b49b4367-51e7-f62a-6209-b46a6880824b@gmail.com>
 <20200211231454.GB870@sol.localdomain>
 <c39f57d5-c9a4-5fbb-3ce3-cd21e90ef921@gmail.com>
 <20200214203510.GA1985@gmail.com>
 <479b0fff-6af2-32e6-a645-03fcfc65ad59@gmail.com>
 <20200730175252.GA1074@sol.localdomain>
Message-ID: <0d5c5b1d-2170-025e-2cc1-75169bb33008@gmail.com>
Date:   Fri, 31 Jul 2020 13:40:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200730175252.GA1074@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 7/30/20 1:52 PM, Eric Biggers wrote:
> On Wed, Feb 19, 2020 at 06:49:07PM -0500, Jes Sorensen wrote:
>>> We'd also need to follow shared library best practices like compiling with
>>> -fvisibility=hidden and marking the API functions explicitly with
>>> __attribute__((visibility("default"))), and setting the 'soname' like
>>> -Wl,-soname=libfsverity.so.0.
>>>
>>> Also, is the GPLv2+ license okay for the use case?
>>
>> Personally I only care about linking it into rpm, which is GPL v2, so
>> from my perspective, that is sufficient. I am also fine making it LGPL,
>> but given it's your code I am stealing, I cannot make that call.
>>
> 
> Hi Jes, I'd like to revisit this, as I'm concerned about future use cases where
> software under other licenses (e.g. LGPL, MIT, or Apache 2.0) might want to use
> libfsverity -- especially if libfsverity grows more functionality.
> 
> Also, fsverity-utils links to OpenSSL, which some people (e.g. Debian) consider
> to be incompatible with GPLv2.
> 
> We think the MIT license (https://opensource.org/licenses/MIT) would offer the
> most flexibility.  Are you okay with changing the license of fsverity-utils to
> MIT?  If so, I'll send a patch and you can give an Acked-by on it.
> 
> Thanks!
> 
> - Eric

Hi Eric,

I went back through my patches to make sure I didn't reuse code from
other GPL projects. I don't see anything that looks like it was reused
except from fsverity-utils itself, so it should be fine.

I think it's fair to relax the license so other projects can link to it.
I would prefer we use the LGPL rather than the MIT license though?

CC'ing Chris Mason as well, since he has the auth to ack it on behalf of
the company.

Cheers,
Jes


