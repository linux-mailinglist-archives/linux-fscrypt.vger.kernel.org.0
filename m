Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4AF491172
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jan 2022 22:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243375AbiAQVyy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jan 2022 16:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiAQVyx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jan 2022 16:54:53 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE1EC06173F
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jan 2022 13:54:53 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id j85so20956707qke.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jan 2022 13:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KmBygC3q5AQG8qkNJvnSnx+ggl7+9U+ombjnJKusFG4=;
        b=BBYk7pWCxTpa4e9gEBi36zq0wZnDK1j8g3Khe3W2pLKftHSHr/CXDUEoyfqz3ooNbi
         Glv8rYMWVGazEcND3kjnCvRMhHh/gu6xQWjwk8OJcUpOewIl+l/ejIwlhSRThY2N0OVs
         mwTbFhmbf+K+mhRd0FmNjgwoVw20osV7MBe8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KmBygC3q5AQG8qkNJvnSnx+ggl7+9U+ombjnJKusFG4=;
        b=OPri/8OCIj++se5JZ+csmB8i9ZGDcRATsD2zyCiEJRoYxHnLS7t8wJJvJpthVGcwqJ
         S6itw8cEO362/O9n3JZtR3EXSEMXTvXNrznmLe5eIFeSidPxnHdPaz9kytU2qiab87EQ
         Vz9HDLBCyccOTO3aUAPyqz4L/UuOZhtC2rHsxsCfXPgWl8CHFrJvP7WxbHCPfqWz59QM
         ZDeziXMf4ZlOCM7aCQ/xw6CpH4LgSdIJzM5GL9H8dm0ckLCKEzzv1aT3u/ZDYFPTBowh
         N8wBzuJM4hzBi1BZL8m3Wv5mhYSaZZ7MQaNiQyn0T336bcaR6TG/mIpDTgx+fXQ1b/K5
         /73Q==
X-Gm-Message-State: AOAM530bsjZwF++biLRUxcC3A346BkYUGscg3v7voY/TurvNtHPQJh4o
        2OYx/DdB5rnVqMPMqSK7D4a1Kg==
X-Google-Smtp-Source: ABdhPJxaMz1oYURs6e5lMt7vVVBbGEnFSB7TjiLRH+xlZuiq3V/0TG+DoST9VWbXv6HeYfW5osR6TA==
X-Received: by 2002:a37:aad8:: with SMTP id t207mr15930861qke.216.1642456492290;
        Mon, 17 Jan 2022 13:54:52 -0800 (PST)
Received: from nitro.local (bras-base-mtrlpq5031w-grc-32-216-209-220-181.dsl.bell.ca. [216.209.220.181])
        by smtp.gmail.com with ESMTPSA id f9sm9371606qkp.94.2022.01.17.13.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 13:54:51 -0800 (PST)
Date:   Mon, 17 Jan 2022 16:54:49 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>, dhowells@redhat.com,
        dwmw2@infradead.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.ibm.com, ebiggers@kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
Message-ID: <20220117215449.2qboqd3nmsky2g3w@nitro.local>
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
 <YeV+jkGg6mpQdRID@zx2c4.com>
 <20220117165933.l3762ppcbj5jxicc@meerkat.local>
 <392d28fa-7a2c-867a-5fbb-640064461eb7@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <392d28fa-7a2c-867a-5fbb-640064461eb7@maciej.szmigiero.name>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 17, 2022 at 09:59:22PM +0100, Maciej S. Szmigiero wrote:
> > I am concerned that ed25519 private key management is very rudimentary -- more
> > often than not it is just kept somewhere on disk, often without any passphrase
> > encryption.
> > 
> > With all its legacy warts, GnuPG at least has decent support for hardware
> > off-load via OpenPGP smartcards or TPM integration in GnuPG 2.3, but the best
> > we have with ed25519 is passhprase protection as implemented in minisign (and
> 
> I am not sure that I understood your point here correctly, but GnuPG
> already supports ed25519 keys, including stored on a smartcard - for
> example, on a YubiKey [1].

Yes, I know, but you cannot use ed25519-capable OpenPGP smartcards to create
non-PGP signatures. The discussion was about using ed25519 signatures
directly (e.g. like signify/minisign do). Jason pointed out to me on IRC that
it's possible to do it with YubiHSM, but it's an expensive device ($650 USD
from Yubico).

> While the current software support for ed25519 might be limited, there
> is certainly progress being made, RFC 8410 allowed these algos for X.509
> certificates.
> Support for such certificates is already implemented in OpenSSL [2].
> 
> ECDSA, on the other hand, is very fragile with respect to random number
> generation at signing time.
> We know that people got burned here in the past.

I think this is taking us far away from the main topic (which
signing/verification standards to use in-kernel).

-K
