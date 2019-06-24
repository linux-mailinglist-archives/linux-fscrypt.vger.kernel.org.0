Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA8F750289
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Jun 2019 08:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfFXGwQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Jun 2019 02:52:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38550 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFXGwP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Jun 2019 02:52:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id d18so12582676wrs.5;
        Sun, 23 Jun 2019 23:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CXj7EcHXfZQG+ULuS9k1X3crNZy9bY3cT9sIZIipFpE=;
        b=oGaEafgHZd7moSrSQ6D45tbG5l4DdlEkpwFd7sQA8Y0d8IgICxtZkA9d9Rgc/s6uar
         +Sdd/QAAgKObk1xW+UtAh+BXvRyTKDdzsCNtPtkwCFacdHhzAuHwY7wPrUQbYrGhqoHF
         OmeY0bIvQ2kp/7FsYUZ+h4K4wlUSimb2+pie+ZBCkvxdoeevqIDlOmg5EY0tUsm4vvP1
         QgOGOtBugP+cCBPm5h25eeY97jIFwJhckAuufFE6t0QjOqV/d1x2ouqrIAxTo/gjiTpB
         Yo3B34ugM0IhEKINvCWXXlMweJOpSncMlkhZKBSKK4XBwCCsjCzuYPA4B8rSGRa7caId
         cJwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CXj7EcHXfZQG+ULuS9k1X3crNZy9bY3cT9sIZIipFpE=;
        b=d6quRybdwIF6gEwFI+QXGY9laSAHU2oSyLGN+F2fz2CMRLqAIROAVJlOt2A9uYKpA4
         4+Pehx8AFKMQS6j1Lt6AaOq1x82H057PTUIP+HVvYSzFklM/UEOV71RSIcevOhlMsgvH
         roNXEqjDuQXNli+foXAqj4XDEFyO2FR6HXQlaMBOYZA4ffIL96h7ZXm2RSNW+WUXfU76
         SYriuRQK5CryBe6A8g26WXNqAtrIJbXPMWgWNRxUkv7czh10y7slkLqLFgMmFB9A4fsB
         KDm+CqrZO61hXwrCHKW3TCzupRa3Q/KeygEz0CeJPynlOrwtDECNDttJ34xeu7H5x8/L
         2p3g==
X-Gm-Message-State: APjAAAVIO9GzScGTLf1V5fTgcVXwjcZ7nvlH0Iw1HlNXlNcUiGaNLDMv
        UUsM9yL6u12a3I7OZmoXV9U=
X-Google-Smtp-Source: APXvYqy9M0ufMnCjzTHTXqIB8vH/HLBE4Q0+Khju+56/6idlT7wXUBIq+uW9cugeU8pMDf/RnFHqww==
X-Received: by 2002:adf:df10:: with SMTP id y16mr21102817wrl.302.1561359133444;
        Sun, 23 Jun 2019 23:52:13 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id w185sm13479825wma.39.2019.06.23.23.52.12
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 23:52:12 -0700 (PDT)
Subject: Re: [PATCH v4 0/6] crypto: switch to crypto API for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190621080918.22809-1-ard.biesheuvel@arm.com>
 <CAKv+Gu-ZO9Fnfx06XYJ-tp+6nrk0D8TBGa2chmxFW-kjPMmLCw@mail.gmail.com>
 <20190623101241.6cr4sbxyviigu3sz@gondor.apana.org.au>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <5ebd992b-cb01-6dcc-f571-55afbb05c03b@gmail.com>
Date:   Mon, 24 Jun 2019 08:52:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190623101241.6cr4sbxyviigu3sz@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 23/06/2019 12:12, Herbert Xu wrote:
> On Sun, Jun 23, 2019 at 11:30:41AM +0200, Ard Biesheuvel wrote:
>>
>> So with that in mind, I think we should decouple the multi-sector
>> discussion and leave it for a followup series, preferably proposed by
>> someone who also has access to some hardware to prototype it on.
> 
> Yes that makes sense.

Yes.

And TBH, the most important optimization for dm-crypt in this case
is processing 8 512-bytes sectors in 4k encryption block (because page
cache will generate page-sized bios) and with XTS mode and linear IV (plain64),
not ESSIV.

Dm-crypt can use 4k sectors directly, there are only two
blockers - you need LUKS2 to support it, and many devices
just do not advertise physical 4k sectors (many SSDs).
So switching to 4k could cause some problems with partial 4k writes
(after a crash or power-fail).

The plan for the dm-crypt side is more to focus on using 4k native
sectors than this micro-optimization in HW.

Milan
