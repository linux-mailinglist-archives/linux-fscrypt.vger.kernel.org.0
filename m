Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614435B2288
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Sep 2022 17:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiIHPiT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Sep 2022 11:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiIHPh6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Sep 2022 11:37:58 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96025AD99B
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Sep 2022 08:37:52 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id d15so732428qka.9
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Sep 2022 08:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4SANW6LI1B5rdXy0jdH7H2VYf+tB1vMEjPKRxLSeXsQ=;
        b=aN/lwnm0VXf9/OPlhruLIJgHfGiPY1OMjUOpiaWIGNZqY/4SY5kKd5EMcay+z91HZq
         HLHAbaeQdu0v1tvnmYE99/yuwPTgKq1NLilu4Ptz2BRX+eb0UDpWdA4vn7EBiFcl0OJi
         4zR166PsD2pOSnWUzsR4P8YJ/lrHKZ0n1fj1gzMVQ8YZKHH2n6kS8/WiHEIsloPjVG2K
         3wd7uVmnrHCnDpi7tBgoIH99KYDPnrWAUQMIdEd6gv2wdaPkXN2zP6ArkZIcPgBmzncy
         4Gv5MsgffOAyVXdNiQRYNzc3LUrigBksx5sl0F4zIi23ClGpWp8r0kWNDVl3QFm5mcn1
         l94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4SANW6LI1B5rdXy0jdH7H2VYf+tB1vMEjPKRxLSeXsQ=;
        b=Uo1wjXwEGW2/IO/+Fc/4JUbtCbR6KC+ApxzJru3x0NNuDs4hyL6Sf0UJ8a5FxizENr
         M1yNFuYT0xNODBHMh6457zEMuIoTSXdw/RSOC9vGypnfL2Dwnswm7roaxH+Wz6Yukftz
         TAGpCpFFgvKC1C22A6MOSjMaX9n95KPnlfQ7Us4tPYKAnDh2SJv5PJ20oxhSTTHIU+Ct
         5cfcvDR/CVm1SJlPm7EkA/TcruC3fkHlLLrWD3rhheHTfiSxZvWVjFbAXXXE59bQvEHc
         4rFplXZY3eU3+0fhDLgbdBccF0+ku74SUUnI7S22e4fRmCz8DQcy9uzxI0ZQQDWi8k9J
         8OrQ==
X-Gm-Message-State: ACgBeo0SJmiy0TUCcnoh/OXolgrkEpo7COtQ9Gtgkhq4ddt5wj0yurPj
        WF3AeglasVqbrbEcI26nZ1QJjg==
X-Google-Smtp-Source: AA6agR6NDfQE4MbgZjjEl6kfX5MDeZzbRLkKLcbnKNN4eP71TltPQ+5ELaFH4vGUezbZ9MPoc2tjBA==
X-Received: by 2002:a05:620a:4692:b0:6bb:5a0c:9ca1 with SMTP id bq18-20020a05620a469200b006bb5a0c9ca1mr6853769qkb.318.1662651470796;
        Thu, 08 Sep 2022 08:37:50 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id c28-20020ac81e9c000000b0034454067d24sm15362923qtm.64.2022.09.08.08.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:37:50 -0700 (PDT)
