Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D1E6BBCB1
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 19:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjCOSuv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 14:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjCOSut (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 14:50:49 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392FA37717
        for <linux-fscrypt@vger.kernel.org>; Wed, 15 Mar 2023 11:50:48 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id h11so5592348ild.11
        for <linux-fscrypt@vger.kernel.org>; Wed, 15 Mar 2023 11:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678906247;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kMDOjIg1OZYhHj5a/39EqMyTxnoFfJ9P5mxbiPc4tCk=;
        b=UaBf/AzGD4sW9EI38zMM2xcZVHP7vP4SBcY2NXhuSolw+c2TTsfXpyv9nnodEAeQPP
         wWxWVyE6JakaISEu9kZHS03rANBIlcf1VsRT53fIZd/FBxnElrXjJcU/o67dOya85BwC
         gOWE+FXguFXVyRrP5/YFmcJ1W48lDEB1V7ESe9vhje6qThTncYlU2DKgouJa5EzypYo8
         PUwVO/6GQCeU1c0G21jCL4ce+MXKqa0l7itYdF0SAdkLZ5p1o+MZpeOaOSoaRfcbcuLW
         Gs+smbNDuQCZkWzikUwfjY3KnEcgmhREc/qWNPyYlvp5eTben9XGsGn8wSCw2b+j//yG
         VA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678906247;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kMDOjIg1OZYhHj5a/39EqMyTxnoFfJ9P5mxbiPc4tCk=;
        b=18CiJ21GDbDsYoFQwJFgQAPzciXt19GILVtBHED0SEMJcMQJlh6qTaJB4U8JbiWyWL
         8PHZN/0iKylOJjB4aRMBvSpP82R0lnkQtzsse63CkYL39taYQ5Zxcl/pah0ZY8WB9YTy
         fce0i819EWnDqASMzp74F38EUjeSvOyjEo0puOBP2GJstYAgnp76WVwo2PnihBqIUzOB
         MZqNblquAWVMFDjPBH41HozXGa+vHk6jEWjknE8k/IYgPEB9rercXHNVMDH8QbDD2f94
         ZTCMYryPVrthRPWhrNiR5w7nEC4EQ4QDqlQFVbNRcQfnyK+WwI5D+yQvjNHpSr1F+oR1
         1aDw==
X-Gm-Message-State: AO0yUKVfAREoXIrhvN6foSPQcq5Zcht9QcJ2Yof/FeYNzB2xS3UMF+l4
        +n3rxpMvKswwbXGq4bjsF7kLGrC8drFKP+oMRjDOmw==
X-Google-Smtp-Source: AK7set8YaDEyPvkGP0zpBMAOFYP8zP5aSmCoARlfjp4edDco6gg/mBPWJIdlZTUnlOiZWutlqxK+HA==
X-Received: by 2002:a05:6e02:1a88:b0:316:ef1e:5e1f with SMTP id k8-20020a056e021a8800b00316ef1e5e1fmr189939ilv.1.1678906247545;
        Wed, 15 Mar 2023 11:50:47 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id s17-20020a92c5d1000000b00313f1b861b7sm1816590ilt.51.2023.03.15.11.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 11:50:47 -0700 (PDT)
Message-ID: <881ec7d4-8169-70f6-2e29-131ca9ca0573@kernel.dk>
Date:   Wed, 15 Mar 2023 12:50:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v3 5/6] blk-mq: return actual keyslot error in
 blk_insert_cloned_request()
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
References: <20230315183907.53675-1-ebiggers@kernel.org>
 <20230315183907.53675-6-ebiggers@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230315183907.53675-6-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 3/15/23 12:39 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> To avoid hiding information, pass on the error code from
> blk_crypto_rq_get_keyslot() instead of always using BLK_STS_IOERR.

Maybe just fold this with the previous patch?

-- 
Jens Axboe


