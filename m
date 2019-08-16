Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DC78FDC2
	for <lists+linux-fscrypt@lfdr.de>; Fri, 16 Aug 2019 10:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfHPI0Z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 16 Aug 2019 04:26:25 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37457 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHPI0Y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 16 Aug 2019 04:26:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id z11so744040wrt.4;
        Fri, 16 Aug 2019 01:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=56fPS/dgJdCSM/wPNRnGXBen8t9t2W1bcanq5wh0TUQ=;
        b=PRw7PPE4b5LWXqiKs/xktokPR+OlURF/RNAvkR94hWvmbIsBuK7puDw+UFq7xRA1FL
         OIAs+ufv3BHCchuwmyq7w10SCIdzC3O60RbCS5kIRtlg81B9C+J8UY9dHBahbqW5hXPp
         KtrQTsqX66YqtX0EksHtPZGqQ1oK7AtuWJnDbX3BXh7fRo/GdhY0njCYS+lEjN6Y6uMK
         VIqNj92B+wmEKRmbUSFfeoIfFAy2Ng8LzVXI/ZjuF5j6CdEMuw0cMRCyRo6L5ipuLCDW
         nS2JTw5tQCjMBELlp2Ebh7TIUb0i5slThjRilKBgRS+WKuSQ2AN1BLtsP+envGss2N6n
         vy4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=56fPS/dgJdCSM/wPNRnGXBen8t9t2W1bcanq5wh0TUQ=;
        b=ACZgiySydOHfPepqxcR2Mh7Dsni2VCEklMcxcdrqzFdroCZil9LydnZQEndRdfGi59
         m8GOnDayNSa6nXu9q6K2eJ6i2QbJ042Ez0mS1/M2P/kR06jpKyKBS4IjXjia/xDZ+wHX
         0uk7muLPZj8UyjwhqxePK3IodVfp7fRsnzZRmtoJsVvlctDVshLmGEGC/6fk3m2QhtFt
         WdsbX70f7Zxa7nAXG0QVod1sfxX9e0r8I/vcN/lGmBDd+lcHMgvIWWscstHNOGw8W2ji
         2p63517a3d0R1DGxiKDm/IY5D2tKQN8j2ebrKpNzxnGEh7SAyKxsXTXGAnqPHa68mkQe
         YdHA==
X-Gm-Message-State: APjAAAUwz/oe27EPNawSjXu3Jz2zzTZA8OsS3LXMLG329SE09EZkMKUt
        sQ1dmBGU1OxBrPLZZ7s9sk4=
X-Google-Smtp-Source: APXvYqyGOIj1aB2EpmHGuZNQG3fAHhYs4PTy/JhagxqHTt62717Sh77M0+5CTHy949ACc/NSB0K/Wg==
X-Received: by 2002:adf:fe08:: with SMTP id n8mr8983932wrr.60.1565943982177;
        Fri, 16 Aug 2019 01:26:22 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id m23sm6314419wml.41.2019.08.16.01.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2019 01:26:21 -0700 (PDT)
Subject: Re: [PATCH v12 0/4] crypto: switch to crypto API for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
 <1463bca3-77dc-42be-7624-e8eaf5cfbf32@gmail.com>
 <CAKv+Gu9CtMMAjtjfR=uuB-+x0Lhy8gnme2HhExckW+eVZ8B_Ow@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <d509ce52-1ae1-f785-fe5a-7d5a0e2bc8d0@gmail.com>
Date:   Fri, 16 Aug 2019 10:26:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9CtMMAjtjfR=uuB-+x0Lhy8gnme2HhExckW+eVZ8B_Ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 16/08/2019 10:18, Ard Biesheuvel wrote:
> On Fri, 16 Aug 2019 at 10:29, Milan Broz <gmazyland@gmail.com> wrote:
>>
>> Hi Ard,
>>
>> On 15/08/2019 21:28, Ard Biesheuvel wrote:
>>> Changes since v10:
>>> - Drop patches against fscrypt and dm-crypt - these will be routed via the
>>>   respective maintainer trees during the next cycle
>>
>> I tested the previous dm-crypt patches (I also try to keep them in my kernel.org tree),
>> it works and looks fine to me (and I like the final cleanup :)
>>
>> Once all maintainers are happy with the current state, I think it should go to
>> the next release (5.4; IMO both ESSIV API and dm-crypt changes).
>> Maybe you could keep sending dm-crypt patches in the end of the series (to help testing it)?
>>
> 
> OK. But we'll need to coordinate a bit so that the first patch (the
> one that introduces the template) is available in both branches,
> otherwise ESSIV will be broken in the dm branch until it hits another
> branch (-next or mainline) that also contains cryptodev.

Yes, I know. I'll ask Mike what is his preference here...
For now, it should appear at least in the cryptodev tree :)

...
 
> Any idea about the status of the EBOIV patch?

It is in the queue for 5.4 (should be in linux-next already), I guess 5.4 target is ok here.

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.4

Milan
