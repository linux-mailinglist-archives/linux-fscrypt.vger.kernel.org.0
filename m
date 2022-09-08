Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923355B2784
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Sep 2022 22:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiIHUQG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Sep 2022 16:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiIHUQF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Sep 2022 16:16:05 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C407ED3BD
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Sep 2022 13:16:01 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id b2so13799066qkh.12
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Sep 2022 13:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=CJ2+EJJ+2NQcIGAdP/1D385oFTBzh/9hYTJm2KNrbrk=;
        b=1WH4KT6A7fiyRMhot5sflX3yNcSRH1w1WCQ3+N+c5G02mp98b+DrOSwBnToUJQICab
         iDaeoD4QnFVAWGeXZnb+drXyy+zjYMA+YN7gVjkz0AFImDgXtsGCmoI3sN9Sx/0lcf/l
         JFdmtJzkzfmFqVovhlUwVr32N+mryDZlGf5nD6l/zHY5WnhvHuZvflTYUsnt8uWoO7YE
         vge+xHaDpk+3VjajcWE0L/uMXkgkqA4k24demVX+/8fwOn2Y5J7lCdnMhW96yO1tA+/C
         v8d7AJjFhG2og9Q0WPo78tG/v8O1D43gmuplTJuUtUnYLFowejzaet1CuuhStZNoJ3AQ
         mQyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=CJ2+EJJ+2NQcIGAdP/1D385oFTBzh/9hYTJm2KNrbrk=;
        b=itlxhzqWS9ayr0QGS7ZBEYzeP66/BoCo1SSjRkbbTYIug+io+j1rZiyvsfWTRcB5OV
         ZJKK0YKwVzgteyTv3caNcKT203j6P1ANQzFBy8d37+GHOuZOdpYF98w71Hl1gfP++d/v
         tqwZjavSGfpZATP7wPo/FYRBd8lxXQ8+NKRhKq6GVEMIVuA9amgK+bsWriJ+eKiZIV8w
         q2VwLcRcCE47Yz+deWE204rvZ0nL+WbxpDYH6qogPTpjjquYxl2XIcQCzmCzikhsyIoJ
         SrRCdGQvwHu6knNwTDCXUCkLxrytVLU24iZq5QxBDtboNj1xMcwmmwy6O4AGhLCDhMOc
         Eyww==
X-Gm-Message-State: ACgBeo0fy42Sap8ZNAWaUzBmwMQn1sNFxIZw7Yfk/IlGTCPabtJniBLV
        SR/7kdxUuIjwpxfQgdrtJujeHQ==
X-Google-Smtp-Source: AA6agR72wLshtMFXdwG0+3DNxqbuZnwcvT7bnx1payHQ4VlrHw33GzmKJZAGXAnN3KHNjh1s8EthdA==
X-Received: by 2002:a05:620a:1298:b0:6be:9bec:b555 with SMTP id w24-20020a05620a129800b006be9becb555mr7961111qki.146.1662668160217;
        Thu, 08 Sep 2022 13:16:00 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id fp18-20020a05622a509200b0034455ff76ddsm23535qtb.34.2022.09.08.13.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 13:15:59 -0700 (PDT)
Date:   Thu, 8 Sep 2022 16:15:58 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 18/20] btrfs: adapt directory read and lookup to
 potentially encrypted filenames
