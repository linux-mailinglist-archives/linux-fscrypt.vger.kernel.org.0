Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E64275681F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 17:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjGQPiz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 11:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjGQPiv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 11:38:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9D6138;
        Mon, 17 Jul 2023 08:38:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 81FF42190B;
        Mon, 17 Jul 2023 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689608325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=Ui9BArDPGIiw+DuCM6yGZ74N3mMdb6G0qhzaARysTV0=;
        b=oGHbboF7oXUwOCmSsN8gHn7ka7XBeFnU9E1gbHN1DmcF4wYypapHK6Oj5hgRAKtO6arDnQ
        IE0Fj7ffGyBJl+6GCfFF27n3reNe3p2cEEsYbeoz+Fz9pxtRodRNOdvN7rfAMA0vdqAk+7
        JZMESPG+g5BCfumQhbpFLgn+379X0AE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689608325;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=Ui9BArDPGIiw+DuCM6yGZ74N3mMdb6G0qhzaARysTV0=;
        b=gsTfZiezFSh5KG958EeN5BLHv2QIfV8DEqaMaFmWEh/A9/6hjfZmZs3Wgd3MlV3AwRmjQ/
        /MdpWq5TqToaBeCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D4B0D13276;
        Mon, 17 Jul 2023 15:38:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K2+xMIRgtWRcFAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 17 Jul 2023 15:38:44 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 80dfd430;
        Mon, 17 Jul 2023 15:38:44 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs?= Henriques <lhenriques@suse.de>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 04/17] btrfs: start using fscrypt hooks
Date:   Mon, 17 Jul 2023 16:34:17 +0100
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
        <0afc75247f4312d78ce663382e7d89854c353e9b.1689564024.git.sweettea-kernel@dorminy.me>
Message-ID: <875y6iwnsr.fsf@suse.de>
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

(Sorry for the send.  Somehow, my MUA is failing to set the CC header.)
Sweet Tea Dorminy <sweettea-kernel@dorminy.me> writes:

> From: Omar Sandoval <osandov@osandov.com>
>
> In order to appropriately encrypt, create, open, rename, and various
> symlink operations must call fscrypt hooks. These determine whether the
> inode should be encrypted and do other preparatory actions. The
> superblock must have fscrypt operations registered, so implement the
> minimal set also, and introduce the new fscrypt.[ch] files to hold the
> fscrypt-specific functionality. Also add the key prefix for fscrypt v1
> keys.
>
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/Makefile      |  1 +
>  fs/btrfs/btrfs_inode.h |  1 +
>  fs/btrfs/file.c        |  3 ++
>  fs/btrfs/fscrypt.c     |  8 ++++
>  fs/btrfs/fscrypt.h     | 10 +++++
>  fs/btrfs/inode.c       | 87 +++++++++++++++++++++++++++++++++++-------
>  fs/btrfs/super.c       |  2 +
>  7 files changed, 99 insertions(+), 13 deletions(-)
>  create mode 100644 fs/btrfs/fscrypt.c
>  create mode 100644 fs/btrfs/fscrypt.h
>
> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
> index 90d53209755b..90d30b1e044a 100644
> --- a/fs/btrfs/Makefile
> +++ b/fs/btrfs/Makefile
> @@ -40,6 +40,7 @@ btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) +=3D check-int=
egrity.o
>  btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) +=3D ref-verify.o
>  btrfs-$(CONFIG_BLK_DEV_ZONED) +=3D zoned.o
>  btrfs-$(CONFIG_FS_VERITY) +=3D verity.o
> +btrfs-$(CONFIG_FS_ENCRYPTION) +=3D fscrypt.o
>=20=20
>  btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) +=3D tests/free-space-tests.o \
>  	tests/extent-buffer-tests.o tests/btrfs-tests.o \
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index d47a927b3504..ec4a06a78aff 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -448,6 +448,7 @@ struct btrfs_new_inode_args {
>  	struct posix_acl *default_acl;
>  	struct posix_acl *acl;
>  	struct fscrypt_name fname;
> +	bool encrypt;
>  };
>=20=20
>  int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index fd03e689a6be..73038908876a 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -3698,6 +3698,9 @@ static int btrfs_file_open(struct inode *inode, str=
uct file *filp)
>=20=20
>  	filp->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
>  		        FMODE_CAN_ODIRECT;
> +	ret =3D fscrypt_file_open(inode, filp);
> +	if (ret)
> +		return ret;
>=20=20
>  	ret =3D fsverity_file_open(inode, filp);
>  	if (ret)
> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c

