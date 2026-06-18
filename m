Return-Path: <linux-fscrypt+bounces-1642-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id k2x0Fc8zNGpqRQYAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1642-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Jun 2026 20:07:11 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A81BA6A20C4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Jun 2026 20:07:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ax67mbTh;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1642-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1642-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6BA7F30247F6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Jun 2026 18:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A023331EC6;
	Thu, 18 Jun 2026 18:07:09 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B5D27874F;
	Thu, 18 Jun 2026 18:07:07 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781806028; cv=none; b=PWl44wljRgr8UlQ9brmGKhUvN1V+4EH4EhCrwvvQE9rHQ+2WL8XYyV3FssIa35s3jOnG0fqT5dWh/o3RCAeKF1Tt0AAqHpbY6t6YSU/GN4SSFKEOgLJp3tnn2SxYp25ReQWz7+/T8XJ6/JkksdM203z+DrSoW7GdbbNtHwL/NvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781806028; c=relaxed/simple;
	bh=I7mHGouvvV+4ibCp7u9Y+2bh88BwZHwSqH8fOk6Kd84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rTudsEbkuecT3NQHZ9M9bmNwpq/5KyAnsw9KmfkJ3pqan4to9Jn0AD4oNt1HpebdjGdJYSWd9hE+mbPL24LW7MrbbBtYO+2ZkFAELKcdCXMWcV/H9VNJEbxdito666VwAWLcAqnYFOAwh2YcA35SMlo/j/Bk6AEyPb79BAnkqEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ax67mbTh; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0951F000E9;
	Thu, 18 Jun 2026 18:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781806027;
	bh=Szn21LUOyUiIgzW8DMbhED04O/Mj/YhQ6+0lzayAndE=;
	h=From:To:Cc:Subject:Date;
	b=ax67mbTh+9bOHPS6qFRe1nAP6XyKbg/SRUInN5tL5EV5PGNrKp+UtYeOj868KWZF9
	 YdsPK63SL/mZbs7J7VO9Mdv0Qpm5wXXpRrYkycFjRa7LJ8sB9Xnc/EFtgtpiWhh2fo
	 KWjwnj5OhhEQrQtIBnjgiJ/92iQvDoz6CPzA5Ucg9MIhmwYsHvNeR72E/EMkaCZl4d
	 RW2rLDdyVTx2qycyaOkAl5R70Dg7ZiF+2KS2hqUUaDDaGogdwr8OMjV8pLLkdiVXVi
	 6BkPuntXw+RgWojpOIOKyoOPect+IfAPiFUECkoTtoUfU+ArdWwHlr7IivmM0tew8n
	 DRAkj6thNOJZA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] fscrypt: Fix key setup in edge case with multiple data unit sizes
Date: Thu, 18 Jun 2026 11:06:51 -0700
Message-ID: <20260618180652.52742-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:tytso@mit.edu,m:jaegeuk@kernel.org,m:linux-kernel@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:ebiggers@kernel.org,m:stable@vger.kernel.org,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-1642-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A81BA6A20C4

The addition of support for customizable data unit sizes introduced an
edge case where a file's contents can be en/decrypted with the wrong
data unit size.  It occurs when there are multiple v2 policies that:

- Have *different* data unit sizes, via the log2_data_unit_size field

- Share the same master_key_identifier, contents_encryption_mode, and
  either FSCRYPT_POLICY_FLAG_DIRECT_KEY,
  FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32, or
  FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64

- Are being used on the same filesystem, which also must be mounted with
  the "inlinecrypt" mount option.

Fortunately this edge case doesn't actually occur in practice.  I just
found it via code review.  But it needs to be fixed regardless.

The bug is caused by the data unit size not being fully considered when
blk_crypto_keys are cached in mk_direct_keys, mk_iv_ino_lblk_32_keys,
and mk_iv_ino_lblk_64_keys.  They're differentiated only by master key,
encryption mode, and flag.  However, each one actually has a data unit
size too.  Only the first data unit size that is cached is used.

