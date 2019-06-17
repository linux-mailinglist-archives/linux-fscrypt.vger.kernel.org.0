Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C934A4858F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jun 2019 16:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfFQOfX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jun 2019 10:35:23 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:56315 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfFQOfX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jun 2019 10:35:23 -0400
Received: by mail-wm1-f53.google.com with SMTP id a15so9540803wmj.5;
        Mon, 17 Jun 2019 07:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=22htbqOLr0XYz5dY7iw/lqEMIjyN2LQkWGZjVe5M4U8=;
        b=fI66Ni32h1PR3wfJoTAbfdZDDaLgESfZYApsZogQeUMoYJDd/Boy2vbkE6YF+k+yql
         MH8jSfByY7FJMOjuxJ2lgcG/Pos4a6jXGNzmXePYpHaEg23C9FOIWdh8LqfL0vPWnqoF
         xMry9mVJKfF2Fp4Ek+k7uhTh6mg5ojYhv7nIOHWVYs771NIyHdFRVw6Rde1WU28vDYav
         2Tc3F5hmIDFKt9CSfuEKg21KZ+Vd6k+GH5/VmStiWK/uzHW9+QOWXM5vfoJF/Fty5jmZ
         svD7pZpA+qVuRrQlU8n/L43V7xu5jWD+KLE+WG8zNC6KTi7bX/2aPy6BZhNtaJhX5bVy
         ve+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=22htbqOLr0XYz5dY7iw/lqEMIjyN2LQkWGZjVe5M4U8=;
        b=p5uc7XIn06cmwmfxqqPW7n25sad+UGMF/9emXo4fC/4spMeADAG3PK4pAYQI/XDeBH
         NUG4yW47HDcYVwFSfcKifrsNS1uuESaTEB3n/z2jgjtqvLtYUcEZEVSg/vQJbffqaCJL
         t6Vv1R6c0CK8djBSot6L1wqzs8O6j/AscLk+UVKnq0RjC6/FMYRH9dvyxVhQSOpjXEzy
         IrJQ2fdHKE23w/eG7aoRCnCizwSnfekJAPZda9dXe3UPxNWb57F0M5L25bo9tjLrwcKm
         KH75nLb5DHIUF5SHVGjm4PZmZMymqj9rJwHz0dHWDthfskQzPeqCB+4EXLElXUQ+cXs/
         9grg==
X-Gm-Message-State: APjAAAVrkiiIzxv6JXAWswH6Tw4w4BAX+V81Y1khIUt+IOvdx+6JPl3J
        TIsQVj6sq+GLwCG5aLAuKiw=
X-Google-Smtp-Source: APXvYqyiWunU5GABbzLQ1ZPZBKBxDoyu00ONFMmHa1x5ZM5ZTq56hMLLh1u4keP0X1Qfw/imFppu6Q==
X-Received: by 2002:a1c:544d:: with SMTP id p13mr20250977wmi.78.1560782120445;
        Mon, 17 Jun 2019 07:35:20 -0700 (PDT)
Received: from [10.43.17.44] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j18sm13561342wre.23.2019.06.17.07.35.19
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 07:35:19 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain>
 <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
 <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
 <8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com>
 <CAKv+Gu9sb0t6EC=MwVfqTw5TKtatK-c8k3ryNUhV8O0876NV7g@mail.gmail.com>
 <CAKv+Gu-LFShLW-Tt7hwBpni1vQRvv7k+L_bpP-wU86x88v+eRg@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <90214c3d-55ef-cc3a-3a04-f200d6f96cfd@gmail.com>
Date:   Mon, 17 Jun 2019 16:35:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu-LFShLW-Tt7hwBpni1vQRvv7k+L_bpP-wU86x88v+eRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 17/06/2019 15:59, Ard Biesheuvel wrote:
> 
> So my main question/showstopper at the moment is: which modes do we
> need to support for ESSIV? Only CBC? Any skcipher? Or both skciphers
> and AEADs?

Support, or cover by internal test? I think you nee to support everything
what dmcrypt currently allows, if you want to port dmcrypt to new API.

I know of many systems that use aes-xts-essiv:sha256 (it does not make sense
much but people just use it).

Some people use serpent and twofish, but we allow any cipher that fits...

For the start, run this
https://gitlab.com/cryptsetup/cryptsetup/blob/master/tests/mode-test

In other words, if you add some additional limit, we are breaking backward compatibility.
(Despite the configuration is "wrong" from the security point of view.)

Milan