Message-ID: <YxpNfmMN8H/brIeL@localhost.localdomain>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <a39aff2f5502199152a680e31db90f7162b4f350.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a39aff2f5502199152a680e31db90f7162b4f350.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:33PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> When filenames can be encrypted, if we don't initially match a desired
> filename, we have to try decrypting it with the directory key to see if
> it matches in plaintext. Similarly, for readdir, we need to read
> encrypted directory items as well as unencrypted.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/delayed-inode.c | 32 +++++++++++---
>  fs/btrfs/delayed-inode.h |  4 +-
>  fs/btrfs/dir-item.c      | 23 ++++++++++
>  fs/btrfs/inode.c         | 90 ++++++++++++++++++++++++++++++++++++----
>  4 files changed, 134 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 069326654074..5eef6f96c6b6 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1493,9 +1493,9 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
>  
>  	ret = __btrfs_add_delayed_item(delayed_node, delayed_item);
>  	if (unlikely(ret)) {
> +		// TODO: It would be nice to print the base64encoded name here maybe?
>  		btrfs_err(trans->fs_info,
> -			  "err add delayed dir index item(name: %.*s) into the insertion tree of the delayed node(root id: %llu, inode id: %llu, errno: %d)",
> -			  fname_len(fname), fname_name(fname),
> +			  "err add delayed dir index item into the insertion tree of the delayed node (root id: %llu, inode id: %llu, errno: %d)",
>  			  delayed_node->root->root_key.objectid,
>  			  delayed_node->inode_id, ret);
>  		BUG();
> @@ -1721,7 +1721,9 @@ int btrfs_should_delete_dir_index(struct list_head *del_list,
>   * btrfs_readdir_delayed_dir_index - read dir info stored in the delayed tree
>   *
>   */
> -int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
> +int btrfs_readdir_delayed_dir_index(struct inode *inode,
> +				    struct fscrypt_str *fstr,
> +				    struct dir_context *ctx,
>  				    struct list_head *ins_list)
>  {
>  	struct btrfs_dir_item *di;
> @@ -1731,6 +1733,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
>  	int name_len;
>  	int over = 0;
>  	unsigned char d_type;
> +	size_t fstr_len = fstr->len;
>  
>  	if (list_empty(ins_list))
>  		return 0;
> @@ -1758,8 +1761,27 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
>  		d_type = fs_ftype_to_dtype(btrfs_dir_flags_to_ftype(di->type));
>  		btrfs_disk_key_to_cpu(&location, &di->location);
>  
> -		over = !dir_emit(ctx, name, name_len,
> -			       location.objectid, d_type);
> +		if (di->type & BTRFS_FT_FSCRYPT_NAME) {
> +			int ret;
> +			struct fscrypt_str iname = FSTR_INIT(name, name_len);
> +			fstr->len = fstr_len;
> +			/*
> +			 * The hash is only used when the encryption key is not
> +			 * available. But if we have delayed insertions, then we
> +			 * must have the encryption key available or we wouldn't
> +			 * have been able to create entries in the directory.
> +			 * So, we don't calculate the hash.
> +			 */
> +			ret = fscrypt_fname_disk_to_usr(inode, 0, 0, &iname,
> +							fstr);
> +			if (ret)
> +				return ret;
> +			over = !dir_emit(ctx, fstr->name, fstr->len,
> +					 location.objectid, d_type);
> +		} else {
> +			over = !dir_emit(ctx, name, name_len, location.objectid,
> +					 d_type);
> +		}
>  
>  		if (refcount_dec_and_test(&curr->refs))
>  			kfree(curr);
> diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
> index 8abeb78af14e..9491bf0b7576 100644
> --- a/fs/btrfs/delayed-inode.h
> +++ b/fs/btrfs/delayed-inode.h
> @@ -156,7 +156,9 @@ void btrfs_readdir_put_delayed_items(struct inode *inode,
>  				     struct list_head *del_list);
>  int btrfs_should_delete_dir_index(struct list_head *del_list,
>  				  u64 index);
> -int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
> +int btrfs_readdir_delayed_dir_index(struct inode *inode,
> +				    struct fscrypt_str *fstr,
> +				    struct dir_context *ctx,
>  				    struct list_head *ins_list);
>  
>  /* Used during directory logging. */
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index 8d7c3c32ed8e..6b1ea32419fb 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -120,6 +120,9 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
>  	struct btrfs_disk_key disk_key;
>  	u32 data_size;
>  
> +	if (fname->crypto_buf.name)
> +		type |= BTRFS_FT_FSCRYPT_NAME;
> +
>  	key.objectid = btrfs_ino(dir);
>  	key.type = BTRFS_DIR_ITEM_KEY;
>  	key.offset = btrfs_name_hash(fname);
> @@ -385,6 +388,18 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
>  	u32 cur = 0;
>  	u32 this_len;
>  	struct extent_buffer *leaf;
> +	bool encrypted = (fname->crypto_buf.name != NULL);
> +	struct fscrypt_name unencrypted_fname;
> +
> +	if (encrypted) {
> +		unencrypted_fname = (struct fscrypt_name){
> +			.usr_fname = fname->usr_fname,
> +			.disk_name = {
> +				.name = (unsigned char *)fname->usr_fname->name,
> +				.len = fname->usr_fname->len,
> +			},
> +		};
> +	}
>  
>  	leaf = path->nodes[0];
>  	dir_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
> @@ -401,6 +416,14 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
>  			return dir_item;
>  		}
>  
> +		if (encrypted && 

Whitespace.

> +		    btrfs_dir_name_len(leaf, dir_item) == fname_len(&unencrypted_fname) &&
> +		    btrfs_fscrypt_match_name(&unencrypted_fname, leaf,
> +					     (unsigned long)(dir_item + 1),
> +					     dir_name_len)) {
> +			return dir_item;
> +		}
> +
>  		cur += this_len;
>  		dir_item = (struct btrfs_dir_item *)((char *)dir_item +
>  						     this_len);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4c134a6486b3..1c7681d7770c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4292,6 +4292,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  	u64 index;
>  	u64 ino = btrfs_ino(inode);
>  	u64 dir_ino = btrfs_ino(dir);
> +	u64 di_name_len;
>  
>  	path = btrfs_alloc_path();
>  	if (!path) {
> @@ -4304,6 +4305,13 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  		ret = di ? PTR_ERR(di) : -ENOENT;
>  		goto err;
>  	}
> +
> +	/*
> +	 * We have to read the actual name length off disk -- the fname
> +	 * provided may have been a nokey_name with uncertain length.
> +	 */
> +	di_name_len = btrfs_dir_name_len(path->nodes[0], di);
> +
>  	ret = btrfs_delete_one_dir_name(trans, root, path, di);
>  	if (ret)
>  		goto err;
> @@ -4371,7 +4379,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  	if (ret)
>  		goto out;
>  
> -	btrfs_i_size_write(dir, dir->vfs_inode.i_size - fname_len(fname) * 2);
> +	btrfs_i_size_write(dir, dir->vfs_inode.i_size - di_name_len * 2);
>  	inode_inc_iversion(&inode->vfs_inode);
>  	inode_inc_iversion(&dir->vfs_inode);
>  	inode->vfs_inode.i_ctime = current_time(&inode->vfs_inode);
> @@ -5882,12 +5890,25 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
>  	struct btrfs_root *root = BTRFS_I(dir)->root;
>  	struct btrfs_root *sub_root = root;
>  	struct btrfs_key location;
> +	struct fscrypt_name fname;
>  	u8 di_type = 0;
>  	int ret = 0;
>  
>  	if (dentry->d_name.len > BTRFS_NAME_LEN)
>  		return ERR_PTR(-ENAMETOOLONG);
>  
> +	if (BTRFS_I(dir)->flags & BTRFS_INODE_FSCRYPT_CONTEXT) {
> +		ret = fscrypt_prepare_lookup(dir, dentry, &fname);
> +		if (ret)
> +			return ERR_PTR(ret);
> +	} else {
> +		fname = (struct fscrypt_name) {
> +			.usr_fname = &dentry->d_name,
> +			.disk_name = FSTR_INIT((char *) dentry->d_name.name,
> +					       dentry->d_name.len),
> +		};
> +	}
> +
>  	ret = btrfs_inode_by_name(dir, dentry, &location, &di_type);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> @@ -6029,18 +6050,32 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
>  	struct list_head del_list;
>  	int ret;
>  	char *name_ptr;
> -	int name_len;
> +	u32 name_len;
>  	int entries = 0;
>  	int total_len = 0;
>  	bool put = false;
>  	struct btrfs_key location;
> +	struct fscrypt_str fstr = FSTR_INIT(NULL, 0);
> +	u32 fstr_len = 0;
>  
>  	if (!dir_emit_dots(file, ctx))
>  		return 0;
>  
> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_FSCRYPT_CONTEXT) {
> +		ret = fscrypt_prepare_readdir(inode);
> +		if (ret)
> +			return ret;
> +		ret = fscrypt_fname_alloc_buffer(BTRFS_NAME_LEN, &fstr);
> +		if (ret)
> +			return ret;
> +		fstr_len = fstr.len;
> +	}
> +
>  	path = btrfs_alloc_path();
> -	if (!path)
> -		return -ENOMEM;
> +	if (!path) {
> +		ret = -ENOMEM;
> +		goto err_fstr;
> +	}
>  
>  	addr = private->filldir_buf;
>  	path->reada = READA_FORWARD;
> @@ -6058,6 +6093,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
>  		struct dir_entry *entry;
>  		struct extent_buffer *leaf = path->nodes[0];
>  		u8 di_flags;
> +		u32 nokey_len;
>  
>  		if (found_key.objectid != key.objectid)
>  			break;
> @@ -6069,8 +6105,13 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
>  			continue;
>  		di = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
>  		name_len = btrfs_dir_name_len(leaf, di);
> -		if ((total_len + sizeof(struct dir_entry) + name_len) >=
> -		    PAGE_SIZE) {
> +		nokey_len = DIV_ROUND_UP(name_len * 4, 3);
> +		/*
> +		 * If name is encrypted, and we don't have the key, we could
> +		 * need up to 4/3rds the bytes to print it.
> +		 */
> +		if ((total_len + sizeof(struct dir_entry) + nokey_len)
> +		    >= PAGE_SIZE) {
>  			btrfs_release_path(path);
>  			ret = btrfs_filldir(private->filldir_buf, entries, ctx);
>  			if (ret)
> @@ -6084,8 +6125,36 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
>  		di_flags = btrfs_dir_flags(leaf, di);
>  		entry = addr;
>  		name_ptr = (char *)(entry + 1);
> -		read_extent_buffer(leaf, name_ptr,
> -				   (unsigned long)(di + 1), name_len);
> +		if (di_flags & BTRFS_FT_FSCRYPT_NAME) {
> +			struct fscrypt_str oname = FSTR_INIT(name_ptr,
> +							     nokey_len);
> +			u32 hash = 0, minor_hash = 0;
> +
> +			read_extent_buffer(leaf, fstr.name,
> +					   (unsigned long)(di + 1), name_len);
> +			fstr.len = name_len;
> +			/*
> +			 * We're iterating through DIR_INDEX items, so we don't
> +			 * have the DIR_ITEM hash handy. Only compute it if
> +			 * we'll need it.
> +			 */
> +			if (!fscrypt_has_encryption_key(inode)) {
> +				struct fscrypt_name fname = {
> +					.disk_name = fstr,
> +				};
> +				u64 name_hash = btrfs_name_hash(&fname);
> +				hash = name_hash;
> +				minor_hash = name_hash >> 32;
> +			}
> +			ret = fscrypt_fname_disk_to_usr(inode, hash, minor_hash,
> +							&fstr, &oname);
> +			if (ret)
> +				goto err;
> +			name_len = oname.len;

You have this same work in the delayed inode stuff, the only exception is that
you don't do the hash thing.  I assume with the delayed inode that
fscrypt_has_encryption_key() would be true, so you could stuff all this in a
helper and use the helper from both places?  Thanks,

Josef
