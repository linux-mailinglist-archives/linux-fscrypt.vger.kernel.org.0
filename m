Return-Path: <linux-fscrypt+bounces-1561-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2CeiF3g9BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1561-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 10:59:36 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E35CE5301A5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 10:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DDCB0311E6CA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B993E5A05;
	Wed, 13 May 2026 08:54:27 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C8A3E51F2
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662467; cv=none; b=QhpFrAuv3gtmbbvZGdbt8Fnp9KpS/ZM1TxUFPbytzcT73HzAXY9j+wfTef8RiqX+TsXRQJC1PSgZ9S8gS5Tmp4bh7AnnJs/2m7G8l+hE2itTmbHIac5bLl6ovrCa/jt214ZkLI72M6lGxzHSrshudRbGhR9YGol16IvCj//JsQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662467; c=relaxed/simple;
	bh=it2qKlH9nB3E/6q10v98uSpqECmNicldtP54IfDlZDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oin9S2IH71yUd99pCCmpbpK8fGM68pClR9SwizfZrrWYjaZOPPqoyYBTFmvvKxYt7bWo+tX7NSEr41OFtRT+CwTmnfNZWGROOPfgrO2E4w/8aDhV3/51Aq7tJgq/PBjr5EyUoh4Wcvt+f/9cgAbPDmJUAxu+3TyofIYixSr76pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC7FA6BB4F;
	Wed, 13 May 2026 08:54:16 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 83C82593A9;
	Wed, 13 May 2026 08:54:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mMqlHzg8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:16 +0000
From: Daniel Vacek <neelx@suse.com>
To: Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>
Cc: linux-block@vger.kernel.org,
	Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 01/43] fscrypt: add per-extent encryption support
Date: Wed, 13 May 2026 10:52:35 +0200
Message-ID: <20260513085340.3673127-2-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260513085340.3673127-1-neelx@suse.com>
References: <20260513085340.3673127-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: E35CE5301A5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[suse.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1561-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.993];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:email,suse.com:mid]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

This adds the code necessary for per-extent encryption.  We will store a
nonce for every extent we create, and then use the inode's policy and
the extents nonce to derive a per-extent key.

This is meant to be flexible, if we choose to expand the on-disk extent
information in the future we have a version number we can use to change
what exists on disk.

The file system indicates it wants to use per-extent encryption by
setting s_cop->has_per_extent_encryption.  This also requires the use of
inline block encryption.

The support is relatively straightforward, the only "extra" bit is we're
deriving a per-extent key to use for the encryption, the inode still
controls the policy and access to the master key.

Since extent based encryption uses a lot of keys, we're requiring the
use of inline block crypto if you use extent-based encryption.  This
enables us to take advantage of the built in pooling and reclamation of
the crypto structures that underpin all of the encryption.

The different encryption related options for fscrypt are too numerous to
support for extent based encryption.  Support for a few of these options
could possibly be added, but since they're niche options simply reject
them for file systems using extent based encryption.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v7 changes:
 * Code cleanup in setup_extent_info(), no functional changes.
 * API cleanup passing a byte offset as an argument rather then logical
   block number in new functions.  This follows upstream v7.1 changes:
   https://lore.kernel.org/linux-fscrypt/20260218061531.3318130-1-hch@lst.de/
 * Make fscrypt_set_bio_crypt_ctx_from_extent() and fscrypt_mergeable_extent_bio()
   handle unencrypted extents gracefully (ei == NULL).  This way they can
   be called unconditionally.
 * Constify `ctx` argument of fscrypt_load_extent_info().
 * Comment cleanups as suggested by Eric.
v6 changes:
 * Fixed a merge collision with HW wrapped keydefinition.
 * Adapt to fscrypt changes.
   - Key derivation is void now instead of returning err.
   - Crypt info structure was split from VFS inode
     into FS specific inode structure.