To fix this, start using the data unit size to differentiate the cached
keys.  For several reasons, including avoiding increasing the size of
struct fscrypt_master_key, just replace all three arrays with a single
linked list instead of changing them into two-dimensional arrays.  This
works well when considering that in practice at most 2 entries are used
across all three arrays, so it was already mostly wasted space.

For simplicity, make the list also take over the publish/subscribe of
the prepared key itself.  That is, create separate list nodes for
blk_crypto_keys vs crypto_skciphers, and add nodes to the list only when
their key is actually prepared.  (Note that the legacy
fscrypt_direct_keys table in fs/crypto/keysetup_v1.c already works this
way.)  This eliminates the need for the additional memory barriers when
reading and writing the fields of struct fscrypt_prepared_key.

Note that I technically should have included the data unit size in the
HKDF info string as well.  But it's too late to change that.

Fixes: 5b1188847180 ("fscrypt: support crypto data unit size less than filesystem block size")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

I'm planning to take this via the fscrypt tree for 7.2

 fs/crypto/fscrypt_private.h |  52 +++++++++-------
 fs/crypto/inline_crypt.c    |   8 +--
 fs/crypto/keyring.c         |  23 ++++---
 fs/crypto/keysetup.c        | 118 ++++++++++++++++++++++--------------
 4 files changed, 120 insertions(+), 81 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 8d3c278a7591..4263cac24b32 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -234,19 +234,28 @@ struct fscrypt_symlink_data {
 /**
  * struct fscrypt_prepared_key - a key prepared for actual encryption/decryption
  * @tfm: crypto API transform object
  * @blk_key: key for blk-crypto
  *
- * Normally only one of the fields will be non-NULL.
+ * Only one of the fields is non-NULL.
  */
 struct fscrypt_prepared_key {
 	struct crypto_sync_skcipher *tfm;
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 	struct blk_crypto_key *blk_key;
 #endif
 };
 
+/* An entry in the linked list ->mk_mode_keys */
+struct fscrypt_mode_key {
+	struct fscrypt_prepared_key key;
+	struct list_head link;
+	u8 hkdf_context;
+	u8 mode_num;
+	u8 data_unit_bits;
+};
+
 /*
  * fscrypt_inode_info - the "encryption key" for an inode
  *
  * When an encrypted file's key is made available, an instance of this struct is
  * allocated and a pointer to it is stored in the file's in-memory inode.  Once
@@ -428,24 +437,16 @@ int fscrypt_derive_sw_secret(struct super_block *sb,
 /*
  * Check whether the crypto transform or blk-crypto key has been allocated in
  * @prep_key, depending on which encryption implementation the file will use.
  */
 static inline bool
-fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
+fscrypt_is_key_prepared(const struct fscrypt_prepared_key *prep_key,
 			const struct fscrypt_inode_info *ci)
 {
-	/*
-	 * The two smp_load_acquire()'s here pair with the smp_store_release()'s
-	 * in fscrypt_prepare_inline_crypt_key() and fscrypt_prepare_key().
-	 * I.e., in some cases (namely, if this prep_key is a per-mode
-	 * encryption key) another task can publish blk_key or tfm concurrently,
-	 * executing a RELEASE barrier.  We need to use smp_load_acquire() here
-	 * to safely ACQUIRE the memory the other task published.
-	 */
 	if (fscrypt_using_inline_encryption(ci))
-		return smp_load_acquire(&prep_key->blk_key) != NULL;
-	return smp_load_acquire(&prep_key->tfm) != NULL;
+		return prep_key->blk_key != NULL;
+	return prep_key->tfm != NULL;
 }
 
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 static inline int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci,
@@ -484,14 +485,14 @@ fscrypt_derive_sw_secret(struct super_block *sb,
 	fscrypt_warn(NULL, "kernel doesn't support hardware-wrapped keys");
 	return -EOPNOTSUPP;
 }
 
 static inline bool
-fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
+fscrypt_is_key_prepared(const struct fscrypt_prepared_key *prep_key,
 			const struct fscrypt_inode_info *ci)
 {
-	return smp_load_acquire(&prep_key->tfm) != NULL;
+	return prep_key->tfm != NULL;
 }
 #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 /* keyring.c */
 
@@ -575,12 +576,12 @@ struct fscrypt_master_key {
 	struct rw_semaphore			mk_sem;
 
 	/*
 	 * Active and structural reference counts.  An active ref guarantees
 	 * that the struct continues to exist, continues to be in the keyring
-	 * ->s_master_keys, and that any embedded subkeys (e.g.
-	 * ->mk_direct_keys) that have been prepared continue to exist.
+	 * ->s_master_keys, and that any non-file-scoped subkeys (e.g.
+	 * ->mk_mode_keys) that have been prepared continue to exist.
 	 * A structural ref only guarantees that the struct continues to exist.
 	 *
 	 * There is one active ref associated with ->mk_present being true, and
 	 * one active ref for each inode in ->mk_decrypted_inodes.
 	 *
@@ -630,16 +631,25 @@ struct fscrypt_master_key {
 	 */
 	struct list_head	mk_decrypted_inodes;
 	spinlock_t		mk_decrypted_inodes_lock;
 
 	/*
-	 * Per-mode encryption keys for the various types of encryption policies
-	 * that use them.  Allocated and derived on-demand.
+	 * A list of 'struct fscrypt_mode_key' for the (hkdf_context, mode_num,
+	 * data_unit_bits, inlinecrypt) combinations that are in use for this
+	 * master key, for hkdf_context in [HKDF_CONTEXT_DIRECT_KEY,
+	 * HKDF_CONTEXT_IV_INO_LBLK_32_KEY, HKDF_CONTEXT_IV_INO_LBLK_64_KEY].
+	 *
+	 * This is a linked list and not a hash table because in practice
+	 * there's just a single encryption policy per master key, using
+	 * _at most_ 2 nodes in this list.  Per-file keys don't use this at all.
+	 *
+	 * This list is append-only until the master key is fully removed, at
+	 * which time the list is cleared.  Before then,
+	 * fscrypt_mode_key_setup_mutex synchronizes appends, and searches use
+	 * the RCU read lock together with ->mk_sem held for read.
 	 */
-	struct fscrypt_prepared_key mk_direct_keys[FSCRYPT_MODE_MAX + 1];
-	struct fscrypt_prepared_key mk_iv_ino_lblk_64_keys[FSCRYPT_MODE_MAX + 1];
-	struct fscrypt_prepared_key mk_iv_ino_lblk_32_keys[FSCRYPT_MODE_MAX + 1];
+	struct list_head	mk_mode_keys;
 
 	/* Hash key for inode numbers.  Initialized only when needed. */
 	siphash_key_t		mk_ino_hash_key;
 	bool			mk_ino_hash_key_initialized;
 
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 37d42d357925..47324062fee5 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -196,17 +196,11 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	if (err) {
 		fscrypt_err(inode, "error %d starting to use blk-crypto", err);
 		goto fail;
 	}
 
-	/*
-	 * Pairs with the smp_load_acquire() in fscrypt_is_key_prepared().
-	 * I.e., here we publish ->blk_key with a RELEASE barrier so that
-	 * concurrent tasks can ACQUIRE it.  Note that this concurrency is only
-	 * possible for per-mode keys, not for per-file keys.
-	 */
-	smp_store_release(&prep_key->blk_key, blk_key);
+	prep_key->blk_key = blk_key;
 	return 0;
 
 fail:
 	kfree_sensitive(blk_key);
 	return err;
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index be8e6e8011f2..5fe0d985a58d 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -85,18 +85,18 @@ void fscrypt_put_master_key(struct fscrypt_master_key *mk)
 }
 
 void fscrypt_put_master_key_activeref(struct super_block *sb,
 				      struct fscrypt_master_key *mk)
 {
-	size_t i;
+	struct fscrypt_mode_key *node, *tmp;
 
 	if (!refcount_dec_and_test(&mk->mk_active_refs))
 		return;
 	/*
 	 * No active references left, so complete the full removal of this
 	 * fscrypt_master_key struct by removing it from the keyring and
-	 * destroying any subkeys embedded in it.
+	 * destroying any non-file-scoped subkeys.
 	 */
 
 	if (WARN_ON_ONCE(!sb->s_master_keys))
 		return;
 	spin_lock(&sb->s_master_keys->lock);
@@ -108,17 +108,20 @@ void fscrypt_put_master_key_activeref(struct super_block *sb,
 	 * ->mk_decrypted_inodes is empty.
 	 */
 	WARN_ON_ONCE(mk->mk_present);
 	WARN_ON_ONCE(!list_empty(&mk->mk_decrypted_inodes));
 
-	for (i = 0; i <= FSCRYPT_MODE_MAX; i++) {
-		fscrypt_destroy_prepared_key(
-				sb, &mk->mk_direct_keys[i]);
-		fscrypt_destroy_prepared_key(
-				sb, &mk->mk_iv_ino_lblk_64_keys[i]);
-		fscrypt_destroy_prepared_key(
-				sb, &mk->mk_iv_ino_lblk_32_keys[i]);
+	/*
+	 * Destroy any non-file-scoped subkeys.  Since ->mk_active_refs == 0,
+	 * they're no longer referenced by any inodes.  Nor can key setup run
+	 * and use them again.  So they're no longer needed.  (This implies no
+	 * concurrent readers, so we don't need list_del_rcu() for example.)
+	 */
+	list_for_each_entry_safe(node, tmp, &mk->mk_mode_keys, link) {
+		fscrypt_destroy_prepared_key(sb, &node->key);
+		list_del(&node->link);
+		kfree(node);
 	}
 	memzero_explicit(&mk->mk_ino_hash_key,
 			 sizeof(mk->mk_ino_hash_key));
 	mk->mk_ino_hash_key_initialized = false;
 
@@ -443,10 +446,12 @@ static int add_new_master_key(struct super_block *sb,
 	mk->mk_spec = *mk_spec;
 
 	INIT_LIST_HEAD(&mk->mk_decrypted_inodes);
 	spin_lock_init(&mk->mk_decrypted_inodes_lock);
 
+	INIT_LIST_HEAD(&mk->mk_mode_keys);
+
 	if (mk_spec->type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER) {
 		err = allocate_master_key_users_keyring(mk);
 		if (err)
 			goto out_put;
 		err = add_master_key_user(mk);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index ce327bfdada4..f905f9f94bdd 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -161,17 +161,11 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 							false, ci);
 
 	tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
-	/*
-	 * Pairs with the smp_load_acquire() in fscrypt_is_key_prepared().
-	 * I.e., here we publish ->tfm with a RELEASE barrier so that
-	 * concurrent tasks can ACQUIRE it.  Note that this concurrency is only
-	 * possible for per-mode keys, not for per-file keys.
-	 */
-	smp_store_release(&prep_key->tfm, tfm);
+	prep_key->tfm = tfm;
 	return 0;
 }
 
 /* Destroy a crypto transform object and/or blk-crypto key. */
 void fscrypt_destroy_prepared_key(struct super_block *sb,
@@ -188,21 +182,50 @@ int fscrypt_set_per_file_enc_key(struct fscrypt_inode_info *ci,
 {
 	ci->ci_owns_key = true;
 	return fscrypt_prepare_key(&ci->ci_enc_key, raw_key, ci);
 }
 
+/*
+ * Find the fscrypt_prepared_key (if any) for a particular (mk, hkdf_context,
+ * mode_num, data_unit_bits, inlinecrypt) combination.
+ *
+ * The caller must hold ->mk_sem for reading and ->mk_present must be true,
+ * ensuring that ->mk_mode_keys is still append-only.
+ */
+static struct fscrypt_prepared_key *
+fscrypt_find_mode_key(struct fscrypt_master_key *mk, u8 hkdf_context,
+		      u8 mode_num, const struct fscrypt_inode_info *ci)
+{
+	struct fscrypt_mode_key *node;
+
+	/*
+	 * The RCU read lock here is used only to synchronize with concurrent
+	 * list_add_tail_rcu().  Concurrent deletions are impossible here, so
+	 * returning a pointer to a node without taking any refcount is safe.
+	 */
+	guard(rcu)();
+	list_for_each_entry_rcu(node, &mk->mk_mode_keys, link) {
+		if (node->hkdf_context == hkdf_context &&
+		    node->mode_num == mode_num &&
+		    node->data_unit_bits == ci->ci_data_unit_bits &&
+		    fscrypt_is_key_prepared(&node->key, ci))
+			return &node->key;
+	}
+	return NULL;
+}
+
 static int setup_per_mode_enc_key(struct fscrypt_inode_info *ci,
 				  struct fscrypt_master_key *mk,
-				  struct fscrypt_prepared_key *keys,
 				  u8 hkdf_context, bool include_fs_uuid)
 {
 	const struct inode *inode = ci->ci_inode;
 	const struct super_block *sb = inode->i_sb;
 	struct fscrypt_mode *mode = ci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
 	struct fscrypt_prepared_key *prep_key;
-	u8 mode_key[FSCRYPT_MAX_RAW_KEY_SIZE];
+	struct fscrypt_mode_key *new_node;
+	u8 raw_mode_key[FSCRYPT_MAX_RAW_KEY_SIZE];
 	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
 	unsigned int hkdf_infolen = 0;
 	bool use_hw_wrapped_key = false;
 	int err;
 
@@ -221,52 +244,60 @@ static int setup_per_mode_enc_key(struct fscrypt_inode_info *ci,
 			return -EINVAL;
 		}
 		use_hw_wrapped_key = true;
 	}
 
-	prep_key = &keys[mode_num];
-	if (fscrypt_is_key_prepared(prep_key, ci)) {
+	prep_key = fscrypt_find_mode_key(mk, hkdf_context, mode_num, ci);
+	if (prep_key) {
 		ci->ci_enc_key = *prep_key;
 		return 0;
 	}
 
-	mutex_lock(&fscrypt_mode_key_setup_mutex);
+	guard(mutex)(&fscrypt_mode_key_setup_mutex);
 
-	if (fscrypt_is_key_prepared(prep_key, ci))
-		goto done_unlock;
+	prep_key = fscrypt_find_mode_key(mk, hkdf_context, mode_num, ci);
+	if (prep_key) {
+		ci->ci_enc_key = *prep_key;
+		return 0;
+	}
+
+	new_node = kzalloc_obj(*new_node);
+	if (!new_node)
+		return -ENOMEM;
+	new_node->hkdf_context = hkdf_context;
+	new_node->mode_num = mode_num;
+	new_node->data_unit_bits = ci->ci_data_unit_bits;
+	prep_key = &new_node->key;
 
 	if (use_hw_wrapped_key) {
 		err = fscrypt_prepare_inline_crypt_key(prep_key,
 						       mk->mk_secret.bytes,
 						       mk->mk_secret.size, true,
 						       ci);
-		if (err)
-			goto out_unlock;
-		goto done_unlock;
+	} else {
+		static_assert(sizeof(mode_num) == 1);
+		static_assert(sizeof(sb->s_uuid) == 16);
+		static_assert(sizeof(hkdf_info) == 17);
+		hkdf_info[hkdf_infolen++] = mode_num;
+		if (include_fs_uuid) {
+			memcpy(&hkdf_info[hkdf_infolen], &sb->s_uuid,
+			       sizeof(sb->s_uuid));
+			hkdf_infolen += sizeof(sb->s_uuid);
+		}
+		fscrypt_hkdf_expand(&mk->mk_secret.hkdf, hkdf_context,
+				    hkdf_info, hkdf_infolen, raw_mode_key,
+				    mode->keysize);
+		err = fscrypt_prepare_key(prep_key, raw_mode_key, ci);
+		memzero_explicit(raw_mode_key, mode->keysize);
 	}
-
-	BUILD_BUG_ON(sizeof(mode_num) != 1);
-	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
-	BUILD_BUG_ON(sizeof(hkdf_info) != 17);
-	hkdf_info[hkdf_infolen++] = mode_num;
-	if (include_fs_uuid) {
-		memcpy(&hkdf_info[hkdf_infolen], &sb->s_uuid,
-		       sizeof(sb->s_uuid));
-		hkdf_infolen += sizeof(sb->s_uuid);
+	if (err) {
+		kfree(new_node);
+		return err;
 	}
-	fscrypt_hkdf_expand(&mk->mk_secret.hkdf, hkdf_context, hkdf_info,
-			    hkdf_infolen, mode_key, mode->keysize);
-	err = fscrypt_prepare_key(prep_key, mode_key, ci);
-	memzero_explicit(mode_key, mode->keysize);
-	if (err)
-		goto out_unlock;
-done_unlock:
+	list_add_tail_rcu(&new_node->link, &mk->mk_mode_keys);
 	ci->ci_enc_key = *prep_key;
-	err = 0;
-out_unlock:
-	mutex_unlock(&fscrypt_mode_key_setup_mutex);
-	return err;
+	return 0;
 }
 
 /*
  * Derive a SipHash key from the given fscrypt master key and the given
  * application-specific information string.
@@ -309,12 +340,12 @@ void fscrypt_hash_inode_number(struct fscrypt_inode_info *ci,
 static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_inode_info *ci,
 					    struct fscrypt_master_key *mk)
 {
 	int err;
 
-	err = setup_per_mode_enc_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
-				     HKDF_CONTEXT_IV_INO_LBLK_32_KEY, true);
+	err = setup_per_mode_enc_key(ci, mk, HKDF_CONTEXT_IV_INO_LBLK_32_KEY,
+				     true);
 	if (err)
 		return err;
 
 	/* pairs with smp_store_release() below */
 	if (!smp_load_acquire(&mk->mk_ino_hash_key_initialized)) {
@@ -362,23 +393,22 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_inode_info *ci,
 		 * v1 policies, for v2 policies in this case we don't encrypt
 		 * with the master key directly but rather derive a per-mode
 		 * encryption key.  This ensures that the master key is
 		 * consistently used only for HKDF, avoiding key reuse issues.
 		 */
-		err = setup_per_mode_enc_key(ci, mk, mk->mk_direct_keys,
-					     HKDF_CONTEXT_DIRECT_KEY, false);
+		err = setup_per_mode_enc_key(ci, mk, HKDF_CONTEXT_DIRECT_KEY,
+					     false);
 	} else if (ci->ci_policy.v2.flags &
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
 		/*
 		 * IV_INO_LBLK_64: encryption keys are derived from (master_key,
 		 * mode_num, filesystem_uuid), and inode number is included in
 		 * the IVs.  This format is optimized for use with inline
 		 * encryption hardware compliant with the UFS standard.
 		 */
-		err = setup_per_mode_enc_key(ci, mk, mk->mk_iv_ino_lblk_64_keys,
-					     HKDF_CONTEXT_IV_INO_LBLK_64_KEY,
-					     true);
+		err = setup_per_mode_enc_key(
+			ci, mk, HKDF_CONTEXT_IV_INO_LBLK_64_KEY, true);
 	} else if (ci->ci_policy.v2.flags &
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
 		err = fscrypt_setup_iv_ino_lblk_32_key(ci, mk);
 	} else {
 		u8 derived_key[FSCRYPT_MAX_RAW_KEY_SIZE];

base-commit: 83f1454877cc292b88baf13c829c16ce6937d120
-- 
2.54.0


