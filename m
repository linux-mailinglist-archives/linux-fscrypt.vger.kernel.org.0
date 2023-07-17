Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8B97567B6
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 17:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjGQPW5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 11:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbjGQPW4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 11:22:56 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F7C172D
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 08:22:34 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-403b36a4226so23368041cf.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 08:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689607307; x=1692199307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EqcVH7sv/0hg29upGUy0RVbDeka4i7FQlqHJU2puOSY=;
        b=trUKTW/vHVzT3XfKJvkaihNWWe4vyVjNOVs1mfYS5oU4oxpu1ye7vK1emlUY5+NvgH
         PpqUW9VKfu0Z7TmgWBOi/QzPQy4rn16eNKr0nnVx44+h++RGi8xKXetgELPqfdeBPv36
         80Nmfxc2nAiFbNn2/SSaX+Ypi/WaK5Kl7QBF4wCyggEJ89gv4e5tZ4lVhTbfRm6jGL6R
         D4Y/FdxdwXYFU2wsbTmdRXwG54FdVlJOk95QZoBmC5WHEjv6XpYJRFmpved+e+1TB6BX
         tlNY/0I3U4bFgAfq+kpP6heZE0/1sZkQd9i095NpPyfcQEQ+kLGsHDblmBshfyYpf0QX
         DpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607307; x=1692199307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EqcVH7sv/0hg29upGUy0RVbDeka4i7FQlqHJU2puOSY=;
        b=OVzsUgm3VMNLBG6liaW1GkMVIAY9JJs518Rfsx2km452FLXs7yl1zIfo+wzdXhdhwN
         VV4oQ+QU4U4wT5Z1irLbu+aIlECXHFIjcSjADFH8RM0eUaE0nTeZqDTjpybMqpJnwnff
         6DzdI8yQMJ12O7NXV8ghLe9r6IUqWxP7Lcrnt4pruvGU+laqgUXXjaCvQ0Jdw53wVlwV
         3sUeKY6DZASRdIlxSBRFQZ0Wa2lstFxPHZ/5Xi6ycO3OwHzFB9gIrQgWaZc/3AGwxHhO
         6CjipnErgckoyxAsD6XfrSaxpdjDzIseRP/XAcDA9S/XvhSxFZg98AmoF4klbJjeEJgh
         HA4g==
X-Gm-Message-State: ABy/qLYJ/eBH5rhg9WXEcBiK8tdZCA0X8vJch9Z/9L1PXa0bkbSm5uMw
        QXtfeIBAf0oFm7jgkvzK9HBLCg==
X-Google-Smtp-Source: APBJJlHq8Cb7U/JrshTCo5LlRMdd2I4ewCiyotW4c0qGHWE90Uc/MvsMyBlhWQpfH5BXR8rAaAXHIw==
X-Received: by 2002:ac8:7d8c:0:b0:403:a77b:20cd with SMTP id c12-20020ac87d8c000000b00403a77b20cdmr10338228qtd.22.1689607307323;
        Mon, 17 Jul 2023 08:21:47 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id a9-20020ac84d89000000b00403f5b07e27sm17430qtw.51.2023.07.17.08.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 08:21:46 -0700 (PDT)
Date:   Mon, 17 Jul 2023 11:21:44 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 11/14] fscrypt: add creation/usage/freeing of
 per-extent infos
Message-ID: <20230717152144.GF691303@perftesting>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
 <f3a26dde5d1ba50faf3f1db418b1066e859110de.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3a26dde5d1ba50faf3f1db418b1066e859110de.1688927487.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 09, 2023 at 02:53:44PM -0400, Sweet Tea Dorminy wrote:
