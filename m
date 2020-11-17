Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C472B57DE
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Nov 2020 04:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKQD1o (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 22:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgKQD1n (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 22:27:43 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47F222469D;
        Tue, 17 Nov 2020 03:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605583662;
        bh=9CwJn8QpyI+D4Gz7jxAZUUcOSO+EMLP20wnVdlB9sy8=;
        h=From:To:Cc:Subject:Date:From;
        b=un4bj2jGvlut+tTTMr0qk+xT8Tw7f9VhIYbcQlYLBhsOAGQiJJQj0umgZWYmpehZC
         Rkhce4A40lU1Hl+gF1GeghWAXLoo175rJLSi7m5PtnXWXkzmp4VCW8ToQR7EWaUv16
         0FifMmt7+NzSyCj04RyCyiDP/ssQ6gqoXsv/twt8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH] fscrypt: simplify master key locking
Date:   Mon, 16 Nov 2020 19:26:26 -0800
Message-Id: <20201117032626.320275-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The stated reasons for separating fscrypt_master_key::mk_secret_sem from
the standard semaphore contained in every 'struct key' no longer apply.

First, due to commit a992b20cd4ee ("fscrypt: add
fscrypt_prepare_new_inode() and fscrypt_set_context()"),
fscrypt_get_encryption_info() is no longer called from within a
filesystem transaction.

Second, due to commit d3ec10aa9581 ("KEYS: Don't write out to userspace
while holding key semaphore"), the semaphore for the "keyring" key type
no longer ranks above page faults.

That leaves performance as the only possible reason to keep the separate
mk_secret_sem.  Specifically, having mk_secret_sem reduces the
contention between setup_file_encryption_key() and
FS_IOC_{ADD,REMOVE}_ENCRYPTION_KEY.  However, these ioctls aren't
executed often, so this doesn't seem to be worth the extra complexity.

Therefore, simplify the locking design by just using key->sem instead of
mk_secret_sem.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 19 ++++++-------------
 fs/crypto/hooks.c           |  8 +++++---
 fs/crypto/keyring.c         |  8 +-------
 fs/crypto/keysetup.c        | 20 +++++++++-----------
 4 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 322ecae9a758..a61d4dbf0a0b 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -439,16 +439,9 @@ struct fscrypt_master_key {
 	 * FS_IOC_REMOVE_ENCRYPTION_KEY can be retried, or
 	 * FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
 	 *
-	 * Locking: protected by key->sem (outer) and mk_secret_sem (inner).
-	 * The reason for two locks is that key->sem also protects modifying
-	 * mk_users, which ranks it above the semaphore for the keyring key
-	 * type, which is in turn above page faults (via keyring_read).  But
-	 * sometimes filesystems call fscrypt_get_encryption_info() from within
-	 * a transaction, which ranks it below page faults.  So we need a
-	 * separate lock which protects mk_secret but not also mk_users.
+	 * Locking: protected by this master key's key->sem.
 	 */
 	struct fscrypt_master_key_secret	mk_secret;
-	struct rw_semaphore			mk_secret_sem;
 
 	/*
 	 * For v1 policy keys: an arbitrary key descriptor which was assigned by
@@ -467,8 +460,8 @@ struct fscrypt_master_key {
 	 *
 	 * This is NULL for v1 policy keys; those can only be added by root.
 	 *
-	 * Locking: in addition to this keyrings own semaphore, this is
-	 * protected by the master key's key->sem, so we can do atomic
+	 * Locking: in addition to this keyring's own semaphore, this is
+	 * protected by this master key's key->sem, so we can do atomic
 	 * search+insert.  It can also be searched without taking any locks, but
 	 * in that case the returned key may have already been removed.
 	 */
@@ -510,9 +503,9 @@ is_master_key_secret_present(const struct fscrypt_master_key_secret *secret)
 	/*
 	 * The READ_ONCE() is only necessary for fscrypt_drop_inode() and
 	 * fscrypt_key_describe().  These run in atomic context, so they can't
-	 * take ->mk_secret_sem and thus 'secret' can change concurrently which
-	 * would be a data race.  But they only need to know whether the secret
-	 * *was* present at the time of check, so READ_ONCE() suffices.
+	 * take the key semaphore and thus 'secret' can change concurrently
+	 * which would be a data race.  But they only need to know whether the
+	 * secret *was* present at the time of check, so READ_ONCE() suffices.
 	 */
 	return READ_ONCE(secret->size) != 0;
 }
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 20b0df47fe6a..282dfe52ac99 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -138,6 +138,7 @@ int fscrypt_prepare_setflags(struct inode *inode,
 			     unsigned int oldflags, unsigned int flags)
 {
 	struct fscrypt_info *ci;
+	struct key *key;
 	struct fscrypt_master_key *mk;
 	int err;
 
@@ -153,13 +154,14 @@ int fscrypt_prepare_setflags(struct inode *inode,
 		ci = inode->i_crypt_info;
 		if (ci->ci_policy.version != FSCRYPT_POLICY_V2)
 			return -EINVAL;
-		mk = ci->ci_master_key->payload.data[0];
-		down_read(&mk->mk_secret_sem);
+		key = ci->ci_master_key;
+		mk = key->payload.data[0];
+		down_read(&key->sem);
 		if (is_master_key_secret_present(&mk->mk_secret))
 			err = fscrypt_derive_dirhash_key(ci, mk);
 		else
 			err = -ENOKEY;
-		up_read(&mk->mk_secret_sem);
+		up_read(&key->sem);
 		return err;
 	}
 	return 0;
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index d7ec52cb3d9a..0b3ffbb4faf4 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -347,7 +347,6 @@ static int add_new_master_key(struct fscrypt_master_key_secret *secret,
 	mk->mk_spec = *mk_spec;
 
 	move_master_key_secret(&mk->mk_secret, secret);
-	init_rwsem(&mk->mk_secret_sem);
 
 	refcount_set(&mk->mk_refcount, 1); /* secret is present */
 	INIT_LIST_HEAD(&mk->mk_decrypted_inodes);
@@ -427,11 +426,8 @@ static int add_existing_master_key(struct fscrypt_master_key *mk,
 	}
 
 	/* Re-add the secret if needed. */
-	if (rekey) {
-		down_write(&mk->mk_secret_sem);
+	if (rekey)
 		move_master_key_secret(&mk->mk_secret, secret);
-		up_write(&mk->mk_secret_sem);
-	}
 	return 0;
 }
 
@@ -975,10 +971,8 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
 	/* No user claims remaining.  Go ahead and wipe the secret. */
 	dead = false;
 	if (is_master_key_secret_present(&mk->mk_secret)) {
-		down_write(&mk->mk_secret_sem);
 		wipe_master_key_secret(&mk->mk_secret);
 		dead = refcount_dec_and_test(&mk->mk_refcount);
-		up_write(&mk->mk_secret_sem);
 	}
 	up_write(&key->sem);
 	if (dead) {
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 31fb08d94f87..50675b42d5b7 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -337,11 +337,11 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
  * Find the master key, then set up the inode's actual encryption key.
  *
  * If the master key is found in the filesystem-level keyring, then the
- * corresponding 'struct key' is returned in *master_key_ret with
- * ->mk_secret_sem read-locked.  This is needed to ensure that only one task
- * links the fscrypt_info into ->mk_decrypted_inodes (as multiple tasks may race
- * to create an fscrypt_info for the same inode), and to synchronize the master
- * key being removed with a new inode starting to use it.
+ * corresponding 'struct key' is returned in *master_key_ret with its semaphore
+ * read-locked.  This is needed to ensure that only one task links the
+ * fscrypt_info into ->mk_decrypted_inodes (as multiple tasks may race to create
+ * an fscrypt_info for the same inode), and to synchronize the master key being
+ * removed with a new inode starting to use it.
  */
 static int setup_file_encryption_key(struct fscrypt_info *ci,
 				     bool need_dirhash_key,
@@ -390,7 +390,7 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 	}
 
 	mk = key->payload.data[0];
-	down_read(&mk->mk_secret_sem);
+	down_read(&key->sem);
 
 	/* Has the secret been removed (via FS_IOC_REMOVE_ENCRYPTION_KEY)? */
 	if (!is_master_key_secret_present(&mk->mk_secret)) {
@@ -433,7 +433,7 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 	return 0;
 
 out_release_key:
-	up_read(&mk->mk_secret_sem);
+	up_read(&key->sem);
 	key_put(key);
 	return err;
 }
@@ -536,9 +536,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	res = 0;
 out:
 	if (master_key) {
-		struct fscrypt_master_key *mk = master_key->payload.data[0];
-
-		up_read(&mk->mk_secret_sem);
+		up_read(&master_key->sem);
 		key_put(master_key);
 	}
 	put_crypt_info(crypt_info);
@@ -712,7 +710,7 @@ int fscrypt_drop_inode(struct inode *inode)
 		return 0;
 
 	/*
-	 * Note: since we aren't holding ->mk_secret_sem, the result here can
+	 * Note: since we aren't holding the key semaphore, the result here can
 	 * immediately become outdated.  But there's no correctness problem with
 	 * unnecessarily evicting.  Nor is there a correctness problem with not
 	 * evicting while iput() is racing with the key being removed, since

base-commit: 3ceb6543e9cf6ed87cc1fbc6f23ca2db903564cd
-- 
2.29.2

