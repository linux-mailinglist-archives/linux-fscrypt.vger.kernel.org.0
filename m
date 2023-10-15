Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF827C981E
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 Oct 2023 08:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjJOGMW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 Oct 2023 02:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJOGMV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 Oct 2023 02:12:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D1FC5;
        Sat, 14 Oct 2023 23:12:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3011C433C8;
        Sun, 15 Oct 2023 06:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697350338;
        bh=gpMloLh1SLIL5NfGrEKNiaI7gxO45Qg+mX/cdOtHjbY=;
        h=From:To:Cc:Subject:Date:From;
        b=jbR+4+rhZ0RU7sFOTWWgldOeI4vmkFCXPazDahRH/14aU7zVxhWYq+gpEKfZIGRzh
         jZhcfzgkG4Yx+ImADdN6aWFACiVv3ATjkfNXT145ZtHdhzROT79+XIy4GHgumNnz6j
         BpNJBrwBvFY+f93vXldON9/viHfCqqN75eM9dK7Dd/X4f9Mf6FolNCpC1SjraJJnXI
         reXJaNusL2rtZpfDLZ2Uqa8yMuy4v8Yb8C9iKMDVCeoUsRfmcB9lZrdT/ucGgB+pOW
         oH/zymps7nvOYuF99al0zzD9WcS4ITfN4IBPV2+2Sw+GIbiIuucya8kAOrFjRA85YI
         v7ZHBqjx3KJ+g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH] fscrypt: track master key presence separately from secret
Date:   Sat, 14 Oct 2023 23:10:55 -0700
Message-ID: <20231015061055.62673-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Master keys can be in one of three states: present, incompletely
removed, and absent (as per FSCRYPT_KEY_STATUS_* used in the UAPI).
Currently, the way that "present" is distinguished from "incompletely
removed" internally is by whether ->mk_secret exists or not.

With extent-based encryption, it will be necessary to allow per-extent
keys to be derived while the master key is incompletely removed, so that
I/O on open files will reliably continue working after removal of the
key has been initiated.  (We could allow I/O to sometimes fail in that
case, but that seems problematic for reasons such as writes getting
silently thrown away and diverging from the existing fscrypt semantics.)
Therefore, when the filesystem is using extent-based encryption,
->mk_secret can't be wiped when the key becomes incompletely removed.

As a prerequisite for doing that, this patch makes the "present" state
be tracked using a new field, ->mk_present.  No behavior is changed yet.

