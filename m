Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1388660CD2C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 25 Oct 2022 15:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbiJYNPe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 25 Oct 2022 09:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiJYNPa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 25 Oct 2022 09:15:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2E1AC3A9;
        Tue, 25 Oct 2022 06:15:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 689E061934;
        Tue, 25 Oct 2022 13:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E17C433B5;
        Tue, 25 Oct 2022 13:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666703726;
        bh=EoLWwycui0KR3pjfjdSlDzbRRlIz7E4Qg4fxS1nIroM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PWtb1jgWInnJFVM+lLB+bTd3T8clTsfXDciuOg+rHgJWuQG2urhklCptMm5KNBpdj
         SKTcEZLhdAjGzwFIksfeakOvuDM9DT6qtR4eJ17aJly+t2DKjFlmBdCVkvqKcf5K3T
         v1L/mphTA6J3JMHozPLsGQzPOk2Oz7Dou8VRG1IJScHb0tvIvsyaKvde9+VCa/ZL9k
         K7dU1M1vB18flP48n1WP+aQTyKmy0HUs0PpKrUb+wYWOJULDKpo5FVNPmH0Zm/YNZH
         4BjyqtvhGRkPC7GaHfmZSSZI1OYjl+Z83Orx8oPhrYXME+0v7+SI3r2xG+C2cDBZM/
         2DSpG3qODJZ9g==
Received: by mail-oi1-f174.google.com with SMTP id u132so1033851oib.0;
        Tue, 25 Oct 2022 06:15:26 -0700 (PDT)
X-Gm-Message-State: ACrzQf2mC38SZqPbPon+BdbuYhS2hNfS6UWT1ZNM2kW6Ug5XDbSwHRoc
        BArl5YpglwWf/vxdycY03xyLTBUCWtZZmz5gIEY=
X-Google-Smtp-Source: AMsMyM6Ng2o8kHAcUvnapmnZEb7nD3tAUbwOzg38RhgCtIqnY4kPo5MG+18EugIVhtZcA/vE+/cLI/IoKrkxn5RzY68=
X-Received: by 2002:aca:aa8f:0:b0:355:29cc:b77f with SMTP id
 t137-20020acaaa8f000000b0035529ccb77fmr23831512oie.92.1666703725639; Tue, 25
 Oct 2022 06:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1666651724.git.sweettea-kernel@dorminy.me> <0bc4b89f82d49a12a2d33777824afde9dac80985.1666651724.git.sweettea-kernel@dorminy.me>
