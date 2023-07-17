Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2FE756823
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 17:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjGQPjN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 11:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjGQPjL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 11:39:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FAA138;
        Mon, 17 Jul 2023 08:39:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 770D71FDA5;
        Mon, 17 Jul 2023 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689608345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=MyrFC5/PChiCVRsVExqapTfITdsPUBy8G+9ya6xtjmM=;
        b=JiuJECmD5HHkL0PEM+U6+tkwCqVOp6xSFK5GOiMZzP+FuXW2wmg5fAfUVnxnaQFACZaeaB
        yIs1r3K01t80alOKI6sb3+6slX+8O+zTiHNsJdZOvuz4bh4Mlyvv2HdpMk+wjHGxIcwIGe
        pJ52NHEpcF9Jh26X4rwtRa44LPBS0a0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689608345;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=MyrFC5/PChiCVRsVExqapTfITdsPUBy8G+9ya6xtjmM=;
        b=srVjSpDqXz3ZTNKlieGA7ldKtHueBYSpRxA4sUi8U8fsje6mBo/mo+iBQRcXpxS7gUg7NP
        b93keFZO71ivNxCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C28BE13276;
        Mon, 17 Jul 2023 15:39:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id H+drLJhgtWSBFAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 17 Jul 2023 15:39:04 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id b48e731e;
        Mon, 17 Jul 2023 15:39:04 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs?= Henriques <lhenriques@suse.de>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 07/17] btrfs: adapt readdir for encrypted and nokey
 names
Date:   Mon, 17 Jul 2023 16:34:32 +0100
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
        <ba4d9065b8109ea74fc1c5bed788e45c95a07e75.1689564024.git.sweettea-kernel@dorminy.me>
Message-ID: <87351mwns7.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Sweet Tea Dorminy <sweettea-kernel@dorminy.me> writes:

> From: Omar Sandoval <osandov@osandov.com>
> @@ -5793,13 +5787,18 @@ struct inode *btrfs_lookup_dentry(struct inode *d=
ir, struct dentry *dentry)
>  	struct btrfs_root *root =3D BTRFS_I(dir)->root;
>  	struct btrfs_root *sub_root =3D root;
>  	struct btrfs_key location;
> +	struct fscrypt_name fname;
>  	u8 di_type =3D 0;
>  	int ret =3D 0;
>=20=20
>  	if (dentry->d_name.len > BTRFS_NAME_LEN)
>  		return ERR_PTR(-ENAMETOOLONG);
>=20=20
> -	ret =3D btrfs_inode_by_name(BTRFS_I(dir), dentry, &location, &di_type);
> +	ret =3D fscrypt_prepare_lookup(dir, dentry, &fname);
> +	if (ret)
> +		return ERR_PTR(ret);
> +

I _think_ these error paths below need to be changed in order to invoke
fscrypt_free_lookup().

Cheers,
--=20
Lu=C3=ADs

