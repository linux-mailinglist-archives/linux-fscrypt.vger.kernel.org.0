Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEBA516727
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 20:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348551AbiEASlL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 14:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234391AbiEASlL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 14:41:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B703819039;
        Sun,  1 May 2022 11:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AABDB80D08;
        Sun,  1 May 2022 18:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2C1C385AA;
        Sun,  1 May 2022 18:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651430261;
        bh=RPbPn+ISgi6eo/0pALloybPyhv8zLJjGIiCsUz+5jkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l8KY085q1j58kNDn77EfgNTUs/QW0NgRLHFFsrP70fW6MmTc6/JdfQiu/IQDCeky0
         Cd0zw5xxLmwosLTatvZDFiZ70aChyt+d9oRVmUmr+putbgNm/AAaRYCVURBNWAZ6+m
         XR3XQEFxGyL+j3oTqW8DLTjCZtFm73uP1G7w2C5yH6KZtCVLIKZEn/ps/xgjAe3qCq
         g0SSoWzlGJre074JiIH7Vv+FTjp8nwYBgkvO1ff6/y2zlgISwJfrKUsFOahBIU8faJ
         8sz23MUwla1t6MVsU8klN9+K+k82xonNg06E4/rInHi+taPPiViGe24wUH9a6ueszP
         Ud5hxAYzA6jFw==
Date:   Sun, 1 May 2022 11:37:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v5 8/8] fscrypt: Add HCTR2 support for filename encryption
Message-ID: <Ym7TdNCe/3gXdVNr@sol.localdomain>
References: <20220427003759.1115361-1-nhuck@google.com>
 <20220427003759.1115361-9-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427003759.1115361-9-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Apr 27, 2022 at 12:37:59AM +0000, Nathan Huckleberry wrote:
> HCTR2 is a tweakable, length-preserving encryption mode that is intended
> for use on CPUs with dedicated crypto instructions.  HCTR2 has the
> property that a bitflip in the plaintext changes the entire ciphertext.
> This property fixes a known weakness with filename encryption: when two
> filenames in the same directory share a prefix of >= 16 bytes, with
> AES-CTS-CBC their encrypted filenames share a common substring, leaking
> information.  HCTR2 does not have this problem.
> 
> More information on HCTR2 can be found here: "Length-preserving
> encryption with HCTR2": https://eprint.iacr.org/2021/1441.pdf
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

Acked-by: Eric Biggers <ebiggers@google.com>

- Eric