Nit: both ext4 and ubifs (and in a (hopefully!) near future, ceph) use
'crypto.c' for naming this file.  I'd prefer consistency, but meh.

> new file mode 100644
> index 000000000000..3a53dc59c1e4
> --- /dev/null
> +++ b/fs/btrfs/fscrypt.c
> @@ -0,0 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "ctree.h"
> +#include "fscrypt.h"
> +
> +const struct fscrypt_operations btrfs_fscrypt_ops =3D {
> +	.key_prefix =3D "btrfs:"
> +};
> diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
> new file mode 100644
> index 000000000000..7f4e6888bd43
> --- /dev/null
> +++ b/fs/btrfs/fscrypt.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef BTRFS_FSCRYPT_H
> +#define BTRFS_FSCRYPT_H
> +
> +#include <linux/fscrypt.h>
> +
> +extern const struct fscrypt_operations btrfs_fscrypt_ops;
> +
> +#endif /* BTRFS_FSCRYPT_H */
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 6e622328f2b5..d8484752b905 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5361,6 +5361,7 @@ void btrfs_evict_inode(struct inode *inode)
>  	trace_btrfs_inode_evict(inode);
>=20=20
>  	if (!root) {
> +		fscrypt_put_encryption_info(inode);
>  		fsverity_cleanup_inode(inode);
>  		clear_inode(inode);

Small suggestion: maybe it's time to start thinking adding a new label in
this function and use a 'goto' here.

>  		return;
> @@ -5464,6 +5465,7 @@ void btrfs_evict_inode(struct inode *inode)
>  	 * to retry these periodically in the future.
>  	 */
>  	btrfs_remove_delayed_node(BTRFS_I(inode));
> +	fscrypt_put_encryption_info(inode);
>  	fsverity_cleanup_inode(inode);
>  	clear_inode(inode);
>  }
> @@ -6214,6 +6216,10 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode=
_args *args,
>  		return ret;
>  	}
>=20=20
> +	ret =3D fscrypt_prepare_new_inode(dir, inode, &args->encrypt);
> +	if (ret)

We're leaking args->fname here.

Cheers,
--=20
Lu=C3=ADs

