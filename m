Return-Path: <linux-fscrypt+bounces-1644-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id qUNIIYRvNGpTYAYAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1644-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Jun 2026 00:21:56 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8AEC6A2EC8
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Jun 2026 00:21:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z4KKxsOM;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1644-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1644-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3CE91302ED79
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Jun 2026 22:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFAF340A47;
	Thu, 18 Jun 2026 22:21:53 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1510531F9AA;
	Thu, 18 Jun 2026 22:21:51 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781821313; cv=none; b=jg6qxUg6oJZHdmhtPgFscvOG4SCfLzRMmAK5do7IeqcnSqeXqeBojjz4UTdh3XQt23LTJ8r8dGFEKblrAZOq5xasRjtLsmvJgKGuNjueA8TwUC1KvYHDruB+i0hsqFishqyKnGmXJJZ/Kmxo5KAWmOy/7jt765q6S+/GaM7Grlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781821313; c=relaxed/simple;
	bh=AgxHtsmvGo4EVDkI4Gs1WI8OWFulBrNfn5HVAWoYBRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CYUC+WSRPWZj6DBBk7MeBcdX5v1pKkW3gotPl/QjX8GIQqNPNR0PrN71dwUIN8T5JWqzskyRe20MlPLxuFV0uJnhZETzf2h45va+tuus6kUfyzy4Wo0QScP3Rh3Ta+6vAcQOH+kQBE4mFenhiTDEk9o9vKYde/UDohWamqzImqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4KKxsOM; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550E21F000E9;
	Thu, 18 Jun 2026 22:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781821311;
	bh=QWVtX7CJ07xpJ1fsGWAdUQSB4ZlOweuJEKlmVX6ibqI=;
	h=From:To:Cc:Subject:Date;
	b=Z4KKxsOMBd4goAeFfIZDp25xkl7A5kNUfOUMv63YQSRwUcp7NbThCvNFuOjOI2vjR
	 N/THlnJF5n98seKSOb29ZZMtxSPx4oiMZZqmGMLzAAnA00559YyKuy26WotcriordM
	 AzrlDECpBtTXpKf1epMj7aMU+9/UWAax2ywB6xCo+78Q/3/HhZQ2IeqXdY2w6MI5jU
	 rBBPse8pF7Nbdnn1biPkCcl3SW8i4IzW7jlA7KwozYRrTsRWNvmY6K1BAz7DajGuTG
	 pZqP+s9r1s1SKd5E8eNv7WxbKKY3xbc/l79XV39h/Z81O1zDG64Tb/7ffR4cfgBk1E
	 SXOYv61AR0NOg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Luis Henriques <luis@igalia.com>,
	linux-fsdevel@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] fscrypt: Replace mk_users keyring with simple list
Date: Thu, 18 Jun 2026 15:19:21 -0700
Message-ID: <20260618221921.87896-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1644-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:tytso@mit.edu,m:jaegeuk@kernel.org,m:jarkko@kernel.org,m:luis@igalia.com,m:linux-fsdevel@vger.kernel.org,m:keyrings@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:ebiggers@kernel.org,m:syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com,m:med08elkadiri@gmail.com,m:stable@vger.kernel.org,m:syzbot@syzkaller.appspotmail.com,s:lists@lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,kernel.org,igalia.com,vger.kernel.org,syzkaller.appspotmail.com,gmail.com];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt,f55b043dacf43776b50c];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,syzkaller.appspot.com:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C8AEC6A2EC8

Change mk_users (the set of user claims to an fscrypt master key) from a
'struct key' keyring to a simple linked list.

It's still a collection of 'struct key' for quota tracking.  It was
originally thought to be natural that a collection of 'struct key'
should be held in a 'struct key' keyring.  In reality, it's just been
causing problems, similar to how using 'struct key' for the filesystem
keyring caused problems and was removed in commit d7e7b9af104c
("fscrypt: stop using keyrings subsystem for fscrypt_master_key").