The basic idea here is borrowed from Josef Bacik's patch
"fscrypt: use a flag to indicate that the master key is being evicted"
(https://lore.kernel.org/r/e86c16dddc049ff065f877d793ad773e4c6bfad9.1696970227.git.josef@toxicpanda.com).
I reimplemented it using a "present" bool instead of an "evicted" flag,
fixed a couple bugs, and tried to update everything to be consistent.

Note: I considered adding a ->mk_status field instead, holding one of
FSCRYPT_KEY_STATUS_*.  At first that seemed nice, but it ended up being
more complex (despite simplifying FS_IOC_GET_ENCRYPTION_KEY_STATUS),
since it would have introduced redundancy and had weird locking rules.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst |  4 +-
 fs/crypto/fscrypt_private.h           | 66 +++++++++++++----------
 fs/crypto/hooks.c                     |  2 +-
 fs/crypto/keyring.c                   | 78 ++++++++++++++++-----------
 fs/crypto/keysetup.c                  | 13 ++---
 5 files changed, 95 insertions(+), 68 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 28700fb41a00b..1b84f818e574e 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1127,22 +1127,22 @@ The caller must zero all input fields, then fill in ``key_spec``:
       ``key_spec.type`` to FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR and fill
       in ``key_spec.u.descriptor``.
 
     - To get the status of a key for v2 encryption policies, set
       ``key_spec.type`` to FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER and fill
       in ``key_spec.u.identifier``.
 
 On success, 0 is returned and the kernel fills in the output fields:
 
 - ``status`` indicates whether the key is absent, present, or
-  incompletely removed.  Incompletely removed means that the master
-  secret has been removed, but some files are still in use; i.e.,
+  incompletely removed.  Incompletely removed means that removal has
+  been initiated, but some files are still in use; i.e.,
   `FS_IOC_REMOVE_ENCRYPTION_KEY`_ returned 0 but set the informational
   status flag FSCRYPT_KEY_REMOVAL_STATUS_FLAG_FILES_BUSY.
 
 - ``status_flags`` can contain the following flags:
 
     - ``FSCRYPT_KEY_STATUS_FLAG_ADDED_BY_SELF`` indicates that the key
       has added by the current user.  This is only set for keys
       identified by ``identifier`` rather than by ``descriptor``.
 
 - ``user_count`` specifies the number of users who have added the key.
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 2fb4ba435d27d..1892356cf924a 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -468,65 +468,78 @@ struct fscrypt_master_key_secret {
 
 	/* For v1 policy keys: the raw key.  Wiped for v2 policy keys. */
 	u8			raw[FSCRYPT_MAX_KEY_SIZE];
 
 } __randomize_layout;
 
 /*
  * fscrypt_master_key - an in-use master key
  *
  * This represents a master encryption key which has been added to the
- * filesystem and can be used to "unlock" the encrypted files which were
- * encrypted with it.
+ * filesystem.  There are three high-level states that a key can be in:
+ *
+ * FSCRYPT_KEY_STATUS_PRESENT
+ *	Key is fully usable; it can be used to unlock inodes that are encrypted
+ *	with it (this includes being able to create new inodes).  ->mk_present
+ *	indicates whether the key is in this state.  ->mk_secret exists, the key
+ *	is in the keyring, and ->mk_active_refs > 0 due to ->mk_present.
+ *
+ * FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED
+ *	Removal of this key has been initiated, but some inodes that were
+ *	unlocked with it are still in-use.  Like ABSENT, ->mk_secret is wiped,
+ *	and the key can no longer be used to unlock inodes.  Unlike ABSENT, the
+ *	key is still in the keyring; ->mk_decrypted_inodes is nonempty; and
+ *	->mk_active_refs > 0, being equal to the size of ->mk_decrypted_inodes.
+ *
+ *	This state transitions to ABSENT if ->mk_decrypted_inodes becomes empty,
+ *	or to PRESENT if FS_IOC_ADD_ENCRYPTION_KEY is called again for this key.
+ *
+ * FSCRYPT_KEY_STATUS_ABSENT
+ *	Key is fully removed.  The key is no longer in the keyring,
+ *	->mk_decrypted_inodes is empty, ->mk_active_refs == 0, ->mk_secret is
+ *	wiped, and the key can no longer be used to unlock inodes.
  */
 struct fscrypt_master_key {
 
 	/*
 	 * Link in ->s_master_keys->key_hashtable.
 	 * Only valid if ->mk_active_refs > 0.
 	 */
 	struct hlist_node			mk_node;
 
-	/* Semaphore that protects ->mk_secret and ->mk_users */
+	/* Semaphore that protects ->mk_secret, ->mk_users, and ->mk_present */
 	struct rw_semaphore			mk_sem;
 
 	/*
 	 * Active and structural reference counts.  An active ref guarantees
 	 * that the struct continues to exist, continues to be in the keyring
 	 * ->s_master_keys, and that any embedded subkeys (e.g.
 	 * ->mk_direct_keys) that have been prepared continue to exist.
 	 * A structural ref only guarantees that the struct continues to exist.
 	 *
-	 * There is one active ref associated with ->mk_secret being present,
-	 * and one active ref for each inode in ->mk_decrypted_inodes.
+	 * There is one active ref associated with ->mk_present being true, and
+	 * one active ref for each inode in ->mk_decrypted_inodes.
 	 *
 	 * There is one structural ref associated with the active refcount being
 	 * nonzero.  Finding a key in the keyring also takes a structural ref,
 	 * which is then held temporarily while the key is operated on.
 	 */
 	refcount_t				mk_active_refs;
 	refcount_t				mk_struct_refs;
 
 	struct rcu_head				mk_rcu_head;
 
 	/*
-	 * The secret key material.  After FS_IOC_REMOVE_ENCRYPTION_KEY is
-	 * executed, this is wiped and no new inodes can be unlocked with this
-	 * key; however, there may still be inodes in ->mk_decrypted_inodes
-	 * which could not be evicted.  As long as some inodes still remain,
-	 * FS_IOC_REMOVE_ENCRYPTION_KEY can be retried, or
-	 * FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
+	 * The secret key material.  Wiped as soon as it is no longer needed;
+	 * for details, see the fscrypt_master_key struct comment.
 	 *
-	 * While ->mk_secret is present, one ref in ->mk_active_refs is held.
-	 *
-	 * Locking: protected by ->mk_sem.  The manipulation of ->mk_active_refs
-	 *	    associated with this field is protected by ->mk_sem as well.
+	 * Locking: protected by ->mk_sem.
 	 */
 	struct fscrypt_master_key_secret	mk_secret;
 
 	/*
 	 * For v1 policy keys: an arbitrary key descriptor which was assigned by
 	 * userspace (->descriptor).
 	 *
 	 * For v2 policy keys: a cryptographic hash of this key (->identifier).
 	 */
 	struct fscrypt_key_specifier		mk_spec;
@@ -535,21 +548,21 @@ struct fscrypt_master_key {
 	 * Keyring which contains a key of type 'key_type_fscrypt_user' for each
 	 * user who has added this key.  Normally each key will be added by just
 	 * one user, but it's possible that multiple users share a key, and in
 	 * that case we need to keep track of those users so that one user can't
 	 * remove the key before the others want it removed too.
 	 *
 	 * This is NULL for v1 policy keys; those can only be added by root.
 	 *
 	 * Locking: protected by ->mk_sem.  (We don't just rely on the keyrings
 	 * subsystem semaphore ->mk_users->sem, as we need support for atomic
-	 * search+insert along with proper synchronization with ->mk_secret.)
+	 * search+insert along with proper synchronization with other fields.)
 	 */
 	struct key		*mk_users;
 
 	/*
 	 * List of inodes that were unlocked using this key.  This allows the
 	 * inodes to be evicted efficiently if the key is removed.
 	 */
 	struct list_head	mk_decrypted_inodes;
 	spinlock_t		mk_decrypted_inodes_lock;
 
@@ -558,34 +571,31 @@ struct fscrypt_master_key {
 	 * that use them.  Allocated and derived on-demand.
 	 */
 	struct fscrypt_prepared_key mk_direct_keys[FSCRYPT_MODE_MAX + 1];
 	struct fscrypt_prepared_key mk_iv_ino_lblk_64_keys[FSCRYPT_MODE_MAX + 1];
 	struct fscrypt_prepared_key mk_iv_ino_lblk_32_keys[FSCRYPT_MODE_MAX + 1];
 
 	/* Hash key for inode numbers.  Initialized only when needed. */
 	siphash_key_t		mk_ino_hash_key;
 	bool			mk_ino_hash_key_initialized;
 
-} __randomize_layout;
-
-static inline bool
-is_master_key_secret_present(const struct fscrypt_master_key_secret *secret)
-{
 	/*
-	 * The READ_ONCE() is only necessary for fscrypt_drop_inode().
-	 * fscrypt_drop_inode() runs in atomic context, so it can't take the key
-	 * semaphore and thus 'secret' can change concurrently which would be a
-	 * data race.  But fscrypt_drop_inode() only need to know whether the
-	 * secret *was* present at the time of check, so READ_ONCE() suffices.
+	 * Whether this key is in the "present" state, i.e. fully usable.  For
+	 * details, see the fscrypt_master_key struct comment.
+	 *
+	 * Locking: protected by ->mk_sem, but can be read locklessly using
+	 * READ_ONCE().  Writers must use WRITE_ONCE() when concurrent readers
+	 * are possible.
 	 */
-	return READ_ONCE(secret->size) != 0;
-}
+	bool			mk_present;
+
+} __randomize_layout;
 
 static inline const char *master_key_spec_type(
 				const struct fscrypt_key_specifier *spec)
 {
 	switch (spec->type) {
 	case FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR:
 		return "descriptor";
 	case FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER:
 		return "identifier";
 	}
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 85d2975b69b78..52504dd478d31 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -180,21 +180,21 @@ int fscrypt_prepare_setflags(struct inode *inode,
 	 */
 	if (IS_ENCRYPTED(inode) && (flags & ~oldflags & FS_CASEFOLD_FL)) {
 		err = fscrypt_require_key(inode);
 		if (err)
 			return err;
 		ci = inode->i_crypt_info;
 		if (ci->ci_policy.version != FSCRYPT_POLICY_V2)
 			return -EINVAL;
 		mk = ci->ci_master_key;
 		down_read(&mk->mk_sem);
-		if (is_master_key_secret_present(&mk->mk_secret))
+		if (mk->mk_present)
 			err = fscrypt_derive_dirhash_key(ci, mk);
 		else
 			err = -ENOKEY;
 		up_read(&mk->mk_sem);
 		return err;
 	}
 	return 0;
 }
 
 /**
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index a51fa6a33de10..f34a9b0b9e922 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -92,42 +92,54 @@ void fscrypt_put_master_key_activeref(struct super_block *sb,
 	 * destroying any subkeys embedded in it.
 	 */
 
 	if (WARN_ON_ONCE(!sb->s_master_keys))
 		return;
 	spin_lock(&sb->s_master_keys->lock);
 	hlist_del_rcu(&mk->mk_node);
 	spin_unlock(&sb->s_master_keys->lock);
 
 	/*
-	 * ->mk_active_refs == 0 implies that ->mk_secret is not present and
-	 * that ->mk_decrypted_inodes is empty.
+	 * ->mk_active_refs == 0 implies that ->mk_present is false and
+	 * ->mk_decrypted_inodes is empty.
 	 */
-	WARN_ON_ONCE(is_master_key_secret_present(&mk->mk_secret));
+	WARN_ON_ONCE(mk->mk_present);
 	WARN_ON_ONCE(!list_empty(&mk->mk_decrypted_inodes));
 
 	for (i = 0; i <= FSCRYPT_MODE_MAX; i++) {
 		fscrypt_destroy_prepared_key(
 				sb, &mk->mk_direct_keys[i]);
 		fscrypt_destroy_prepared_key(
 				sb, &mk->mk_iv_ino_lblk_64_keys[i]);
 		fscrypt_destroy_prepared_key(
 				sb, &mk->mk_iv_ino_lblk_32_keys[i]);
 	}
 	memzero_explicit(&mk->mk_ino_hash_key,
 			 sizeof(mk->mk_ino_hash_key));
 	mk->mk_ino_hash_key_initialized = false;
 
 	/* Drop the structural ref associated with the active refs. */
 	fscrypt_put_master_key(mk);
 }
 
+/*
+ * This transitions the key state from present to incompletely removed, and then
+ * potentially to absent (depending on whether inodes remain).
+ */
+static void fscrypt_initiate_key_removal(struct super_block *sb,
+					 struct fscrypt_master_key *mk)
+{
+	WRITE_ONCE(mk->mk_present, false);
+	wipe_master_key_secret(&mk->mk_secret);
+	fscrypt_put_master_key_activeref(sb, mk);
+}
+
 static inline bool valid_key_spec(const struct fscrypt_key_specifier *spec)
 {
 	if (spec->__reserved)
 		return false;
 	return master_key_spec_len(spec) != 0;
 }
 
 static int fscrypt_user_key_instantiate(struct key *key,
 					struct key_preparsed_payload *prep)
 {
@@ -227,28 +239,27 @@ void fscrypt_destroy_keyring(struct super_block *sb)
 		struct hlist_head *bucket = &keyring->key_hashtable[i];
 		struct fscrypt_master_key *mk;
 		struct hlist_node *tmp;
 
 		hlist_for_each_entry_safe(mk, tmp, bucket, mk_node) {
 			/*
 			 * Since all potentially-encrypted inodes were already
 			 * evicted, every key remaining in the keyring should
 			 * have an empty inode list, and should only still be in
 			 * the keyring due to the single active ref associated
-			 * with ->mk_secret.  There should be no structural refs
-			 * beyond the one associated with the active ref.
+			 * with ->mk_present.  There should be no structural
+			 * refs beyond the one associated with the active ref.
 			 */
 			WARN_ON_ONCE(refcount_read(&mk->mk_active_refs) != 1);
 			WARN_ON_ONCE(refcount_read(&mk->mk_struct_refs) != 1);
-			WARN_ON_ONCE(!is_master_key_secret_present(&mk->mk_secret));
-			wipe_master_key_secret(&mk->mk_secret);
-			fscrypt_put_master_key_activeref(sb, mk);
+			WARN_ON_ONCE(!mk->mk_present);
+			fscrypt_initiate_key_removal(sb, mk);
 		}
 	}
 	kfree_sensitive(keyring);
 	sb->s_master_keys = NULL;
 }
 
 static struct hlist_head *
 fscrypt_mk_hash_bucket(struct fscrypt_keyring *keyring,
 		       const struct fscrypt_key_specifier *mk_spec)
 {
@@ -432,21 +443,22 @@ static int add_new_master_key(struct super_block *sb,
 	if (mk_spec->type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER) {
 		err = allocate_master_key_users_keyring(mk);
 		if (err)
 			goto out_put;
 		err = add_master_key_user(mk);
 		if (err)
 			goto out_put;
 	}
 
 	move_master_key_secret(&mk->mk_secret, secret);
-	refcount_set(&mk->mk_active_refs, 1); /* ->mk_secret is present */
+	mk->mk_present = true;
+	refcount_set(&mk->mk_active_refs, 1); /* ->mk_present is true */
 
 	spin_lock(&keyring->lock);
 	hlist_add_head_rcu(&mk->mk_node,
 			   fscrypt_mk_hash_bucket(keyring, mk_spec));
 	spin_unlock(&keyring->lock);
 	return 0;
 
 out_put:
 	fscrypt_put_master_key(mk);
 	return err;
@@ -471,25 +483,32 @@ static int add_existing_master_key(struct fscrypt_master_key *mk,
 			if (IS_ERR(mk_user))
 				return PTR_ERR(mk_user);
 			key_put(mk_user);
 			return 0;
 		}
 		err = add_master_key_user(mk);
 		if (err)
 			return err;
 	}
 
-	/* Re-add the secret if needed. */
-	if (!is_master_key_secret_present(&mk->mk_secret)) {
-		if (!refcount_inc_not_zero(&mk->mk_active_refs))
+	/* If the key is incompletely removed, make it present again. */
+	if (!mk->mk_present) {
+		if (!refcount_inc_not_zero(&mk->mk_active_refs)) {
+			/*
+			 * Raced with the last active ref being dropped, so the
+			 * key has become, or is about to become, "absent".
+			 * Therefore, we need to allocate a new key struct.
+			 */
 			return KEY_DEAD;
+		}
 		move_master_key_secret(&mk->mk_secret, secret);
+		WRITE_ONCE(mk->mk_present, true);
 	}
 
 	return 0;
 }
 
 static int do_add_master_key(struct super_block *sb,
 			     struct fscrypt_master_key_secret *secret,
 			     const struct fscrypt_key_specifier *mk_spec)
 {
 	static DEFINE_MUTEX(fscrypt_add_key_mutex);
@@ -499,22 +518,22 @@ static int do_add_master_key(struct super_block *sb,
 	mutex_lock(&fscrypt_add_key_mutex); /* serialize find + link */
 
 	mk = fscrypt_find_master_key(sb, mk_spec);
 	if (!mk) {
 		/* Didn't find the key in ->s_master_keys.  Add it. */
 		err = allocate_filesystem_keyring(sb);
 		if (!err)
 			err = add_new_master_key(sb, secret, mk_spec);
 	} else {
 		/*
-		 * Found the key in ->s_master_keys.  Re-add the secret if
-		 * needed, and add the user to ->mk_users if needed.
+		 * Found the key in ->s_master_keys.  Add the user to ->mk_users
+		 * if needed, and make the key "present" again if possible.
 		 */
 		down_write(&mk->mk_sem);
 		err = add_existing_master_key(mk, secret);
 		up_write(&mk->mk_sem);
 		if (err == KEY_DEAD) {
 			/*
 			 * We found a key struct, but it's already been fully
 			 * removed.  Ignore the old struct and add a new one.
 			 * fscrypt_add_key_mutex means we don't need to worry
 			 * about concurrent adds.
@@ -982,23 +1001,22 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
  * claim to the key, then removes the key itself if no other users have claims.
  * FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS (all_users=true) always removes the
  * key itself.
  *
  * To "remove the key itself", first we wipe the actual master key secret, so
  * that no more inodes can be unlocked with it.  Then we try to evict all cached
  * inodes that had been unlocked with the key.
  *
  * If all inodes were evicted, then we unlink the fscrypt_master_key from the
  * keyring.  Otherwise it remains in the keyring in the "incompletely removed"
- * state (without the actual secret key) where it tracks the list of remaining
- * inodes.  Userspace can execute the ioctl again later to retry eviction, or
- * alternatively can re-add the secret key again.
+ * state where it tracks the list of remaining inodes.  Userspace can execute
+ * the ioctl again later to retry eviction, or alternatively can re-add the key.
  *
  * For more details, see the "Removing keys" section of
  * Documentation/filesystems/fscrypt.rst.
  */
 static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
 {
 	struct super_block *sb = file_inode(filp)->i_sb;
 	struct fscrypt_remove_key_arg __user *uarg = _uarg;
 	struct fscrypt_remove_key_arg arg;
 	struct fscrypt_master_key *mk;
@@ -1046,44 +1064,43 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
 			 * can't remove the key itself.
 			 */
 			status_flags |=
 				FSCRYPT_KEY_REMOVAL_STATUS_FLAG_OTHER_USERS;
 			err = 0;
 			up_write(&mk->mk_sem);
 			goto out_put_key;
 		}
 	}
 
-	/* No user claims remaining.  Go ahead and wipe the secret. */
+	/* No user claims remaining.  Initiate removal of the key. */
 	err = -ENOKEY;
-	if (is_master_key_secret_present(&mk->mk_secret)) {
-		wipe_master_key_secret(&mk->mk_secret);
-		fscrypt_put_master_key_activeref(sb, mk);
+	if (mk->mk_present) {
+		fscrypt_initiate_key_removal(sb, mk);
 		err = 0;
 	}
 	inodes_remain = refcount_read(&mk->mk_active_refs) > 0;
 	up_write(&mk->mk_sem);
 
 	if (inodes_remain) {
 		/* Some inodes still reference this key; try to evict them. */
 		err = try_to_lock_encrypted_files(sb, mk);
 		if (err == -EBUSY) {
 			status_flags |=
 				FSCRYPT_KEY_REMOVAL_STATUS_FLAG_FILES_BUSY;
 			err = 0;
 		}
 	}
 	/*
 	 * We return 0 if we successfully did something: removed a claim to the
-	 * key, wiped the secret, or tried locking the files again.  Users need
-	 * to check the informational status flags if they care whether the key
-	 * has been fully removed including all files locked.
+	 * key, initiated removal of the key, or tried locking the files again.
+	 * Users need to check the informational status flags if they care
+	 * whether the key has been fully removed including all files locked.
 	 */
 out_put_key:
 	fscrypt_put_master_key(mk);
 	if (err == 0)
 		err = put_user(status_flags, &uarg->removal_status_flags);
 	return err;
 }
 
 int fscrypt_ioctl_remove_key(struct file *filp, void __user *uarg)
 {
@@ -1096,26 +1113,25 @@ int fscrypt_ioctl_remove_key_all_users(struct file *filp, void __user *uarg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 	return do_remove_key(filp, uarg, true);
 }
 EXPORT_SYMBOL_GPL(fscrypt_ioctl_remove_key_all_users);
 
 /*
  * Retrieve the status of an fscrypt master encryption key.
  *
  * We set ->status to indicate whether the key is absent, present, or
- * incompletely removed.  "Incompletely removed" means that the master key
- * secret has been removed, but some files which had been unlocked with it are
- * still in use.  This field allows applications to easily determine the state
- * of an encrypted directory without using a hack such as trying to open a
- * regular file in it (which can confuse the "incompletely removed" state with
- * absent or present).
+ * incompletely removed.  (For an explanation of what these statuses mean and
+ * how they are represented internally, see struct fscrypt_master_key.)  This
+ * field allows applications to easily determine the status of an encrypted
+ * directory without using a hack such as trying to open a regular file in it
+ * (which can confuse the "incompletely removed" status with absent or present).
  *
  * In addition, for v2 policy keys we allow applications to determine, via
  * ->status_flags and ->user_count, whether the key has been added by the
  * current user, by other users, or by both.  Most applications should not need
  * this, since ordinarily only one user should know a given key.  However, if a
  * secret key is shared by multiple users, applications may wish to add an
  * already-present key to prevent other users from removing it.  This ioctl can
  * be used to check whether that really is the case before the work is done to
  * add the key --- which might e.g. require prompting the user for a passphrase.
  *
@@ -1143,21 +1159,21 @@ int fscrypt_ioctl_get_key_status(struct file *filp, void __user *uarg)
 	memset(arg.__out_reserved, 0, sizeof(arg.__out_reserved));
 
 	mk = fscrypt_find_master_key(sb, &arg.key_spec);
 	if (!mk) {
 		arg.status = FSCRYPT_KEY_STATUS_ABSENT;
 		err = 0;
 		goto out;
 	}
 	down_read(&mk->mk_sem);
 
-	if (!is_master_key_secret_present(&mk->mk_secret)) {
+	if (!mk->mk_present) {
 		arg.status = refcount_read(&mk->mk_active_refs) > 0 ?
 			FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED :
 			FSCRYPT_KEY_STATUS_ABSENT /* raced with full removal */;
 		err = 0;
 		goto out_release_key;
 	}
 
 	arg.status = FSCRYPT_KEY_STATUS_PRESENT;
 	if (mk->mk_users) {
 		struct key *mk_user;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 094d1b7a1ae61..d71f7c799e79e 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -479,22 +479,22 @@ static int setup_file_encryption_key(struct fscrypt_inode_info *ci,
 		/*
 		 * As a legacy fallback for v1 policies, search for the key in
 		 * the current task's subscribed keyrings too.  Don't move this
 		 * to before the search of ->s_master_keys, since users
 		 * shouldn't be able to override filesystem-level keys.
 		 */
 		return fscrypt_setup_v1_file_key_via_subscribed_keyrings(ci);
 	}
 	down_read(&mk->mk_sem);
 
-	/* Has the secret been removed (via FS_IOC_REMOVE_ENCRYPTION_KEY)? */
-	if (!is_master_key_secret_present(&mk->mk_secret)) {
+	if (!mk->mk_present) {
+		/* FS_IOC_REMOVE_ENCRYPTION_KEY has been executed on this key */
 		err = -ENOKEY;
 		goto out_release_key;
 	}
 
 	if (!fscrypt_valid_master_key_size(mk, ci)) {
 		err = -ENOKEY;
 		goto out_release_key;
 	}
 
 	switch (ci->ci_policy.version) {
@@ -532,22 +532,22 @@ static void put_crypt_info(struct fscrypt_inode_info *ci)
 		fscrypt_put_direct_key(ci->ci_direct_key);
 	else if (ci->ci_owns_key)
 		fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
 					     &ci->ci_enc_key);
 
 	mk = ci->ci_master_key;
 	if (mk) {
 		/*
 		 * Remove this inode from the list of inodes that were unlocked
 		 * with the master key.  In addition, if we're removing the last
-		 * inode from a master key struct that already had its secret
-		 * removed, then complete the full removal of the struct.
+		 * inode from an incompletely removed key, then complete the
+		 * full removal of the key.
 		 */
 		spin_lock(&mk->mk_decrypted_inodes_lock);
 		list_del(&ci->ci_master_key_link);
 		spin_unlock(&mk->mk_decrypted_inodes_lock);
 		fscrypt_put_master_key_activeref(ci->ci_inode->i_sb, mk);
 	}
 	memzero_explicit(ci, sizeof(*ci));
 	kmem_cache_free(fscrypt_inode_info_cachep, ci);
 }
 
@@ -794,20 +794,21 @@ int fscrypt_drop_inode(struct inode *inode)
 	/*
 	 * With proper, non-racy use of FS_IOC_REMOVE_ENCRYPTION_KEY, all inodes
 	 * protected by the key were cleaned by sync_filesystem().  But if
 	 * userspace is still using the files, inodes can be dirtied between
 	 * then and now.  We mustn't lose any writes, so skip dirty inodes here.
 	 */
 	if (inode->i_state & I_DIRTY_ALL)
 		return 0;
 
 	/*
-	 * Note: since we aren't holding the key semaphore, the result here can
+	 * We can't take ->mk_sem here, since this runs in atomic context.
+	 * Therefore, ->mk_present can change concurrently, and our result may
 	 * immediately become outdated.  But there's no correctness problem with
 	 * unnecessarily evicting.  Nor is there a correctness problem with not
 	 * evicting while iput() is racing with the key being removed, since
 	 * then the thread removing the key will either evict the inode itself
 	 * or will correctly detect that it wasn't evicted due to the race.
 	 */
-	return !is_master_key_secret_present(&ci->ci_master_key->mk_secret);
+	return !READ_ONCE(ci->ci_master_key->mk_present);
 }
 EXPORT_SYMBOL_GPL(fscrypt_drop_inode);

base-commit: 3e7807d5a7d770c59837026e9967fe99ad043174
-- 
2.42.0

