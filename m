Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2287D52AE0F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 May 2022 00:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiEQWYo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 May 2022 18:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiEQWYm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 May 2022 18:24:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B550552B2F
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 May 2022 15:24:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43B3BB81CA8
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 May 2022 22:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DC9C385B8;
        Tue, 17 May 2022 22:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652826279;
        bh=hxN6XRwlXWCShLw8HNagKP6U4EBet6aIwaUnuHrmpYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SuXO4wxEX/4D9Xu79EFuTfumKhg1FAQiOGtN1U9XrBH4UPMidIIgk+6aXSkCqCq4p
         tCHN5xOXO7OxSFbdn53hL14kJryAADU2ggd8gzF3KgTHaBTld5kJbqawt0XDmBqEFq
         md5WIVzXYW3/l0+EVK+9gyJtBczncwvowwERzob2Zh1FLEEZqWWewsr4gKDH9xJLtZ
         2fDup6OA5QkhENPbPWOpaepbbluwgS3cCXB/xuPFPrneqZJzO9z5OUTOsvcX7nNvDH
         xNg2jTwsMvXaRixq2TZmkMnWJzMEG8aEp+GR6aXT7QibWvHpJSAw9dDksJ/2jigMHM
         hq6n5LKoGXxIw==
Date:   Tue, 17 May 2022 15:24:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/2] fsverity: factor out sysctl from signature.c
Message-ID: <YoQgpR7eNDIVJIPF@sol.localdomain>
References: <cover.1651184207.git.boris@bur.io>
 <42e975ed011e1e62d13bee0eb79012627b2abd60.1651184207.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42e975ed011e1e62d13bee0eb79012627b2abd60.1651184207.git.boris@bur.io>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 28, 2022 at 03:19:19PM -0700, Boris Burkov wrote:
> diff --git a/fs/verity/signature.c b/fs/verity/signature.c
> index 143a530a8008..67a471e4b570 100644
> --- a/fs/verity/signature.c
> +++ b/fs/verity/signature.c
> @@ -12,11 +12,7 @@
>  #include <linux/slab.h>
>  #include <linux/verification.h>
>  
> -/*
> - * /proc/sys/fs/verity/require_signatures
> - * If 1, all verity files must have a valid builtin signature.
> - */
> -static int fsverity_require_signatures;
> +extern int fsverity_require_signatures;

This forward declaration should go in fsverity_private.h so that it is also
visible at the definition site.  Otherwise it causes a compiler warning:

fs/verity/sysctl.c:11:5: warning: symbol 'fsverity_require_signatures' was not declared. Should it be static?

> diff --git a/fs/verity/sysctl.c b/fs/verity/sysctl.c
> new file mode 100644
> index 000000000000..3ba7b02282db
> --- /dev/null
> +++ b/fs/verity/sysctl.c
> @@ -0,0 +1,51 @@
> +// SPDX-License-Identifier: GPL-2.0
> +

Please keep the existing copyright statements when moving code.

- Eric
