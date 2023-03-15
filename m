Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375B66BBCC9
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 19:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbjCOSzg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 14:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCOSzf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 14:55:35 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74F71DBAD
        for <linux-fscrypt@vger.kernel.org>; Wed, 15 Mar 2023 11:55:33 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id b5so8277150iow.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 15 Mar 2023 11:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678906533;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tBRZFYzimKPA6mjNORdkOv4Y2TpAYKv/XmDa+UV/AZA=;
        b=gqdyqQdxZZCobmgNW6+jKTD6luUkT7RaA47VxrzeGkMNEyd8AnZhdIvh+tuBMYBFzn
         xQJGjpl4FyvKStOBHZ7weg/CT2EMc/a5e3mRNIodsnVEQa6TFbfg9i6afKI0LSrjouD9
         8lnEiyr261yTUKX9hB+tLFfLEiXtKZiskQoDwFSIAgPVmJjRykAXCIN0FaPd9x2QDYSe
         vkL3ZtJi+0v8xLS5w/jXg5e4bsLcppkUOhSAgh7DfPS8zg8Des2R7YuoFjiv/iSCzBax
         W5QfMCQhU252NTYpx8AxWei2RDNn38GE1edm4ITB0dghG4spPDfDKOfhbbcrCP8MuRvy
         WSVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678906533;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tBRZFYzimKPA6mjNORdkOv4Y2TpAYKv/XmDa+UV/AZA=;
        b=ofIihTmiI7TTAiM5qWryrKfU9oKCB01DAK3s+FuW/k3XrFIqmCj4n0cuVsXBdEjm0n
         ZHH5BOhP4AD9i14cSyz5bb/tcDb/wXsc99FVYjKM9STqZ4znNDnjCADrNamiV+dh3KK9
         GhooIJbQGrWJWviBUZfGiROOmx78Ib7NzqjchVWVcM+jQYj3gXwmNyGqOVUQZNHqmqZj
         h7ktB7vAqq5afKZqsrUP5ZpgGBCxWNNGtCVs8k/QK1ZCBpqzLLoymGhJhJblXAivgNb1
         Y/bELpkNMjm926l4SKjwo24Kgji7TuKnR9PeEneCT20ip1Ryi7dGN0DXj6avgrCEFmlX
         FSeQ==
X-Gm-Message-State: AO0yUKUGsqpObKrvgN6ZPm6kmOFO92l/0jqN/dONScFwx3IjmosbsqNG
        akVyKlLbbU0SM86zzO5FYoS3FA==
X-Google-Smtp-Source: AK7set/sZGfB9IpYhHW6fDDCyBmsiy+lorektPh+uRuSnbz0YZ+huTH8uQmt1UDL+BtbI08y+Sdkbw==
X-Received: by 2002:a5e:a902:0:b0:74c:7ef2:fd79 with SMTP id c2-20020a5ea902000000b0074c7ef2fd79mr179277iod.2.1678906533210;
        Wed, 15 Mar 2023 11:55:33 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a11-20020a056638018b00b004057f1dc889sm1854224jaq.130.2023.03.15.11.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 11:55:32 -0700 (PDT)
Message-ID: <c930024d-64d8-901d-972b-9786f7803011@kernel.dk>
Date:   Wed, 15 Mar 2023 12:55:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v3 5/6] blk-mq: return actual keyslot error in
 blk_insert_cloned_request()
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
References: <20230315183907.53675-1-ebiggers@kernel.org>
 <20230315183907.53675-6-ebiggers@kernel.org>
 <881ec7d4-8169-70f6-2e29-131ca9ca0573@kernel.dk>
 <20230315185418.GD975@sol.localdomain>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230315185418.GD975@sol.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 3/15/23 12:54 PM, Eric Biggers wrote:
> On Wed, Mar 15, 2023 at 12:50:45PM -0600, Jens Axboe wrote:
>> On 3/15/23 12:39 PM, Eric Biggers wrote:
>>> From: Eric Biggers <ebiggers@google.com>
>>>
>>> To avoid hiding information, pass on the error code from
>>> blk_crypto_rq_get_keyslot() instead of always using BLK_STS_IOERR.
>>
>> Maybe just fold this with the previous patch?
> 
> I'd prefer to keep the behavior change separate from the cleanup.

OK fair enough, not a big deal to me. Series looks fine as far as
I'm concerned. Not loving the extra additions in the completion path,
but I suppose there's no way around that.

-- 
Jens Axboe