In-Reply-To: <0bc4b89f82d49a12a2d33777824afde9dac80985.1666651724.git.sweettea-kernel@dorminy.me>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 25 Oct 2022 14:14:49 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7_0FmVwP32P6vJsrRb6rdVze=OLV7jHBucpnc7NfGP1w@mail.gmail.com>
Message-ID: <CAL3q7H7_0FmVwP32P6vJsrRb6rdVze=OLV7jHBucpnc7NfGP1w@mail.gmail.com>
Subject: Re: [PATCH v4 08/21] btrfs: setup qstrings from dentrys using fscrypt helper
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 25, 2022 at 2:29 AM Sweet Tea Dorminy
<sweettea-kernel@dorminy.me> wrote:
>
> Most places where we get a struct qstr, we are doing so from a dentry.
> With fscrypt, the dentry's name may be encrypted on-disk, so fscrypt
> provides a helper to convert a dentry name to the appropriate disk name
> if necessary. Convert each of the dentry name accesses to use
> fscrypt_setup_filename(), then convert the resulting fscrypt_name back
> to an unencrypted qstr. This does not work for nokey names, but the
> specific locations that could spawn nokey names are noted.
>
> At present, since there are no encrypted directories,
> nothing goes down the filename encryption paths.
>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/ctree.h       |   3 +
>  fs/btrfs/inode.c       | 187 ++++++++++++++++++++++++++++++++---------
>  fs/btrfs/transaction.c |  40 ++++++---
>  fs/btrfs/tree-log.c    |  11 ++-
>  4 files changed, 186 insertions(+), 55 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index d80ebd5b1a83..6653972d7c01 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -28,6 +28,7 @@
>  #include <linux/refcount.h>
>  #include <linux/crc32c.h>
>  #include <linux/iomap.h>
> +#include <linux/fscrypt.h>
>  #include "extent-io-tree.h"
>  #include "extent_io.h"
>  #include "extent_map.h"
> @@ -1674,6 +1675,8 @@ struct btrfs_new_inode_args {
>          */
>         struct posix_acl *default_acl;
>         struct posix_acl *acl;
> +       struct fscrypt_name fname;
> +       struct qstr name;
>  };
>  int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
>                             unsigned int *trans_num_items);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 32beee9d9d85..5607d05c309b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4428,16 +4428,27 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
>         struct btrfs_trans_handle *trans;
>         struct inode *inode = d_inode(dentry);
>         int ret;
> +       struct fscrypt_name fname;
> +       struct qstr name;
> +
> +       ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
> +       if (ret)
> +               return ret;
> +       name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
> +
> +       /* This needs to handle no-key deletions later on */
>
>         trans = __unlink_start_trans(dir);
> -       if (IS_ERR(trans))
> -               return PTR_ERR(trans);
> +       if (IS_ERR(trans)) {
> +               ret = PTR_ERR(trans);
> +               goto out;
> +       }
>
>         btrfs_record_unlink_dir(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
>                         0);
>
>         ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
> -                                &dentry->d_name);
> +                                &name);
>         if (ret)
>                 goto out;
>
> @@ -4448,6 +4459,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
>         }
>
>  out:
> +       fscrypt_free_filename(&fname);
>         btrfs_end_transaction(trans);
>         btrfs_btree_balance_dirty(BTRFS_I(dir)->root->fs_info);
>         return ret;
> @@ -4462,11 +4474,19 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>         struct extent_buffer *leaf;
>         struct btrfs_dir_item *di;
>         struct btrfs_key key;
> -       const struct qstr *name = &dentry->d_name;
> +       struct qstr name;
>         u64 index;
>         int ret;
>         u64 objectid;
>         u64 dir_ino = btrfs_ino(BTRFS_I(dir));
> +       struct fscrypt_name fname;
> +
> +       ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
> +       if (ret)
> +               return ret;
> +       name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
> +
> +       /* This needs to handle no-key deletions later on */
>
>         if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
>                 objectid = inode->root->root_key.objectid;
> @@ -4474,15 +4494,18 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>                 objectid = inode->location.objectid;
>         } else {
>                 WARN_ON(1);
> +               fscrypt_free_filename(&fname);
>                 return -EINVAL;
>         }
>
>         path = btrfs_alloc_path();
> -       if (!path)
> -               return -ENOMEM;
> +       if (!path) {
> +               ret = -ENOMEM;
> +               goto out;
> +       }
>
>         di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
> -                                  name, -1);
> +                                  &name, -1);
>         if (IS_ERR_OR_NULL(di)) {
>                 ret = di ? PTR_ERR(di) : -ENOENT;
>                 goto out;
> @@ -4508,7 +4531,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>          * call btrfs_del_root_ref, and it _shouldn't_ fail.
>          */
>         if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
> -               di = btrfs_search_dir_index_item(root, path, dir_ino, name);
> +               di = btrfs_search_dir_index_item(root, path, dir_ino, &name);
>                 if (IS_ERR_OR_NULL(di)) {
>                         if (!di)
>                                 ret = -ENOENT;
> @@ -4525,7 +4548,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>         } else {
>                 ret = btrfs_del_root_ref(trans, objectid,
>                                          root->root_key.objectid, dir_ino,
> -                                        &index, name);
> +                                        &index, &name);
>                 if (ret) {
>                         btrfs_abort_transaction(trans, ret);
>                         goto out;
> @@ -4538,7 +4561,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>                 goto out;
>         }
>
> -       btrfs_i_size_write(BTRFS_I(dir), dir->i_size - name->len * 2);
> +       btrfs_i_size_write(BTRFS_I(dir), dir->i_size - name.len * 2);
>         inode_inc_iversion(dir);
>         dir->i_mtime = current_time(dir);
>         dir->i_ctime = dir->i_mtime;
> @@ -4547,6 +4570,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>                 btrfs_abort_transaction(trans, ret);
>  out:
>         btrfs_free_path(path);
> +       fscrypt_free_filename(&fname);
>         return ret;
>  }
>
> @@ -4810,6 +4834,8 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
>         int err = 0;
>         struct btrfs_trans_handle *trans;
>         u64 last_unlink_trans;
> +       struct fscrypt_name fname;
> +       struct qstr name;
>
>         if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
>                 return -ENOTEMPTY;
> @@ -4822,9 +4848,18 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
>                 return btrfs_delete_subvolume(dir, dentry);
>         }
>
> +       err = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
> +       if (err)
> +               return err;
> +       name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
> +
> +       /* This needs to handle no-key deletions later on */
> +
>         trans = __unlink_start_trans(dir);
> -       if (IS_ERR(trans))
> -               return PTR_ERR(trans);
> +       if (IS_ERR(trans)) {
> +               err = PTR_ERR(trans);
> +               goto out_notrans;
> +       }
>
>         if (unlikely(btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
>                 err = btrfs_unlink_subvol(trans, dir, dentry);
> @@ -4839,7 +4874,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
>
>         /* now the directory is empty */
>         err = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
> -                                &dentry->d_name);
> +                                &name);
>         if (!err) {
>                 btrfs_i_size_write(BTRFS_I(inode), 0);
>                 /*
> @@ -4858,7 +4893,9 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
>         }
>  out:
>         btrfs_end_transaction(trans);
> +out_notrans:
>         btrfs_btree_balance_dirty(fs_info);
> +       fscrypt_free_filename(&fname);
>
>         return err;
>  }
> @@ -5523,7 +5560,7 @@ void btrfs_evict_inode(struct inode *inode)
>
>  /*
>   * Return the key found in the dir entry in the location pointer, fill @type
> - * with BTRFS_FT_*, and return 0.
> + * with BTRFS_FT_*, and return 0. Used only for lookups, not removals.

This is a bit confusing. What removals?
Isn't it clear the function is used only for lookups?

>   *
>   * If no dir entries were found, returns -ENOENT.
>   * If found a corrupted location in dir entry, returns -EUCLEAN.
> @@ -5531,18 +5568,27 @@ void btrfs_evict_inode(struct inode *inode)
>  static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
>                                struct btrfs_key *location, u8 *type)
>  {
> -       const struct qstr *name = &dentry->d_name;
> +       struct qstr name;
>         struct btrfs_dir_item *di;
>         struct btrfs_path *path;
>         struct btrfs_root *root = BTRFS_I(dir)->root;
>         int ret = 0;
> +       struct fscrypt_name fname;
>
>         path = btrfs_alloc_path();
>         if (!path)
>                 return -ENOMEM;
>
> +       ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
> +       if (ret)
> +               goto out;
> +
> +       name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
> +
> +       /* This needs to handle no-key deletions later on */
> +
>         di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(BTRFS_I(dir)),
> -                                  name, 0);
> +                                  &name, 0);
>         if (IS_ERR_OR_NULL(di)) {
>                 ret = di ? PTR_ERR(di) : -ENOENT;
>                 goto out;
> @@ -5554,12 +5600,13 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
>                 ret = -EUCLEAN;
>                 btrfs_warn(root->fs_info,
>  "%s gets something invalid in DIR_ITEM (name %s, directory ino %llu, location(%llu %u %llu))",
> -                          __func__, name->name, btrfs_ino(BTRFS_I(dir)),
> +                          __func__, name.name, btrfs_ino(BTRFS_I(dir)),
>                            location->objectid, location->type, location->offset);
>         }
>         if (!ret)
>                 *type = btrfs_dir_type(path->nodes[0], di);
>  out:
> +       fscrypt_free_filename(&fname);
>         btrfs_free_path(path);
>         return ret;
>  }
> @@ -5582,6 +5629,14 @@ static int fixup_tree_root_location(struct btrfs_fs_info *fs_info,
>         struct btrfs_key key;
>         int ret;
>         int err = 0;
> +       struct fscrypt_name fname;
> +       struct qstr name;
> +
> +       ret = fscrypt_setup_filename(dir, &dentry->d_name, 0, &fname);
> +       if (ret)
> +               return ret;
> +
> +       name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
>
>         path = btrfs_alloc_path();
>         if (!path) {
> @@ -5604,12 +5659,11 @@ static int fixup_tree_root_location(struct btrfs_fs_info *fs_info,
>         leaf = path->nodes[0];
>         ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_root_ref);
>         if (btrfs_root_ref_dirid(leaf, ref) != btrfs_ino(BTRFS_I(dir)) ||
> -           btrfs_root_ref_name_len(leaf, ref) != dentry->d_name.len)
> +           btrfs_root_ref_name_len(leaf, ref) != name.len)
>                 goto out;
>
> -       ret = memcmp_extent_buffer(leaf, dentry->d_name.name,
> -                                  (unsigned long)(ref + 1),
> -                                  dentry->d_name.len);
> +       ret = memcmp_extent_buffer(leaf, name.name, (unsigned long)(ref + 1),
> +                                  name.len);
>         if (ret)
>                 goto out;
>
> @@ -5628,6 +5682,7 @@ static int fixup_tree_root_location(struct btrfs_fs_info *fs_info,
>         err = 0;
>  out:
>         btrfs_free_path(path);
> +       fscrypt_free_filename(&fname);
>         return err;
>  }
>
> @@ -6236,9 +6291,19 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
>         struct inode *inode = args->inode;
>         int ret;
>
> +       if (!args->orphan) {
> +               ret = fscrypt_setup_filename(dir, &args->dentry->d_name, 0,
> +                                            &args->fname);
> +               if (ret)
> +                       return ret;
> +               args->name = (struct qstr)FSTR_TO_QSTR(&args->fname.disk_name);
> +       }
> +
>         ret = posix_acl_create(dir, &inode->i_mode, &args->default_acl, &args->acl);
> -       if (ret)
> +       if (ret) {
> +               fscrypt_free_filename(&args->fname);
>                 return ret;
> +       }
>
>         /* 1 to add inode item */
>         *trans_num_items = 1;
> @@ -6278,6 +6343,7 @@ void btrfs_new_inode_args_destroy(struct btrfs_new_inode_args *args)
>  {
>         posix_acl_release(args->acl);
>         posix_acl_release(args->default_acl);
> +       fscrypt_free_filename(&args->fname);
>  }
>
>  /*
> @@ -6703,6 +6769,8 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
>         struct btrfs_root *root = BTRFS_I(dir)->root;
>         struct inode *inode = d_inode(old_dentry);
>         struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> +       struct fscrypt_name fname;
> +       struct qstr name;
>         u64 index;
>         int err;
>         int drop_inode = 0;
> @@ -6714,6 +6782,12 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
>         if (inode->i_nlink >= BTRFS_LINK_MAX)
>                 return -EMLINK;
>
> +       err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &fname);
> +       if (err)
> +               goto fail;
> +
> +       name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
> +
>         err = btrfs_set_inode_index(BTRFS_I(dir), &index);
>         if (err)
>                 goto fail;
> @@ -6740,7 +6814,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
>         set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
>
>         err = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
> -                            &dentry->d_name, 1, index);
> +                            &name, 1, index);
>
>         if (err) {
>                 drop_inode = 1;
> @@ -6764,6 +6838,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
>         }
>
>  fail:
> +       fscrypt_free_filename(&fname);
>         if (trans)
>                 btrfs_end_transaction(trans);
>         if (drop_inode) {
> @@ -8995,6 +9070,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
>         int ret;
>         int ret2;
>         bool need_abort = false;
> +       struct fscrypt_name old_fname, new_fname;
> +       struct qstr old_name, new_name;
>
>         /*
>          * For non-subvolumes allow exchange only within one subvolume, in the
> @@ -9006,6 +9083,19 @@ static int btrfs_rename_exchange(struct inode *old_dir,
>              new_ino != BTRFS_FIRST_FREE_OBJECTID))
>                 return -EXDEV;
>
> +       ret = fscrypt_setup_filename(old_dir, &old_dentry->d_name, 0, &old_fname);
> +       if (ret)
> +               return ret;
> +
> +       ret = fscrypt_setup_filename(new_dir, &new_dentry->d_name, 0, &new_fname);
> +       if (ret) {
> +               fscrypt_free_filename(&old_fname);
> +               return ret;
> +       }
> +
> +       old_name = (struct qstr)FSTR_TO_QSTR(&old_fname.disk_name);
> +       new_name = (struct qstr)FSTR_TO_QSTR(&new_fname.disk_name);
> +
>         /* close the race window with snapshot create/destroy ioctl */
>         if (old_ino == BTRFS_FIRST_FREE_OBJECTID ||
>             new_ino == BTRFS_FIRST_FREE_OBJECTID)
> @@ -9073,8 +9163,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
>                 /* force full log commit if subvolume involved. */
>                 btrfs_set_log_full_commit(trans);
>         } else {
> -               ret = btrfs_insert_inode_ref(trans, dest, &new_dentry->d_name,
> -                                            old_ino,
> +               ret = btrfs_insert_inode_ref(trans, dest, &new_name, old_ino,
>                                              btrfs_ino(BTRFS_I(new_dir)),
>                                              old_idx);
>                 if (ret)
> @@ -9087,8 +9176,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
>                 /* force full log commit if subvolume involved. */
>                 btrfs_set_log_full_commit(trans);
>         } else {
> -               ret = btrfs_insert_inode_ref(trans, root, &old_dentry->d_name,
> -                                            new_ino,
> +               ret = btrfs_insert_inode_ref(trans, root, &old_name, new_ino,
>                                              btrfs_ino(BTRFS_I(old_dir)),
>                                              new_idx);
>                 if (ret) {
> @@ -9123,8 +9211,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
>         } else { /* src is an inode */
>                 ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
>                                            BTRFS_I(old_dentry->d_inode),
> -                                          &old_dentry->d_name,
> -                                          &old_rename_ctx);
> +                                          &old_name, &old_rename_ctx);
>                 if (!ret)
>                         ret = btrfs_update_inode(trans, root, BTRFS_I(old_inode));
>         }
> @@ -9139,8 +9226,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
>         } else { /* dest is an inode */
>                 ret = __btrfs_unlink_inode(trans, BTRFS_I(new_dir),
>                                            BTRFS_I(new_dentry->d_inode),
> -                                          &new_dentry->d_name,
> -                                          &new_rename_ctx);
> +                                          &new_name, &new_rename_ctx);
>                 if (!ret)
>                         ret = btrfs_update_inode(trans, dest, BTRFS_I(new_inode));
>         }
> @@ -9150,14 +9236,14 @@ static int btrfs_rename_exchange(struct inode *old_dir,
>         }
>
>         ret = btrfs_add_link(trans, BTRFS_I(new_dir), BTRFS_I(old_inode),
> -                            &new_dentry->d_name, 0, old_idx);
> +                            &new_name, 0, old_idx);
>         if (ret) {
>                 btrfs_abort_transaction(trans, ret);
>                 goto out_fail;
>         }
>
>         ret = btrfs_add_link(trans, BTRFS_I(old_dir), BTRFS_I(new_inode),
> -                            &old_dentry->d_name, 0, new_idx);
> +                            &old_name, 0, new_idx);
>         if (ret) {
>                 btrfs_abort_transaction(trans, ret);
>                 goto out_fail;
> @@ -9200,6 +9286,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
>             old_ino == BTRFS_FIRST_FREE_OBJECTID)
>                 up_read(&fs_info->subvol_sem);
>
> +       fscrypt_free_filename(&new_fname);
> +       fscrypt_free_filename(&old_fname);
>         return ret;
>  }
>
> @@ -9239,6 +9327,8 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
>         int ret;
>         int ret2;
>         u64 old_ino = btrfs_ino(BTRFS_I(old_inode));
> +       struct fscrypt_name old_fname, new_fname;
> +       struct qstr old_name, new_name;
>
>         if (btrfs_ino(BTRFS_I(new_dir)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
>                 return -EPERM;
> @@ -9255,21 +9345,32 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
>             new_inode->i_size > BTRFS_EMPTY_DIR_SIZE)
>                 return -ENOTEMPTY;
>
> +       ret = fscrypt_setup_filename(old_dir, &old_dentry->d_name, 0, &old_fname);
> +       if (ret)
> +               return ret;
> +
> +       ret = fscrypt_setup_filename(new_dir, &new_dentry->d_name, 0, &new_fname);
> +       if (ret) {
> +               fscrypt_free_filename(&old_fname);
> +               return ret;
> +       }
> +
> +       old_name = (struct qstr)FSTR_TO_QSTR(&old_fname.disk_name);
> +       new_name = (struct qstr)FSTR_TO_QSTR(&new_fname.disk_name);
>
>         /* check for collisions, even if the  name isn't there */
> -       ret = btrfs_check_dir_item_collision(dest, new_dir->i_ino,
> -                                            &new_dentry->d_name);
> +       ret = btrfs_check_dir_item_collision(dest, new_dir->i_ino, &new_name);
>
>         if (ret) {
>                 if (ret == -EEXIST) {
>                         /* we shouldn't get
>                          * eexist without a new_inode */
>                         if (WARN_ON(!new_inode)) {
> -                               return ret;
> +                               goto out_fscrypt_names;
>                         }
>                 } else {
>                         /* maybe -EOVERFLOW */
> -                       return ret;
> +                       goto out_fscrypt_names;
>                 }
>         }
>         ret = 0;
> @@ -9352,8 +9453,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
>                 /* force full log commit if subvolume involved. */
>                 btrfs_set_log_full_commit(trans);
>         } else {
> -               ret = btrfs_insert_inode_ref(trans, dest, &new_dentry->d_name,
> -                                            old_ino,
> +               ret = btrfs_insert_inode_ref(trans, dest, &new_name, old_ino,
>                                              btrfs_ino(BTRFS_I(new_dir)), index);
>                 if (ret)
>                         goto out_fail;
> @@ -9377,7 +9477,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
>         } else {
>                 ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
>                                            BTRFS_I(d_inode(old_dentry)),
> -                                          &old_dentry->d_name, &rename_ctx);
> +                                          &old_name, &rename_ctx);
>                 if (!ret)
>                         ret = btrfs_update_inode(trans, root, BTRFS_I(old_inode));
>         }
> @@ -9396,7 +9496,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
>                 } else {
>                         ret = btrfs_unlink_inode(trans, BTRFS_I(new_dir),
>                                                  BTRFS_I(d_inode(new_dentry)),
> -                                                &new_dentry->d_name);
> +                                                &new_name);
>                 }
>                 if (!ret && new_inode->i_nlink == 0)
>                         ret = btrfs_orphan_add(trans,
> @@ -9408,7 +9508,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
>         }
>
>         ret = btrfs_add_link(trans, BTRFS_I(new_dir), BTRFS_I(old_inode),
> -                            &new_dentry->d_name, 0, index);
> +                            &new_name, 0, index);
>         if (ret) {
>                 btrfs_abort_transaction(trans, ret);
>                 goto out_fail;
> @@ -9443,6 +9543,9 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
>  out_whiteout_inode:
>         if (flags & RENAME_WHITEOUT)
>                 iput(whiteout_args.inode);
> +out_fscrypt_names:
> +       fscrypt_free_filename(&old_fname);
> +       fscrypt_free_filename(&new_fname);
>         return ret;
>  }
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 7db9612f4d0e..c2883d2b7111 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -6,6 +6,7 @@
>  #include <linux/fs.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
> +#include <linux/sched/mm.h>
>  #include <linux/writeback.h>
>  #include <linux/pagemap.h>
>  #include <linux/blkdev.h>
> @@ -1611,10 +1612,9 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>         struct btrfs_root *root = pending->root;
>         struct btrfs_root *parent_root;
>         struct btrfs_block_rsv *rsv;
> -       struct inode *parent_inode;
> +       struct inode *parent_inode = pending->dir;
>         struct btrfs_path *path;
>         struct btrfs_dir_item *dir_item;
> -       struct dentry *dentry;
>         struct extent_buffer *tmp;
>         struct extent_buffer *old;
>         struct timespec64 cur_time;
> @@ -1623,6 +1623,9 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>         u64 index = 0;
>         u64 objectid;
>         u64 root_flags;
> +       unsigned int mem_flags;
> +       struct fscrypt_name fname;
> +       struct qstr name;
>
>         ASSERT(pending->path);
>         path = pending->path;
> @@ -1630,9 +1633,23 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>         ASSERT(pending->root_item);
>         new_root_item = pending->root_item;
>
> +       /*
> +        * Since this is during btrfs_commit_transaction() and more items
> +        * joining the transaction at this point would be bad, use NOFS
> +        * allocations so that no new writes are kicked off.
> +        */

