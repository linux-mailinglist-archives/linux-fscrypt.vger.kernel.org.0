Return-Path: <linux-fscrypt+bounces-1080-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2B2kEAsyhmneKQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1080-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:25:15 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BE002101CA0
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF326304E70D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDCCB426D23;
	Fri,  6 Feb 2026 18:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GHLSpuHB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GHLSpuHB"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF13426D09
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402236; cv=none; b=miaamSjudmo9lTYMBRhOiZ9farIW1HE0W8zj5MVL8cZZRf/w3nzVUK/x75+IGLiHNolZyA8X0CZY8gUWyujHLHGJiVqGomeBHwOGStuZ5RTOnGhhmxvKO+q8bOJ8zFIU77FECHzBmF5YNJ+zhoo5VbbIARcmP2YvdPELRnpAKbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402236; c=relaxed/simple;
	bh=kqgvlO6eUzLn2d85mw7XQwIpiVD9orgONQSTd1aAjtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvgEci+gS/vpxPk7GA0WYrQjFvyPccgenrzhyXmQCqQATMxLjHtzsV08iRZAtT8EMOwk/fPKttGGvH61JFpd7oDT0LbNFRPUlF5fuhqRT3WHzfDxhUsYMf3ULna6KSehVnZTTVehllllE8aXe0srzhZ/Cj7EU78qX88PfdxlcFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GHLSpuHB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GHLSpuHB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A4A843E72D;
	Fri,  6 Feb 2026 18:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pfIQDeUmEf5ccatb2Jkls8D0bbgJ78aaEFsNSXvLjrY=;
	b=GHLSpuHBIYwAJb9BxFzsPqPrkA6XxfzDII0cyq4GYHdMIqAQQAFANLCK57IvdrcRYlNYQn
	BhAzgrpLC2gdyFXkPMrSlrwR/fYhhw3D5yJEhKHZ1WjYIyewyKqcQ7srl8q2IMCobvwowG
	Yxe+TgeMGHaJP1hHu5L0wLO/+Sccwz0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pfIQDeUmEf5ccatb2Jkls8D0bbgJ78aaEFsNSXvLjrY=;
	b=GHLSpuHBIYwAJb9BxFzsPqPrkA6XxfzDII0cyq4GYHdMIqAQQAFANLCK57IvdrcRYlNYQn
	BhAzgrpLC2gdyFXkPMrSlrwR/fYhhw3D5yJEhKHZ1WjYIyewyKqcQ7srl8q2IMCobvwowG
	Yxe+TgeMGHaJP1hHu5L0wLO/+Sccwz0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 787D33EA63;
	Fri,  6 Feb 2026 18:23:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8FvOHLoxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:23:54 +0000
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
Subject: [PATCH v6 01/43] fscrypt: add per-extent encryption support
Date: Fri,  6 Feb 2026 19:22:33 +0100
Message-ID: <20260206182336.1397715-2-neelx@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260206182336.1397715-1-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1080-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,suse.com:email,suse.com:dkim,suse.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BE002101CA0
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

v5: https://lore.kernel.org/linux-btrfs/37c2237bf485e44b0c813716f9506413026ce6dc.1706116485.git.josef@toxicpanda.com/
 * Fixed a merge collision with HW wrapped keydefinition.
 * Adapt to fscrypt changes.
   - Key derivation is void now instead of returning err.
   - Crypt info structure was split from VFS inode
     into FS specific inode structure.
