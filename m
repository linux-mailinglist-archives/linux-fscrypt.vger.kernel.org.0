Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 117F74CCE6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 13:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfFTLaD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 07:30:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37905 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfFTLaD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 07:30:03 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so2786633wmj.3;
        Thu, 20 Jun 2019 04:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pS5S9mCD3ELnfbNEhV9YPpFLxOX8S/sVLcPGWO1xWlU=;
        b=CzMyp6Accmw+rOsbIWW8YexNrQvVEiduw35vfculij9cJWb2Ii4BoAFUiJ1uM0puXH
         Wm6F20L9zmZKfIj8g9sL32cDSl61RlCD5qSJB88JI8tr4BP3O5ZAshMUJ6bMSY7wpC0J
         WqARKiG6cKxhsht0na8YMV9UluzlxB/9bGVnm0XqamznEBQvOop2zM7nE9+wshm9N1r+
         AhgrqsETQ6fvtBpdvox7GAiir7/Nm4CaZK5pwNL7SA/jggxybl2nBPQeH1zVxqEbDbAl
         nsKb+vONxleVSctB95Ago/EE+V1mn2ANqok296NRAZzvTS/UsdiZ+Rjpum5twXz7OIj9
         yuLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pS5S9mCD3ELnfbNEhV9YPpFLxOX8S/sVLcPGWO1xWlU=;
        b=CX+WEZwttF6ofjUfAXzX361i9JI1rWCgiX4/ry0Kx1QTWdRcySQxU0CdLWf3k4d9b5
         4ntczCOU0sUoWMAZbLUk8OiFbb9N7tk6iRAChEjqF6y9tPhxcska4mFxP7WiyOlAib5v
         tNRymSR8bonP34LoCrmAI90zxxzGupdHfYGJXNMUobFYul8MR9eBlrtwljUKKElUvQi4
         MMBmWk9LhFa3TVL/KgIxQayWCkft1pFivmLbaCFJjAvGF3pY7Gaj3/OKhrpaGHEDEzE7
         pfSJRuoqaOtARWTplV9FmAsi4njTkUzJVFymItJAplBxhSiad7UN3fKWpoE8wvcUMmPG
         2f2w==
X-Gm-Message-State: APjAAAWxKExtTn60paMTOet1GVuyt1ueaL3oVvW9FV0LD7qsyvvjRp+x
        wsgg9cMvN+JCxay+aDZIJRw=
X-Google-Smtp-Source: APXvYqznP6WHtpYtJyJi9GFxJNaxps6TOLDTpjuZYIoRdsnWIN1xkd4nGw94wBVXwc4F8aCvQi69aw==
X-Received: by 2002:a1c:6555:: with SMTP id z82mr2619967wmb.129.1561030200877;
        Thu, 20 Jun 2019 04:30:00 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id c1sm6140007wrh.1.2019.06.20.04.29.59
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 04:30:00 -0700 (PDT)
Subject: Re: [PATCH v3 6/6] crypto: arm64/aes - implement accelerated
 ESSIV/CBC mode
To:     Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-7-ard.biesheuvel@linaro.org>
 <20190619223710.GC33328@gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <ed3113fb-8f5f-7045-75ba-b63e4ed669ff@gmail.com>
Date:   Thu, 20 Jun 2019 13:29:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190619223710.GC33328@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 20/06/2019 00:37, Eric Biggers wrote:
> On Wed, Jun 19, 2019 at 06:29:21PM +0200, Ard Biesheuvel wrote:
>> Add an accelerated version of the 'essiv(cbc(aes),aes,sha256)'
>> skcipher, which is used by fscrypt, and in some cases, by dm-crypt.
>> This avoids a separate call into the AES cipher for every invocation.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> I'm not sure we should bother with this, since fscrypt normally uses AES-256-XTS
> for contents encryption.  AES-128-CBC-ESSIV support was only added because
> people wanted something that is fast on low-powered embedded devices with crypto
> accelerators such as CAAM or CESA that don't support XTS.
> 
> In the case of Android, the CDD doesn't even allow AES-128-CBC-ESSIV with
> file-based encryption (fscrypt).  It's still the default for "full disk
> encryption" (which uses dm-crypt), but that's being deprecated.
> 
> So maybe dm-crypt users will want this, but I don't think it's very useful for
> fscrypt.

The aes-cbc-essiv:sha256 is still default for plain cryptsetup devices
(LUKS uses XTS for several years as a default already).

The reason is compatibility with older distros (if there is no cipher mode
specification in crypttab for plain device, switching default could cause data corruption).

But I think initscripts now enforce cipher and keysize crypttab options for some time,
so I can probably switch the default to XTS for plain devices soon.
(We have already compile time option for it anyway.)

IOW intention for dm-crypt is to slightly deprecate CBC mode use for all types of devices.

Milan
