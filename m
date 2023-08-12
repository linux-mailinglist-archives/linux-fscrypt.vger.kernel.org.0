Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D94F77A3C5
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Aug 2023 00:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjHLWlo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 12 Aug 2023 18:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjHLWlo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 12 Aug 2023 18:41:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AEE1985;
        Sat, 12 Aug 2023 15:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9D6061769;
        Sat, 12 Aug 2023 22:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC255C433C8;
        Sat, 12 Aug 2023 22:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691880106;
        bh=jQoWuVGAGz2XkHuD3UbriES1sJmINymZmimavq1rqo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KnByuTvV9qbDwO4JYfvLA5YkUTEAZMeA+Fa2Vb3qeFYG45IVCMsEQrE7pY7OLG4HP
         cGtkbIfG6Am/IECVAdOZFmNpeq+m68Pb7BFJEYMakWeh0lpitAprKGbig3TdMxMDMl
         eCf+sKcs5zyshMAaPWRy/gVFDqi97DaAtw7Gcfgasw58yZBOBfIM9LMnz51Wz83pSY
         sfOCJHVNvgtNTHJXX/ByFSVK0K6nHp2YvaIz/A0wsR6Dq945jg1/R+eMUqM2gWgHZc
         tgKgCDTZyIWJ4dzkGo6r41H8KHD14TKDI3WsDUN6xd2+jf5/zbeobLYoKquDntgIJE
         RlPgk6a40ZaTA==
Date:   Sat, 12 Aug 2023 15:41:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 14/16] fscrypt: cache list of inlinecrypt devices
Message-ID: <20230812224144.GB41642@sol.localdomain>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
 <62170e01a2c0b107619018c859250c03b6023a57.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62170e01a2c0b107619018c859250c03b6023a57.1691505882.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:31PM -0400, Sweet Tea Dorminy wrote:
> btrfs sometimes frees extents while holding a mutex, which makes it
> impossible to free an inlinecrypt prepared key since that requires
> taking a semaphore. Therefore, we will need to offload prepared key
> freeing into an asynchronous process (rcu is insufficient since that can
> run in softirq context which is also incompatible with taking a
> semaphore). In order to avoid use-after-free on the filesystem
> superblock for keys being freed during shutdown, we need to cache the
> list of devices that the key has been loaded into, so that we can later
> remove it without reference to the superblock.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/fscrypt_private.h | 13 +++++++++++--
>  fs/crypto/inline_crypt.c    | 20 +++++++++-----------
>  fs/crypto/keysetup.c        |  2 +-
>  3 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 03be2c136c0e..aba83509c735 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -205,6 +205,16 @@ struct fscrypt_prepared_key {
>  	struct crypto_skcipher *tfm;
>  #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
>  	struct blk_crypto_key *blk_key;
> +
> +	/*
> +	 * The list of devices that have this block key.
> +	 */
> +	struct block_device **devices;
> +
> +	/*
> +	 * The number of devices in @ci_devices.
> +	 */
> +	size_t device_count;
>  #endif
>  	enum fscrypt_prepared_key_type type;
>  };

Well, this is basically reverting commit 22e9947a4b2b, but doing it in a
slightly different way.

I worry about potentially bringing back problems from doing work after the
filesystem has already been unmounted.

Can't you just make the filesystem flush its eviction work items when it is
being unmounted?

- Eric
