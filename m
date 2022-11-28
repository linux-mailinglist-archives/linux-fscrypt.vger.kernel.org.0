Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A11063A96B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Nov 2022 14:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiK1N1V (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Nov 2022 08:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiK1N1U (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Nov 2022 08:27:20 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6913D63CE;
        Mon, 28 Nov 2022 05:27:20 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id x13-20020a17090a46cd00b00218f611b6e9so10143327pjg.1;
        Mon, 28 Nov 2022 05:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2vb+1bLPVb5hfsxkqEVzykK6ocW2O4D2G72jVhvRYEA=;
        b=mMb6EGxy3dJgY4UHWRr8qZRri14boj7PoJL9Z4wdous2HPmdydQsttpT8j+/bTWIGT
         mqZHDpU5J0pRW72gOI+L4tVDKVq/8eV3pd3HKc1drdMWAteMzBJAoPv503g3U6WH/y5q
         8qXYxSsANnwIUr1k8rs9f74iZfJhzVUqeQg5VnJsVy58ESfFqQc0I/scjouJWYXDtsON
         aKUMcAI/Ughmm0BSjJfuJ7KEhOHH6ki2gB/bIlyERq5uXFn7YO5ML18lluOFRdA3i8Jn
         82lcTj9HVND7alL9ZJkmM3CDxeAcKuIVF4XW9NucUrg/wzSohWu6uLRob9h7YH5IV91v
         Q77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2vb+1bLPVb5hfsxkqEVzykK6ocW2O4D2G72jVhvRYEA=;
        b=elAVLzDlIqM9NciYQaaUgfVeuJykFNPZMGcOOPvfyB5P8YDkTpOtMT62DtlWUjiyUk
         ZZJFnAxAxM5poNZe2Wr9QdQdyjxc+uX/OgNA0iKzQfN0vabI4l/ZBfHRVd6W+Ds1VSy3
         QiMBEiWDEYzq+Tj73JHKt/TsumcwDRmnujOcChh+8y7yOSqbZaoPwjAAU7ZN4tSYOSsB
         8mC68Xrv5XDlvV59VCDGXH48ITZqMN+0lDjd12L9ZWnIshNKxQmFagLzUttYiaI6ik2Q
         b+gDGE/PU+xaAePOx0w8chTx57EEzNtN++4l0PXCBlNJ6I5duxI5Yi37U2OVYhe8x8P5
         IvLA==
X-Gm-Message-State: ANoB5pleVtm/4zjAZ5jSJsVX1I+94nVFheb3rTHXUkH8tux6q8rPWvdG
        8T4dtCObQGNDUA5yqunTMfA=
X-Google-Smtp-Source: AA0mqf4yAdWIx9CNloBV4uqDw6hFxOCLHtgOUNWxsE+XC8R+wuoLFUtAMlaENLJmo+WRUTudWogsDw==
X-Received: by 2002:a17:902:708a:b0:189:7372:1451 with SMTP id z10-20020a170902708a00b0018973721451mr12229858plk.122.1669642039923;
        Mon, 28 Nov 2022 05:27:19 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-72.three.co.id. [180.214.232.72])
        by smtp.gmail.com with ESMTPSA id v2-20020a626102000000b005609d3d3008sm8261580pfb.171.2022.11.28.05.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 05:27:19 -0800 (PST)
Message-ID: <42624542-6ccb-26a5-db98-d7944972246e@gmail.com>
Date:   Mon, 28 Nov 2022 20:26:38 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 1/2] blk-crypto: Add support for SM4-XTS blk crypto
 mode
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20221125121630.87793-1-tianjia.zhang@linux.alibaba.com>
 <20221125121630.87793-2-tianjia.zhang@linux.alibaba.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221125121630.87793-2-tianjia.zhang@linux.alibaba.com>
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
> SM4 is a symmetric algorithm widely used in China, and SM4-XTS is also
> used to encrypt length-preserving data, these algoritms are mandatory
> in many scenarios. This patch enables the use of SM4-XTS algorithm in
> block inline encryption, and provides support for fscrypt.
> 

Please reformulate the patch description in imperative mood instead.
Also, take care of wording and punctuation - commas should not be
used for continuing distinct sentences/clauses where separating them
by a full stop is more appropriate.

That is, the description should be:

```
SM4 is a symmetric cipher algorithm widely used in China. The SM4-XTS
variant is used to encrypt length-preserving data.

Enable the algorithm in block inline encryption, as well as enable
fscrypt support.
```

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

