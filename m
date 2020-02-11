Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D93159BEE
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2020 23:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgBKWJY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Feb 2020 17:09:24 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43013 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgBKWJY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Feb 2020 17:09:24 -0500
Received: by mail-pl1-f194.google.com with SMTP id p11so94240plq.10
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Feb 2020 14:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SMF/k0wFUSlzRWoCd1eLqvIrml24aq6HU2zpaPfy8xY=;
        b=rZQ0P6w3ecXtBsaP8Lzckb+ro6RlN+rwO/DidQOufkeug+8NGFOs2eaeDx6TgYP+sM
         0lY9H0AVjt46XVNQSFSYqpqXyFfWX8wcVnw3za/PF2BbuCPUinfdtQ1H3XpcXuy6IP3j
         JocC9IgdJGRs8cnnHmkpXFcjAPFQDh6ThUbgNyuzH9ZQxvYsTCLEjpZT2CZiMx9j6FpG
         r5mF8SzO1GmKUQy0i9D5aw6G/M/Etcdt6jbbCAoY0lfuZtdcLCuVuizedB//9l4rkXf2
         kqpyyPZuRddzgacGm7TgDsOWuU+8sewd6uqXAC/KmYed8xsEn8GEr+gg1wow7t+Z1U8g
         BKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SMF/k0wFUSlzRWoCd1eLqvIrml24aq6HU2zpaPfy8xY=;
        b=UgfNNzo57vbOUvQAWEi9VcmOHFR2rg46JeX/OLTDoVmPtHzlhCYn9bqCTmrArBLLuk
         G1xwuJ+rVJtAX7YUEyGjZHh0aEHBbQXzGIpXFj0MkOlhPo4ftZlM4FVexpYP7klR0Ell
         Jg5oXs3KdrI4B1X1oSzTlN0QUFbPwUb/kLzO7QaUhOCSh0V3EKkLMfU1Nz+oJ3hGdyGm
         rkm9vHGet5FEaG4Vtbufxz46fZzMaTeZ6fKTmOQbGE49tv32IMp54RZx9AwJvXT3n/T7
         YE5A5OHoRBiDe55m4Ed5Yf7oNwmyVyRgY2P+9xTumfIFiQ/Dtm8KK/GcIa4+smB3+rQS
         S0CQ==
X-Gm-Message-State: APjAAAVWqVxT3zlf58ixXTO7WW2eQDD+NBjM2+CTVRr+IUAv9oe+pE1h
        Chm+KzCrZ+DrwUu0J4XvsJk=
X-Google-Smtp-Source: APXvYqzDyHlcp7hyEinBJBG9SLtQdLTeErIjS8xITY8ZsqWcTC3LUkj0FbqsYWxdiY3ZngLJmmVdHA==
X-Received: by 2002:a17:90a:ac0f:: with SMTP id o15mr5995108pjq.133.1581458963969;
        Tue, 11 Feb 2020 14:09:23 -0800 (PST)
Received: from ?IPv6:2620:10d:c082:1055::1a29? ([2620:10d:c090:200::e626])
        by smtp.gmail.com with ESMTPSA id d69sm5761271pfd.72.2020.02.11.14.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 14:09:23 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 0/7] Split fsverity-utils into a shared library
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
 <20200211192209.GA870@sol.localdomain>
Message-ID: <b49b4367-51e7-f62a-6209-b46a6880824b@gmail.com>
Date:   Tue, 11 Feb 2020 17:09:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200211192209.GA870@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2/11/20 2:22 PM, Eric Biggers wrote:
> Hi Jes,
> 
> On Mon, Feb 10, 2020 at 07:00:30PM -0500, Jes Sorensen wrote:
>> From: Jes Sorensen <jsorensen@fb.com>
>> If we can agree on the approach, then I am happy to deal with the full
>> libtoolification etc.
> 
> Before we do all this work, can you take a step back and explain the use case so
> that we can be sure it's really worthwhile?
> 
> fsverity_cmd_enable() and fsverity_cmd_measure() would just be trivial wrappers
> around the FS_IOC_ENABLE_VERITY and FS_IOC_MEASURE_VERITY ioctls, so they don't
> need a library.  [Aside: I'd suggest calling these fsverity_enable() and
> fsverity_measure(), and leaving "cmd" for the command-line wrappers.] 
> 
> That leaves signing as the only real point of the library.  But do you actually
> need to be able to *sign* the files via the rpm binary, or do you just need to
> be able to install already-created signatures?  I.e., can the signatures instead
> just be created with 'fsverity sign' when building the RPMs?

So I basically want to be able to carry verity signatures in RPM as RPM
internal data, similar to how it supports IMA signatures. I want to be
able to install those without relying on post-install scripts and
signature files being distributed as actual files that gets installed,
just to have to remove them. This is how IMA support is integrated into
RPM as well.

Right now the RPM approach for signatures involves two steps, a build
digest phase, and a sign the digest phase.

The reason I included enable and measure was for completeness. I don't
care wildly about those.

> Separately, before you start building something around fs-verity's builtin
> signature verification support, have you also considered adding support for
> fs-verity to IMA?  I.e., using the fs-verity hashing mechanism with the IMA
> signature mechanism.  The IMA maintainer has been expressed interested in that.
> If rpm already supports IMA signatures, maybe that way would be a better fit?

I looked at IMA and it is overly complex. It is not obvious to me how
you would get around that without the full complexity of IMA? The beauty
of fsverity's approach is the simplicity of relying on just the kernel
keyring for validation of the signature. If you have explicit
suggestions, I am certainly happy to look at it.

Thanks,
Jes
