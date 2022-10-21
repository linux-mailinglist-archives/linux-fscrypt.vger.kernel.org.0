Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCD4608005
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Oct 2022 22:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiJUUnD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Oct 2022 16:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiJUUmZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Oct 2022 16:42:25 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2049CABE3
        for <linux-fscrypt@vger.kernel.org>; Fri, 21 Oct 2022 13:42:03 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id hh9so2407976qtb.13
        for <linux-fscrypt@vger.kernel.org>; Fri, 21 Oct 2022 13:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fbiK3bqCuAHt9aRaUIDjozx1MWhytKTxkAd6fGi00zE=;
        b=v3IJ6AJFcyhDhuZnFHpX8QzGdzDY8ZnNlWHqVUoc9gxx8mIOG3Xad6/tGapsaryN+1
         4n3UZlPB5Wi7bQgy6MdVXgOxn1oqjyPairjO5eaDFEk+NBSTJUnr0eadqwy5O2a48aGP
         C2UrsWFMSmrna1Uf5jG0B+p18G+EX3Oa2Q/n1oArWBibrKCz+Xw63Cwzfdt92Fs7uSns
         QBJ13o5guTd+PfQ+DRxwTQi6FPpuNCNz+mDQli5VxgTPt98xTFX/tfmAp/fqRVKCSsjS
         sw8gfXd96+1L+el61YtfeBfQB7A4MzRt5INFpU8y9nWCF7CIWOeyBf/W5PN8un8GrQF2
         FQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fbiK3bqCuAHt9aRaUIDjozx1MWhytKTxkAd6fGi00zE=;
        b=Ct0Sgd6fo9hbE7jg1asGUu6C3Fwve37bXClebqrUFw0Da9sTQtiwtC8/mio0vMYOke
         my0xambfnF2LG5cv30ZwSQBZA7Ehe8EXH22JnuDo5z14S8LBXsvhHv1fRUwHEq2b0qH2
         6m1lT7GjMkXBOmacRVq19d0N3gTLrRtLAC7uAkxzL8qajMEWtiVXSb6gDLFjcJWaXp2e
         nPdOtJzlKoPFEhch9lbmRdYXQcVFA+Bb1AkU4fI3YO9rnvLadqd54sv+eYIi0g/7oO51
         Q4xKGnRUWhEeaHptigSAbiN0RmN98nN5l45OAREAs+xxlO52EB+RyMwuTzNvdrNZBcCk
         IO6g==
X-Gm-Message-State: ACrzQf3gYJ/DxdZuJ+NGpWN3i/auMevogFQfxp+wRJfGHSdtiXBH+kRQ
        LEC9b/NJs74+kyOyd0mJPphqAQ==
X-Google-Smtp-Source: AMsMyM7knd/ms0kNL+pfqC4GcEYq5GqQpgrJ69wAEP4yxfX0Z7UlJnEoiDf02i9vUk5Kq7P8sKAjug==
X-Received: by 2002:a05:622a:1aa0:b0:39c:ce01:8764 with SMTP id s32-20020a05622a1aa000b0039cce018764mr18777389qtc.401.1666384922264;
        Fri, 21 Oct 2022 13:42:02 -0700 (PDT)
Received: from localhost (cpe-174-109-170-245.nc.res.rr.com. [174.109.170.245])
        by smtp.gmail.com with ESMTPSA id br32-20020a05620a462000b006e9b3096482sm10133697qkb.64.2022.10.21.13.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 13:42:01 -0700 (PDT)
Date:   Fri, 21 Oct 2022 16:42:00 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 08/22] btrfs: use struct fscrypt_str instead of struct
 qstr
Message-ID: <Y1MEGPa6/YgVfiDy@localhost.localdomain>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
 <8c708f4e52ddcf6a361706265f5fcfa64cce912a.1666281277.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c708f4e52ddcf6a361706265f5fcfa64cce912a.1666281277.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 20, 2022 at 12:58:27PM -0400, Sweet Tea Dorminy wrote:
