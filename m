Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BA24E097
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Jun 2019 08:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfFUGo3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Jun 2019 02:44:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39699 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfFUGo3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Jun 2019 02:44:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so5367470wrt.6;
        Thu, 20 Jun 2019 23:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T0c/iajo/VZSQKfb3VczokbIDSIWM9pmHxJ48YeWxjM=;
        b=oelbXbyWzHjuukI+wyIvixgUy/zOkKhyd9yIlXzWtd3PNEHuXSeRRoN3DXOhtwbUoJ
         Vup6PUOykHbB/cAx0fGflV0Mdh858CGw0yBR6xrGVGywP8QkVSa43fCLy4uR9ThUIAy2
         ylCgPojfkdX4bQ36Scix1aJlB3IMjMIbXGPqTh7ReSr62tqCTYp9aUcLdNTulZerjHFE
         vBgVNgTFe3weu2D0PEEMHP779RMcCwxn9nYrF8TAhjXXZR2SaR/G/TQ6F1SBcv5L//lS
         qA1QW2EJ40lIKyc6VVWFboQdIJTIBqNDea59C0o0wB1LEQy0em2H88yOLi6KzsZFxhYV
         AGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T0c/iajo/VZSQKfb3VczokbIDSIWM9pmHxJ48YeWxjM=;
        b=maJUJvC1Gt/H9BJR88PjbcMsixQddfCdGz2Lh6qTkJNX6NwZXsw3ESW6fv7lDvD34H
         e72pnGrdxSVv89fXVPc/ItrMtJN78BGqpaNzBOVGhCWzXuT7e1nDAq4mZYZF3yYrLCLD
         N5xPOSPqkxsRbVlQUfAL+s3WdaVVTrLXZFgZ6Ksa8JP66BAC4kdBxovnfSocUN7O+1fa
         lCb5YnuRI5ukqH8tg+KxdivbksP9HF5PGNk46PnaBnqKnY6sGwzNAnKFL8Bhn/yj/RqF
         uhpOWrR7B0f5P9RaUc2oTtZTrTkd8kK0PilGQZibRD4rRudBSw9jEERYBVsJCQlb+2Qt
         ikaQ==
X-Gm-Message-State: APjAAAU8eRSseSgz/TKRBo/oWlKxnrBpzbcItRIX/te5TXV83i1tk+Q3
        aI1C6fNSbos9S6lXks/ZnVWe2QyC6LJ/Nw==
X-Google-Smtp-Source: APXvYqzUNhVlRMeWRb8OYwodTPHWPCSgiYh8AoPSoPUe7Z6UpPglYu0GAy68wKgG9zQNrtgPeFLatw==
X-Received: by 2002:adf:f38b:: with SMTP id m11mr28209636wro.79.1561099466836;
        Thu, 20 Jun 2019 23:44:26 -0700 (PDT)
Received: from [192.168.8.100] (37-48-48-91.nat.epc.tmcz.cz. [37.48.48.91])
        by smtp.gmail.com with ESMTPSA id a2sm2291158wmj.9.2019.06.20.23.44.25
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 23:44:26 -0700 (PDT)
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper template for ESSIV
 generation
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org>
 <20190620010417.GA722@sol.localdomain>
 <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
 <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
 <20190620125339.gqup5623sw4xrsmi@gondor.apana.org.au>
 <CAKv+Gu_z3oMB-XBHRrNWpXNbSmb4CFC8VNn8s+8bOd-JjiakqQ@mail.gmail.com>
 <20190620134045.fncibzc7eyufd5sj@gondor.apana.org.au>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <8d522740-1c3c-5102-86b8-fb5428a6cb3e@gmail.com>
Date:   Fri, 21 Jun 2019 08:44:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190620134045.fncibzc7eyufd5sj@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 20/06/2019 15:40, Herbert Xu wrote:
> On Thu, Jun 20, 2019 at 03:02:04PM +0200, Ard Biesheuvel wrote:
>>
>> It also depend on how realistic it is that we will need to support
>> arbitrary sector sizes in the future. I mean, if we decide today that
>> essiv() uses an implicit sector size of 4k, we can always add
>> essiv64k() later, rather than adding lots of complexity now that we
>> are never going to use. Note that ESSIV is already more or less
>> deprecated, so there is really no point in inventing these weird and
>> wonderful things if we want people to move to XTS and plain IV
>> generation instead.
> 
> Well whatever we do for ESSIV should also extend to other IV
> generators in dm-crypt so that potentially we can have a single
> interface for dm-crypt multi-sector processing in future (IOW
> you don't have special code for ESSIV vs. other algos).
> 
> That is why we should get the ESSIV interface right as it could
> serve as an example for future implementations.
> 
> What do the dm-crypt people think? Are you ever going to need
> processing in units other than 4K?

For the "technical" limit, dm-crypt supports 512, 1024, 2048 and 4096-byte encryption
sector size (power of two) since commit 8f0009a225171cc1b76a6b443de5137b26e1374b.

As the commit says, the 4k limit is because of page limit where whole IO must fit
(4k is minimal page size).
I do not want to introduce devices that are created on some architecture
and cannot be opened elsewhere with a smaller page size.
But maybe some reason appears, or there is some trick we did not tried...

(I guess fs has the same limits?)

Milan