Commit d3a7bd420076 ("fscrypt: clear keyring before calling key_put()")
fixed mk_users cleanup to be synchronous.  But that apparently wasn't
enough: the keyring subsystem's redundant locking is still generating
lockdep false positives due to the interaction with filesystem reclaim.

With the simple list, the redundant locking and lockdep issue goes away.

Of course, searching a linked list is linear-time whereas the
'struct key' keyring used a fancy constant-time associative array.  But
that's fine here, since in practice there's just one entry in the list.
In fact the new code is much faster in practice, since it's much smaller
and doesn't have to convert the kuid_t into a string to search for it.

Reported-by: syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f55b043dacf43776b50c
Reported-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Closes: https://lore.kernel.org/keyrings/20260614150041.21172-1-med08elkadiri@gmail.com/
Fixes: 23c688b54016 ("fscrypt: allow unprivileged users to add/remove keys for v2 policies")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

I'm planning to take this via the fscrypt tree for 7.2

 fs/crypto/fscrypt_private.h |  32 ++++--
 fs/crypto/keyring.c         | 216 +++++++++++++++---------------------
 2 files changed, 113 insertions(+), 135 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 4263cac24b32..0053b5c45412 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -494,10 +494,23 @@ fscrypt_is_key_prepared(const struct fscrypt_prepared_key *prep_key,
 }
 #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 /* keyring.c */
 