> While struct qstr is more natural without fscrypt, since it's provided
> by dentries, struct fscrypt_str is provided by the fscrypt handlers
> processing dentries, and is thus more natural in the fscrypt world.
> Replace all of the struct qstr uses with struct fscrypt_str.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/ctree.h       | 19 +++++----
>  fs/btrfs/dir-item.c    | 10 ++---
>  fs/btrfs/inode-item.c  | 14 +++----
>  fs/btrfs/inode-item.h  | 10 ++---
>  fs/btrfs/inode.c       | 90 +++++++++++++++++-------------------------
>  fs/btrfs/ioctl.c       |  4 +-
>  fs/btrfs/root-tree.c   |  4 +-
>  fs/btrfs/send.c        |  4 +-
>  fs/btrfs/super.c       |  2 +-
>  fs/btrfs/transaction.c | 13 +++---
>  fs/btrfs/tree-log.c    | 42 ++++++++++----------
>  fs/btrfs/tree-log.h    |  4 +-
>  12 files changed, 98 insertions(+), 118 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 695fd6cf8918..9d1186a16912 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2898,10 +2898,10 @@ static inline void btrfs_clear_sb_rdonly(struct super_block *sb)
>  /* root-item.c */
>  int btrfs_add_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
>  		       u64 ref_id, u64 dirid, u64 sequence,
> -		       const struct qstr *name);
> +		       const struct fscrypt_str *name);
>  int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
>  		       u64 ref_id, u64 dirid, u64 *sequence,
> -		       const struct qstr *name);
> +		       const struct fscrypt_str *name);
>  int btrfs_del_root(struct btrfs_trans_handle *trans,
>  		   const struct btrfs_key *key);
>  int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> @@ -2930,23 +2930,23 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info);
>  
>  /* dir-item.c */
>  int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
> -			  const struct qstr *name);
> +			  const struct fscrypt_str *name);
>  int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
> -			  const struct qstr *name, struct btrfs_inode *dir,
> +			  const struct fscrypt_str *name, struct btrfs_inode *dir,
>  			  struct btrfs_key *location, u8 type, u64 index);
>  struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
>  					     struct btrfs_root *root,
>  					     struct btrfs_path *path, u64 dir,
> -					     const struct qstr *name, int mod);
> +					     const struct fscrypt_str *name, int mod);
>  struct btrfs_dir_item *
>  btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
>  			    struct btrfs_root *root,
>  			    struct btrfs_path *path, u64 dir,
> -			    u64 index, const struct qstr *name, int mod);
> +			    u64 index, const struct fscrypt_str *name, int mod);
>  struct btrfs_dir_item *
>  btrfs_search_dir_index_item(struct btrfs_root *root,
>  			    struct btrfs_path *path, u64 dirid,
> -			    const struct qstr *name);
> +			    const struct fscrypt_str *name);
>  int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
>  			      struct btrfs_root *root,
>  			      struct btrfs_path *path,
> @@ -3027,10 +3027,10 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
>  int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
>  int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  		       struct btrfs_inode *dir, struct btrfs_inode *inode,
> -		       const struct qstr *name);
> +		       const struct fscrypt_str *name);
>  int btrfs_add_link(struct btrfs_trans_handle *trans,
>  		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
> -		   const struct qstr *name, int add_backref, u64 index);
> +		   const struct fscrypt_str *name, int add_backref, u64 index);
>  int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry);
>  int btrfs_truncate_block(struct btrfs_inode *inode, loff_t from, loff_t len,
>  			 int front);
> @@ -3056,7 +3056,6 @@ struct btrfs_new_inode_args {
>  	struct posix_acl *default_acl;
>  	struct posix_acl *acl;
>  	struct fscrypt_name fname;
> -	struct qstr name;
>  };
>  int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
>  			    unsigned int *trans_num_items);
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index 8c60f37eb13f..fdab48c1abb8 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -104,7 +104,7 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
>   * Will return 0 or -ENOMEM
>   */
>  int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
> -			  const struct qstr *name, struct btrfs_inode *dir,
> +			  const struct fscrypt_str *name, struct btrfs_inode *dir,
>  			  struct btrfs_key *location, u8 type, u64 index)
>  {
>  	int ret = 0;
> @@ -206,7 +206,7 @@ static struct btrfs_dir_item *btrfs_lookup_match_dir(
>  struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
>  					     struct btrfs_root *root,
>  					     struct btrfs_path *path, u64 dir,
> -					     const struct qstr *name,
> +					     const struct fscrypt_str *name,
>  					     int mod)
>  {
>  	struct btrfs_key key;
> @@ -225,7 +225,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
>  }
>  
>  int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
> -				   const struct qstr *name)
> +				   const struct fscrypt_str *name)
>  {
>  	int ret;
>  	struct btrfs_key key;
> @@ -302,7 +302,7 @@ struct btrfs_dir_item *
>  btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
>  			    struct btrfs_root *root,
>  			    struct btrfs_path *path, u64 dir,
> -			    u64 index, const struct qstr *name, int mod)
> +			    u64 index, const struct fscrypt_str *name, int mod)
>  {
>  	struct btrfs_dir_item *di;
>  	struct btrfs_key key;
> @@ -321,7 +321,7 @@ btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
>  
>  struct btrfs_dir_item *
>  btrfs_search_dir_index_item(struct btrfs_root *root, struct btrfs_path *path,
> -			    u64 dirid, const struct qstr *name)
> +			    u64 dirid, const struct fscrypt_str *name)
>  {
>  	struct btrfs_dir_item *di;
>  	struct btrfs_key key;
> diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
> index 643b0c555064..ce5c51ffdc0d 100644
> --- a/fs/btrfs/inode-item.c
> +++ b/fs/btrfs/inode-item.c
> @@ -12,7 +12,7 @@
>  
>  struct btrfs_inode_ref *btrfs_find_name_in_backref(struct extent_buffer *leaf,
>  						   int slot,
> -						   const struct qstr *name)
> +						   const struct fscrypt_str *name)
>  {
>  	struct btrfs_inode_ref *ref;
>  	unsigned long ptr;
> @@ -39,7 +39,7 @@ struct btrfs_inode_ref *btrfs_find_name_in_backref(struct extent_buffer *leaf,
>  
>  struct btrfs_inode_extref *btrfs_find_name_in_ext_backref(
>  		struct extent_buffer *leaf, int slot, u64 ref_objectid,
> -		const struct qstr *name)
> +		const struct fscrypt_str *name)
>  {
>  	struct btrfs_inode_extref *extref;
>  	unsigned long ptr;
> @@ -78,7 +78,7 @@ struct btrfs_inode_extref *
>  btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
>  			  struct btrfs_root *root,
>  			  struct btrfs_path *path,
> -			  const struct qstr *name,
> +			  const struct fscrypt_str *name,
>  			  u64 inode_objectid, u64 ref_objectid, int ins_len,
>  			  int cow)
>  {
> @@ -101,7 +101,7 @@ btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
>  
>  static int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
>  				  struct btrfs_root *root,
> -				  const struct qstr *name,
> +				  const struct fscrypt_str *name,
>  				  u64 inode_objectid, u64 ref_objectid,
>  				  u64 *index)
>  {
> @@ -171,7 +171,7 @@ static int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
>  }
>  
>  int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
> -			struct btrfs_root *root, const struct qstr *name,
> +			struct btrfs_root *root, const struct fscrypt_str *name,
>  			u64 inode_objectid, u64 ref_objectid, u64 *index)
>  {
>  	struct btrfs_path *path;
> @@ -248,7 +248,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
>   */
>  static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
>  				     struct btrfs_root *root,
> -				     const struct qstr *name,
> +				     const struct fscrypt_str *name,
>  				     u64 inode_objectid, u64 ref_objectid,
>  				     u64 index)
>  {
> @@ -303,7 +303,7 @@ static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
>  
>  /* Will return 0, -ENOMEM, -EMLINK, or -EEXIST or anything from the CoW path */
>  int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
> -			   struct btrfs_root *root, const struct qstr *name,
> +			   struct btrfs_root *root, const struct fscrypt_str *name,
>  			   u64 inode_objectid, u64 ref_objectid, u64 index)
>  {
>  	struct btrfs_fs_info *fs_info = root->fs_info;
> diff --git a/fs/btrfs/inode-item.h b/fs/btrfs/inode-item.h
> index 3c657c670cfd..b80aeb715701 100644
> --- a/fs/btrfs/inode-item.h
> +++ b/fs/btrfs/inode-item.h
> @@ -64,10 +64,10 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  			       struct btrfs_root *root,
>  			       struct btrfs_truncate_control *control);
>  int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
> -			   struct btrfs_root *root, const struct qstr *name,
> +			   struct btrfs_root *root, const struct fscrypt_str *name,
>  			   u64 inode_objectid, u64 ref_objectid, u64 index);
>  int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
> -			struct btrfs_root *root, const struct qstr *name,
> +			struct btrfs_root *root, const struct fscrypt_str *name,
>  			u64 inode_objectid, u64 ref_objectid, u64 *index);
>  int btrfs_insert_empty_inode(struct btrfs_trans_handle *trans,
>  			     struct btrfs_root *root,
> @@ -80,15 +80,15 @@ struct btrfs_inode_extref *btrfs_lookup_inode_extref(
>  			  struct btrfs_trans_handle *trans,
>  			  struct btrfs_root *root,
>  			  struct btrfs_path *path,
> -			  const struct qstr *name,
> +			  const struct fscrypt_str *name,
>  			  u64 inode_objectid, u64 ref_objectid, int ins_len,
>  			  int cow);
>  
>  struct btrfs_inode_ref *btrfs_find_name_in_backref(struct extent_buffer *leaf,
>  						   int slot,
> -						   const struct qstr *name);
> +						   const struct fscrypt_str *name);
>  struct btrfs_inode_extref *btrfs_find_name_in_ext_backref(
>  		struct extent_buffer *leaf, int slot, u64 ref_objectid,
> -		const struct qstr *name);
> +		const struct fscrypt_str *name);
>  
>  #endif
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4c5b2e2d8b5e..b36e1bfdadd5 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4284,7 +4284,7 @@ int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
>  static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  				struct btrfs_inode *dir,
>  				struct btrfs_inode *inode,
> -				const struct qstr *name,
> +				const struct fscrypt_str *name,
>  				struct btrfs_rename_ctx *rename_ctx)
>  {
>  	struct btrfs_root *root = dir->root;
> @@ -4387,7 +4387,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  
>  int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  		       struct btrfs_inode *dir, struct btrfs_inode *inode,
> -		       const struct qstr *name)
> +		       const struct fscrypt_str *name)
>  {
>  	int ret;
>  	ret = __btrfs_unlink_inode(trans, dir, inode, name, NULL);
> @@ -4427,13 +4427,11 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
>  	struct inode *inode = d_inode(dentry);
>  	int ret;
>  	struct fscrypt_name fname;
> -	struct qstr name;
>  
>  	ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
>  	if (ret)
>  		return ret;
> -	name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
> -
> +	

Whitespace.  Thanks,

Josef
