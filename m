Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B0652DAA4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 18:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239364AbiESQwT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 May 2022 12:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbiESQwS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 May 2022 12:52:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC9C5BD2B
        for <linux-fscrypt@vger.kernel.org>; Thu, 19 May 2022 09:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ED0660F76
        for <linux-fscrypt@vger.kernel.org>; Thu, 19 May 2022 16:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2473C385AA;
        Thu, 19 May 2022 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652979136;
        bh=22hHy9EdQdbFc2O76w4qOjBbtLZL6dn2CHBKjFKFfno=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EoURjnQtbZoOFf+2vlsFj+xADwf2FEeYZEh2RyMqm0M+YkBz8Z2mH0LsEzIxaPyiI
         0nOJUuASw1FfEo5NWkfUeNYS6nNjMCKPWRRfYT6bN19UOeBDExaMej5UWjEO0KtJpK
         C3vQpgseBBz41Me9cloDDD4djPeTgXHndF3gONx92qoH2+grXzeqle90nohfpADjw9
         DE2fe36tn+CE5b1vPUXpZJFY60azwwReNURK6SWSOLnx3SC6kaEv08DBFJ7zLacKGm
         a1rliRqxYvZSWzcr2MpDYQvtzEPpRbRrru1i1PIiz94FhhzWKzUfaNk7Et+AkrBLYl
         Ler1zl6kZ12QQ==
Date:   Thu, 19 May 2022 09:52:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     James Simmons <jsimmons@infradead.org>
Cc:     Andreas Dilger <adilger@whamcloud.com>, NeilBrown <neilb@suse.de>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: allow alternative bounce buffers
Message-ID: <YoZ1vlUWqX/ZF/iJ@sol.localdomain>
References: <1652966485-7418-1-git-send-email-jsimmons@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652966485-7418-1-git-send-email-jsimmons@infradead.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, May 19, 2022 at 09:21:25AM -0400, James Simmons wrote:
> Currently fscrypt offers two options. One option is to use the
> internal bounce buffer allocated or perform inline encrpytion.
> Add the option to use an external bounce buffer. This change can
> be used useful for example for a network file systems which can
> pass in a page from the page cache and place the encrypted data
> into a page for a network packet to be sent. Another potential
> use is the use of GPU pages with RDMA being the final destination
> for the encrypted data. Lastly in performance measurements the
> allocation of the bounce page incures a heavy cost. Using a page
> from a predefined memory pool can lower the case. We can replace
> the one off case of inplace encryption with the new general
> functions.
> 
> Signed-Off-By: James Simmons <jsimmons@infradead.org>
> ---
>  fs/crypto/crypto.c      | 34 +++++++++++++++++++---------------
>  fs/ubifs/crypto.c       | 16 +++++++++-------
>  include/linux/fscrypt.h | 31 ++++++++++++++++---------------
>  3 files changed, 44 insertions(+), 37 deletions(-)

Can you send a patch with the user of this at the same time?  This patch isn't
useful on its own.  UBIFS doesn't count, since it works fine without this.

>  /**
> - * fscrypt_encrypt_block_inplace() - Encrypt a filesystem block in-place
> + * fscrypt_encrypt_page() - Cache an encrypt filesystem block in a page

fscrypt_encrypt_block() would be a better name, to avoid confusion between
blocks and pages.

Also, "Cache an encrypt filesystem block" => "Encrypt a filesystem block"

>  /**
> - * fscrypt_decrypt_block_inplace() - Decrypt a filesystem block in-place
> + * fscrypt_decrypt_page() - Cache a decrypt a filesystem block in a page

Likewise, fscrypt_decrypt_block().

>   * @inode:     The inode to which this block belongs
> - * @page:      The page containing the block to decrypt
> + * @src:       The page containing the block to decrypt
> + * @dst:       The page which will contain the plain data
>   * @len:       Size of block to decrypt.  This must be a multiple of
>   *		FSCRYPT_CONTENTS_ALIGNMENT.
>   * @offs:      Byte offset within @page at which the block to decrypt begins
> @@ -292,17 +295,18 @@ EXPORT_SYMBOL(fscrypt_decrypt_pagecache_blocks);
>   * Decrypt a possibly-compressed filesystem block that is located in an
>   * arbitrary page, not necessarily in the original pagecache page.  The @inode
>   * and @lblk_num must be specified, as they can't be determined from @page.
> + * The encrypted data will be stored in @dst.
>   *
>   * Return: 0 on success; -errno on failure
>   */
> -int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page *page,
> -				  unsigned int len, unsigned int offs,
> -				  u64 lblk_num)
> +int fscrypt_decrypt_page(const struct inode *inode, struct page *src,
> +			 struct page *dst, unsigned int len, unsigned int offs,
> +			 u64 lblk_num, gfp_t gfp_flags)

The new gfp_flags parameter is not documented in the kerneldoc comment.

- Eric