>=20
> +	ret =3D btrfs_inode_by_name(BTRFS_I(dir), &fname, &location, &di_type);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
>=20=20
> @@ -5940,18 +5939,32 @@ static int btrfs_real_readdir(struct file *file, =
struct dir_context *ctx)
>  	struct list_head del_list;
>  	int ret;
>  	char *name_ptr;
> -	int name_len;
> +	u32 name_len;
>  	int entries =3D 0;
>  	int total_len =3D 0;
>  	bool put =3D false;
>  	struct btrfs_key location;
> +	struct fscrypt_str fstr =3D FSTR_INIT(NULL, 0);
> +	u32 fstr_len =3D 0;
>=20=20
>  	if (!dir_emit_dots(file, ctx))
>  		return 0;
>=20=20
> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_ENCRYPT) {
> +		ret =3D fscrypt_prepare_readdir(inode);
> +		if (ret)
> +			return ret;
> +		ret =3D fscrypt_fname_alloc_buffer(BTRFS_NAME_LEN, &fstr);
> +		if (ret)
> +			return ret;
> +		fstr_len =3D fstr.len;
> +	}
> +
>  	path =3D btrfs_alloc_path();
> -	if (!path)
> -		return -ENOMEM;
> +	if (!path) {
> +		ret =3D -ENOMEM;
> +		goto err_fstr;
> +	}
>=20=20
>  	addr =3D private->filldir_buf;
>  	path->reada =3D READA_FORWARD;
> @@ -5969,6 +5982,7 @@ static int btrfs_real_readdir(struct file *file, st=
ruct dir_context *ctx)
>  		struct dir_entry *entry;
>  		struct extent_buffer *leaf =3D path->nodes[0];
>  		u8 ftype;
> +		u32 nokey_len;
>=20=20
>  		if (found_key.objectid !=3D key.objectid)
>  			break;
> @@ -5980,8 +5994,13 @@ static int btrfs_real_readdir(struct file *file, s=
truct dir_context *ctx)
>  			continue;
>  		di =3D btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
>  		name_len =3D btrfs_dir_name_len(leaf, di);
> -		if ((total_len + sizeof(struct dir_entry) + name_len) >=3D
> -		    PAGE_SIZE) {
> +		nokey_len =3D DIV_ROUND_UP(name_len * 4, 3);
> +		/*
> +		 * If name is encrypted, and we don't have the key, we could
> +		 * need up to 4/3rds the bytes to print it.
> +		 */
> +		if ((total_len + sizeof(struct dir_entry) + nokey_len)
> +		    >=3D PAGE_SIZE) {
>  			btrfs_release_path(path);
>  			ret =3D btrfs_filldir(private->filldir_buf, entries, ctx);
>  			if (ret)
> @@ -5995,8 +6014,36 @@ static int btrfs_real_readdir(struct file *file, s=
truct dir_context *ctx)
>  		ftype =3D btrfs_dir_flags_to_ftype(btrfs_dir_flags(leaf, di));
>  		entry =3D addr;
>  		name_ptr =3D (char *)(entry + 1);
> -		read_extent_buffer(leaf, name_ptr,
> -				   (unsigned long)(di + 1), name_len);
> +		if (btrfs_dir_flags(leaf, di) & BTRFS_FT_ENCRYPTED) {
> +			struct fscrypt_str oname =3D FSTR_INIT(name_ptr,
> +							     nokey_len);
> +			u32 hash =3D 0, minor_hash =3D 0;
> +
> +			read_extent_buffer(leaf, fstr.name,
> +					   (unsigned long)(di + 1), name_len);
> +			fstr.len =3D name_len;
> +			/*
> +			 * We're iterating through DIR_INDEX items, so we don't
> +			 * have the DIR_ITEM hash handy. Only compute it if
> +			 * we'll need it -- the nokey name stores it, so that
> +			 * we can look up the appropriate item by nokey name
> +			 * later on.
> +			 */
> +			if (!fscrypt_has_encryption_key(inode)) {
> +				u64 name_hash =3D btrfs_name_hash(fstr.name,
> +								fstr.len);
> +				hash =3D name_hash;
> +				minor_hash =3D name_hash >> 32;
> +			}
> +			ret =3D fscrypt_fname_disk_to_usr(inode, hash, minor_hash,
> +							&fstr, &oname);
> +			if (ret)
> +				goto err;
> +			name_len =3D oname.len;
> +		} else {
> +			read_extent_buffer(leaf, name_ptr,
> +					   (unsigned long)(di + 1), name_len);
> +		}
>  		put_unaligned(name_len, &entry->name_len);
>  		put_unaligned(fs_ftype_to_dtype(ftype), &entry->type);
>  		btrfs_dir_item_key_to_cpu(leaf, di, &location);
> @@ -6016,7 +6063,8 @@ static int btrfs_real_readdir(struct file *file, st=
ruct dir_context *ctx)
>  	if (ret)
>  		goto nopos;
>=20=20
> -	ret =3D btrfs_readdir_delayed_dir_index(ctx, &ins_list);
> +	fstr.len =3D fstr_len;
> +	ret =3D btrfs_readdir_delayed_dir_index(inode, &fstr, ctx, &ins_list);
>  	if (ret)
>  		goto nopos;
>=20=20
> @@ -6047,6 +6095,8 @@ static int btrfs_real_readdir(struct file *file, st=
ruct dir_context *ctx)
>  	if (put)
>  		btrfs_readdir_put_delayed_items(inode, &ins_list, &del_list);
>  	btrfs_free_path(path);
> +err_fstr:
> +	fscrypt_fname_free_buffer(&fstr);
>  	return ret;
>  }
>=20=20
> @@ -6555,6 +6605,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
>  	struct btrfs_root *root =3D parent_inode->root;
>  	u64 ino =3D btrfs_ino(inode);
>  	u64 parent_ino =3D btrfs_ino(parent_inode);
> +	struct fscrypt_name fname =3D { .disk_name =3D *name };
>=20=20
>  	if (unlikely(ino =3D=3D BTRFS_FIRST_FREE_OBJECTID)) {
>  		memcpy(&key, &inode->root->root_key, sizeof(key));
> @@ -6612,7 +6663,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
>  		int err;
>  		err =3D btrfs_del_root_ref(trans, key.objectid,
>  					 root->root_key.objectid, parent_ino,
> -					 &local_index, name);
> +					 &local_index, &fname);
>  		if (err)
>  			btrfs_abort_transaction(trans, err);
>  	} else if (add_backref) {
> @@ -8982,7 +9033,7 @@ static int btrfs_rename_exchange(struct inode *old_=
dir,
>  	} else { /* src is an inode */
>  		ret =3D __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
>  					   BTRFS_I(old_dentry->d_inode),
> -					   old_name, &old_rename_ctx);
> +					   &old_fname, &old_rename_ctx);
>  		if (!ret)
>  			ret =3D btrfs_update_inode(trans, root, BTRFS_I(old_inode));
>  	}
> @@ -8997,7 +9048,7 @@ static int btrfs_rename_exchange(struct inode *old_=
dir,
>  	} else { /* dest is an inode */
>  		ret =3D __btrfs_unlink_inode(trans, BTRFS_I(new_dir),
>  					   BTRFS_I(new_dentry->d_inode),
> -					   new_name, &new_rename_ctx);
> +					   &new_fname, &new_rename_ctx);
>  		if (!ret)
>  			ret =3D btrfs_update_inode(trans, dest, BTRFS_I(new_inode));
>  	}
> @@ -9246,7 +9297,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
>  	} else {
>  		ret =3D __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
>  					   BTRFS_I(d_inode(old_dentry)),
> -					   &old_fname.disk_name, &rename_ctx);
> +					   &old_fname, &rename_ctx);
>  		if (!ret)
>  			ret =3D btrfs_update_inode(trans, root, BTRFS_I(old_inode));
>  	}
> @@ -9265,7 +9316,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
>  		} else {
>  			ret =3D btrfs_unlink_inode(trans, BTRFS_I(new_dir),
>  						 BTRFS_I(d_inode(new_dentry)),
> -						 &new_fname.disk_name);
> +						 &new_fname);
>  		}
>  		if (!ret && new_inode->i_nlink =3D=3D 0)
>  			ret =3D btrfs_orphan_add(trans,
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 859874579456..5fa416ef54ad 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -10,6 +10,7 @@
>  #include "messages.h"
>  #include "transaction.h"
>  #include "disk-io.h"
> +#include "fscrypt.h"
>  #include "print-tree.h"
>  #include "qgroup.h"
>  #include "space-info.h"
> @@ -333,7 +334,7 @@ int btrfs_del_root(struct btrfs_trans_handle *trans,
>=20=20
>  int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
>  		       u64 ref_id, u64 dirid, u64 *sequence,
> -		       const struct fscrypt_str *name)
> +		       struct fscrypt_name *name)
>  {
>  	struct btrfs_root *tree_root =3D trans->fs_info->tree_root;
>  	struct btrfs_path *path;
> @@ -355,13 +356,14 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *t=
rans, u64 root_id,
>  	if (ret < 0) {
>  		goto out;
>  	} else if (ret =3D=3D 0) {
> +		u32 name_len;
>  		leaf =3D path->nodes[0];
>  		ref =3D btrfs_item_ptr(leaf, path->slots[0],
>  				     struct btrfs_root_ref);
>  		ptr =3D (unsigned long)(ref + 1);
> +		name_len =3D btrfs_root_ref_name_len(leaf, ref);
>  		if ((btrfs_root_ref_dirid(leaf, ref) !=3D dirid) ||
> -		    (btrfs_root_ref_name_len(leaf, ref) !=3D name->len) ||
> -		    memcmp_extent_buffer(leaf, name->name, ptr, name->len)) {
> +		    !btrfs_fscrypt_match_name(name, leaf, ptr, name_len)) {
>  			ret =3D -ENOENT;
>  			goto out;
>  		}
> diff --git a/fs/btrfs/root-tree.h b/fs/btrfs/root-tree.h
> index cbbaca32126e..a57bbf7b0180 100644
> --- a/fs/btrfs/root-tree.h
> +++ b/fs/btrfs/root-tree.h
> @@ -13,7 +13,7 @@ int btrfs_add_root_ref(struct btrfs_trans_handle *trans=
, u64 root_id,
>  		       const struct fscrypt_str *name);
>  int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
>  		       u64 ref_id, u64 dirid, u64 *sequence,
> -		       const struct fscrypt_str *name);
> +		       struct fscrypt_name *name);
>  int btrfs_del_root(struct btrfs_trans_handle *trans, const struct btrfs_=
key *key);
>  int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_roo=
t *root,
>  		      const struct btrfs_key *key,
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 8ad7e7e38d18..3bf746668e07 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -901,9 +901,10 @@ static int unlink_inode_for_log_replay(struct btrfs_=
trans_handle *trans,
>  				       struct btrfs_inode *inode,
>  				       const struct fscrypt_str *name)
>  {
> +	struct fscrypt_name fname =3D { .disk_name =3D *name, };
>  	int ret;
>=20=20
> -	ret =3D btrfs_unlink_inode(trans, dir, inode, name);
> +	ret =3D btrfs_unlink_inode(trans, dir, inode, &fname);
>  	if (ret)
>  		return ret;
>  	/*
> --=20
>
> 2.40.1
>