> This change adds the superblock function pointer to get the info
> corresponding to a specific block in an inode for a filesystem using
> per-extent infos. It allows creating a info for a new extent and freeing
> that info, and uses the extent's info if appropriate in encrypting
> blocks of data.
> 
> This change does not deal with saving and loading an extent's info, but
> introduces the mechanics necessary therefore.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/crypto.c          |  2 +
>  fs/crypto/fscrypt_private.h | 76 +++++++++++++++++++++----------------
>  fs/crypto/keyring.c         |  9 +----
>  fs/crypto/keysetup.c        | 58 +++++++++++++++++++++++++++-
>  include/linux/fscrypt.h     | 48 ++++++++++++++++++-----
>  5 files changed, 141 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index d75f1b3f5795..0f0c721e40fe 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -113,6 +113,8 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
>  	struct crypto_skcipher *tfm = ci->ci_enc_key->tfm;
>  	int res = 0;
>  
> +	if (!ci)
> +		return -EINVAL;
>  	if (WARN_ON_ONCE(len <= 0))
>  		return -EINVAL;
>  	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0))
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 926531597e7b..6e6020f7746c 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -286,6 +286,38 @@ typedef enum {
>  	FS_ENCRYPT,
>  } fscrypt_direction_t;
>  
> +/**
> + * fscrypt_fs_uses_extent_encryption() -- whether a filesystem uses per-extent
> + *				          encryption
> + *
> + * @sb: the superblock of the filesystem in question
> + *
> + * Return: true if the fs uses per-extent fscrypt_infos, false otherwise
> + */
> +static inline bool
> +fscrypt_fs_uses_extent_encryption(const struct super_block *sb)
> +{
> +	return !!sb->s_cop->get_extent_info;
> +}
> +
> +/**
> + * fscrypt_uses_extent_encryption() -- whether an inode uses per-extent
> + *				       encryption
> + *
> + * @inode: the inode in question
> + *
> + * Return: true if the inode uses per-extent fscrypt_infos, false otherwise
> + */
> +static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
> +{
> +	// Non-regular files don't have extents

Wrong comment format.

> +	if (!S_ISREG(inode->i_mode))
> +		return false;
> +
> +	return fscrypt_fs_uses_extent_encryption(inode->i_sb);
> +}
> +
> +
>  /**
>   * fscrypt_get_lblk_info() - get the fscrypt_info to crypt a particular block
>   *
> @@ -306,6 +338,17 @@ static inline struct fscrypt_info *
>  fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
>  		      u64 *extent_len)
>  {
> +	if (fscrypt_uses_extent_encryption(inode)) {
> +		struct fscrypt_info *info;
> +		int res;
> +
> +		res = inode->i_sb->s_cop->get_extent_info(inode, lblk, &info,
> +							  offset, extent_len);
> +		if (res == 0)
> +			return info;
> +		return NULL;
> +	}
> +
>  	if (offset)
>  		*offset = lblk;
>  	if (extent_len)
> @@ -314,39 +357,6 @@ fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
>  	return inode->i_crypt_info;
>  }
>  
> -/**
> - * fscrypt_uses_extent_encryption() -- whether an inode uses per-extent
> - *				       encryption
> - *
> - * @inode: the inode in question
> - *
> - * Return: true if the inode uses per-extent fscrypt_infos, false otherwise
> - */
> -static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
> -{
> -	// Non-regular files don't have extents
> -	if (!S_ISREG(inode->i_mode))
> -		return false;
> -
> -	// No filesystems currently use per-extent infos
> -	return false;
> -}
> -
> -/**
> - * fscrypt_fs_uses_extent_encryption() -- whether a filesystem uses per-extent
> - *				          encryption
> - *
> - * @sb: the superblock of the filesystem in question
> - *
> - * Return: true if the fs uses per-extent fscrypt_infos, false otherwise
> - */
> -static inline bool
> -fscrypt_fs_uses_extent_encryption(const struct super_block *sb)
> -{
> -	// No filesystems currently use per-extent infos
> -	return false;
> -}
> -
>  /**
>   * fscrypt_get_info_ino() - get the ino or ino equivalent for an info
>   *
> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> index 59748d333b89..8e4065d1e422 100644
> --- a/fs/crypto/keyring.c
> +++ b/fs/crypto/keyring.c
> @@ -880,15 +880,8 @@ static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
>  
>  	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
>  		inode = ci->ci_inode;
> -		if (!inode) {
> -			if (!ci->ci_sb->s_cop->forget_extent_info)
> -				continue;
> -
> -			spin_unlock(&mk->mk_decrypted_inodes_lock);
> -			ci->ci_sb->s_cop->forget_extent_info(ci->ci_info_ptr);
> -			spin_lock(&mk->mk_decrypted_inodes_lock);
> +		if (ci->ci_info_ptr)
>  			continue;
> -		}
>  
>  		spin_lock(&inode->i_lock);
>  		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index 2b4fca6814a7..c8cdcd4fe835 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -676,8 +676,8 @@ fscrypt_setup_encryption_info(struct inode *inode,
>  
>  	if (fscrypt_uses_extent_encryption(inode) && info_for_extent)
>  		crypt_info->ci_info_ptr = info_ptr;
> -	else
> -		crypt_info->ci_inode = inode;
> +
> +	crypt_info->ci_inode = inode;

You changed this and now you're changing it back, go back to the original patch
and leave this the way it was.

>  
>  	crypt_info->ci_sb = inode->i_sb;
>  	crypt_info->ci_policy = *policy;
> @@ -917,6 +917,60 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
>  }
>  EXPORT_SYMBOL_GPL(fscrypt_prepare_new_inode);
>  
> +/**
> + * fscrypt_prepare_new_extent() - set up the fscrypt_info for a new extent
> + * @inode: the inode to which the extent belongs
> + * @info_ptr: a pointer to return the extent's fscrypt_info into. Should be
> + *	      a pointer to a member of the extent struct, as it will be passed
> + *	      back to the filesystem if key removal demands removal of the
> + *	      info from the extent
> + * @encrypt_ret: (output) set to %true if the new inode will be encrypted
> + *
> + * If the extent is part of an encrypted inode, set up its fscrypt_info in
> + * preparation for encrypting data and set *encrypt_ret=true.
> + *
> + * This isn't %GFP_NOFS-safe, and therefore it should be called before starting
> + * any filesystem transaction to create the inode.
> + *
> + * This doesn't persist the new inode's encryption context.  That still needs to
> + * be done later by calling fscrypt_set_context().
> + *
> + * Return: 0 on success, -ENOKEY if the encryption key is missing, or another
> + *	   -errno code
> + */
> +int fscrypt_prepare_new_extent(struct inode *inode,
> +			       struct fscrypt_info **info_ptr)
> +{
> +	const union fscrypt_policy *policy;
> +	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
> +
> +	policy = fscrypt_policy_to_inherit(inode);
> +	if (policy == NULL)
> +		return 0;
> +	if (IS_ERR(policy))
> +		return PTR_ERR(policy);
> +
> +	/* Only regular files can have extents.  */
> +	if (WARN_ON_ONCE(!S_ISREG(inode->i_mode)))
> +		return -EINVAL;
> +
> +	get_random_bytes(nonce, FSCRYPT_FILE_NONCE_SIZE);
> +	return fscrypt_setup_encryption_info(inode, policy, nonce,
> +					     false, info_ptr);
> +}
> +EXPORT_SYMBOL_GPL(fscrypt_prepare_new_extent);
> +
> +/**
> + * fscrypt_free_extent_info() - free an extent's fscrypt_info
> + * @info_ptr: a pointer containing the extent's fscrypt_info pointer.
> + */
> +void fscrypt_free_extent_info(struct fscrypt_info **info_ptr)
> +{
> +	put_crypt_info(*info_ptr);
> +	*info_ptr = NULL;
> +}
> +EXPORT_SYMBOL_GPL(fscrypt_free_extent_info);
> +
>  /**
>   * fscrypt_put_encryption_info() - free most of an inode's fscrypt data
>   * @inode: an inode being evicted
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index 22affbb15706..e39165fbed41 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -113,6 +113,29 @@ struct fscrypt_operations {
>  	int (*set_context)(struct inode *inode, const void *ctx, size_t len,
>  			   void *fs_data);
>  
> +	/*
> +	 * Get the fscrypt_info for the given inode at the given block, for
> +	 * extent-based encryption only.
> +	 *
> +	 * @inode: the inode in question
> +	 * @lblk: the logical block number in question
> +	 * @ci: a pointer to return the fscrypt_info
> +	 * @offset: a pointer to return the offset of @lblk into the extent,
> +	 *          in blocks (may be NULL)
> +	 * @extent_len: a pointer to return the number of blocks in this extent
> +	 *              starting at this point (may be NULL)
> +	 *
> +	 * May cause the filesystem to allocate memory, which the filesystem
> +	 * must do with %GFP_NOFS, including calls into fscrypt to create or
> +	 * load an fscrypt_info.
> +	 *
> +	 * Return: 0 if an extent is found with an info, -ENODATA if the key is
> +	 *         unavailable, or another -errno.
> +	 */
> +	int (*get_extent_info)(const struct inode *inode, u64 lblk,
> +			       struct fscrypt_info **ci, u64 *offset,
> +			       u64 *extent_len);
> +
>  	/*
>  	 * Get the dummy fscrypt policy in use on the filesystem (if any).
>  	 *
> @@ -129,15 +152,6 @@ struct fscrypt_operations {
>  	 */
>  	bool (*empty_dir)(struct inode *inode);
>  
> -	/*
> -	 * Inform the filesystem that a particular extent must forget its
> -	 * fscrypt_info (for instance, for a key removal).
> -	 *
> -	 * @info_ptr: a pointer to the location storing the fscrypt_info pointer
> -	 *            within the opaque extent whose info is to be freed
> -	 */
> -	void (*forget_extent_info)(struct fscrypt_info **info_ptr);
> -

You've done this again, backed out a change you did before.  Rework the series
to simply not need this thing in the first place.  Thanks,

Josef
