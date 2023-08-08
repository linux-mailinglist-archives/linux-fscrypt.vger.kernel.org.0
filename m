Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7277B7743AF
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbjHHSIV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjHHSH5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:07:57 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4519015C7A0;
        Tue,  8 Aug 2023 10:08:55 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D138683542;
        Tue,  8 Aug 2023 13:08:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514534; bh=X5VZrDl+HOopD5CK3S8HzBpQk1qElsBaYmp5R12HdyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1uL6sm01fSkdjao8WB4efclHN4Bp50SxCP6i2swQOD9z5kHwxqpSjCBeHR6Ul3H2
         jXxxrjOL9rSiOdFJ55JB2lYQXennagQ3TBwCcU0tiHiywPEDilV8ZPvjSMe/smdB8d
         L8aq2K565DplaVUpjahn6GPl9pN4xenYzStUHcDsmMDj8yuHv9LAGAVekWgPI2yoyu
         xqtaSMGhv9MmW3ZYaNXArCw6JOSbxIXoZs3mvBgijlw9GrBHL1QoDX1DzeMHvSwsWX
         wHEZnxx1L8bq9yAyEWGSEeVDUngimlsiXz9Flnfyu1Bd7p8OOI+JzrfVBTCPNmmYfi
         nPKQIXpPfHeAw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 09/16] fscrypt: revamp key removal for extent encryption
Date:   Tue,  8 Aug 2023 13:08:26 -0400
Message-ID: <25ca0cf3c15e92509718a0638563e21497a1d82d.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Currently, for inode encryption, once an inode is open IO will not fail
due to lack of key until the inode is closed. Even if the key is
removed, open inodes will continue to use the key.

For extent encryption, it's a little harder, since the extent may not be
createdi/loaded until well after the REMOVE_KEY ioctl is called. To be
as similar to inode based encryption as plausible, this changes key
removal to be 'soft' for extent-based encryption, allowing new extents
to use keys which were in use by open inodes at the time of removal;
this hopefully follows the discussion at [1].

[1] https://lore.kernel.org/linux-fscrypt/248eac32-96cc-eb2e-85da-422a8d75a376@dorminy.me/T/#m48f43837cf98e0212de2e70aa6435320e3532d6e

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 37 ++++++++++++++++++++++++++++++-----
 fs/crypto/keyring.c         | 39 +++++++++++++++++++++++++++----------
 fs/crypto/keysetup.c        | 35 ++++++++++++++++++++++++++++++++-
 3 files changed, 95 insertions(+), 16 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 4fe79b774f1f..21e4e138cfcc 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -332,6 +332,21 @@ static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
 	return false;
 }
 
+/**
+ * fscrypt_fs_uses_extent_encryption() -- whether a filesystem uses per-extent
+ *				          encryption
+ *
+ * @sb: the superblock of the filesystem in question
+ *
+ * Return: true if the fs uses per-extent fscrypt_infos, false otherwise
+ */
+static inline bool
+fscrypt_fs_uses_extent_encryption(const struct super_block *sb)
+{
+	// No filesystems currently use per-extent infos
+	return false;
+}
+
 /**
  * fscrypt_get_info_ino() - get the ino or ino equivalent for an info
  *
@@ -556,11 +571,14 @@ struct fscrypt_master_key {
 
 	/*
 	 * The secret key material.  After FS_IOC_REMOVE_ENCRYPTION_KEY is
-	 * executed, this is wiped and no new inodes can be unlocked with this
-	 * key; however, there may still be inodes in ->mk_decrypted_inodes
-	 * which could not be evicted.  As long as some inodes still remain,
-	 * FS_IOC_REMOVE_ENCRYPTION_KEY can be retried, or
-	 * FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
+	 * executed, no new inodes can be unlocked with this key; however,
+	 * there may still be inodes in ->mk_decrypted_inodes which could not
+	 * be evicted. For inode-based encryption, the secret is wiped; for
+	 * extent-based encryption, the secret is preserved while inodes still
+	 * reference it, as they may need to create new extents using the
+	 * secret to service IO; @soft_deleted is set to true then. As long as
+	 * some inodes still remain, FS_IOC_REMOVE_ENCRYPTION_KEY can be
+	 * retried, or FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
 	 *
 	 * While ->mk_secret is present, one ref in ->mk_active_refs is held.
 	 *
@@ -599,6 +617,13 @@ struct fscrypt_master_key {
 	struct list_head	mk_decrypted_inodes;
 	spinlock_t		mk_decrypted_inodes_lock;
 
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
@@ -626,6 +651,8 @@ is_master_key_secret_present(const struct fscrypt_master_key_secret *secret)
 	return READ_ONCE(secret->size) != 0;
 }
 
+void fscrypt_wipe_master_key_secret(struct fscrypt_master_key_secret *secret);
+
 static inline const char *master_key_spec_type(
 				const struct fscrypt_key_specifier *spec)
 {
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 9d00cadb19ee..feca4a8410bb 100644
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
index 32e62cc57708..51d3787fc964 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -576,6 +576,15 @@ static int find_and_lock_master_key(const struct fscrypt_info *ci,
 		goto out_release_key;
 	}
 
+	if (!ci->ci_info_ptr && mk->mk_soft_deleted) {
+		/*
+		 * This is an inode info, and only extent infos can use keys
+		 * that have been soft deleted
+		 */
+		err = -ENOKEY;
+		goto out_release_key;
+	}
+
 	*mk_ret = mk;
 	return 0;
 
@@ -606,6 +615,8 @@ static void put_crypt_info(struct fscrypt_info *ci)
 
 	mk = ci->ci_master_key;
 	if (mk) {
+		bool any_inodes;
+
 		/*
 		 * Remove this inode from the list of inodes that were unlocked
 		 * with the master key.  In addition, if we're removing the last
@@ -614,7 +625,28 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		 */
 		spin_lock(&mk->mk_decrypted_inodes_lock);
 		list_del(&ci->ci_master_key_link);
+		any_inodes = list_empty(&mk->mk_decrypted_inodes);
 		spin_unlock(&mk->mk_decrypted_inodes_lock);
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
+				fscrypt_put_master_key_activeref(ci->ci_sb, mk);
+		}
+
 		fscrypt_put_master_key_activeref(ci->ci_sb, mk);
 	}
 	memzero_explicit(ci, sizeof(*ci));
@@ -967,6 +999,7 @@ int fscrypt_drop_inode(struct inode *inode)
 	 * then the thread removing the key will either evict the inode itself
 	 * or will correctly detect that it wasn't evicted due to the race.
 	 */
-	return !is_master_key_secret_present(&ci->ci_master_key->mk_secret);
+	return READ_ONCE(ci->ci_master_key->mk_soft_deleted) ||
+		!is_master_key_secret_present(&ci->ci_master_key->mk_secret);
 }
 EXPORT_SYMBOL_GPL(fscrypt_drop_inode);
-- 
2.41.0

