Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC6251D0E5
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 May 2022 07:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389290AbiEFFyE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 6 May 2022 01:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241386AbiEFFxs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 6 May 2022 01:53:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E48A2CE2B;
        Thu,  5 May 2022 22:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5AD2B831B9;
        Fri,  6 May 2022 05:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20789C385AA;
        Fri,  6 May 2022 05:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651816198;
        bh=8PSn7NDUZ6qAlG7PnSxYBQyy8HrO/Tvwf5uUNcJEdt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lzSnceChIv86SDn4QF+ArFGI5XBUOGy2c05zvpSfsSBpMsJIdqf4tUwBRCSx+9yKi
         2jepqGHR1IBdVZ9KI5bN7RaRTBc1KTqCCz19nsc3elGQq+Nb1jPaVax4fL/jt4zRIh
         a/28NAopga6ATC7iyHSFt1tQ4pg2VgwerFmmSQXJfpgOQRPVKoHTXAvaS9pVSRcgXH
         9mYBQrgjuLqJ3Rw5yeLoMdAzDtpA9Tms7wVUuUk/w5vYrzyq/wHNi4R04Cb5z45dLg
         xUzlLUYjKdjCWeZZdFMEq6CFqyYb7tLCUdzJCS6ZhJefF0Og+31dxkFQHhSBb9vOfk
         e5CyHnH+dXM+w==
Date:   Thu, 5 May 2022 22:49:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v6 5/9] crypto: arm64/aes-xctr: Add accelerated
 implementation of XCTR
Message-ID: <YnS3BNXSDDIkja9B@sol.localdomain>
References: <20220504001823.2483834-1-nhuck@google.com>
 <20220504001823.2483834-6-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504001823.2483834-6-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 04, 2022 at 12:18:19AM +0000, Nathan Huckleberry wrote:
> Add hardware accelerated version of XCTR for ARM64 CPUs with ARMv8
> Crypto Extension support.  This XCTR implementation is based on the CTR
> implementation in aes-modes.S.
> 
> More information on XCTR can be found in
> the HCTR2 paper: Length-preserving encryption with HCTR2:
> https://eprint.iacr.org/2021/1441.pdf
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/Kconfig     |   4 +-
>  arch/arm64/crypto/aes-glue.c  |  64 ++++++++++++-
>  arch/arm64/crypto/aes-modes.S | 168 +++++++++++++++++++++-------------
>  3 files changed, 169 insertions(+), 67 deletions(-)

Looks good, although the assembly code gets easier to read after the next patch.

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