Date:   Thu, 8 Sep 2022 11:37:49 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 07/20] btrfs: store directory's encryption state
Message-ID: <YxoMTeFGYn0W81HP@localhost.localdomain>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <ff2c761cd3f71ed4ff2098c2a02a1ff52afbdbe9.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff2c761cd3f71ed4ff2098c2a02a1ff52afbdbe9.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:22PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> For directories with encrypted files/filenames, we need to store a flag
> indicating this fact. There's no room in other fields, so we'll need to
> borrow a bit from dir_type. Since it's now a combination of type and
> flags, we rename it to dir_flags to reflect its new usage.
> 
> The new flag, FT_FSCRYPT, indicates a (perhaps partially) encrypted
> directory, which is orthogonal to file type; therefore, add the new
> flag, and make conversion from directory type to file type strip the
> flag.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/ctree.h                | 15 +++++++++++++--
>  fs/btrfs/delayed-inode.c        |  6 +++---
>  fs/btrfs/delayed-inode.h        |  2 +-
>  fs/btrfs/dir-item.c             |  4 ++--
>  fs/btrfs/inode.c                | 15 +++++++++------
>  fs/btrfs/print-tree.c           |  4 ++--
>  fs/btrfs/send.c                 |  2 +-
>  fs/btrfs/tree-checker.c         |  2 +-
>  fs/btrfs/tree-log.c             | 20 ++++++++++----------
>  include/uapi/linux/btrfs_tree.h |  7 +++++++
>  10 files changed, 49 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 7007c7974a2e..1793b0e16a14 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2184,10 +2184,10 @@ BTRFS_SETGET_FUNCS(root_ref_name_len, struct btrfs_root_ref, name_len, 16);
>  
>  /* struct btrfs_dir_item */
>  BTRFS_SETGET_FUNCS(dir_data_len, struct btrfs_dir_item, data_len, 16);
> -BTRFS_SETGET_FUNCS(dir_type, struct btrfs_dir_item, type, 8);
> +BTRFS_SETGET_FUNCS(dir_flags, struct btrfs_dir_item, type, 8);
>  BTRFS_SETGET_FUNCS(dir_name_len, struct btrfs_dir_item, name_len, 16);
>  BTRFS_SETGET_FUNCS(dir_transid, struct btrfs_dir_item, transid, 64);
> -BTRFS_SETGET_STACK_FUNCS(stack_dir_type, struct btrfs_dir_item, type, 8);
> +BTRFS_SETGET_STACK_FUNCS(stack_dir_flags, struct btrfs_dir_item, type, 8);
>  BTRFS_SETGET_STACK_FUNCS(stack_dir_data_len, struct btrfs_dir_item,
>  			 data_len, 16);
>  BTRFS_SETGET_STACK_FUNCS(stack_dir_name_len, struct btrfs_dir_item,
> @@ -2195,6 +2195,17 @@ BTRFS_SETGET_STACK_FUNCS(stack_dir_name_len, struct btrfs_dir_item,
>  BTRFS_SETGET_STACK_FUNCS(stack_dir_transid, struct btrfs_dir_item,
>  			 transid, 64);
>  
> +static inline u8 btrfs_dir_ftype(const struct extent_buffer *eb,
> +				 const struct btrfs_dir_item *item)
> +{
> +	return btrfs_dir_flags_to_ftype(btrfs_dir_flags(eb, item));
> +}
> +
> +static inline u8 btrfs_stack_dir_ftype(const struct btrfs_dir_item *item)
> +{
> +	return btrfs_dir_flags_to_ftype(btrfs_stack_dir_flags(item));
> +}
> +
>  static inline void btrfs_dir_item_key(const struct extent_buffer *eb,
>  				      const struct btrfs_dir_item *item,
>  				      struct btrfs_disk_key *key)
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index cac5169eaf8d..7e405aafab86 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1412,7 +1412,7 @@ void btrfs_balance_delayed_items(struct btrfs_fs_info *fs_info)
>  int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
>  				   const char *name, int name_len,
>  				   struct btrfs_inode *dir,
> -				   struct btrfs_disk_key *disk_key, u8 type,
> +				   struct btrfs_disk_key *disk_key, u8 flags,
>  				   u64 index)
>  {
>  	struct btrfs_fs_info *fs_info = trans->fs_info;
> @@ -1443,7 +1443,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
>  	btrfs_set_stack_dir_transid(dir_item, trans->transid);
>  	btrfs_set_stack_dir_data_len(dir_item, 0);
>  	btrfs_set_stack_dir_name_len(dir_item, name_len);
> -	btrfs_set_stack_dir_type(dir_item, type);
> +	btrfs_set_stack_dir_flags(dir_item, flags);
>  	memcpy((char *)(dir_item + 1), name, name_len);
>  
>  	data_len = delayed_item->data_len + sizeof(struct btrfs_item);
> @@ -1753,7 +1753,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
>  		name = (char *)(di + 1);
>  		name_len = btrfs_stack_dir_name_len(di);
>  
> -		d_type = fs_ftype_to_dtype(di->type);
> +		d_type = fs_ftype_to_dtype(btrfs_dir_flags_to_ftype(di->type));
>  		btrfs_disk_key_to_cpu(&location, &di->location);
>  
>  		over = !dir_emit(ctx, name, name_len,
> diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
> index 0163ca637a96..4f21daa3dbc7 100644
> --- a/fs/btrfs/delayed-inode.h
> +++ b/fs/btrfs/delayed-inode.h
> @@ -113,7 +113,7 @@ static inline void btrfs_init_delayed_root(
>  int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
>  				   const char *name, int name_len,
>  				   struct btrfs_inode *dir,
> -				   struct btrfs_disk_key *disk_key, u8 type,
> +				   struct btrfs_disk_key *disk_key, u8 flags,
>  				   u64 index);
>  
>  int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index 72fb2c518a2b..e37b075afa96 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -81,7 +81,7 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
>  	leaf = path->nodes[0];
>  	btrfs_cpu_key_to_disk(&disk_key, &location);
>  	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
> -	btrfs_set_dir_type(leaf, dir_item, BTRFS_FT_XATTR);
> +	btrfs_set_dir_flags(leaf, dir_item, BTRFS_FT_XATTR);
>  	btrfs_set_dir_name_len(leaf, dir_item, name_len);
>  	btrfs_set_dir_transid(leaf, dir_item, trans->transid);
>  	btrfs_set_dir_data_len(leaf, dir_item, data_len);
> @@ -140,7 +140,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, const char *name,
>  
>  	leaf = path->nodes[0];
>  	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
> -	btrfs_set_dir_type(leaf, dir_item, type);
> +	btrfs_set_dir_flags(leaf, dir_item, type);
>  	btrfs_set_dir_data_len(leaf, dir_item, 0);
>  	btrfs_set_dir_name_len(leaf, dir_item, name_len);
>  	btrfs_set_dir_transid(leaf, dir_item, trans->transid);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e5284f2686c8..97e17b9bd34f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5563,7 +5563,7 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
>  			   location->objectid, location->type, location->offset);
>  	}
>  	if (!ret)
> -		*type = btrfs_dir_type(path->nodes[0], di);
> +		*type = btrfs_dir_ftype(path->nodes[0], di);
>  out:
>  	btrfs_free_path(path);
>  	return ret;
> @@ -6001,6 +6001,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
>  	btrfs_for_each_slot(root, &key, &found_key, path, ret) {
>  		struct dir_entry *entry;
>  		struct extent_buffer *leaf = path->nodes[0];
> +		u8 di_flags;
>  
>  		if (found_key.objectid != key.objectid)
>  			break;
> @@ -6024,13 +6025,15 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
>  			goto again;
>  		}
>  
> +		di_flags = btrfs_dir_flags(leaf, di);

You're already doing this just for the thing below, why not just do

		u8 ftype;

		ftype = btrfs_dir_flags_to_ftype(btrfs_dir_flags(leaf, di);

>  		entry = addr;
> -		put_unaligned(name_len, &entry->name_len);
>  		name_ptr = (char *)(entry + 1);
> -		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
> -				   name_len);
> -		put_unaligned(fs_ftype_to_dtype(btrfs_dir_type(leaf, di)),
> -				&entry->type);
> +		read_extent_buffer(leaf, name_ptr,
> +				   (unsigned long)(di + 1), name_len);
> +		put_unaligned(name_len, &entry->name_len);
> +		put_unaligned(
> +			fs_ftype_to_dtype(btrfs_dir_flags_to_ftype(di_flags)),
> +			&entry->type);

then here do

		put unaligned(fs_ftyp_to_dtype(ftype), &entry->type);

to make it a little cleaner.  Thanks,

Josef