---
 fs/crypto/crypto.c          |  10 ++-
 fs/crypto/fscrypt_private.h |  42 +++++++++
 fs/crypto/inline_crypt.c    |  74 ++++++++++++++++
 fs/crypto/keysetup.c        | 165 ++++++++++++++++++++++++++++++++++++
 fs/crypto/policy.c          |  47 ++++++++++
 include/linux/fscrypt.h     |  67 +++++++++++++++
 6 files changed, 404 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 07f9cbfe3ea4..8845de2d5af0 100644
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
index 4e8e82a9ccf9..409e84851fb0 100644
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
+ * encryption.
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
@@ -326,6 +347,25 @@ struct fscrypt_inode_info {
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
@@ -333,6 +373,7 @@ typedef enum {
 
 /* crypto.c */
 extern struct kmem_cache *fscrypt_inode_info_cachep;
+extern struct kmem_cache *fscrypt_extent_info_cachep;
 int fscrypt_initialize(struct super_block *sb);
 int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
 			    fscrypt_direction_t rw, u64 index,
@@ -400,6 +441,7 @@ void fscrypt_init_hkdf(struct hmac_sha512_key *hkdf, const u8 *master_key,
 #define HKDF_CONTEXT_INODE_HASH_KEY	7 /* info=<empty>		*/
 #define HKDF_CONTEXT_KEY_IDENTIFIER_FOR_HW_WRAPPED_KEY \
 					8 /* info=<empty>		*/
+#define HKDF_CONTEXT_PER_EXTENT_ENC_KEY 9 /* info=extent_nonce		*/
 
 void fscrypt_hkdf_expand(const struct hmac_sha512_key *hkdf, u8 context,
 			 const u8 *info, unsigned int infolen,
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index ed6e926226b5..0d62bce2114a 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -314,6 +314,34 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx);
 
+/**
+ * fscrypt_set_bio_crypt_ctx_from_extent() - prepare a file contents bio for
+ *					     inline crypto with extent
+ *					     encryption
+ * @bio: a bio which will eventually be submitted to the file
+ * @ei: the extent's crypto info
+ * @first_lblk: the first file logical block number in the I/O
+ * @gfp_mask: memory allocation flags - these must be a waiting mask so that
+ *					bio_crypt_set_ctx can't fail.
+ *
+ * If the contents of the file should be encrypted (or decrypted) with inline
+ * encryption, then assign the appropriate encryption context to the bio.
+ *
+ * Normally the bio should be newly allocated (i.e. no pages added yet), as
+ * otherwise fscrypt_mergeable_bio() won't work as intended.
+ *
+ * The encryption context will be freed automatically when the bio is freed.
+ */
+void fscrypt_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					   const struct fscrypt_extent_info *ei,
+					   u64 first_lblk, gfp_t gfp_mask)
+{
+	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { first_lblk };
+
+	bio_crypt_set_ctx(bio, ei->prep_key.blk_key, dun, gfp_mask);
+}
+EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx_from_extent);
+
 /* Extract the inode and logical block number from a buffer_head. */
 static bool bh_get_inode_and_lblk_num(const struct buffer_head *bh,
 				      const struct inode **inode_ret,
@@ -406,6 +434,52 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio);
 
+/**
+ * fscrypt_mergeable_extent_bio() - test whether data can be added to a bio
+ * @bio: the bio being built up
+ * @ei: the fscrypt_extent_info for this extent
+ * @next_lblk: the next file logical block number in the I/O
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
+ * another way, such as I/O targeting only a single file (and thus a single key)
+ * combined with fscrypt_limit_io_blocks() to ensure DUN contiguity.
+ *
+ * Return: true iff the I/O is mergeable
+ */
+bool fscrypt_mergeable_extent_bio(struct bio *bio,
+				  const struct fscrypt_extent_info *ei,
+				  u64 next_lblk)
+{
+	const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
+	u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { next_lblk };
+
+	if (!ei)
+		return true;
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
+	return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
+}
+EXPORT_SYMBOL_GPL(fscrypt_mergeable_extent_bio);
+
 /**
  * fscrypt_mergeable_bio_bh() - test whether data can be added to a bio
  * @bio: the bio being built up
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 40fa05688d3a..44be08988065 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -849,3 +849,168 @@ int fscrypt_drop_inode(struct inode *inode)
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
+	down_read(&mk->mk_sem);
+	/*
+	 * We specifically don't check ->mk_present here because if the inode is
+	 * open and has a reference on the master key then it should be
+	 * available for us to use.
+	 */
+	fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
+			    HKDF_CONTEXT_PER_EXTENT_ENC_KEY, ei->nonce,
+			    FSCRYPT_FILE_NONCE_SIZE, derived_key,
+			    ci->ci_mode->keysize);
+
+	err = fscrypt_prepare_inline_crypt_key(&ei->prep_key, derived_key,
+						ci->ci_mode->keysize, false, ci);
+	memzero_explicit(derived_key, ci->ci_mode->keysize);
+	if (err)
+		goto out_free;
+	up_read(&mk->mk_sem);
+	return ei;
+out_free:
+	up_read(&mk->mk_sem);
+	memzero_explicit(ei, sizeof(*ei));
+	kmem_cache_free(fscrypt_extent_info_cachep, ei);
+	return ERR_PTR(err);
+}
+
+/**
+ * fscrypt_prepare_new_extent() - prepare to create a new extent for a file
+ * @inode: the possibly-encrypted inode
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
+						     u8 *ctx, size_t ctx_size)
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
index bbb2f5ced988..b37162fedd92 100644
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
+			     "Encryption flags aren't supported on file systems that use extent encryption");
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
+ * buf must be at most FSCRYPT_SET_CONTEXT_MAX_SIZE.
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
index 516aba5b858b..5a17e4975b06 100644
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
+	 * allowed to be chosen.  Currently this means only plain v2 policies
+	 * are supported.
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
+						     u8 *ctx, size_t ctx_size);
 
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
+fscrypt_load_extent_info(struct inode *inode, u8 *ctx, size_t ctx_size)
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
@@ -869,6 +917,10 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio,
 			       const struct inode *inode, u64 first_lblk,
 			       gfp_t gfp_mask);
 
+void fscrypt_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					   const struct fscrypt_extent_info *ei,
+					   u64 first_lblk, gfp_t gfp_mask);
+
 void fscrypt_set_bio_crypt_ctx_bh(struct bio *bio,
 				  const struct buffer_head *first_bh,
 				  gfp_t gfp_mask);
@@ -879,6 +931,10 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 bool fscrypt_mergeable_bio_bh(struct bio *bio,
 			      const struct buffer_head *next_bh);
 
+bool fscrypt_mergeable_extent_bio(struct bio *bio,
+				  const struct fscrypt_extent_info *ei,
+				  u64 next_lblk);
+
 bool fscrypt_dio_supported(struct inode *inode);
 
 u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks);
@@ -894,6 +950,10 @@ static inline void fscrypt_set_bio_crypt_ctx(struct bio *bio,
 					     const struct inode *inode,
 					     u64 first_lblk, gfp_t gfp_mask) { }
 
+static inline void fscrypt_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					const struct fscrypt_extent_info *ei,
+					u64 first_lblk, gfp_t gfp_mask) { }
+
 static inline void fscrypt_set_bio_crypt_ctx_bh(
 					 struct bio *bio,
 					 const struct buffer_head *first_bh,
@@ -906,6 +966,13 @@ static inline bool fscrypt_mergeable_bio(struct bio *bio,
 	return true;
 }
 
+static inline bool fscrypt_mergeable_extent_bio(struct bio *bio,
+						const struct fscrypt_extent_info *ei,
+						u64 next_lblk)
+{
+	return true;
+}
+
 static inline bool fscrypt_mergeable_bio_bh(struct bio *bio,
 					    const struct buffer_head *next_bh)
 {
-- 
2.51.0


