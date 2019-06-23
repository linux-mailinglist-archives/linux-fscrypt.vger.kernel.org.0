Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C164FAF4
	for <lists+linux-fscrypt@lfdr.de>; Sun, 23 Jun 2019 11:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfFWJaz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 23 Jun 2019 05:30:55 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42790 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfFWJaz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 23 Jun 2019 05:30:55 -0400
Received: by mail-io1-f67.google.com with SMTP id u19so1161584ior.9
        for <linux-fscrypt@vger.kernel.org>; Sun, 23 Jun 2019 02:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wvgYQJkZGqcc1lfJilFFMb7xsNi0HiPMMJpo064zefM=;
        b=XIWvSciJXTWxUHdpOJ/Jiw7mhnXChMAz38UwfOCNYhyxtiP5995AZVApj5EI1r64qE
         G5Wb50bCXsb63Sy0BT9k05wbOEaMxUv54DGQFr61UYycrgIvHMzur3LWuloXlUEBCCaw
         dtFMdlCVVo3+ieBGYj2lThfkRy8GABw5srKabwQYjzqsUnZt0LRsesAbKNb+ATr9jcPw
         iah80UTd4lExTLdH1RzhcUQ4it23dakXPQiMyqQpY4Yp0RS8wvEIV6o8w/mkaNN5d98P
         yAk/MjnWrm0JKZw9hhyk9KJDeSjzHSgAZL2sMFJOkgPmwLTOa2yjnFos/mv5KvelBlLz
         29rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wvgYQJkZGqcc1lfJilFFMb7xsNi0HiPMMJpo064zefM=;
        b=qHRNqKXeg0Wy5KbWF3yJn+mk+GOz5zgaGerGFzCRmpSaKTft9ti7ZRzRRgZsjgVHlh
         oIdDWclWpam4BTG7iGapmQJhjCLap3a/I1EteXPZ2/FQHG1z5KTnwO9PJgXA284hwMpa
         K/GDrDlBc3KRwzXAsbwaVuCCN75Nuyshd4x5+VmDYy2UMrXOtoJiWdt3IIvpE1+UltCh
         /xvvRZsHmrheoJzui86VDYhTqDnnW+/azyfAiLY0fu9/xW1Eq+iZwVg909lAYC7yIZIy
         UztQE1b15UtWKTDKWq5PRx9kuz4D3Nb9xbAcAfWyAOiLDxXqmC0EM113uGhVYJF9ogl3
         5zzA==
X-Gm-Message-State: APjAAAXIo7R8Vz6PhFRaTCof4HgkcpQ+CDAai+oLS/3GymalwrA/vWNK
        74JzzoLfX3IvZwPSZe2+cmQAcDT8NKehzbjRE5QL9A==
X-Google-Smtp-Source: APXvYqw231WPDSV0vp3+/kcuJTLLvj6P/KErcOQKt6Gw4rdKpxSKVjzoeHQpp0qSCZAo3xz5kn3MmfYU0+FjLta6sSY=
X-Received: by 2002:a5e:d51a:: with SMTP id e26mr503654iom.71.1561282254656;
 Sun, 23 Jun 2019 02:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190621080918.22809-1-ard.biesheuvel@arm.com>
In-Reply-To: <20190621080918.22809-1-ard.biesheuvel@arm.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 23 Jun 2019 11:30:41 +0200
Message-ID: <CAKv+Gu-ZO9Fnfx06XYJ-tp+6nrk0D8TBGa2chmxFW-kjPMmLCw@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] crypto: switch to crypto API for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 21 Jun 2019 at 10:09, Ard Biesheuvel <ard.biesheuvel@arm.com> wrote:
>
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
...
>
> - given that hardware already exists that can perform en/decryption including
>   ESSIV generation of a range of blocks, it would be useful to encapsulate
>   this in the ESSIV template, and teach at least dm-crypt how to use it
>   (given that it often processes 8 512-byte sectors at a time)

I thought about this a bit more, and it occurred to me that the
capability of issuing several sectors at a time and letting the lower
layers increment the IV between sectors is orthogonal to whether ESSIV
is being used or not, and so it probably belongs in another wrapper.

I.e., if we define a skcipher template like dmplain64le(), which is
defined as taking a sector size as part of the key, and which
increments a 64 LE counter between sectors if multiple are passed, it
can be used not only for ESSIV but also for XTS, which I assume can be
h/w accelerated in the same way.

So with that in mind, I think we should decouple the multi-sector
discussion and leave it for a followup series, preferably proposed by
someone who also has access to some hardware to prototype it on.
