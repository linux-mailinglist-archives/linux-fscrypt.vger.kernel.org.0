Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762E54CD3B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 13:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfFTLyw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 07:54:52 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37422 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfFTLyw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 07:54:52 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so1226692iok.4
        for <linux-fscrypt@vger.kernel.org>; Thu, 20 Jun 2019 04:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4FkvkHqvLzWMKuGvT5HlaO0Xon8bDR4AOszW3W1UHPo=;
        b=jTiFaEM9AYBwT28O0vAOO7Z7siXf9GEq7+nLTrbhQ2hEID45J8EPizhLrPLP9OM4Pd
         dXL379acSYeNBalCGwcRtG4oARuGiWuVIE73jiO3g//w6zC1d4U0HDeTdlii6zx2KJoh
         Clu3iIDV1Sntl0k6P66Me1BQvof01u566vGV70zufviAFRPSs/pIJ27CTI4iJTrI52Yr
         5avyeuBOjWdKi4iPY/Z8yilIVT2KIdWY8WQEPxAjPrRDvdH/ZlPyCG5lO76H+z8JYPFu
         brnOJTFCCwIsSPLvAT+ViL0i1BLLfZYcbS7TC5Zen/4dTbT+T2auNCe0QzQNL2DqGlMe
         WOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4FkvkHqvLzWMKuGvT5HlaO0Xon8bDR4AOszW3W1UHPo=;
        b=si9jjY0BIlHRaL7D6uc/FJfS2xLqNNJJ+9uc0T0yl1huyfnoSvnpdQbp0Akn6UVTUa
         p4R/iyfh7kUMOtZxsFmshvy1NUw3MdryhHBtOOoTLm2y6+FBFbU7Pspp21rwOikc/h2b
         ZRZMQiBmqe+VvD4QNB8L6eecJ4K4UWDcUatmM8pf5vt7/Ox0T0oMwLJcuqj0o3xJMeTW
         F2ePz+whPoxevl0Io/0+XMlWXYuPxOFdk6BXozF3PxZajb5kEHR14d3Nlkn86a+uLyel
         CXVJANdhpbYVYsWl5P71J6aoOZXIeNls9wi5QWYVGnRMnPjBiZWGKfmjoUfJ4LiNEYDO
         GnfA==
X-Gm-Message-State: APjAAAUH6/uEn2RCUrHOv2LDiVKkwEfIIfIxR14+WVN8f2rJ10kCVQxH
        fOLxaJZsP1a1HGzAvLgAdzWJ64H9LVsM4cBymKVjnQ==
X-Google-Smtp-Source: APXvYqw41BwTZDw+7K8vCUqvfiWkTc0lVlvd8y2KFmszNzNT+AGGvfrs0VaISa+owA/muxopKidLO5it/7mQm3yNgGU=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr17448241jar.2.1561031691895;
 Thu, 20 Jun 2019 04:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org> <459f5760-3a1c-719d-2b44-824ba6283dd7@gmail.com>
In-Reply-To: <459f5760-3a1c-719d-2b44-824ba6283dd7@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 13:54:40 +0200
Message-ID: <CAKv+Gu9jk8KxWykTcKeh6k0HUb47wgx7iZYuwwN8AUyErFLXxA@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] crypto: switch to crypto API for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 20 Jun 2019 at 13:22, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 19/06/2019 18:29, Ard Biesheuvel wrote:
> > This series creates an ESSIV template that produces a skcipher or AEAD
> > transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
> > (or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
> > encapsulated sync or async skcipher/aead by passing through all operations,
> > while using the cipher/shash pair to transform the input IV into an ESSIV
> > output IV.
> >
> > This matches what both users of ESSIV in the kernel do, and so it is proposed
> > as a replacement for those, in patches #2 and #4.
> >
> > This code has been tested using the fscrypt test suggested by Eric
> > (generic/549), as well as the mode-test script suggested by Milan for
> > the dm-crypt case. I also tested the aead case in a virtual machine,
> > but it definitely needs some wider testing from the dm-crypt experts.
> >
> > Changes since v2:
> > - fixed a couple of bugs that snuck in after I'd done the bulk of my
> >   testing
> > - some cosmetic tweaks to the ESSIV template skcipher setkey function
> >   to align it with the aead one
> > - add a test case for essiv(cbc(aes),aes,sha256)
> > - add an accelerated implementation for arm64 that combines the IV
> >   derivation and the actual en/decryption in a single asm routine
>
> I run tests for the whole patchset, including some older scripts and seems
> it works for dm-crypt now.
>

Thanks Milan, that is really helpful.

Does this include configurations that combine authenc with essiv?

> For the new CRYPTO_ESSIV option - dm-crypt must unconditionally
> select it (we rely on all IV generators availability in userspace),
> but that's already done in patch 4.
>

Indeed.
