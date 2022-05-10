Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE3B52247E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 May 2022 21:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242826AbiEJTGH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 May 2022 15:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349122AbiEJTGE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 May 2022 15:06:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521B650B10;
        Tue, 10 May 2022 12:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCC0D61143;
        Tue, 10 May 2022 19:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DF3C385C8;
        Tue, 10 May 2022 19:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652209561;
        bh=IiUKjLjANHL8lDcaB4wju0pa98VTPo8stRQrGPhc1o4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l/FHpZVH5hOhWmKLR2/VZgGM6j5VjLq3hNun/voFYgxNHlb7G2E8yPr1V8bRMXAIU
         wyg8Ku+8mWpfc1n6P0kQ4Ra29Q6JdJ/JDdlLWjaAk0iDKQ213szCieSjwnUMFU7W3z
         osczplpE+sJwMJYhffH7VUkMmNCsns4SAlrxL7QU5Q93Mye4BKnypqw5gIJNabu17x
         1VGEcgyN535Ujn9sIK3vBRH0EirgraXQcKZDFOAVhwCIh7hAUW6vANMXbbSy60rZ4V
         AxQlC1/jzu1cf5YPTWW+rLcmVpxa8Jrpb+qohiNIzQNFqpJVU2z/wjCblv4tggTaWV
         O19YdD1oJh6SQ==
Date:   Tue, 10 May 2022 12:05:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v8 0/9] crypto: HCTR2 support
Message-ID: <Ynq3l+CRd86ZNDMK@sol.localdomain>
References: <20220510172359.3720527-1-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220510172359.3720527-1-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 10, 2022 at 05:23:50PM +0000, Nathan Huckleberry wrote:
> HCTR2 is a length-preserving encryption mode that is efficient on
> processors with instructions to accelerate AES and carryless
> multiplication, e.g. x86 processors with AES-NI and CLMUL, and ARM
> processors with the ARMv8 Crypto Extensions.
> 
> HCTR2 is specified in https://ia.cr/2021/1441 "Length-preserving encryption
> with HCTR2" which shows that if AES is secure and HCTR2 is instantiated
> with AES, then HCTR2 is secure.  Reference code and test vectors are at
> https://github.com/google/hctr2.
> 
> As a length-preserving encryption mode, HCTR2 is suitable for applications
> such as storage encryption where ciphertext expansion is not possible, and
> thus authenticated encryption cannot be used.  Currently, such applications
> usually use XTS, or in some cases Adiantum.  XTS has the disadvantage that
> it is a narrow-block mode: a bitflip will only change 16 bytes in the
> resulting ciphertext or plaintext.  This reveals more information to an
> attacker than necessary.
> 
> HCTR2 is a wide-block mode, so it provides a stronger security property: a
> bitflip will change the entire message.  HCTR2 is somewhat similar to
> Adiantum, which is also a wide-block mode.  However, HCTR2 is designed to
> take advantage of existing crypto instructions, while Adiantum targets
> devices without such hardware support.  Adiantum is also designed with
> longer messages in mind, while HCTR2 is designed to be efficient even on
> short messages.
> 
> The first intended use of this mode in the kernel is for the encryption of
> filenames, where for efficiency reasons encryption must be fully
> deterministic (only one ciphertext for each plaintext) and the existing CBC
> solution leaks more information than necessary for filenames with common
> prefixes.
> 
> HCTR2 uses two passes of an ε-almost-∆-universal hash function called
> POLYVAL and one pass of a block cipher mode called XCTR.  POLYVAL is a
> polynomial hash designed for efficiency on modern processors and was
> originally specified for use in AES-GCM-SIV (RFC 8452).  XCTR mode is a
> variant of CTR mode that is more efficient on little-endian machines.
> 
> This patchset adds HCTR2 to Linux's crypto API, including generic
> implementations of XCTR and POLYVAL, hardware accelerated implementations
> of XCTR and POLYVAL for both x86-64 and ARM64, a templated implementation
> of HCTR2, and an fscrypt policy for using HCTR2 for filename encryption.
> 

Thanks, this series looks good now.  I've also tested it on x86_64 and arm64.

Herbert, I think this series is ready to be applied, when you're ready for it.

- Eric
