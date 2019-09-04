Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1846A80CA
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Sep 2019 13:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbfIDLBd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Sep 2019 07:01:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40598 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbfIDLBd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Sep 2019 07:01:33 -0400
Received: by mail-wm1-f65.google.com with SMTP id t9so3142832wmi.5;
        Wed, 04 Sep 2019 04:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aiCDqJNilYcMlqpj9RhS+m7CTUNRMuH0wMXQB4/ydNs=;
        b=AJvJyEe3o4RSGAQNm7ptP1O9prm45dP1+pi00k0IfH3U/XrhBxx7zwLVXtSjob/dui
         MggxUaQ0PbxWippH3czqsid6AltkQG8NJyvvbV42/4ysz0VuxLKjr75ukbx02Lc73cz+
         19ccaj3MQB44iWLwj9BYme9iPt46NnpjzEGZC+Er4ZBg/gefJXGZXUCODbPaQ52a5Ke2
         ISRc4EgSYUdogV4/Gk/5kbiy91X82gAHRJHBizyKWsAxncG1dFGlTzdulwfmIZcMHSen
         9Rd2U2BJGaiEgoV3hSvF1XfAZkkX+Fm6KVlzejqaQKW1eR50Qo9rHplFkqZANA9WI8oB
         Z/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aiCDqJNilYcMlqpj9RhS+m7CTUNRMuH0wMXQB4/ydNs=;
        b=jlaOnl/HR+5wGxeWe2PcQSS4iyXFj6rF+FLhNrPdfAOdWW8qEguJu/YapFnon4NBVn
         Wa3Z3J88YgahBQ3hchogHJQRb2Pmm6yAjpeWQUK5ffvqsKZaV9o6yklc5Qf/X8Z2QcYk
         TtuY0a9NjE/SSTRYDB58M9ZqCJNGyGUqI3H/3jHUiwJlIXd/wKR2XivsM9yxVjnWJ4lC
         Jtq8FkGTrf+CQzSr4pIKw0mLwEoGRiF9pcJff1G/Z1lZINDZqU1HLI2YzzSudMXnUwkZ
         xSBMleC05eGEI9n1SlqeG41Z4WEo2CPIDwnp45eG6T/+YH5336leFp6PNI1ME+T2m0iK
         YepA==
X-Gm-Message-State: APjAAAUZlL/jogC5epItm4QXNRO25c1Fx+6+R0yrB7OhqLwHRa+le/Hm
        v4I9HgRj5did9v2aPSexWrI=
X-Google-Smtp-Source: APXvYqyxoU5bw4NMVPG7sTFGi+Sd6Ec/4zLMmAvb9SW6PPWUSkkQ4NnaA3Eu+Q68qKNxGMbGI6HLTg==
X-Received: by 2002:a05:600c:2105:: with SMTP id u5mr4155388wml.150.1567594891095;
        Wed, 04 Sep 2019 04:01:31 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id e30sm32581785wra.48.2019.09.04.04.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 04:01:30 -0700 (PDT)
Subject: Re: [PATCH v13 6/6] md: dm-crypt: omit parsing of the encapsulated
 cipher
To:     Mike Snitzer <snitzer@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
 <20190819141738.1231-7-ard.biesheuvel@linaro.org>
 <20190903185827.GD13472@redhat.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <403192f0-d1c4-0c60-5af1-7dee8516d629@gmail.com>
Date:   Wed, 4 Sep 2019 13:01:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903185827.GD13472@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 03/09/2019 20:58, Mike Snitzer wrote:
> On Mon, Aug 19 2019 at 10:17am -0400,
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> 
>> Only the ESSIV IV generation mode used to use cc->cipher so it could
>> instantiate the bare cipher used to encrypt the IV. However, this is
>> now taken care of by the ESSIV template, and so no users of cc->cipher
>> remain. So remove it altogether.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> 
> Might be wise to bump the dm-crypt target's version number (from
> {1, 19, 0} to {1, 20, 0}) at the end of this patch too though...

The function should be exactly the same, dependencies on needed modules are set.

In cryptsetup we always report dm target + kernel version,
so we know that since version 5.4 it uses crypto API for ESSIV.
I think version bump here is really not so important.

Just my two cents :)

Anyway, thanks everyone.

Milan
