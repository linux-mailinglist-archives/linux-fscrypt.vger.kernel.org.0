Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930F647FDD
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jun 2019 12:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfFQKj6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jun 2019 06:39:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42638 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFQKj6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jun 2019 06:39:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id x17so9359506wrl.9;
        Mon, 17 Jun 2019 03:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=POQUQG4MYB5xEHchrmHz7dMXS7q/nCg6auQxpiFJVc8=;
        b=SyGcWgtgdAELquNabM+nexfBqTjNd4wqDx+BMeVDp2zKguLYpfaJd8f8Tp8ZgTRDTP
         5unNl9XeVCGRuzKTqNV2Jwz6s/ScWZnIBnJdmokb0nmN9i98EKKSQwJDHizG0fJPC9qK
         t32Jp2KHAOqlHuuPpcxVqHspzqRtT2LBwahgRL+vnPqQ9gawO/beN00XaF8N86VdiOZH
         22sciINSBhtIQhUexugsvn4RMg0z+foU9cALIdOZdbcuz6z2BDYG5w3gzsAKyDjpXr+g
         WjJ9Pp306eDSJ7rZMj9+bMRqjSazuZk2Z/gutwnmKAxEY0viiaBAsffTNIqdsgelic5K
         EWjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=POQUQG4MYB5xEHchrmHz7dMXS7q/nCg6auQxpiFJVc8=;
        b=pJbUcpkPI9sNEA72sJSYy5/Tz/WQX22hivvLIq21R4pdA940rrlZFbqQIDGTpQUQ0F
         L1p45cSNILNpRVD7onL8m8uxkPveXVBtCkH2/ZqrlqNZqcYRUs85HgmHqsnYp24hRlug
         5PPtbR/BjyqHfeE6G2u0V7jgqxbJuG/m0UzHpFqhr84EBz7/oUvTpkapG7O6RVerwOIX
         H451gJfL8EGHEparuhvXcjCoblvDi6XyuqM0rsn7WqsSg/2XZzK8BHjfFF+GfrPdVixn
         xJhj974hjOgWuaIlrLTHwgqkIQy+SiEq1BgRTE/V1TD/uy/6W01WVbgQgr8gpuljxwff
         9A7g==
X-Gm-Message-State: APjAAAUwb6Kc0/TJtpAlpSBfS+ztOaB2n0y1Byy1En+4evzY/SS+099f
        GryoDxTqlCh0TMhBOyNei2A=
X-Google-Smtp-Source: APXvYqzTNH7Cwt878QuhzyY23K0t/xeUu+dLMMLRZoWPCvFvYZd++TVVE10lVz3uqAU/v/QTuo+niQ==
X-Received: by 2002:adf:fb47:: with SMTP id c7mr39219046wrs.116.1560767995778;
        Mon, 17 Jun 2019 03:39:55 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id c11sm8392658wrs.97.2019.06.17.03.39.54
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 03:39:55 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain>
 <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
 <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com>
Date:   Mon, 17 Jun 2019 12:39:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 17/06/2019 11:15, Ard Biesheuvel wrote:
>> I will also add that going the skcipher route rather than shash will
>> allow hardware tfm providers like CryptoCell that can do the ESSIV
>> part in hardware implement that as a single API call and/or hardware
>> invocation flow.
>> For those system that benefit from hardware providers this can be beneficial.
>>
> 
> Ah yes, thanks for reminding me. There was some debate in the past
> about this, but I don't remember the details.
> 
> I think implementing essiv() as a skcipher template is indeed going to
> be the best approach, I will look into that.

For ESSIV (that is de-facto standard now), I think there is no problem
to move it to crypto API.

The problem is with some other IV generators in dm-crypt.

Some do a lot of more work than just IV (it is hackish, it can modify data, this applies
for loop AES "lmk" and compatible TrueCrypt "tcw" IV implementations).

For these I would strongly say it should remain "hacked" inside dm-crypt only
(it is unusable for anything else than disk encryption and should not be visible outside).

Moreover, it is purely legacy code - we provide it for users can access old systems only.

If you end with rewriting all IVs as templates, I think it is not a good idea.

If it is only about ESSIV, and patch for dm-crypt is simple, it is a reasonable approach.

(The same applies for simple dmcryp IVs like "plain" "plain64", "plain64be and "benbi" that
are just linear IVs in various encoded variants.)

Milan
