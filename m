Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8210590521
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Aug 2022 18:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiHKQuU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 11 Aug 2022 12:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbiHKQt6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 11 Aug 2022 12:49:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 145799D8E9
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Aug 2022 09:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660234991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GlT7Sic8QO1AMTJC4OHa6oG5D/j9d4B9LH00c/lFNEY=;
        b=LMKRy79eYpxWbzMPZzrgwK+cbjVcrIBA5G9SndoaKmoVIL0o0/6er/Y303c6Wi48Ry9ujL
        QbAseOgvszxyQMQJ8PNF/ab7g5TXO7ssxWsoN36rDIQGVGPBImdUD5U1xBoN9AWgcTklKu
        awlC8wdInOI6Kv9bml7Iygl2kWUDBW4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-634-bH7VCmcmOeWHXXiTclSH8A-1; Thu, 11 Aug 2022 12:23:10 -0400
X-MC-Unique: bH7VCmcmOeWHXXiTclSH8A-1
Received: by mail-qk1-f198.google.com with SMTP id bs33-20020a05620a472100b006b97dc17ab4so6144819qkb.6
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Aug 2022 09:23:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=GlT7Sic8QO1AMTJC4OHa6oG5D/j9d4B9LH00c/lFNEY=;
        b=uE0qVIVsMaVaj50CZU5fsqSeA7U6RiF1TSX0G3/7k8sfXp3GNkL3D9Aa6uT67Vdple
         BPHt37hJAKuCGzPuZqYyQcDgZXNFXsYv5zzJHjPX9x8HdleVFI7rtkI65IZZAiX+Y4OZ
         7XcuJ+qEEXBBXdS9PSrzUV63NruPOeRKYfEIJoZ0VUPrMXnKWBr3vYqINxsj8CPAtbHF
         lwllGZh4lKX6kCSxsIAf15vkdTA3YfoFErE+sa0BmK9D8xm8EYRP7fpdan4Y7lfpSFA2
         b8d8XiVVWcLHz0b4ghiFoIh+lJt6R8JVS6g3VVune0NL60n8OVWArIlCnp4wChq2xBWC
         xFOA==
X-Gm-Message-State: ACgBeo31ovHxn31DTVZ3pOU74eMg/t6t7T6nB1dpXp8G9DpoPLqdtZJu
        grzJsz/jgCuRvF2rEUePzX6b2D0kMHPnWfeC5pIjzADyawdPOy5LbDCD+KxPYteWcfuMGu+UBr0
        88AeIWTwkHObqe3pDi9GkVYnM2w==
X-Received: by 2002:a05:620a:4901:b0:6ba:15c1:beae with SMTP id ed1-20020a05620a490100b006ba15c1beaemr1883262qkb.516.1660234990075;
        Thu, 11 Aug 2022 09:23:10 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4yT3ubSXo2cVxDNK9V5RCYyWvQCpUpZslOCNokBU7WUhVeLg0OfXJT4oU326i5KodhzmmmXA==
X-Received: by 2002:a05:620a:4901:b0:6ba:15c1:beae with SMTP id ed1-20020a05620a490100b006ba15c1beaemr1883240qkb.516.1660234989798;
        Thu, 11 Aug 2022 09:23:09 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s12-20020a05620a29cc00b006af147d4876sm2567969qkp.30.2022.08.11.09.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 09:23:09 -0700 (PDT)
Date:   Fri, 12 Aug 2022 00:23:03 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v6 0/2] generic: test HCTR2 filename encryption
Message-ID: <20220811162303.7fn5kexteoc7haov@zlang-mailbox>
References: <20220809184037.636578-1-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809184037.636578-1-nhuck@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 09, 2022 at 11:40:35AM -0700, Nathan Huckleberry wrote:
> HCTR2 is a new wide-block encryption mode that can used for filename encryption
> in fscrypt.  This patchset adds a reference implementation of HCTR2 to the
> fscrypt testing utility and adds tests for filename encryption with HCTR2.
> 
> More information on HCTR2 can be found here: "Length-preserving encryption with
> HCTR2": https://ia.cr/2021/1441
> 
> The patchset introducing HCTR2 to the kernel can be found here:
> https://lore.kernel.org/linux-crypto/20220520181501.2159644-1-nhuck@google.com/
> 
> Changes in v6:
> * Remove unused variable
> * Rework cover letter

I've merged your v5 patchset. So feel free to send bug fix patches if you
found more issues.

Thanks,
Zorro

> 
> Changes in v5:
> * Added links to relevant references for POLYVAL and HCTR2
> * Removed POLYVAL partial block handling
> * Referenced HCTR2 commit in test



> 
> Changes in v4:
> * Add helper functions for HCTR2 hashing
> * Fix accumulator alignment bug
> * Small style fixes
> 
> Changes in v3:
> * Consolidate tests into one file
> 
> Changes in v2:
> * Use POLYVAL multiplication directly instead of using GHASH trick
> * Split reference implementation and tests into two patches
> * Remove v1 policy tests
> * Various small style fixes
> 
> Nathan Huckleberry (2):
>   fscrypt-crypt-util: add HCTR2 implementation
>   generic: add tests for fscrypt policies with HCTR2
> 
>  common/encrypt           |   2 +
>  src/fscrypt-crypt-util.c | 357 ++++++++++++++++++++++++++++++++-------
>  tests/generic/900        |  31 ++++
>  tests/generic/900.out    |  16 ++
>  4 files changed, 349 insertions(+), 57 deletions(-)
>  create mode 100755 tests/generic/900
>  create mode 100644 tests/generic/900.out
> 
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 

