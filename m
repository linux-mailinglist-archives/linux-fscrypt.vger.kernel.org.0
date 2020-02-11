Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F06D159D3B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Feb 2020 00:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgBKXfs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Feb 2020 18:35:48 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39801 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgBKXfs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Feb 2020 18:35:48 -0500
Received: by mail-pf1-f193.google.com with SMTP id 84so232347pfy.6
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Feb 2020 15:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IC9pg1iUP8Tt6ukz1cZv+3u7OguCrgsQEZeIjq9WJFY=;
        b=CMs6wpQkR2jhpQiZQNFHDSHBomJJ5fi4DFmcLDQ89Oqk8jWfgezzS+pVpGvIZYj36r
         htM7Cj4u78ORg55JaOL0sAoknJi3I8wLYgODCM70eGEecIIt6dOifmzt/5pJKwx4S5p4
         eHyaRR2YIpZ7bL6JcUZFS6a/GrnCrc6GVoZQxIDBZSeRMHy2+fPF1MpBw41t0/V8gO7y
         Ev9+5O1nT01PBTWy3PFXnRGaq4HovEfiR0z/kWQb1ZyD/ciY6KaUztQauS8YzT/AOOqt
         Ko7bJ0Lw6DvkgOujITATY4cB6CTcVP/AjaZLYG82jHrrLJ/P9YmMlXPINv9VBMqKSxyi
         telw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IC9pg1iUP8Tt6ukz1cZv+3u7OguCrgsQEZeIjq9WJFY=;
        b=QrpmhU3fLaev2xWd3UIgXREyeXJRn4WiFJNT2418g9eLL3CUD60DuQz9w2xAOFhIpg
         ikXA6LK10zw/6dtjGI6EpSQqQsgMVm9O7q6A5UusHP5WT7zSPZPTiV9mJzGS20ZA9/qX
         AdpNNdsP1hSvh10MkH97HAEwuoRbvHHbhcyoWFRGC5N58ST+1tx983nhCHYCq5PRxK7a
         hO5q5UeyEEf2EO5ZRDi85V3evCMyB6HNMAMJdReKhk2x5KoAL59XrJCcmHk7CaDE52S7
         kDsash22AovRq0htmDTK+NpIQ6QT4iVUdyEP9jPhILW2njd+lbXT9mYLyBHvWZZFc500
         zQiA==
X-Gm-Message-State: APjAAAVELrzZkcp7oKaP+Z9xr2iv2Q876XvPuxlSO2SkZQw7enIWXs+y
        mx07XLI8BWMYexE+tv4xNBE=
X-Google-Smtp-Source: APXvYqzayYAlYJJVmqWTt+ferz/TpUwEwq7MgoA4crhtkJ2Z77YUf2ZEvH1qYui1JEhfECLPun4SqQ==
X-Received: by 2002:a63:cd04:: with SMTP id i4mr5747458pgg.281.1581464147754;
        Tue, 11 Feb 2020 15:35:47 -0800 (PST)
Received: from ?IPv6:2620:10d:c082:1055::1a29? ([2620:10d:c090:200::e626])
        by smtp.gmail.com with ESMTPSA id 28sm5245639pgl.42.2020.02.11.15.35.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 15:35:47 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 0/7] Split fsverity-utils into a shared library
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
 <20200211192209.GA870@sol.localdomain>
 <b49b4367-51e7-f62a-6209-b46a6880824b@gmail.com>
 <20200211231454.GB870@sol.localdomain>
Message-ID: <c39f57d5-c9a4-5fbb-3ce3-cd21e90ef921@gmail.com>
Date:   Tue, 11 Feb 2020 18:35:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200211231454.GB870@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2/11/20 6:14 PM, Eric Biggers wrote:
> On Tue, Feb 11, 2020 at 05:09:22PM -0500, Jes Sorensen wrote:
>> On 2/11/20 2:22 PM, Eric Biggers wrote:
>>> Hi Jes,
>> So I basically want to be able to carry verity signatures in RPM as RPM
>> internal data, similar to how it supports IMA signatures. I want to be
>> able to install those without relying on post-install scripts and
>> signature files being distributed as actual files that gets installed,
>> just to have to remove them. This is how IMA support is integrated into
>> RPM as well.
>>
>> Right now the RPM approach for signatures involves two steps, a build
>> digest phase, and a sign the digest phase.
>>
>> The reason I included enable and measure was for completeness. I don't
>> care wildly about those.
> 
> So the signing happens when the RPM is built, not when it's installed?  Are you
> sure you actually need a library and not just 'fsverity sign' called from a
> build script?

So the way RPM is handling these is to calculate the digest in one
place, and sign it in another. Basically the signing is a second step,
post build, using the rpmsign command. Shelling out is not a good fit
for this model.

>>> Separately, before you start building something around fs-verity's builtin
>>> signature verification support, have you also considered adding support for
>>> fs-verity to IMA?  I.e., using the fs-verity hashing mechanism with the IMA
>>> signature mechanism.  The IMA maintainer has been expressed interested in that.
>>> If rpm already supports IMA signatures, maybe that way would be a better fit?
>>
>> I looked at IMA and it is overly complex. It is not obvious to me how
>> you would get around that without the full complexity of IMA? The beauty
>> of fsverity's approach is the simplicity of relying on just the kernel
>> keyring for validation of the signature. If you have explicit
>> suggestions, I am certainly happy to look at it.
> 
> fs-verity's builtin signature verification feature is simple, but does it
> actually do what you need?  Note that unlike IMA, it doesn't provide an
> in-kernel policy about which files have to have signatures and which don't.
> I.e., to get any authenticity guarantee, before using any files that are
> supposed to be protected by fs-verity, userspace has to manually check whether
> the fs-verity bit is actually set.  Is that part of your design?

Totally aware of this, and it fits the model I am looking at.

Jes
