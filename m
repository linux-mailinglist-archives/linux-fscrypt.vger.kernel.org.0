Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EEB790573
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343615AbjIBF4K (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243397AbjIBF4K (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:56:10 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A6710F6;
        Fri,  1 Sep 2023 22:56:07 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 9FFDE80A27;
        Sat,  2 Sep 2023 01:56:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634167; bh=Onf9UxFarwFjlBaDiO4ibgiZHvS0BNRZ/Y0HdfEcyLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbwDV1uXLavuH15YZeQb7cW+FHG8y6zDskfNrvj+J3qBQrzmHis2X9gYSRh1cUzuO
         Efy3JXY0zycXksqRgCe4fbquA2LDjrGyuMlIGV8g4QuifdcMCibmGkl+CroN1DOOw7
         s0cUyNOJx3n9G4i0j3HyjaxkmJiglznmZg/96Io0XBTTyoW7FgaiLqgK/rlxVerrMD
         QhsD3QbLXuQHOySzQcIWghVEHjFev6O2cdUK0zlKdBBf+lPtQKCPlkoe53ibq57s8G
         MMcMfy0EvMxmKFcsn8ZlJ8nnb0/+G2h7JSyVqY3jr0/mQ5FsiS8ifaQnnvqXzJERjD
         SOHCk859/WhIw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 09/13] fscrypt: revamp key removal for extent encryption
Date:   Sat,  2 Sep 2023 01:54:27 -0400
Message-ID: <69acd3cd235b4b1bbf414b35e79c5a2131a5de95.1693630890.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1693630890.git.sweettea-kernel@dorminy.me>
References: <cover.1693630890.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Currently, for inode encryption, once an inode is open IO will not fail
due to lack of key until the inode is closed. Even if the key is
removed, open inodes will continue to use a tfm or inline crypt context
set up with the key.

For extent encryption, it's a little harder, since the extent may not be
created or loaded until well after the REMOVE_KEY ioctl is called. If
the key is actually fully removed, then the extent will be unable to
load/create, since it has to set up a new inline crypt context using the
key. Therefore, make key
removal 'soft' for extent-based encryption: keep the key material around if any
inodes using extent encryption are using it, allowing extents for those
inodes to use the key material.

Currently, both the key secret and each inode using the key keep a
reference to the structure; when the remove ioctl is called, the key
secret is removed and its reference is dropped. However, if we need to
keep the key secret around, we can't wipe the secret there, so to
preserve the invariant, we move both wiping and dropping the secret's
reference to the last inode releasing a soft-deleted key.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 22 ++++++++++++++++-----
 fs/crypto/keyring.c         | 39 +++++++++++++++++++++++++++----------
 fs/crypto/keysetup.c        | 35 +++++++++++++++++++++++++++++++--
 3 files changed, 79 insertions(+), 17 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index fe48b61a524b..dd7740105264 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -591,11 +591,14 @@ struct fscrypt_master_key {
 
 	/*
 	 * The secret key material.  After FS_IOC_REMOVE_ENCRYPTION_KEY is
-	 * executed, this is wiped and no new inodes can be unlocked with this
-	 * key; however, there may still be inodes in ->mk_decrypted_infos
-	 * which could not be evicted.  As long as some inodes still remain,
-	 * FS_IOC_REMOVE_ENCRYPTION_KEY can be retried, or
-	 * FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
+	 * executed, no new inodes can be unlocked with this key; however,
+	 * there may still be inodes in ->mk_decrypted_infos which could not
+	 * be evicted. For inode-based encryption, the secret is wiped; for
+	 * extent-based encryption, the secret is preserved while inodes still
+	 * reference it, as they may need to create new extents using the
+	 * secret to service IO; @soft_deleted is set to true then. As long as
+	 * some inodes still remain, FS_IOC_REMOVE_ENCRYPTION_KEY can be
+	 * retried, or FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
 	 *
 	 * While ->mk_secret is present, one ref in ->mk_active_refs is held.
 	 *
@@ -634,6 +637,13 @@ struct fscrypt_master_key {
 	struct list_head	mk_decrypted_infos;
 	spinlock_t		mk_decrypted_infos_lock;
 
+	/*
+	 * Whether the key is unavailable to new inodes, but still available
+	 * to new extents within decrypted inodes. Protected by ->mk_sem, except
+	 * for race-okay access in fscrypt_drop_inode().
+	 */
+	bool			mk_soft_deleted;
+
 	/*
 	 * Per-mode encryption keys for the various types of encryption policies
 	 * that use them.  Allocated and derived on-demand.
@@ -661,6 +671,8 @@ is_master_key_secret_present(const struct fscrypt_master_key_secret *secret)
 	return READ_ONCE(secret->size) != 0;
 }
 
+void fscrypt_wipe_master_key_secret(struct fscrypt_master_key_secret *secret);
+
 static inline const char *master_key_spec_type(
 				const struct fscrypt_key_specifier *spec)
 {
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 27ae0345fa85..9235a5a9bcba 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -38,7 +38,7 @@ struct fscrypt_keyring {
 	struct hlist_head key_hashtable[128];
 };
 
-static void wipe_master_key_secret(struct fscrypt_master_key_secret *secret)
+void fscrypt_wipe_master_key_secret(struct fscrypt_master_key_secret *secret)
 {
 	fscrypt_destroy_hkdf(&secret->hkdf);
 	memzero_explicit(secret, sizeof(*secret));
@@ -239,8 +239,9 @@ void fscrypt_destroy_keyring(struct super_block *sb)
 			 */
 			WARN_ON_ONCE(refcount_read(&mk->mk_active_refs) != 1);
 			WARN_ON_ONCE(refcount_read(&mk->mk_struct_refs) != 1);
-			WARN_ON_ONCE(!is_master_key_secret_present(&mk->mk_secret));
-			wipe_master_key_secret(&mk->mk_secret);
+			WARN_ON_ONCE(!mk->mk_soft_deleted &&
+				     !is_master_key_secret_present(&mk->mk_secret));
+			fscrypt_wipe_master_key_secret(&mk->mk_secret);
 			fscrypt_put_master_key_activeref(sb, mk);
 		}
 	}