> +		return ret;
> +
>  	/* 1 to add inode item */
>  	*trans_num_items =3D 1;
>  	/* 1 to add compression property */
> @@ -6690,9 +6696,13 @@ static int btrfs_link(struct dentry *old_dentry, s=
truct inode *dir,
>  	if (inode->i_nlink >=3D BTRFS_LINK_MAX)
>  		return -EMLINK;
>=20=20
> +	err =3D fscrypt_prepare_link(old_dentry, dir, dentry);
> +	if (err)
> +		return err;
> +
>  	err =3D fscrypt_setup_filename(dir, &dentry->d_name, 0, &fname);
>  	if (err)
> -		goto fail;
> +		return err;
>=20=20
>  	err =3D btrfs_set_inode_index(BTRFS_I(dir), &index);
>  	if (err)
> @@ -8636,6 +8646,7 @@ void btrfs_test_destroy_inode(struct inode *inode)
>=20=20
>  void btrfs_free_inode(struct inode *inode)
>  {
> +	fscrypt_free_inode(inode);
>  	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
>  }
>=20=20
> @@ -8706,8 +8717,7 @@ int btrfs_drop_inode(struct inode *inode)
>  	/* the snap/subvol tree is on deleting */
>  	if (btrfs_root_refs(&root->root_item) =3D=3D 0)
>  		return 1;
> -	else
> -		return generic_drop_inode(inode);
> +	return generic_drop_inode(inode) || fscrypt_drop_inode(inode);
>  }
>=20=20
>  static void init_once(void *foo)
> @@ -9298,6 +9308,11 @@ static int btrfs_rename2(struct mnt_idmap *idmap, =
struct inode *old_dir,
>  	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
>  		return -EINVAL;
>=20=20
> +	ret =3D fscrypt_prepare_rename(old_dir, old_dentry, new_dir, new_dentry,
> +				     flags);
> +	if (ret)
> +		return ret;
> +
>  	if (flags & RENAME_EXCHANGE)
>  		ret =3D btrfs_rename_exchange(old_dir, old_dentry, new_dir,
>  					    new_dentry);
> @@ -9517,15 +9532,22 @@ static int btrfs_symlink(struct mnt_idmap *idmap,=
 struct inode *dir,
>  	};
>  	unsigned int trans_num_items;
>  	int err;
> -	int name_len;
>  	int datasize;
>  	unsigned long ptr;
>  	struct btrfs_file_extent_item *ei;
>  	struct extent_buffer *leaf;
> +	struct fscrypt_str disk_link;
> +	u32 name_len =3D strlen(symname);
>=20=20
> -	name_len =3D strlen(symname);
> -	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info))
> -		return -ENAMETOOLONG;
> +	/*
> +	 * fscrypt sets disk_link.len to be len + 1, including a NUL terminator=
, but we
> +	 * don't store that '\0' character.
> +	 */
> +	err =3D fscrypt_prepare_symlink(dir, symname, name_len,
> +				      BTRFS_MAX_INLINE_DATA_SIZE(fs_info) + 1,
> +				      &disk_link);
> +	if (err)
> +		return err;
>=20=20
>  	inode =3D new_inode(dir->i_sb);
>  	if (!inode)
> @@ -9534,8 +9556,8 @@ static int btrfs_symlink(struct mnt_idmap *idmap, s=
truct inode *dir,
>  	inode->i_op =3D &btrfs_symlink_inode_operations;
>  	inode_nohighmem(inode);
>  	inode->i_mapping->a_ops =3D &btrfs_aops;
> -	btrfs_i_size_write(BTRFS_I(inode), name_len);
> -	inode_set_bytes(inode, name_len);
> +	btrfs_i_size_write(BTRFS_I(inode), disk_link.len - 1);
> +	inode_set_bytes(inode, disk_link.len - 1);
>=20=20
>  	new_inode_args.inode =3D inode;
>  	err =3D btrfs_new_inode_prepare(&new_inode_args, &trans_num_items);
> @@ -9562,10 +9584,23 @@ static int btrfs_symlink(struct mnt_idmap *idmap,=
 struct inode *dir,
>  		inode =3D NULL;
>  		goto out;
>  	}
> +
> +	if (IS_ENCRYPTED(inode)) {
> +		err =3D fscrypt_encrypt_symlink(inode, symname, name_len,
> +					      &disk_link);
> +		if (err) {
> +			btrfs_abort_transaction(trans, err);
> +			btrfs_free_path(path);
> +			discard_new_inode(inode);
> +			inode =3D NULL;
> +			goto out;
> +		}
> +	}
> +
>  	key.objectid =3D btrfs_ino(BTRFS_I(inode));
>  	key.offset =3D 0;
>  	key.type =3D BTRFS_EXTENT_DATA_KEY;
> -	datasize =3D btrfs_file_extent_calc_inline_size(name_len);
> +	datasize =3D btrfs_file_extent_calc_inline_size(disk_link.len - 1);
>  	err =3D btrfs_insert_empty_item(trans, root, path, &key,
>  				      datasize);
>  	if (err) {
> @@ -9584,10 +9619,10 @@ static int btrfs_symlink(struct mnt_idmap *idmap,=
 struct inode *dir,
>  	btrfs_set_file_extent_encryption(leaf, ei, 0);
>  	btrfs_set_file_extent_compression(leaf, ei, 0);
>  	btrfs_set_file_extent_other_encoding(leaf, ei, 0);
> -	btrfs_set_file_extent_ram_bytes(leaf, ei, name_len);
> +	btrfs_set_file_extent_ram_bytes(leaf, ei, disk_link.len - 1);
>=20=20
>  	ptr =3D btrfs_file_extent_inline_start(ei);
> -	write_extent_buffer(leaf, symname, ptr, name_len);
> +	write_extent_buffer(leaf, disk_link.name, ptr, disk_link.len - 1);
>  	btrfs_mark_buffer_dirty(leaf);
>  	btrfs_free_path(path);
>=20=20
> @@ -9604,6 +9639,29 @@ static int btrfs_symlink(struct mnt_idmap *idmap, =
struct inode *dir,
>  	return err;
>  }
>=20=20
> +static const char *btrfs_get_link(struct dentry *dentry, struct inode *i=
node,
> +				  struct delayed_call *done)
> +{
> +	struct page *cpage;
> +	const char *paddr;
> +	struct btrfs_fs_info *fs_info =3D btrfs_sb(inode->i_sb);
> +
> +	if (!IS_ENCRYPTED(inode))
> +		return page_get_link(dentry, inode, done);
> +
> +	if (!dentry)
> +		return ERR_PTR(-ECHILD);
> +
> +	cpage =3D read_mapping_page(inode->i_mapping, 0, NULL);
> +	if (IS_ERR(cpage))
> +		return ERR_CAST(cpage);
> +
> +	paddr =3D fscrypt_get_symlink(inode, page_address(cpage),
> +				    BTRFS_MAX_INLINE_DATA_SIZE(fs_info), done);
> +	put_page(cpage);
> +	return paddr;
> +}
> +
>  static struct btrfs_trans_handle *insert_prealloc_file_extent(
>  				       struct btrfs_trans_handle *trans_in,
>  				       struct btrfs_inode *inode,
> @@ -11082,7 +11140,7 @@ static const struct inode_operations btrfs_specia=
l_inode_operations =3D {
>  	.update_time	=3D btrfs_update_time,
>  };
>  static const struct inode_operations btrfs_symlink_inode_operations =3D {
> -	.get_link	=3D page_get_link,
> +	.get_link	=3D btrfs_get_link,
>  	.getattr	=3D btrfs_getattr,
>  	.setattr	=3D btrfs_setattr,
>  	.permission	=3D btrfs_permission,
> @@ -11092,4 +11150,7 @@ static const struct inode_operations btrfs_symlin=
k_inode_operations =3D {
>=20=20
>  const struct dentry_operations btrfs_dentry_operations =3D {
>  	.d_delete	=3D btrfs_dentry_delete,
> +#ifdef CONFIG_FS_ENCRYPTION
> +	.d_revalidate	=3D fscrypt_d_revalidate,
> +#endif
>  };
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index cffdd6f7f8e8..08b1e2ded5be 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -48,6 +48,7 @@
>  #include "tests/btrfs-tests.h"
>  #include "block-group.h"
>  #include "discard.h"
> +#include "fscrypt.h"
>  #include "qgroup.h"
>  #include "raid56.h"
>  #include "fs.h"
> @@ -1144,6 +1145,7 @@ static int btrfs_fill_super(struct super_block *sb,
>  	sb->s_vop =3D &btrfs_verityops;
>  #endif
>  	sb->s_xattr =3D btrfs_xattr_handlers;
> +	fscrypt_set_ops(sb, &btrfs_fscrypt_ops);
>  	sb->s_time_gran =3D 1;
>  #ifdef CONFIG_BTRFS_FS_POSIX_ACL
>  	sb->s_flags |=3D SB_POSIXACL;
> --=20
>
> 2.40.1
>
