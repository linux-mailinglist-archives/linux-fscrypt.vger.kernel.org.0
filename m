Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAC970EB95
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 May 2023 04:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbjEXCzd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 23 May 2023 22:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239208AbjEXCzc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 23 May 2023 22:55:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65FD186;
        Tue, 23 May 2023 19:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC8B63615;
        Wed, 24 May 2023 02:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E3CC433D2;
        Wed, 24 May 2023 02:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684896930;
        bh=hgzNNL06TsbhwPSXrFqaywaqvF+gB0OSOd50WtTbY+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ubs/vCGvvKVN2uuegygIma9dz4N56ne0ieBH+T7VhhZL6m2Bt+2xqN46+YiyaqvMi
         HZDgD9HInhjehRt+uMCXhBtK+eAFauzZ3d5ppBMOf3vxz+7eAfCCBhJERxSj2iCytv
         8vglElowrbo39GSoS0RkXdvD2a/eERiQ97vekJk+8sM1LekoB/x+654245TSq4jroS
         HT9hyUDEU9H1miEs/phRkoW5IELg0O0HeVEOQpWeMb8fIruIhUZevQE0+6TTdvUZTg
         Ny5QseHjtsF5+vSR/wGCd9kH/XKhvYHQ2HnwIYyikA2dy15DK21403unVv3VxN+pPq
         UaBxJ+MoDlM1A==
Date:   Tue, 23 May 2023 19:55:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] fscrypt: Replace 1-element array with flexible array
Message-ID: <20230524025528.GA1076@sol.localdomain>
References: <20230523165458.gonna.580-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523165458.gonna.580-kees@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 23, 2023 at 09:55:02AM -0700, Kees Cook wrote:
> 1-element arrays are deprecated and are being replaced with C99
> flexible arrays[1].
> 
> As sizes were being calculated with the extra byte intentionally,
> propagate the difference so there is no change in binary output.
> 
> [1] https://github.com/KSPP/linux/issues/79
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: "Theodore Y. Ts'o" <tytso@mit.edu>
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
> Cc: linux-fscrypt@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2: update commit log to avoid mentioning "len" member.
> v1: https://lore.kernel.org/lkml/20230522213924.never.119-kees@kernel.org/
> ---
>  fs/crypto/fscrypt_private.h |  2 +-
>  fs/crypto/hooks.c           | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)

Thanks, applied to
https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=for-next

- Eric