@@ -485,6 +486,8 @@ static int add_existing_master_key(struct fscrypt_master_key *mk,
 		move_master_key_secret(&mk->mk_secret, secret);
 	}
 
+	mk->mk_soft_deleted = false;
+
 	return 0;
 }
 
@@ -738,7 +741,7 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 		goto out_wipe_secret;
 	err = 0;
 out_wipe_secret:
-	wipe_master_key_secret(&secret);
+	fscrypt_wipe_master_key_secret(&secret);
 	return err;
 }
 EXPORT_SYMBOL_GPL(fscrypt_ioctl_add_key);
@@ -770,7 +773,7 @@ int fscrypt_get_test_dummy_key_identifier(
 				  NULL, 0, key_identifier,
 				  FSCRYPT_KEY_IDENTIFIER_SIZE);
 out:
-	wipe_master_key_secret(&secret);
+	fscrypt_wipe_master_key_secret(&secret);
 	return err;
 }
 
@@ -794,7 +797,7 @@ int fscrypt_add_test_dummy_key(struct super_block *sb,
 
 	fscrypt_get_test_dummy_secret(&secret);
 	err = add_master_key(sb, &secret, key_spec);
-	wipe_master_key_secret(&secret);
+	fscrypt_wipe_master_key_secret(&secret);
 	return err;
 }
 
@@ -1017,6 +1020,12 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
 	mk = fscrypt_find_master_key(sb, &arg.key_spec);
 	if (!mk)
 		return -ENOKEY;
+
+	if (fscrypt_fs_uses_extent_encryption(sb)) {
+		/* Keep going even if this has an error. */
+		try_to_lock_encrypted_files(sb, mk);
+	}
+
 	down_write(&mk->mk_sem);
 
 	/* If relevant, remove current user's (or all users) claim to the key */
@@ -1043,13 +1052,23 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
 		}
 	}
 
-	/* No user claims remaining.  Go ahead and wipe the secret. */
+	/* No user claims remaining. */
 	err = -ENOKEY;
-	if (is_master_key_secret_present(&mk->mk_secret)) {
-		wipe_master_key_secret(&mk->mk_secret);
+	if (fscrypt_fs_uses_extent_encryption(sb) && refcount_read(&mk->mk_active_refs) > 1) {
+		mk->mk_soft_deleted = true;
+		err = 0;
+	} else if (is_master_key_secret_present(&mk->mk_secret)) {
+		fscrypt_wipe_master_key_secret(&mk->mk_secret);
 		fscrypt_put_master_key_activeref(sb, mk);
 		err = 0;
+	} else if (mk->mk_soft_deleted) {
+		/*
+		 * Was soft deleted, but all inodes have stopped using it, and
+		 * the secret was wiped by the last one.
+		 */
+		err = 0;
 	}
+
 	inodes_remain = refcount_read(&mk->mk_active_refs) > 0;
 	up_write(&mk->mk_sem);
 
@@ -1149,7 +1168,7 @@ int fscrypt_ioctl_get_key_status(struct file *filp, void __user *uarg)
 	}
 	down_read(&mk->mk_sem);
 
