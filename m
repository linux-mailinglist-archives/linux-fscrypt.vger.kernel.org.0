Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE556C26C0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Mar 2023 02:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCUBFB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Mar 2023 21:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjCUBEu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Mar 2023 21:04:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91292E0E2
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Mar 2023 18:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679360590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7gfEt5BxH35TYNB/j8NBuLawufHDsZHBgUOxppj4aSA=;
        b=JC4ut5GoS1/nR9C5rIdIUJsznr5y6iv9fTkY4JS4pCzx+z0ra8ao+3KPYFMlXMm46B3mES
        bevWdTqmodVopwMtyKZ/oXTRttbWBtwltA0ztQztrjaSDavUiF8U547D70vuFvUfq0xKwG
        Vt/PebSVhxEXVTzCWyY7cOlduHCZGtw=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-6Vji0BolMd2P3UDoqQj2Xw-1; Mon, 20 Mar 2023 21:03:09 -0400
X-MC-Unique: 6Vji0BolMd2P3UDoqQj2Xw-1
Received: by mail-pj1-f70.google.com with SMTP id pa10-20020a17090b264a00b0023b4d15f656so123555pjb.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Mar 2023 18:03:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679360588;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7gfEt5BxH35TYNB/j8NBuLawufHDsZHBgUOxppj4aSA=;
        b=7dCdrnO1dK0lKoME/G5PLjQncj1dQ4lyzeVCw8RvBuJLm0Vm5hjF6Rt37EfRoXK8L9
         NrvWfUnNsRtiJehImbzz5vUpTUOTxVAyY2J/9X7bfpTU7tvxz2wAx71s94XBlIWEt55R
         SYUg2sfRqIyDPZu32EtnWa1OHHcixi8X6Ap1OnjullHll5PiaokGo2AxRmPBZ1UeU6mC
         jzHXbrfjdWQxmbS0yIIAWWWY/iww98DZFTdaq/SCA5bnw58xVBBTkqLU8gg7pg3bRBuH
         jw2E6QPiTr1Ymv1Xt+vwKH7PYuWXrhgPkRe84n7r+M3SEonj+6VcZ26RDT/Xe983NE1O
         lsXw==
X-Gm-Message-State: AO0yUKX8Jyp05XuDERcjuqu/F3MsjynPSXB73xPfJ2asQ9G8n7/p7ajb
        q9KjjT3rtZSo+XZMrl54nE3Ugf8W0GYaHnje/pKkJ0US+SLTGxIhkDuii8C1UIAMFofe8qvUmDS
        WnMAXjxR7M8Y3WgGIlD49rL3MnSZxdjrjitML
X-Received: by 2002:a17:902:cf48:b0:19f:1f0a:97f1 with SMTP id e8-20020a170902cf4800b0019f1f0a97f1mr412311plg.30.1679360588119;
        Mon, 20 Mar 2023 18:03:08 -0700 (PDT)
X-Google-Smtp-Source: AK7set8dStI0+KBBJvcsAHFzGjSOydnPpBmdDxrtEFiZa8Ad3nlzRhbsrKn7vCogQmsZTwruLfbjiA==
X-Received: by 2002:a17:902:cf48:b0:19f:1f0a:97f1 with SMTP id e8-20020a170902cf4800b0019f1f0a97f1mr412292plg.30.1679360587847;
        Mon, 20 Mar 2023 18:03:07 -0700 (PDT)
Received: from [10.72.12.59] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t20-20020a1709028c9400b001992fc0a8eesm7305802plo.174.2023.03.20.18.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 18:03:07 -0700 (PDT)
Message-ID: <4a910d6c-3642-6df1-8600-c6ae587a4282@redhat.com>
Date:   Tue, 21 Mar 2023 09:03:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Is there any userland implementations of fscrypt
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Luis Henriques <lhenriques@suse.de>, linux-fscrypt@vger.kernel.org
References: <ffa49a00-4b3f-eeb3-6db8-11509fd08c9b@redhat.com>
 <20230320211908.GC1434@sol.localdomain>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230320211908.GC1434@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 21/03/2023 05:19, Eric Biggers wrote:
> [+Cc linux-fscrypt]
>
> On Mon, Mar 20, 2023 at 06:49:29PM +0800, Xiubo Li wrote:
>> Hi Eric,
>>
>> BTW, I am planing to support the fscrypt in userspace ceph client. Is there
>> any userland implementation of fscrypt ? If no then what should I use
>> instead ?
>>
> I assume that you mean userspace code that encrypts files the same way the
> kernel does?

Yeah, a library just likes the fs/crypto/ in kernel space.

I found the libkcapi, Linux Kernel Crypto API User Space Interface 
Library(http://www.chronox.de/libkcapi.html)  seems exposing the APIs 
from crypto/ not the fs/crypto/.

> There's some code in xfstests that reproduces all the fscrypt encryption for
> testing purposes
> (https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/src/fscrypt-crypt-util.c?h=for-next).
> It does *not* use production-quality implementations of the algorithms, though.
> It just has minimal implementations for testing without depending on OpenSSL.

This is performed in software.

> Similar testing code can also be found in Android's vts_kernel_encryption_test
> (https://android.googlesource.com/platform/test/vts-testcase/kernel/+/refs/heads/master/encryption).
> It uses BoringSSL for the algorithms when possible, but unlike the xfstest it
> does not test filenames encryption.

This too.

> There's also some code in mkfs.ubifs in mtd-utils
> (http://git.infradead.org/mtd-utils.git) that supports creating encrypted files.
> However, it's outdated since it only supports policy version 1.
>
> Which algorithms do you need to support?  The HKDF-SHA512 + AES-256-XTS +
> AES-256-CTS combo shouldn't be hard to support if your program can depend on
> OpenSSL (1.1.0 or later).

Yeah, ceph has already depended on the OpenSSL.

I think the OpenSSL will be the best choice for now.

Thanks Eric,

- Xiubo


> - Eric
>