v5: https://lore.kernel.org/linux-btrfs/37c2237bf485e44b0c813716f9506413026ce6dc.1706116485.git.josef@toxicpanda.com/
---
 fs/crypto/crypto.c          |  10 ++-
 fs/crypto/fscrypt_private.h |  42 +++++++++
 fs/crypto/inline_crypt.c    |  81 ++++++++++++++++++
 fs/crypto/keysetup.c        | 164 ++++++++++++++++++++++++++++++++++++
 fs/crypto/policy.c          |  47 +++++++++++
 include/linux/fscrypt.h     |  69 +++++++++++++++
 6 files changed, 412 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 570a2231c945..8ac9d3626b1d 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -42,6 +42,7 @@ static struct workqueue_struct *fscrypt_read_workqueue;
 static DEFINE_MUTEX(fscrypt_init_mutex);
 
 struct kmem_cache *fscrypt_inode_info_cachep;
+struct kmem_cache *fscrypt_extent_info_cachep;
 
 void fscrypt_enqueue_decrypt_work(struct work_struct *work)
 {
@@ -402,12 +403,19 @@ static int __init fscrypt_init(void)
 	if (!fscrypt_inode_info_cachep)
 		goto fail_free_queue;
 
+	fscrypt_extent_info_cachep = KMEM_CACHE(fscrypt_extent_info,
+						SLAB_RECLAIM_ACCOUNT);
+	if (!fscrypt_extent_info_cachep)
+		goto fail_free_inode_info;
+
 	err = fscrypt_init_keyring();
 	if (err)
-		goto fail_free_inode_info;
+		goto fail_free_extent_info;
 
 	return 0;
 
+fail_free_extent_info:
+	kmem_cache_destroy(fscrypt_extent_info_cachep);
 fail_free_inode_info:
 	kmem_cache_destroy(fscrypt_inode_info_cachep);
 fail_free_queue:
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 8d3c278a7591..e5ab9893dfed 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -66,6 +66,8 @@
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
+#define FSCRYPT_EXTENT_CONTEXT_V1	1
+
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
 #define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
 
@@ -89,6 +91,25 @@ struct fscrypt_context_v2 {
 	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
 };
 
+/*
+ * fscrypt_extent_context - the encryption context of an extent
+ *
+ * This is the on-disk information stored for an extent.  The nonce is used as a
+ * KDF input in conjuction with the inode context to derive a per-extent key for
+ * encryption.  This is used only when the filesystem uses per-extent encryption.
+ *
+ * With the current implementation, master_key_identifier and encryption mode
+ * must match the inode context.  These are here for future expansion where we
+ * may want the option of mixing different keys and encryption modes for the
+ * same file.
+ */
+struct fscrypt_extent_context {
+	u8 version; /* FSCRYPT_EXTENT_CONTEXT_V1 */
+	u8 encryption_mode;
+	u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
+};
+
 /*
  * fscrypt_context - the encryption context of an inode
  *
@@ -323,6 +344,25 @@ struct fscrypt_inode_info {
 	u8 ci_nonce[FSCRYPT_FILE_NONCE_SIZE];
 };
 
+/*
+ * fscrypt_extent_info - the "encryption key" for an extent.
+ *
+ * This contains the derived key for the given extent and the nonce for the
+ * extent.
+ */
+struct fscrypt_extent_info {
+	refcount_t refs;
+
+	/* The derived key for this extent. */
+	struct fscrypt_prepared_key prep_key;
+
+	/* The super block that this extent belongs to. */
+	struct super_block *sb;
+
+	/* This is the extent's nonce, loaded from the fscrypt_extent_context */
+	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
+};
+
 typedef enum {
 	FS_DECRYPT = 0,
 	FS_ENCRYPT,
@@ -330,6 +370,7 @@ typedef enum {
 
 /* crypto.c */
 extern struct kmem_cache *fscrypt_inode_info_cachep;
+extern struct kmem_cache *fscrypt_extent_info_cachep;
 int fscrypt_initialize(struct super_block *sb);
 int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
 			    fscrypt_direction_t rw, u64 index,
@@ -397,6 +438,7 @@ void fscrypt_init_hkdf(struct hmac_sha512_key *hkdf, const u8 *master_key,
 #define HKDF_CONTEXT_INODE_HASH_KEY	7 /* info=<empty>		*/
 #define HKDF_CONTEXT_KEY_IDENTIFIER_FOR_HW_WRAPPED_KEY \
 					8 /* info=<empty>		*/
+#define HKDF_CONTEXT_PER_EXTENT_ENC_KEY 9 /* info=extent_nonce		*/
 
 void fscrypt_hkdf_expand(const struct hmac_sha512_key *hkdf, u8 context,
 			 const u8 *info, unsigned int infolen,
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 37d42d357925..1bf8621093ed 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -312,6 +312,40 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx);
 
+/**
+ * fscrypt_set_bio_crypt_ctx_from_extent() - prepare a file contents bio for
+ *					     inline crypto with extent
+ *					     encryption
+ * @bio: a bio which will eventually be submitted to the file
+ * @ei: the extent's crypto info
+ * @pos: the first extent logical offset (in bytes) in the I/O
+ * @gfp_mask: memory allocation flags - these must be a waiting mask so that
+ *					bio_crypt_set_ctx can't fail.
+ *
+ * If the contents of the file should be encrypted (or decrypted) with inline
+ * encryption, then assign the appropriate encryption context to the bio.
+ *
+ * Normally the bio should be newly allocated (i.e. no pages added yet), as
+ * otherwise fscrypt_mergeable_extent_bio() won't work as intended.
+ *
+ * The encryption context will be freed automatically when the bio is freed.
+ */
+void fscrypt_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					   const struct fscrypt_extent_info *ei,
+					   loff_t pos, gfp_t gfp_mask)
+{
+	const struct blk_crypto_key *key;
+	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = {};
+
+	if (!ei)
+		return;
+	key = ei->prep_key.blk_key;
+
+	dun[0] = pos >> key->data_unit_size_bits;
+	bio_crypt_set_ctx(bio, key, dun, gfp_mask);
+}
+EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx_from_extent);
+
 /**
  * fscrypt_mergeable_bio() - test whether data can be added to a bio
  * @bio: the bio being built up
@@ -359,6 +393,53 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio);
 
+/**
+ * fscrypt_mergeable_extent_bio() - test whether data can be added to a bio
+ * @bio: the bio being built up
+ * @ei: the fscrypt_extent_info for this extent
+ * @pos: the next extent logical offset (in bytes) in the I/O
+ *
+ * When building a bio which may contain data which should undergo inline
+ * encryption (or decryption) via fscrypt, filesystems should call this function
+ * to ensure that the resulting bio contains only contiguous data unit numbers.
+ * This will return false if the next part of the I/O cannot be merged with the
+ * bio because either the encryption key would be different or the encryption
+ * data unit numbers would be discontiguous.
+ *
+ * fscrypt_set_bio_crypt_ctx_from_extent() must have already been called on the
+ * bio.
+ *
+ * This function isn't required in cases where crypto-mergeability is ensured in
+ * another way, such as I/O targeting only a single extent (thus a single key)
+ * combined with fscrypt_limit_io_blocks() to ensure DUN contiguity.
+ *
+ * Return: true iff the I/O is mergeable
+ */
+bool fscrypt_mergeable_extent_bio(struct bio *bio,
+				  const struct fscrypt_extent_info *ei,
+				  loff_t pos)
+{
+	const struct bio_crypt_ctx *bc = bio_crypt_ctx(bio);
+	u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = {};
+
+	if (!ei != !bc)
+		return false;
+	if (!bc)
+		return true;
+
+	/*
+	 * Comparing the key pointers is good enough, as all I/O for each key
+	 * uses the same pointer.  I.e., there's currently no need to support
+	 * merging requests where the keys are the same but the pointers differ.
+	 */
+	if (bc->bc_key != ei->prep_key.blk_key)
+		return false;
+
+	next_dun[0] = pos >> bc->bc_key->data_unit_size_bits;
+	return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
+}
+EXPORT_SYMBOL_GPL(fscrypt_mergeable_extent_bio);
+
 /**
  * fscrypt_dio_supported() - check whether DIO (direct I/O) is supported on an
  *			     inode, as far as encryption is concerned
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index ce327bfdada4..9fde198ae5e3 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -847,3 +847,167 @@ int fscrypt_drop_inode(struct inode *inode)
 	return !READ_ONCE(ci->ci_master_key->mk_present);
 }
 EXPORT_SYMBOL_GPL(fscrypt_drop_inode);
+
+static struct fscrypt_extent_info *
+setup_extent_info(struct inode *inode, const u8 nonce[FSCRYPT_FILE_NONCE_SIZE])
+{
+	struct fscrypt_extent_info *ei;
+	struct fscrypt_inode_info *ci;
+	struct fscrypt_master_key *mk;
+	u8 derived_key[FSCRYPT_MAX_RAW_KEY_SIZE];
+	int keysize;
+	int err;
+
+	ci = *fscrypt_inode_info_addr(inode);
+	mk = ci->ci_master_key;
+	if (WARN_ON_ONCE(!mk))
+		return ERR_PTR(-ENOKEY);
+
+	ei = kmem_cache_zalloc(fscrypt_extent_info_cachep, GFP_KERNEL);
+	if (!ei)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&ei->refs, 1);
+	memcpy(ei->nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
+	ei->sb = inode->i_sb;
+
+	keysize = ci->ci_mode->keysize;
+	down_read(&mk->mk_sem);
+	/*
+	 * We specifically don't check ->mk_present here because if the inode is
+	 * open and has a reference on the master key then it should be
+	 * available for us to use no matter if mk_present is true or false.
+	 */
+	fscrypt_hkdf_expand(&mk->mk_secret.hkdf, HKDF_CONTEXT_PER_EXTENT_ENC_KEY,
+			    ei->nonce, FSCRYPT_FILE_NONCE_SIZE,
+			    derived_key, keysize);
+	err = fscrypt_prepare_inline_crypt_key(&ei->prep_key,
+						derived_key, keysize, false, ci);
+	memzero_explicit(derived_key, keysize);
+	up_read(&mk->mk_sem);
+	if (err) {
+		memzero_explicit(ei, sizeof(*ei));
+		kmem_cache_free(fscrypt_extent_info_cachep, ei);
+		return ERR_PTR(err);
+	}
+	return ei;
+}
+
+/**
+ * fscrypt_prepare_new_extent() - prepare to create a new extent for a file
+ * @inode: the encrypted inode
+ *
+ * If the inode is encrypted, setup the fscrypt_extent_info for a new extent.
+ * This will include the nonce and the derived key necessary for the extent to
+ * be encrypted.  This is only meant to be used with inline crypto and on inodes
+ * that need their contents encrypted.
+ *
+ * This doesn't persist the new extents encryption context, this is done later
+ * by calling fscrypt_set_extent_context().
+ *
+ * Return: The newly allocated fscrypt_extent_info on success, -EOPNOTSUPP if
+ *	   we're not encrypted, or another -errno code
+ */
+struct fscrypt_extent_info *fscrypt_prepare_new_extent(struct inode *inode)
+{
+	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
+
+	if (WARN_ON_ONCE(!*fscrypt_inode_info_addr(inode)))
+		return ERR_PTR(-EOPNOTSUPP);
+	if (WARN_ON_ONCE(!fscrypt_inode_uses_inline_crypto(inode)))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	get_random_bytes(nonce, FSCRYPT_FILE_NONCE_SIZE);
+	return setup_extent_info(inode, nonce);
+}
+EXPORT_SYMBOL_GPL(fscrypt_prepare_new_extent);
+
+/**
+ * fscrypt_load_extent_info() - create an fscrypt_extent_info from the context
+ * @inode: the inode
+ * @ctx: the context buffer
+ * @ctx_size: the size of the context buffer
+ *
+ * Create the fscrypt_extent_info and derive the key based on the
+ * fscrypt_extent_context buffer that is provided.
+ *
+ * Return: The newly allocated fscrypt_extent_info on success, -EOPNOTSUPP if
+ *	   we're not encrypted, or another -errno code
+ */
+struct fscrypt_extent_info *fscrypt_load_extent_info(struct inode *inode,
+						     const u8 *ctx,
+						     size_t ctx_size)
+{
+	struct fscrypt_extent_context extent_ctx;
+	const struct fscrypt_inode_info *ci = *fscrypt_inode_info_addr(inode);
+	const struct fscrypt_policy_v2 *policy = &ci->ci_policy.v2;
+
+	if (WARN_ON_ONCE(!ci))
+		return ERR_PTR(-EOPNOTSUPP);
+	if (WARN_ON_ONCE(!fscrypt_inode_uses_inline_crypto(inode)))
+		return ERR_PTR(-EOPNOTSUPP);
+	if (ctx_size < sizeof(extent_ctx))
+		return ERR_PTR(-EINVAL);
+
+	memcpy(&extent_ctx, ctx, sizeof(extent_ctx));
+
+	if (extent_ctx.version != FSCRYPT_EXTENT_CONTEXT_V1) {
+		fscrypt_warn(inode, "Invalid extent encryption context version");
+		return ERR_PTR(-EINVAL);
+	}
+
+	/*
+	 * For now we need to validate that the master key and the encryption
+	 * mode matches what is in the inode.
+	 */
+	if (memcmp(extent_ctx.master_key_identifier,
+		   policy->master_key_identifier,
+		   sizeof(extent_ctx.master_key_identifier))) {
+		fscrypt_warn(inode, "Mismatching master key identifier");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (extent_ctx.encryption_mode != policy->contents_encryption_mode) {
+		fscrypt_warn(inode, "Mismatching encryption mode");
+		return ERR_PTR(-EINVAL);
+	}
+
+	return setup_extent_info(inode, extent_ctx.nonce);
+}
+EXPORT_SYMBOL_GPL(fscrypt_load_extent_info);
+
+/**
+ * fscrypt_put_extent_info() - put a reference to a fscrypt_extent_info
+ * @ei: the fscrypt_extent_info being put or NULL.
+ *
+ * Drop a reference and possibly free the fscrypt_extent_info.
+ *
+ * Might sleep, since this may call blk_crypto_evict_key() which can sleep.
+ */
+void fscrypt_put_extent_info(struct fscrypt_extent_info *ei)
+{
+	if (ei && refcount_dec_and_test(&ei->refs)) {
+		fscrypt_destroy_prepared_key(ei->sb, &ei->prep_key);
+		memzero_explicit(ei, sizeof(*ei));
+		kmem_cache_free(fscrypt_extent_info_cachep, ei);
+	}
+}
+EXPORT_SYMBOL_GPL(fscrypt_put_extent_info);
+
+/**
+ * fscrypt_get_extent_info() - get a reference to a fscrypt_extent_info
+ * @ei: the extent_info to get.
+ *
+ * Get a reference on the fscrypt_extent_info. This is useful for file systems
+ * that need to pass the fscrypt_extent_info through various other structures to
+ * make lifetime tracking simpler.
+ *
+ * Return: the ei with an extra ref, NULL if ei was NULL.
+ */
+struct fscrypt_extent_info *fscrypt_get_extent_info(struct fscrypt_extent_info *ei)
+{
+	if (ei)
+		refcount_inc(&ei->refs);
+	return ei;
+}
+EXPORT_SYMBOL_GPL(fscrypt_get_extent_info);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 9915e39362db..94dac05c2710 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -211,6 +211,12 @@ static bool fscrypt_supported_v1_policy(const struct fscrypt_policy_v1 *policy,
 		return false;
 	}
 
+	if (inode->i_sb->s_cop->has_per_extent_encryption) {
+		fscrypt_warn(inode,
+			     "v1 policies aren't supported on file systems that use extent encryption");
+		return false;
+	}
+
 	return true;
 }
 
@@ -240,6 +246,11 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 	count += !!(policy->flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY);
 	count += !!(policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64);
 	count += !!(policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32);
+	if (count > 0 && inode->i_sb->s_cop->has_per_extent_encryption) {
+		fscrypt_warn(inode,
+			     "DIRECT_KEY and IV_INO_LBLK_* encryption flags aren't supported on file systems that use extent encryption");
+		return false;
+	}
 	if (count > 1) {
 		fscrypt_warn(inode, "Mutually exclusive encryption flags (0x%02x)",
 			     policy->flags);
@@ -792,6 +803,42 @@ int fscrypt_set_context(struct inode *inode, void *fs_data)
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_context);
 
+/**
+ * fscrypt_set_extent_context() - Set the fscrypt extent context of a new extent
+ * @inode: the inode this extent belongs to
+ * @ei: the fscrypt_extent_info for the given extent
+ * @buf: the buffer to copy the fscrypt extent context into
+ *
+ * This should be called after fscrypt_prepare_new_extent(), using the
+ * fscrypt_extent_info that was created at that point.
+ *
+ * buf should be able to fit up to FSCRYPT_SET_CONTEXT_MAX_SIZE bytes.
+ *
+ * Return: the size of the fscrypt_extent_context, errno if the inode has the
+ *	   wrong policy version.
+ */
+ssize_t fscrypt_context_for_new_extent(struct inode *inode,
+				       struct fscrypt_extent_info *ei, u8 *buf)
+{
+	struct fscrypt_extent_context *ctx = (struct fscrypt_extent_context *)buf;
+	const struct fscrypt_inode_info *ci = *fscrypt_inode_info_addr(inode);
+
+	BUILD_BUG_ON(sizeof(struct fscrypt_extent_context) >
+		     FSCRYPT_SET_CONTEXT_MAX_SIZE);
+
+	if (WARN_ON_ONCE(ci->ci_policy.version != 2))
+		return -EINVAL;
+
+	ctx->version = FSCRYPT_EXTENT_CONTEXT_V1;
+	ctx->encryption_mode = ci->ci_policy.v2.contents_encryption_mode;
+	memcpy(ctx->master_key_identifier,
+	       ci->ci_policy.v2.master_key_identifier,
+	       sizeof(ctx->master_key_identifier));
+	memcpy(ctx->nonce, ei->nonce, FSCRYPT_FILE_NONCE_SIZE);
+	return sizeof(struct fscrypt_extent_context);
+}
+EXPORT_SYMBOL_GPL(fscrypt_context_for_new_extent);
+
 /**
  * fscrypt_parse_test_dummy_encryption() - parse the test_dummy_encryption mount option
  * @param: the mount option
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 54712ec61ffb..f216f1a78069 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -32,6 +32,7 @@
 
 union fscrypt_policy;
 struct fscrypt_inode_info;
+struct fscrypt_extent_info;
 struct fs_parameter;
 struct seq_file;
 
@@ -103,6 +104,14 @@ struct fscrypt_operations {
 	 */
 	unsigned int supports_subblock_data_units : 1;
 
+	/*
+	 * If set then extent based encryption will be used for this file
+	 * system, and fs/crypto/ will enforce limits on the policies that are
+	 * allowed to be chosen.  Currently this means only v2 policies and a
+	 * limited flags are supported.
+	 */
+	unsigned int has_per_extent_encryption : 1;
+
 	/*
 	 * This field exists only for backwards compatibility reasons and should
 	 * only be set by the filesystems that are setting it already.  It
@@ -387,6 +396,8 @@ int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child);
 int fscrypt_context_for_new_inode(void *ctx, struct inode *inode);
 int fscrypt_set_context(struct inode *inode, void *fs_data);
+ssize_t fscrypt_context_for_new_extent(struct inode *inode,
+				       struct fscrypt_extent_info *ei, u8 *buf);
 
 struct fscrypt_dummy_policy {
 	const union fscrypt_policy *policy;
@@ -423,6 +434,11 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 void fscrypt_put_encryption_info(struct inode *inode);
 void fscrypt_free_inode(struct inode *inode);
 int fscrypt_drop_inode(struct inode *inode);
+struct fscrypt_extent_info *fscrypt_prepare_new_extent(struct inode *inode);
+void fscrypt_put_extent_info(struct fscrypt_extent_info *ei);
+struct fscrypt_extent_info *fscrypt_get_extent_info(struct fscrypt_extent_info *ei);
+struct fscrypt_extent_info *fscrypt_load_extent_info(struct inode *inode,
+						     const u8 *ctx, size_t ctx_size);
 
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
@@ -636,6 +652,24 @@ fscrypt_free_dummy_policy(struct fscrypt_dummy_policy *dummy_policy)
 {
 }
 
+static inline ssize_t
+fscrypt_context_for_new_extent(struct inode *inode, struct fscrypt_extent_info *ei,
+			       u8 *buf)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline struct fscrypt_extent_info *
+fscrypt_load_extent_info(struct inode *inode, const u8 *ctx, size_t ctx_size)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline size_t fscrypt_extent_context_size(struct inode *inode)
+{
+	return 0;
+}
+
 /* keyring.c */
 static inline void fscrypt_destroy_keyring(struct super_block *sb)
 {
@@ -688,6 +722,20 @@ static inline int fscrypt_drop_inode(struct inode *inode)
 	return 0;
 }
 
+static inline struct fscrypt_extent_info *
+fscrypt_prepare_new_extent(struct inode *inode)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline void fscrypt_put_extent_info(struct fscrypt_extent_info *ei) { }
+
+static inline struct fscrypt_extent_info *
+fscrypt_get_extent_info(struct fscrypt_extent_info *ei)
+{
+	return ei;
+}
+
  /* fname.c */
 static inline int fscrypt_setup_filename(struct inode *dir,
 					 const struct qstr *iname,
@@ -868,9 +916,17 @@ bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode);
 void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 			       loff_t pos, gfp_t gfp_mask);
 