-	if (!is_master_key_secret_present(&mk->mk_secret)) {
+	if (mk->mk_soft_deleted || !is_master_key_secret_present(&mk->mk_secret)) {
 		arg.status = refcount_read(&mk->mk_active_refs) > 0 ?
 			FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED :
 			FSCRYPT_KEY_STATUS_ABSENT /* raced with full removal */;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 5e944ec4e36f..34d4df4acb19 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -570,6 +570,12 @@ static int find_and_lock_master_key(const struct fscrypt_common_info *cci,
 		goto out_release_key;
 	}
 
+	if (cci->ci_type != CI_EXTENT && mk->mk_soft_deleted) {
+		/* Only extent infos can use keys that have been soft deleted */
+		err = -ENOKEY;
+		goto out_release_key;
+	}
+
 	*mk_ret = mk;
 	return 0;
 
@@ -598,6 +604,8 @@ static void remove_info_from_mk_decrypted_list(struct fscrypt_common_info *cci)
 {
 	struct fscrypt_master_key *mk = cci->ci_master_key;
 	if (mk) {
+		bool any_inodes;
+
 		/*
 		 * Remove this inode from the list of inodes that were unlocked
 		 * with the master key.  In addition, if we're removing the last
@@ -606,7 +614,28 @@ static void remove_info_from_mk_decrypted_list(struct fscrypt_common_info *cci)
 		 */
 		spin_lock(&mk->mk_decrypted_infos_lock);
 		list_del(&cci->ci_master_key_link);
+		any_inodes = list_empty(&mk->mk_decrypted_infos);
 		spin_unlock(&mk->mk_decrypted_infos_lock);
+		if (any_inodes) {
+			bool soft_deleted;
+			/* It might be that someone tried to remove this key,
+			 * but there were still inodes open that could need new
+			 * extents, which needed to be able to access the key
+			 * secret. But now this was the last reference. So we
+			 * can delete the key secret now. (We don't need to
+			 * check for new inodes on the decrypted_inode list
+			 * because once ->mk_soft_deleted is set, no new inode
+			 * can join the list.
+			 */
+			down_write(&mk->mk_sem);
+			soft_deleted = mk->mk_soft_deleted;
+			if (soft_deleted)
+				fscrypt_wipe_master_key_secret(&mk->mk_secret);
+			up_write(&mk->mk_sem);
+			if (soft_deleted)
+				fscrypt_put_master_key_activeref(cci->ci_inode->i_sb, mk);
+		}
+
 		fscrypt_put_master_key_activeref(cci->ci_inode->i_sb, mk);
 	}
 }
@@ -933,6 +962,7 @@ EXPORT_SYMBOL(fscrypt_free_inode);
 int fscrypt_drop_inode(struct inode *inode)
 {
 	const struct fscrypt_info *ci = fscrypt_get_info(inode);
+	const struct fscrypt_common_info *cci = &ci->info;
 
 	/*
 	 * If ci is NULL, then the inode doesn't have an encryption key set up
@@ -940,7 +970,7 @@ int fscrypt_drop_inode(struct inode *inode)
 	 * was provided via the legacy mechanism of the process-subscribed
 	 * keyrings, so we don't know whether it's been removed or not.
 	 */
-	if (!ci || !ci->info.ci_master_key)
+	if (!ci || !cci->ci_master_key)
 		return 0;
 
 	/*
@@ -960,7 +990,8 @@ int fscrypt_drop_inode(struct inode *inode)
 	 * then the thread removing the key will either evict the inode itself
 	 * or will correctly detect that it wasn't evicted due to the race.
 	 */
-	return !is_master_key_secret_present(&ci->info.ci_master_key->mk_secret);
+	return cci->ci_master_key->mk_soft_deleted ||
+		!is_master_key_secret_present(&cci->ci_master_key->mk_secret);
 }
 EXPORT_SYMBOL_GPL(fscrypt_drop_inode);
 
-- 
2.41.0

