Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3529163A99E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Nov 2022 14:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiK1NeF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Nov 2022 08:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiK1NeE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Nov 2022 08:34:04 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D146E113A;
        Mon, 28 Nov 2022 05:34:03 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id o1so5922170pfp.12;
        Mon, 28 Nov 2022 05:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fto765p2zc65D0Me5bUsSOT+sydzo0/9GtopK7Y3Iug=;
        b=WMcoldEw3inHiCLwHGneCrYXX7erWCJKeivRVeB4LCxWbjBox7BP5i2eEbJiQ0zI14
         o2iGB0qSEd7CRfCT1zmWBPm2LUJQbKNG/V8gV4fkop7owpQuxm6qpJI8SzqkO5069+wS
         WGqA+GUon7kCwrqfRWeXSUWGcoHlrFfjXWO1x/Se5KSe8vj5OESHgQDX/yx6EHOY4ply
         V2bDbeEgR1ngU3N1rS5B3Eq3wbIwB5CXPd01/o7f1ovwCVmWdWud5/6M+9kQ2WxS0vkS
         IfwYSy+F7ivMDhTobSMyOoQqiQxQLyQO9bnjZGlQD2Y2Fp7S2IR/AnYPf7gLtlPnfB4X
         brRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fto765p2zc65D0Me5bUsSOT+sydzo0/9GtopK7Y3Iug=;
        b=I78W/XyoH/k6Fclf+KxsAVeZtIxh0ozVwTfTpMnKqGhtgh+D54Pkf762p6M/MeMj12
         1wjxPQ9mJVrtuI1LAep53/OP3CZfFhLEM3fypMC4JXlla2uEmss01Z3BZ+DY2k4c0pog
         WYl2b7kR7QiC2Pwcg+x5p+e6awPJKmAnl/6Rs1m/e6HMHoaMhEWNUaWQr5i07zI1DNqW
         96+JZzt8ZUI/RgkRDmf/8hwrfxHhk5Y0jygeAYy+dovY1FbQpw9tafRdRJ2abzrzdacs
         0Ce6CzeU2/4atFz0Yb0gPAXU9v8dx+ZGB3Vz31UvOtG5izWem33ogf0Di7qACRlY8Se7
         Wd3g==
X-Gm-Message-State: ANoB5plUZV5H51Jv5QNp83UU7tZ/rvDkUrXA2GJbRxdok2FDFSR5ze3T
        knZspRgP5NAvgV4GshthCR4=
X-Google-Smtp-Source: AA0mqf5LUIz+jBK0rb3drNCtOVI9TXMUtAoSZIcsUXDWSM7g3ZXZSpzNVQwOUgdAerR9td2SkNJWEw==
X-Received: by 2002:a63:548:0:b0:477:b4f4:84c with SMTP id 69-20020a630548000000b00477b4f4084cmr23557786pgf.24.1669642443326;
        Mon, 28 Nov 2022 05:34:03 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-72.three.co.id. [180.214.232.72])
        by smtp.gmail.com with ESMTPSA id ij13-20020a170902ab4d00b001769e6d4fafsm8867977plb.57.2022.11.28.05.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 05:34:02 -0800 (PST)
Message-ID: <1a5e57be-ccff-f281-6e06-be5e59db1d05@gmail.com>
Date:   Mon, 28 Nov 2022 20:33:54 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 2/2] fscrypt: Add SM4 XTS/CTS symmetric algorithm
 support
Content-Language: en-US
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20221125121630.87793-1-tianjia.zhang@linux.alibaba.com>
 <20221125121630.87793-3-tianjia.zhang@linux.alibaba.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221125121630.87793-3-tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 11/25/22 19:16, Tianjia Zhang wrote:
> SM4 is a symmetric algorithm widely used in China, and is even mandatory
> in many scenarios. We need to provide these users with the ability to
> encrypt files or disks using SM4-XTS, and many other algorithms that use
> SM2/3/4 algorithms or their combined algorithm scenarios, these features
> are demanded by many users, this patch enables to use SM4-XTS mode to
> encrypt file content, and use SM4-CBC-CTS to encrypt filename.
> 

Similar reply as [1]. That is, better say:

```
Add support for XTS and CTS mode variant of SM4 algorithm, in similar
fashion to SM2 and SM3. The former is used to encrypt file contents, while
the latter (SM4-CBC-CTS) is used to encrypt filenames. 
```

Thanks.

[1]: https://lore.kernel.org/linux-doc/42624542-6ccb-26a5-db98-d7944972246e@gmail.com/

-- 
An old man doll... just what I always wanted! - Clara