This comment makes no sense to me.

The reason we have to use NOFS it's because when a memory allocation
triggers reclaim it may recurse into the filesystem and
trigger transaction start/join/attach, which would result in a
deadlock (see below why exactly).

The "more items joining the transaction at this point would be bad"
makes no sense because it's simply not possible.
At this point the transaction is in the state
TRANS_STATE_COMMIT_DOING, so no one can join it and use it for further
modifying the fs - anyone trying to start a new transaction, join or
attach this one will block until the transaction state
becomes >= TRANS_STATE_UNBLOCKED and after that it will have to start
a new transaction (can't reuse the former).

Thanks.


> +       mem_flags = memalloc_nofs_save();
> +       pending->error = fscrypt_setup_filename(parent_inode,
> +                                               &pending->dentry->d_name, 0,
> +                                               &fname);
> +       memalloc_nofs_restore(mem_flags);
> +       if (pending->error)
> +               goto free_pending;
> +       name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
> +
>         pending->error = btrfs_get_free_objectid(tree_root, &objectid);
>         if (pending->error)
> -               goto no_free_objectid;
> +               goto free_fname;
>
>         /*
>          * Make qgroup to skip current new snapshot's qgroupid, as it is
> @@ -1661,8 +1678,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>         trace_btrfs_space_reservation(fs_info, "transaction",
>                                       trans->transid,
>                                       trans->bytes_reserved, 1);
> -       dentry = pending->dentry;
> -       parent_inode = pending->dir;
>         parent_root = BTRFS_I(parent_inode)->root;
>         ret = record_root_in_trans(trans, parent_root, 0);
>         if (ret)
> @@ -1678,7 +1693,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>         /* check if there is a file/dir which has the same name. */
>         dir_item = btrfs_lookup_dir_item(NULL, parent_root, path,
>                                          btrfs_ino(BTRFS_I(parent_inode)),
> -                                        &dentry->d_name, 0);
> +                                        &name, 0);
>         if (dir_item != NULL && !IS_ERR(dir_item)) {
>                 pending->error = -EEXIST;
>                 goto dir_item_existed;
> @@ -1773,7 +1788,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>         ret = btrfs_add_root_ref(trans, objectid,
>                                  parent_root->root_key.objectid,
>                                  btrfs_ino(BTRFS_I(parent_inode)), index,
> -                                &dentry->d_name);
> +                                &name);
>         if (ret) {
>                 btrfs_abort_transaction(trans, ret);
>                 goto fail;
> @@ -1805,9 +1820,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>         if (ret < 0)
>                 goto fail;
>
> -       ret = btrfs_insert_dir_item(trans, &dentry->d_name,
> -                                   BTRFS_I(parent_inode), &key, BTRFS_FT_DIR,
> -                                   index);
> +       ret = btrfs_insert_dir_item(trans, &name, BTRFS_I(parent_inode), &key,
> +                                   BTRFS_FT_DIR, index);
>         /* We have check then name at the beginning, so it is impossible. */
>         BUG_ON(ret == -EEXIST || ret == -EOVERFLOW);
>         if (ret) {
> @@ -1816,7 +1830,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>         }
>
>         btrfs_i_size_write(BTRFS_I(parent_inode), parent_inode->i_size +
> -                                        dentry->d_name.len * 2);
> +                                                 name.len * 2);
>         parent_inode->i_mtime = current_time(parent_inode);
>         parent_inode->i_ctime = parent_inode->i_mtime;
>         ret = btrfs_update_inode_fallback(trans, parent_root, BTRFS_I(parent_inode));
> @@ -1848,7 +1862,9 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>         trans->bytes_reserved = 0;
>  clear_skip_qgroup:
>         btrfs_clear_skip_qgroup(trans);
> -no_free_objectid:
> +free_fname:
> +       fscrypt_free_filename(&fname);
> +free_pending:
>         kfree(new_root_item);
>         pending->root_item = NULL;
>         btrfs_free_path(path);
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index d6c0bce7569a..f9ed05285a97 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -7395,9 +7395,16 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
>         if (old_dir && old_dir->logged_trans == trans->transid) {
>                 struct btrfs_root *log = old_dir->root->log_root;
>                 struct btrfs_path *path;
> +               struct fscrypt_name fname;
> +               struct qstr name;
>
>                 ASSERT(old_dir_index >= BTRFS_DIR_START_INDEX);
>
> +               ret = fscrypt_setup_filename(&old_dir->vfs_inode,
> +                                            &old_dentry->d_name, 0, &fname);
> +               if (ret)
> +                       goto out;
> +               name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
>                 /*
>                  * We have two inodes to update in the log, the old directory and
>                  * the inode that got renamed, so we must pin the log to prevent
> @@ -7417,6 +7424,7 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
>                 path = btrfs_alloc_path();
>                 if (!path) {
>                         ret = -ENOMEM;
> +                       fscrypt_free_filename(&fname);
>                         goto out;
>                 }
>
> @@ -7432,7 +7440,7 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
>                  */
>                 mutex_lock(&old_dir->log_mutex);
>                 ret = del_logged_dentry(trans, log, path, btrfs_ino(old_dir),
> -                                       &old_dentry->d_name, old_dir_index);
> +                                       &name, old_dir_index);
>                 if (ret > 0) {
>                         /*
>                          * The dentry does not exist in the log, so record its
> @@ -7446,6 +7454,7 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
>                 mutex_unlock(&old_dir->log_mutex);
>
>                 btrfs_free_path(path);
> +               fscrypt_free_filename(&fname);
>                 if (ret < 0)
>                         goto out;
>         }
> --
> 2.35.1
>
