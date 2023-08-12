Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D390F77A407
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Aug 2023 00:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjHLWy4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 12 Aug 2023 18:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjHLWyz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 12 Aug 2023 18:54:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BDF10CE;
        Sat, 12 Aug 2023 15:54:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E5F561FC1;
        Sat, 12 Aug 2023 22:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C0DC433C7;
        Sat, 12 Aug 2023 22:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691880897;
        bh=wUxc+xhAV3/AzhLMmG5gbw6DHlmI+M0YUl7M1BJzNMM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kAwrY1S8lZgWdWYJZ4+9C/AASEN32tBzpSZ4uQ3dg4zHbhNVWO0TnKe3eonptBMg8
         +YbKm93Q/r8q8URlkZFoO7nhYAaoxGij4Lzaajh95Op2Y1cbEF8E7uH9NjhbGhrrxf
         Ly2ybNRsFMy20XAVpLgQN7xhbwDJfWeMoPiYDkVzlQnM8WCEtvyagIVszRZD+hyn0A
         eB1kL1UyJ4PaELLX6WtWDNMdMxz5WKTBut9vHrFNBad2LrpM8e450Cyambk0JE92dZ
         ob67xNKypr4DM8ntGfLMcDxxmyn6ig7kFhnfjfcMZm2is7gblW/eTphFFt0cNo3e7Q
         vocj+qrTBrlvA==
Date:   Sat, 12 Aug 2023 15:54:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 09/16] fscrypt: revamp key removal for extent
 encryption
Message-ID: <20230812225455.GD41642@sol.localdomain>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
 <25ca0cf3c15e92509718a0638563e21497a1d82d.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25ca0cf3c15e92509718a0638563e21497a1d82d.1691505882.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:26PM -0400, Sweet Tea Dorminy wrote:
> @@ -1017,6 +1020,12 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
>  	mk = fscrypt_find_master_key(sb, &arg.key_spec);
>  	if (!mk)
>  		return -ENOKEY;
> +
> +	if (fscrypt_fs_uses_extent_encryption(sb)) {
> +		/* Keep going even if this has an error. */
> +		try_to_lock_encrypted_files(sb, mk);
> +	}

Why is this here?

> @@ -606,6 +615,8 @@ static void put_crypt_info(struct fscrypt_info *ci)
>  
>  	mk = ci->ci_master_key;
>  	if (mk) {
> +		bool any_inodes;
> +
>  		/*
>  		 * Remove this inode from the list of inodes that were unlocked
>  		 * with the master key.  In addition, if we're removing the last
> @@ -614,7 +625,28 @@ static void put_crypt_info(struct fscrypt_info *ci)
>  		 */
>  		spin_lock(&mk->mk_decrypted_inodes_lock);
>  		list_del(&ci->ci_master_key_link);
> +		any_inodes = list_empty(&mk->mk_decrypted_inodes);
>  		spin_unlock(&mk->mk_decrypted_inodes_lock);
> +		if (any_inodes) {
> +			bool soft_deleted;
> +			/* It might be that someone tried to remove this key,
> +			 * but there were still inodes open that could need new
> +			 * extents, which needed to be able to access the key
> +			 * secret. But now this was the last reference. So we
> +			 * can delete the key secret now. (We don't need to
> +			 * check for new inodes on the decrypted_inode list
> +			 * because once ->mk_soft_deleted is set, no new inode
> +			 * can join the list.
> +			 */
> +			down_write(&mk->mk_sem);
> +			soft_deleted = mk->mk_soft_deleted;
> +			if (soft_deleted)
> +				fscrypt_wipe_master_key_secret(&mk->mk_secret);
> +			up_write(&mk->mk_sem);
> +			if (soft_deleted)
> +				fscrypt_put_master_key_activeref(ci->ci_sb, mk);
> +		}
> +

What is all this for?  I'd have thought this would just use the existing
refcounting and no change would be needed here.

- Eric