+/*
+ * fscrypt_master_key_user - a user's claim to a master key
+ */
+struct fscrypt_master_key_user {
+	struct list_head link;
+	kuid_t uid;
+	/*
+	 * This 'struct key' contains no secret.  It exists solely to charge the
+	 * appropriate user's key quota.
+	 */
+	struct key *quota_key;
+};
+
 /*
  * fscrypt_master_key_secret - secret key material of an in-use master key
  */
 struct fscrypt_master_key_secret {
 
@@ -609,23 +622,22 @@ struct fscrypt_master_key {
 	 * For v2 policy keys: a cryptographic hash of this key (->identifier).
 	 */
 	struct fscrypt_key_specifier		mk_spec;
 
 	/*
-	 * Keyring which contains a key of type 'key_type_fscrypt_user' for each
-	 * user who has added this key.  Normally each key will be added by just
-	 * one user, but it's possible that multiple users share a key, and in
-	 * that case we need to keep track of those users so that one user can't
-	 * remove the key before the others want it removed too.
+	 * List of user claims to this key (struct fscrypt_master_key_user).
+	 * Normally each key will be added by just one user, but it's possible
+	 * that multiple users share a key, and in that case we need to keep
+	 * track of those users so that one user can't remove the key before the
+	 * others want it removed too.
 	 *
-	 * This is NULL for v1 policy keys; those can only be added by root.
+	 * Used only for v2 policy keys.  v1 policy keys can be added only by
+	 * root, so user tracking doesn't apply to them.
 	 *
-	 * Locking: protected by ->mk_sem.  (We don't just rely on the keyrings
-	 * subsystem semaphore ->mk_users->sem, as we need support for atomic
-	 * search+insert along with proper synchronization with other fields.)
+	 * Locking: protected by ->mk_sem.
 	 */
-	struct key		*mk_users;
+	struct list_head	mk_users;
 
 	/*
 	 * List of inodes that were unlocked using this key.  This allows the
 	 * inodes to be evicted efficiently if the key is removed.
 	 */
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 6ce6b436c34f..16bc348213ca 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -63,26 +63,23 @@ static void fscrypt_free_master_key(struct rcu_head *head)
 	 * Nevertheless, use kfree_sensitive() in case anything was missed.
 	 */
 	kfree_sensitive(mk);
 }
 
+static void clear_mk_users(struct fscrypt_master_key *mk);
+
 void fscrypt_put_master_key(struct fscrypt_master_key *mk)
 {
 	if (!refcount_dec_and_test(&mk->mk_struct_refs))
 		return;
 	/*
-	 * No structural references left, so free ->mk_users, and also free the
+	 * No structural references left, so clear ->mk_users, and also free the
 	 * fscrypt_master_key struct itself after an RCU grace period ensures
 	 * that concurrent keyring lookups can no longer find it.
 	 */
 	WARN_ON_ONCE(refcount_read(&mk->mk_active_refs) != 0);
-	if (mk->mk_users) {
-		/* Clear the keyring so the quota gets released right away. */
-		keyring_clear(mk->mk_users);
-		key_put(mk->mk_users);
-		mk->mk_users = NULL;
-	}
+	clear_mk_users(mk);
 	call_rcu(&mk->mk_rcu_head, fscrypt_free_master_key);
 }
 
 void fscrypt_put_master_key_activeref(struct super_block *sb,
 				      struct fscrypt_master_key *mk)
@@ -163,12 +160,12 @@ static void fscrypt_user_key_describe(const struct key *key, struct seq_file *m)
 {
 	seq_puts(m, key->description);
 }
 
 /*
- * Type of key in ->mk_users.  Each key of this type represents a particular
- * user who has added a particular master key.
+ * Type of fscrypt_master_key_user::quota_key.  This contains no secret; it
+ * exists solely to charge a user's key quota.
  *
  * Note that the name of this key type really should be something like
  * ".fscrypt-user" instead of simply ".fscrypt".  But the shorter name is chosen
  * mainly for simplicity of presentation in /proc/keys when read by a non-root
  * user.  And it is expected to be rare that a key is actually added by multiple
@@ -178,34 +175,13 @@ static struct key_type key_type_fscrypt_user = {
 	.name			= ".fscrypt",
 	.instantiate		= fscrypt_user_key_instantiate,
 	.describe		= fscrypt_user_key_describe,
 };
 
-#define FSCRYPT_MK_USERS_DESCRIPTION_SIZE	\
-	(CONST_STRLEN("fscrypt-") + 2 * FSCRYPT_KEY_IDENTIFIER_SIZE + \
-	 CONST_STRLEN("-users") + 1)
-
 #define FSCRYPT_MK_USER_DESCRIPTION_SIZE	\
 	(2 * FSCRYPT_KEY_IDENTIFIER_SIZE + CONST_STRLEN(".uid.") + 10 + 1)
 
-static void format_mk_users_keyring_description(
-			char description[FSCRYPT_MK_USERS_DESCRIPTION_SIZE],
-			const u8 mk_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
-{
-	sprintf(description, "fscrypt-%*phN-users",
-		FSCRYPT_KEY_IDENTIFIER_SIZE, mk_identifier);
-}
-
-static void format_mk_user_description(
-			char description[FSCRYPT_MK_USER_DESCRIPTION_SIZE],
-			const u8 mk_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
-{
-
-	sprintf(description, "%*phN.uid.%u", FSCRYPT_KEY_IDENTIFIER_SIZE,
-		mk_identifier, __kuid_val(current_fsuid()));
-}
-
 /* Create ->s_master_keys if needed.  Synchronized by fscrypt_add_key_mutex. */
 static int allocate_filesystem_keyring(struct super_block *sb)
 {
 	struct fscrypt_keyring *keyring;
 
@@ -336,95 +312,98 @@ fscrypt_find_master_key(struct super_block *sb,
 out:
 	rcu_read_unlock();
 	return mk;
 }
 
-static int allocate_master_key_users_keyring(struct fscrypt_master_key *mk)
-{
-	char description[FSCRYPT_MK_USERS_DESCRIPTION_SIZE];
-	struct key *keyring;
-
-	format_mk_users_keyring_description(description,
-					    mk->mk_spec.u.identifier);
-	keyring = keyring_alloc(description, GLOBAL_ROOT_UID, GLOBAL_ROOT_GID,
-				current_cred(), KEY_POS_SEARCH |
-				  KEY_USR_SEARCH | KEY_USR_READ | KEY_USR_VIEW,
-				KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
-	if (IS_ERR(keyring))
-		return PTR_ERR(keyring);
-
-	mk->mk_users = keyring;
-	return 0;
-}
-
-/*
- * Find the current user's "key" in the master key's ->mk_users.
- * Returns ERR_PTR(-ENOKEY) if not found.
- */
-static struct key *find_master_key_user(struct fscrypt_master_key *mk)
+/* Find the current user's claim in ->mk_users.  ->mk_sem must be held. */
+static struct fscrypt_master_key_user *
+find_master_key_user(struct fscrypt_master_key *mk)
 {
-	char description[FSCRYPT_MK_USER_DESCRIPTION_SIZE];
-	key_ref_t keyref;
+	struct fscrypt_master_key_user *mk_user;
+	kuid_t uid = current_fsuid();
 
-	format_mk_user_description(description, mk->mk_spec.u.identifier);
-
-	/*
-	 * We need to mark the keyring reference as "possessed" so that we
-	 * acquire permission to search it, via the KEY_POS_SEARCH permission.
-	 */
-	keyref = keyring_search(make_key_ref(mk->mk_users, true /*possessed*/),
-				&key_type_fscrypt_user, description, false);
-	if (IS_ERR(keyref)) {
-		if (PTR_ERR(keyref) == -EAGAIN || /* not found */
-		    PTR_ERR(keyref) == -EKEYREVOKED) /* recently invalidated */
-			keyref = ERR_PTR(-ENOKEY);
-		return ERR_CAST(keyref);
+	list_for_each_entry(mk_user, &mk->mk_users, link) {
+		if (uid_eq(mk_user->uid, uid))
+			return mk_user;
 	}
-	return key_ref_to_ptr(keyref);
+	return NULL;
 }
 
 /*
- * Give the current user a "key" in ->mk_users.  This charges the user's quota
+ * Give the current user a claim in ->mk_users.  This charges the user's quota
  * and marks the master key as added by the current user, so that it cannot be
  * removed by another user with the key.  Either ->mk_sem must be held for
  * write, or the master key must be still undergoing initialization.
  */
 static int add_master_key_user(struct fscrypt_master_key *mk)
 {
+	kuid_t uid = current_fsuid();
 	char description[FSCRYPT_MK_USER_DESCRIPTION_SIZE];
-	struct key *mk_user;
+	struct key *quota_key;
+	struct fscrypt_master_key_user *mk_user;
 	int err;
 
-	format_mk_user_description(description, mk->mk_spec.u.identifier);
-	mk_user = key_alloc(&key_type_fscrypt_user, description,
-			    current_fsuid(), current_gid(), current_cred(),
-			    KEY_POS_SEARCH | KEY_USR_VIEW, 0, NULL);
-	if (IS_ERR(mk_user))
-		return PTR_ERR(mk_user);
+	snprintf(description, sizeof(description), "%*phN.uid.%u",
+		 FSCRYPT_KEY_IDENTIFIER_SIZE, mk->mk_spec.u.identifier,
+		 __kuid_val(uid));
+	quota_key = key_alloc(&key_type_fscrypt_user, description, uid,
+			      current_gid(), current_cred(),
+			      KEY_POS_SEARCH | KEY_USR_VIEW, 0, NULL);
+	if (IS_ERR(quota_key))
+		return PTR_ERR(quota_key);
+
+	err = key_instantiate_and_link(quota_key, NULL, 0, NULL, NULL);
+	if (err) {
+		key_put(quota_key);
+		return err;
+	}
 
-	err = key_instantiate_and_link(mk_user, NULL, 0, mk->mk_users, NULL);
-	key_put(mk_user);
-	return err;
+	mk_user = kzalloc_obj(*mk_user);
+	if (!mk_user) {
+		key_put(quota_key);
+		return -ENOMEM;
+	}
+	mk_user->uid = uid;
+	mk_user->quota_key = quota_key;
+	list_add(&mk_user->link, &mk->mk_users);
+	return 0;
+}
+
+static void unlink_and_free_mk_user(struct fscrypt_master_key_user *mk_user)
+{
+	list_del(&mk_user->link);
+	key_put(mk_user->quota_key);
+	kfree(mk_user);
 }
 
 /*
- * Remove the current user's "key" from ->mk_users.
+ * Remove the current user's claim from ->mk_users.
  * ->mk_sem must be held for write.
  *
- * Returns 0 if removed, -ENOKEY if not found, or another -errno code.
+ * Returns 0 if removed or -ENOKEY if not found.
  */
 static int remove_master_key_user(struct fscrypt_master_key *mk)
 {
-	struct key *mk_user;
-	int err;
+	struct fscrypt_master_key_user *mk_user;
 
 	mk_user = find_master_key_user(mk);
-	if (IS_ERR(mk_user))
-		return PTR_ERR(mk_user);
-	err = key_unlink(mk->mk_users, mk_user);
-	key_put(mk_user);
-	return err;
+	if (!mk_user)
+		return -ENOKEY;
+	unlink_and_free_mk_user(mk_user);
+	return 0;
+}
+
+/*
+ * Clear ->mk_users.  Either ->mk_sem must be held for write, or 'mk' must have
+ * no structural references left.
+ */
+static void clear_mk_users(struct fscrypt_master_key *mk)
+{
+	struct fscrypt_master_key_user *mk_user, *tmp;
+
+	list_for_each_entry_safe(mk_user, tmp, &mk->mk_users, link)
+		unlink_and_free_mk_user(mk_user);
 }
 
 /*
  * Allocate a new fscrypt_master_key, transfer the given secret over to it, and
  * insert it into sb->s_master_keys.
@@ -443,19 +422,18 @@ static int add_new_master_key(struct super_block *sb,
 
 	init_rwsem(&mk->mk_sem);
 	refcount_set(&mk->mk_struct_refs, 1);
 	mk->mk_spec = *mk_spec;
 
+	INIT_LIST_HEAD(&mk->mk_users);
+
 	INIT_LIST_HEAD(&mk->mk_decrypted_inodes);
 	spin_lock_init(&mk->mk_decrypted_inodes_lock);
 
 	INIT_LIST_HEAD(&mk->mk_mode_keys);
 
 	if (mk_spec->type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER) {
-		err = allocate_master_key_users_keyring(mk);
-		if (err)
-			goto out_put;
 		err = add_master_key_user(mk);
 		if (err)
 			goto out_put;
 	}
 
@@ -480,23 +458,17 @@ static int add_existing_master_key(struct fscrypt_master_key *mk,
 				   struct fscrypt_master_key_secret *secret)
 {
 	int err;
 
 	/*
-	 * If the current user is already in ->mk_users, then there's nothing to
-	 * do.  Otherwise, we need to add the user to ->mk_users.  (Neither is
-	 * applicable for v1 policy keys, which have NULL ->mk_users.)
+	 * For v2 policy keys (FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER): If the current
+	 * user is already in ->mk_users, then there's nothing to do.
+	 * Otherwise, add the user to ->mk_users.
 	 */
-	if (mk->mk_users) {
-		struct key *mk_user = find_master_key_user(mk);
-
-		if (mk_user != ERR_PTR(-ENOKEY)) {
-			if (IS_ERR(mk_user))
-				return PTR_ERR(mk_user);
-			key_put(mk_user);
+	if (mk->mk_spec.type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER) {
+		if (find_master_key_user(mk) != NULL)
 			return 0;
-		}
 		err = add_master_key_user(mk);
 		if (err)
 			return err;
 	}
 
@@ -890,11 +862,10 @@ int fscrypt_add_test_dummy_key(struct super_block *sb,
 int fscrypt_verify_key_added(struct super_block *sb,
 			     const u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
 {
 	struct fscrypt_key_specifier mk_spec;
 	struct fscrypt_master_key *mk;
-	struct key *mk_user;
 	int err;
 
 	mk_spec.type = FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER;
 	memcpy(mk_spec.u.identifier, identifier, FSCRYPT_KEY_IDENTIFIER_SIZE);
 
@@ -902,17 +873,14 @@ int fscrypt_verify_key_added(struct super_block *sb,
 	if (!mk) {
 		err = -ENOKEY;
 		goto out;
 	}
 	down_read(&mk->mk_sem);
-	mk_user = find_master_key_user(mk);
-	if (IS_ERR(mk_user)) {
-		err = PTR_ERR(mk_user);
-	} else {
-		key_put(mk_user);
+	if (find_master_key_user(mk) != NULL)
 		err = 0;
-	}
+	else
+		err = -ENOKEY;
 	up_read(&mk->mk_sem);
 	fscrypt_put_master_key(mk);
 out:
 	if (err == -ENOKEY && capable(CAP_FOWNER))
 		err = 0;
@@ -1100,20 +1068,22 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
 	if (!mk)
 		return -ENOKEY;
 	down_write(&mk->mk_sem);
 
 	/* If relevant, remove current user's (or all users) claim to the key */
-	if (mk->mk_users && mk->mk_users->keys.nr_leaves_on_tree != 0) {
-		if (all_users)
-			err = keyring_clear(mk->mk_users);
-		else
+	if (!list_empty(&mk->mk_users)) {
+		if (all_users) {
+			clear_mk_users(mk);
+			err = 0;
+		} else {
 			err = remove_master_key_user(mk);
+		}
 		if (err) {
 			up_write(&mk->mk_sem);
 			goto out_put_key;
 		}
-		if (mk->mk_users->keys.nr_leaves_on_tree != 0) {
+		if (!list_empty(&mk->mk_users)) {
 			/*
 			 * Other users have still added the key too.  We removed
 			 * the current user's claim to the key, but we still
 			 * can't remove the key itself.
 			 */
@@ -1195,10 +1165,12 @@ EXPORT_SYMBOL_GPL(fscrypt_ioctl_remove_key_all_users);
 int fscrypt_ioctl_get_key_status(struct file *filp, void __user *uarg)
 {
 	struct super_block *sb = file_inode(filp)->i_sb;
 	struct fscrypt_get_key_status_arg arg;
 	struct fscrypt_master_key *mk;
+	kuid_t uid;
+	const struct fscrypt_master_key_user *mk_user;
 	int err;
 
 	if (copy_from_user(&arg, uarg, sizeof(arg)))
 		return -EFAULT;
 
@@ -1227,23 +1199,17 @@ int fscrypt_ioctl_get_key_status(struct file *filp, void __user *uarg)
 		err = 0;
 		goto out_release_key;
 	}
 
 	arg.status = FSCRYPT_KEY_STATUS_PRESENT;
-	if (mk->mk_users) {
-		struct key *mk_user;
 
-		arg.user_count = mk->mk_users->keys.nr_leaves_on_tree;
-		mk_user = find_master_key_user(mk);
-		if (!IS_ERR(mk_user)) {
+	uid = current_fsuid();
+	list_for_each_entry(mk_user, &mk->mk_users, link) {
+		arg.user_count++;
+		if (uid_eq(mk_user->uid, uid))
 			arg.status_flags |=
 				FSCRYPT_KEY_STATUS_FLAG_ADDED_BY_SELF;
-			key_put(mk_user);
-		} else if (mk_user != ERR_PTR(-ENOKEY)) {
-			err = PTR_ERR(mk_user);
-			goto out_release_key;
-		}
 	}
 	err = 0;
 out_release_key:
 	up_read(&mk->mk_sem);
 	fscrypt_put_master_key(mk);

base-commit: 83f1454877cc292b88baf13c829c16ce6937d120
prerequisite-patch-id: 319d2891e88c7df1ebb5ebf434d18b68f770399f
prerequisite-patch-id: 5330c9e4b65644baae81bd177a46be6223d2b494
-- 
2.54.0


