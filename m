Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377E97432E2
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 04:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjF3C7U (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Jun 2023 22:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjF3C7T (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Jun 2023 22:59:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307F930D1;
        Thu, 29 Jun 2023 19:59:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 372A261682;
        Fri, 30 Jun 2023 02:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B68C433C8;
        Fri, 30 Jun 2023 02:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688093956;
        bh=B0uJCCt4pLa8YAS3agrRPmNgvGJ8BG0YaD14PEJl/gU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OSBICMM9QqsAR5EgD2csPc4ULMsCGxbOFC1Cldy1YYAP5XLQ0+0GGBLUHNso6isxm
         POOvVzf/sCKOQAOjXToA2RwgtcTS0ITpdLhQay2slXHvOdyRhlDNBpsa0wM8l0Jogk
         PuVnRp3juYw9vmZLdHs24pejpGQu3vV5xgSgfv291ts1VlQNIKh0G6KOYHIm4eJQQC
         kCyVYTcRrmOxGVFreUiXP1XWp/PV+r4FSkPncD33t+kABYumo7lkQlr9TcaYx/CRaW
         MhmPu/SbdZIlzvzdhOtEdvrc/DFn/QdI/ljO/fCrhNECJGiTkFq4h2evyKbpmxcCBi
         Yf/jZUQ0/dvcw==
Date:   Thu, 29 Jun 2023 19:59:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dongsoo Lee <letrhee@nsr.re.kr>
Cc:     'Herbert Xu' <herbert@gondor.apana.org.au>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jens Axboe' <axboe@kernel.dk>,
        "'Theodore Y. Ts'o'" <tytso@mit.edu>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] fscrypt: Add LEA-256-XTS, LEA-256-CTS support
Message-ID: <20230630025914.GB1088@sol.localdomain>
References: <20230626084703.907331-1-letrhee@nsr.re.kr>
 <20230626084703.907331-5-letrhee@nsr.re.kr>
 <20230628063830.GA7920@sol.localdomain>
 <000901d9aa70$a228c420$e67a4c60$@nsr.re.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000901d9aa70$a228c420$e67a4c60$@nsr.re.kr>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 29, 2023 at 07:01:11PM +0900, Dongsoo Lee wrote:
> On Tue, Jun 27, 2023 at 23:38:30 -0700, Eric Biggers wrote:
> >On Mon, Jun 26, 2023 at 05:47:03PM +0900, Dongsoo Lee wrote:
> >> when SIMD instructions are available, it performs even faster.
> >
> >This will only be true once there is actually an applicable implementation
> of
> >LEA-XTS and LEA-CTS using SIMD instructions included in the kernel.
> >
> >Perhaps it is your plan to go through and accelerate LEA-XTS and LEA-CTS
> for the
> >common CPU architectures.  However, it is not included in this patchset
> yet, so
> >it should not be claimed in the documentation yet.
> >
> >> Particularly, it outperforms AES when the dedicated crypto
> >> +instructions for AES are unavailable, regardless of the presence of SIMD
> >> +instructions. However, it is not recommended to use LEA unless there is
> >> +a clear reason (such as the absence of dedicated crypto instructions for
> >> +AES or a mandatory requirement) to do so. Also, to enable LEA support,
> >> +it needs to be enabled in the kernel crypto API.
> >
> >I think I'd prefer that you omit the mention of the "absence of dedicated
> crypto
> >instructions" use case for now.  fscrypt already supports another algorithm
> that
> >fulfills exactly that use case (Adiantum), and that algorithm already has
> >optimized implementations for arm32, arm64, and x86_64.  LEA does not have
> that
> >yet.  So it does not really bring anything new to the table.  I'm also
> unsure it
> >would be appropriate to recommend a "lightweight" cipher at this point...
> >
> >That would leave "mandatory requirement" as the rationale, at least for
> now,
> >similar to SM4.
> >
> >- Eric
> 
> As you might expect, we are working on a SIMD implementation of LEA in a
> general-purpose CPU environment. However, since no such implementation has
> been submitted yet, we agree that it's right to leave it out for now.
> 
> In the next version, we would like to change the description to the
> following:
> 
> LEA is a South Korean 128-bit block cipher (with 128/192/256-bit keys)
> included in the ISO/IEC 29192-2:2019 standard (Information security -
> Lightweight cryptography - Part 2: Block ciphers). If dedicated cipher
> instructions are available, or other options with performance benefits
> are available, using LEA is likely not a suitable choice. Therefore,
> it is not recommended to use LEA-256-XTS unless there is a clear reason
> to do so, such as if there is a mandate. Also, to enable LEA support,
> it needs to be enabled in the kernel crypto API.

I don't think that really addresses my comment, due to the second sentence.  I
understand that you would like to advertise the performance of LEA.  But as I
mentioned, it's not yet realized in the kernel crypto API, and in the context of
fscrypt it won't really bring anything new to the table anyway.  For now I think
LEA is best described as a "national pride cipher" alongside SM4...  Keep in
mind, it can always be changed later if new use cases come up.

Could you just omit the documentation update from your patch?  I actually need
to rework the whole "Encryption modes and usage" section anyway since it's
growing a bit unwieldy, with 6 different combinations of encryption modes now
supported.  The information needs to be organized better.  It currently reads
like a list, and it might be hard for users to understand which setting to use.

I'll add on a patch that does that and adds the mention of LEA support.

- Eric
