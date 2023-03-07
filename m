Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD0F6AF621
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Mar 2023 20:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCGTvx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Mar 2023 14:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCGTve (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Mar 2023 14:51:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF6754CBA;
        Tue,  7 Mar 2023 11:43:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3D11B8136B;
        Tue,  7 Mar 2023 19:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72557C433EF;
        Tue,  7 Mar 2023 19:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678218154;
        bh=Mqe/Ih9wraBvdsElmN2NZgDJm9p7T1kEby/xwbur6PI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l4xOZwe4VtRv48MdR3UB00d15SwKLL1cUHq4o/CSlXIn+3XJBpuU9RZS8VjDG5rRR
         k6y+U6S1YWvBiDFRT9aPI0UIxLc9H/Le0BFdpbQNb3IHOCEb6mfJEBElDTesB4+ZD5
         1RkrmG8FWpa7k3Imf9lohTJmp3/KKBEe/VS9fUs3GTY0r5kJmhdZJH9glSh1fjHdl6
         0ba8t5UVK8HbzZZr4HOVmwtpxqU1ZJi5F58GJWXIVt9loNyy2nuW01orwnAylBruAy
         L7HOWHRAbdzrscDWnkn4lcE6O4bs5qHmWOKdB1nYC6xHPLZlaSzTsibOpclB02hDbF
         4wdFAtgUx7BCw==
Date:   Tue, 7 Mar 2023 11:42:32 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] fs/buffer.c: use b_folio for fscrypt work
Message-ID: <ZAeTqGnVDJxnH/3j@sol.localdomain>
References: <20230224232503.98372-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224232503.98372-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Feb 24, 2023 at 03:25:03PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Use b_folio now that it exists.  This removes an unnecessary call to
> compound_head().  No actual change in behavior.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/buffer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 034bece27163..d759b105c1e7 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -330,8 +330,8 @@ static void decrypt_bh(struct work_struct *work)
>  	struct buffer_head *bh = ctx->bh;
>  	int err;
>  
> -	err = fscrypt_decrypt_pagecache_blocks(page_folio(bh->b_page),
> -					       bh->b_size, bh_offset(bh));
> +	err = fscrypt_decrypt_pagecache_blocks(bh->b_folio, bh->b_size,
> +					       bh_offset(bh));
>  	if (err == 0 && need_fsverity(bh)) {
>  		/*
>  		 * We use different work queues for decryption and for verity

Applied to https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=for-next

- Eric
