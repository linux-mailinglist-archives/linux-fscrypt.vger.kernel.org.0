Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35D84CCC6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 13:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfFTLXC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 07:23:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38055 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfFTLXB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 07:23:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so2765687wmj.3;
        Thu, 20 Jun 2019 04:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KqQ/0lNgatbAFjvI+UVLmFxYwFfw0GJxlYHEsE9riuI=;
        b=EqwlB9wrZg7QLGcc8q6YnqqCrDzdvMYEbGXNYG+FRDI5VxzNfajkiCb20/BAbsgSDN
         Vef7665o/zWK17Zp1xRcjyn6ZuIkR5fWhViv4hP5sWLzwEVuW+t/ohGYx6/2/3EKgZmC
         SIBY5QU9w0krvt+zTIkUukCY3KDAjmZz6aEDUyaN+Gd7k+hmRVIBeXbl5svknvqxgENX
         j9dLelMWUZj97HgfgBxHcrWJ5oG1X7OC07ctG8ubYz+EMOASHlvKYnxzRCPPu/FH3FWN
         zqujdMNR2NoKYC0LE12m3vOlgJYa2lBzQJP7PtpPgDvUwlw07PPEVe9x+tITHlhIAMoI
         ZO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KqQ/0lNgatbAFjvI+UVLmFxYwFfw0GJxlYHEsE9riuI=;
        b=aZLJbbCzep8ZRP+73wiamc3g5rV9e4Vl0qnxVcxaJRbSc3LeyPu5BsWOMYbQ4KT0Bp
         WDy53DFjnfvEGhbi4QDEKgBbeIN0DYXXkU+YfIRiPU0MQci2IEIQ7BKrBWVWXW1/3qUO
         X1ZCSgeLxswgdK2emQqpJtGEloDd88HXQyTtVrzFVX0w1iuMkNfBPPq/V8K37N5xz6Ls
         OD2rzUXE0Kq2U6dwhRcrURIvV3vk1IH6WRylW9bnBhtFD4VlaAUJz6gzKaCG8TPvV14t
         MmLhMPuZs4qfiPUY/MSirwzmNn9CbFkGRI5XECO4dA3ErcVPs10ytIgLIF11c+d9WysL
         f86g==
X-Gm-Message-State: APjAAAV9MOQ2CuHdOyGMRLWGlG+gzqFlFuwpxoLAEIFgiOxwYLS7qd/Q
        xOE6HxfMo0RzYt64FdATe9y7Xx9D6KebeA==
X-Google-Smtp-Source: APXvYqw6DquVhD4CuXe0+0nmPPcROjtQRWpC/Htr2sGU0pUZBI7eYfu7fFX+7QUJi13w7zzOaFK3sQ==
X-Received: by 2002:a1c:f61a:: with SMTP id w26mr2678480wmc.75.1561029779427;
        Thu, 20 Jun 2019 04:22:59 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id n1sm16511014wrx.39.2019.06.20.04.22.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 04:22:58 -0700 (PDT)
Subject: Re: [PATCH v3 0/6] crypto: switch to crypto API for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <459f5760-3a1c-719d-2b44-824ba6283dd7@gmail.com>
Date:   Thu, 20 Jun 2019 13:22:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 19/06/2019 18:29, Ard Biesheuvel wrote:
> This series creates an ESSIV template that produces a skcipher or AEAD
> transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
> (or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
> encapsulated sync or async skcipher/aead by passing through all operations,
> while using the cipher/shash pair to transform the input IV into an ESSIV
> output IV.
> 
> This matches what both users of ESSIV in the kernel do, and so it is proposed
> as a replacement for those, in patches #2 and #4.
> 
> This code has been tested using the fscrypt test suggested by Eric
> (generic/549), as well as the mode-test script suggested by Milan for
> the dm-crypt case. I also tested the aead case in a virtual machine,
> but it definitely needs some wider testing from the dm-crypt experts.
> 
> Changes since v2:
> - fixed a couple of bugs that snuck in after I'd done the bulk of my
>   testing
> - some cosmetic tweaks to the ESSIV template skcipher setkey function
>   to align it with the aead one
> - add a test case for essiv(cbc(aes),aes,sha256)
> - add an accelerated implementation for arm64 that combines the IV
>   derivation and the actual en/decryption in a single asm routine

I run tests for the whole patchset, including some older scripts and seems
it works for dm-crypt now.

For the new CRYPTO_ESSIV option - dm-crypt must unconditionally
select it (we rely on all IV generators availability in userspace),
but that's already done in patch 4.

Thanks,
Milan