+void fscrypt_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					   const struct fscrypt_extent_info *ei,
+					   loff_t pos, gfp_t gfp_mask);
+
 bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 			   loff_t pos);
 
+bool fscrypt_mergeable_extent_bio(struct bio *bio,
+				  const struct fscrypt_extent_info *ei,
+				  loff_t pos);
+
 bool fscrypt_dio_supported(struct inode *inode);
 
 u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks);
@@ -886,6 +942,11 @@ static inline void fscrypt_set_bio_crypt_ctx(struct bio *bio,
 					     const struct inode *inode,
 					     loff_t pos, gfp_t gfp_mask) { }
 
+static inline void fscrypt_set_bio_crypt_ctx_from_extent(
+					 struct bio *bio,
+					 const struct fscrypt_extent_info *ei,
+					 loff_t pos, gfp_t gfp_mask) { }
+
 static inline bool fscrypt_mergeable_bio(struct bio *bio,
 					 const struct inode *inode,
 					 loff_t pos)
@@ -893,6 +954,14 @@ static inline bool fscrypt_mergeable_bio(struct bio *bio,
 	return true;
 }
 
+static inline bool fscrypt_mergeable_extent_bio(
+					 struct bio *bio,
+					 const struct fscrypt_extent_info *ei,
+					 loff_t pos)
+{
+	return true;
+}
+
 static inline bool fscrypt_dio_supported(struct inode *inode)
 {
 	return !fscrypt_needs_contents_encryption(inode);
-- 
2.53.0


