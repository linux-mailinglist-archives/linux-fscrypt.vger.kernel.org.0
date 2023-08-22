Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61ED37838ED
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Aug 2023 06:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbjHVEx5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Aug 2023 00:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbjHVEx4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Aug 2023 00:53:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B1F18B;
        Mon, 21 Aug 2023 21:53:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26E586320D;
        Tue, 22 Aug 2023 04:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1E7C433C7;
        Tue, 22 Aug 2023 04:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692680034;
        bh=JbeP199iE1PeA5nZ2TaeZmrgj5NV3RzN82APW6nImDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sKL0tD7iRZ0MkDNt1X/V6rp2royaC2a/4T7fNRnrWD9NelVu5FDoxeeR/DefCFcAy
         iBd2gWNzEXW2eAe2EviRTrHqeYtfW6x61trdcBwDDlVVKZzIuQ3vY3rJkJwFBcZaxD
         nqETuGGonh5g6T4KTYvoYcMqQ+SUkuwUTelAxZkEmMl3VXxVl3FEXFk6A3E1JPUgWy
         GXLQglKVetZPae0RPpQtdyGLQg7vpYJtT6kiXjBaGt845lUsiWblW0MoH05OGmGlAe
         lN8lQec6KOtV1vqQDBN3MN769xFtpFtrYQLTYY7k6MJYlQvNSeOYc9QZ1qNmQwlJNf
         5KFLJrD9c57aA==
Date:   Mon, 21 Aug 2023 21:53:52 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dongsoo Lee <letrhee@nsr.re.kr>
Cc:     'Herbert Xu' <herbert@gondor.apana.org.au>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jens Axboe' <axboe@kernel.dk>,
        "'Theodore Y. Ts'o'" <tytso@mit.edu>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] crypto: LEA block cipher implementation
Message-ID: <20230822045352.GB1661@sol.localdomain>
References: <20230630050323.984216-1-letrhee@nsr.re.kr>
 <000001d9d3b8$bca8e9d0$35fabd70$@nsr.re.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001d9d3b8$bca8e9d0$35fabd70$@nsr.re.kr>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 21, 2023 at 07:50:37AM +0900, Dongsoo Lee wrote:
> Hello.
> 
> Is there any further progress on the patch we submitted and the additional fscrypt documentation? 
> 
> https://lore.kernel.org/linux-fscrypt/20230630064811.22569-1-ebiggers@kernel.org/T/#u.
> 
> If the LEA cipher is accepted, we would like to add a SIMD implementation for it.

I already applied 'fscrypt: improve the "Encryption modes and usage" section'
(https://lore.kernel.org/r/20230630064811.22569-2-ebiggers@kernel.org) for 6.6.

I don't object to the fscrypt support for LEA, but I'm not going to apply it
until the crypto API support is accepted.

- Eric
