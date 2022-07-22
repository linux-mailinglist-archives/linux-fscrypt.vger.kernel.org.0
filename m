Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B197457DC33
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Jul 2022 10:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbiGVIU6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 22 Jul 2022 04:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiGVIU5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 22 Jul 2022 04:20:57 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20FF9E2A8;
        Fri, 22 Jul 2022 01:20:55 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id tk8so7312634ejc.7;
        Fri, 22 Jul 2022 01:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CGzPRcx2BHVSrFEMXPI3kWcYnIUX7tUCN7uqV/cjft0=;
        b=PWGtfYRarcGyKtNCGxysQCWrZOtk/zroPWIZv+HPeKpV377AMIwlWpo4VVFa5jJJiC
         lf1/88Xm/ZYO0YzBByj9zAsY1rzE6GEgmVmcV50ZYAvDQgrckyA0eJPEWMzmMislbXJc
         bfqsTqoYtqXntObtkUQs5SZcNBIzRYL97lceKemMF7N+d03soLQhho3WrzAdebh62K1H
         b81YOJ5I/N2Zi7nAf9sW8UJZ+y9S58iAOzL7iGB2LoIZkEZ4Ec6JOy1VA2psocfxCS/j
         V47HOzNh9Vf7yvHmON9Ni4MlaUB/eASeO2SbPYfpPDY7vDkUtvkdGuPRfIvKKspwdKyH
         mCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CGzPRcx2BHVSrFEMXPI3kWcYnIUX7tUCN7uqV/cjft0=;
        b=5Iez47ZDRW6TQYyTygPZzLC4fHvXIOMtrTHUwH+0l76OE6a21/GhkI16UyzOJkFau9
         xQce/djS35Rjbg5EN3zgiuZ/h8uqSmObpuYGwzaTv8D+B/3/XKEZHjyTMCI2iJsiJafS
         R6otXgXD6HoyhhTgWbe3JPTwTb/W68uaEQuntQVTfiwEt4hkRoqNZnAaxeQ60AWeBeFG
         ZMUc+SarCUQGaODIQSZxE2W7u7GicJKWNqaFsMzq0RKw/6xwD3uP8vJhncTA2PVLCw+0
         D38Z9Y52XB029ag0dcO2qgRQu97pf8JGeUqLQOVFQANH4THrFxZCKFjjN8R5llfWE73g
         IXpg==
X-Gm-Message-State: AJIora8HIw2y01cZVNAJRKNglnOgV12JEUMH5sLs6X+Q3EvfHsb0n54y
        GUbTp3WVG0q05ThwqtoRgaFWjbvgZ3cHZw==
X-Google-Smtp-Source: AGRyM1v7wdyeXoa61yzyvQ2gbQ4dc1ENgHDkcFpbRhqkxJ0WE62ubw/EiOn8lbUjjhD0Y8eerLXzCQ==
X-Received: by 2002:a17:907:9810:b0:72f:36e5:266c with SMTP id ji16-20020a170907981000b0072f36e5266cmr2178933ejc.105.1658478053899;
        Fri, 22 Jul 2022 01:20:53 -0700 (PDT)
Received: from [192.168.8.101] (78-80-26-209.customers.tmcz.cz. [78.80.26.209])
        by smtp.gmail.com with ESMTPSA id dk20-20020a0564021d9400b0043a71775903sm2153198edb.39.2022.07.22.01.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 01:20:53 -0700 (PDT)
Message-ID: <a8c3cff3-15f8-abaa-61b1-9347841e984a@gmail.com>
Date:   Fri, 22 Jul 2022 10:20:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [dm-devel] [PATCH 1/1] block: Add support for setting inline
 encryption key per block device
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Israel Rukshin <israelr@nvidia.com>,
        linux-fscrypt@vger.kernel.org,
        Linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com,
        Nitzan Carmi <nitzanc@nvidia.com>
References: <1658316391-13472-1-git-send-email-israelr@nvidia.com>
 <1658316391-13472-2-git-send-email-israelr@nvidia.com>
 <Ytj249InQTKdFshA@sol.localdomain> <20220721125459.GC20555@lst.de>
From:   Milan Broz <gmazyland@gmail.com>
In-Reply-To: <20220721125459.GC20555@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 21/07/2022 14:54, Christoph Hellwig wrote:
> On Wed, Jul 20, 2022 at 11:49:07PM -0700, Eric Biggers wrote:
>> On the other hand, I'd personally be fine with saying that this isn't actually
>> needed, i.e. that allowing arbitrary overriding of the default key is fine,
>> since userspace should just set up the keys properly.  For example, Android
>> doesn't need this at all, as it sets up all its keys properly.  But I want to
>> make sure that everyone is generally okay with this now, as I personally don't
>> see a fundamental difference between this and what the dm-crypt developers had
>> rejected *very* forcefully before.  Perhaps it's acceptable now simply because
>> it wouldn't be part of dm-crypt; it's a new thing, so it can have new semantics.
> 
> I agree with both the dm-crypt maintainer and you on this.  dm-crypt is
> a full disk encryption solution and has to provide guarantees, so it
> can't let upper layers degrade the cypher.  The block layer support on
> the other hand is just a building block an can as long as it is carefully
> documented.

Yes, that is what I meant when complaining about the last dm-crypt patch.

I think inline encryption for block devices is a good idea; my complaint was
integration with dm-crypt - as it can dilute expectations and create a new
threat model here.

But I also think that implementing this directly in the block layer makes sense.
Perhaps it should be generic enough.
(I can imagine dynamic inline encryption integrated into LVM ... :-)

>> I'm wondering if anyone any thoughts about how to allow data_unit_size >
>> logical_block_size with this patch's approach.  I suppose that the ioctl could
>> just allow setting it, and the block layer could fail any I/O that isn't
>> properly aligned to the data_unit_size.
> 
> We could do that, but we'd need to comunicate the limit to the upper
> layers both in the kernel an user space.  Effectively this changes the
> logical block size for all practical purposes.

I think you should support setting logical encryption size from the beginning,
at least prepare API for that. It has a big impact on performance.
The dm-crypt also requires aligned IO here. We propagate new logical size
to upper layers (and also to loop device below, if used).
(Also this revealed hacks in USB enclosures mapping unaligned devices...)

Milan
