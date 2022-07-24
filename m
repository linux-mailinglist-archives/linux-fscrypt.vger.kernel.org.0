Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A7B57F244
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jul 2022 02:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239076AbiGXAw6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 23 Jul 2022 20:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239128AbiGXAw5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 23 Jul 2022 20:52:57 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E7417073;
        Sat, 23 Jul 2022 17:52:52 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D9D8980794;
        Sat, 23 Jul 2022 20:52:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1658623971; bh=0O9sMfDXdAc6wkH1XjE1SmNcbIiQipNcY+DsjhEUBO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtqQKVWDNJ0UcwVS7cw9iBQ8e/DgHGtHfyJLiIYLRjkt5FaG+e/iFlQIPiJe65T13
         Flm+1hkDG5quyg7y0OydAd6xMylyTpMlm8gy3rJgg4DAxY5lqeGyI7QjCQ1lS/VdHq
         l+gfrfC0E9o5i0jdhLw6xlgiO9ZETkjUSNOsVOPrn7eBjtGtkzpGIjZChEPtIPjrRJ
         WvjDzNovqLALZj8pSTf/xm+YxjzsLBfSEUa/bxPREa9tR9+3XLjoEa5ePQSSQFL7KR
         HXLzUWVUeFtpmPOZBPCs+eTLv+d29cQGl/gzPvT3pvUKMmOHKQ84f28kJsDqMgTQSG
         +Zre5rpgkKJZg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, osandov@osandov.com,
        kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH RFC 4/4] fscrypt: Add new encryption policy for btrfs.
Date:   Sat, 23 Jul 2022 20:52:28 -0400
Message-Id: <675dd03f1a4498b09925fbf93cc38b8430cb7a59.1658623235.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1658623235.git.sweettea-kernel@dorminy.me>
References: <cover.1658623235.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Certain filesystems may want to use IVs generated and stored outside of
fscrypt's inode-based IV generation policies.  In particular, btrfs can
have multiple inodes referencing a single block of data, and moves
logical data blocks to different physical locations on disk; these two
features mean inode or physical-location-based IV generation policies
will not work for btrfs. For these or similar reasons, such filesystems
may want to implement their own IV generation and storage for data
blocks.

Plumbing each such filesystem's internals into fscrypt for IV generation
would be ungainly and fragile. Thus, this change adds a new policy,
IV_FROM_FS, and a new operation function pointer, get_fs_derived_iv.  If
this policy is selected, the filesystem is required to provide the
function pointer, which populates the IV for a particular data block.
The IV buffer passed to get_fs_derived_iv() is pre-populated with the
inode contexts' nonce, in case the filesystem would like to use this
information; for btrfs, this is used for filename encryption.  Any
filesystem using this policy is expected to appropriately generate and
store a persistent random IV for each block of data.

Filesystems implementing this policy are expected to be incompatible
with existing IV generation policies, so if the function pointer is set,
only dummy or IV_FROM_FS policies are permitted. If there is a
filesystem which allows other policies as well as IV_FROM_FS, it may be
better to expose the policy to filesystems, so they can determine
whether any given policy is compatible with their operation.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c           | 28 ++++++++++++++++++++++++++--
 fs/crypto/fscrypt_private.h  |  4 ++--
 fs/crypto/inline_crypt.c     | 20 ++++++++++++++------
 fs/crypto/keysetup.c         |  5 +++++
 fs/crypto/policy.c           | 16 +++++++++++++++-
 include/linux/fscrypt.h      | 21 ++++++++++++++++++++-
 include/uapi/linux/fscrypt.h |  1 +
 7 files changed, 83 insertions(+), 12 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index e78be66bbf01..3c29c437ae0b 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -69,6 +69,20 @@ void fscrypt_free_bounce_page(struct page *bounce_page)
 }
 EXPORT_SYMBOL(fscrypt_free_bounce_page);
 
+int fscrypt_mode_ivsize(struct inode *inode)
+{
+	struct fscrypt_info *ci;
+
+	if (!fscrypt_needs_contents_encryption(inode))
+		return 0;
+
+	ci = inode->i_crypt_info;
+	if (WARN_ON_ONCE(!ci))
+		return 0;
+	return ci->ci_mode->ivsize;
+}
+EXPORT_SYMBOL(fscrypt_mode_ivsize);
+
 /*
  * Generate the IV for the given logical block number within the given file.
  * For filenames encryption, lblk_num == 0.
@@ -81,13 +95,23 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 			 const struct fscrypt_info *ci)
 {
 	u8 flags = fscrypt_policy_flags(&ci->ci_policy);
+	struct inode *inode = ci->ci_inode;
 
 	memset(iv, 0, ci->ci_mode->ivsize);
+	if (flags & FSCRYPT_POLICY_FLAG_IV_FROM_FS) {
+		const struct fscrypt_operations *s_cop = inode->i_sb->s_cop;
+		/* Provide the nonce in case the filesystem wants to use it */
+		memcpy(iv->nonce, ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE);
+		s_cop->get_fs_defined_iv(iv->raw, ci->ci_mode->ivsize, inode,
+					 lblk_num);
+		return;
+	}
+
 
 	if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
 		WARN_ON_ONCE(lblk_num > U32_MAX);
-		WARN_ON_ONCE(ci->ci_inode->i_ino > U32_MAX);
-		lblk_num |= (u64)ci->ci_inode->i_ino << 32;
+		WARN_ON_ONCE(inode->i_ino > U32_MAX);
+		lblk_num |= (u64)inode->i_ino << 32;
 	} else if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
 		WARN_ON_ONCE(lblk_num > U32_MAX);
 		lblk_num = (u32)(ci->ci_hashed_ino + lblk_num);
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 6b4c8094cc7b..084c6ba1e766 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -279,8 +279,6 @@ fscrypt_msg(const struct inode *inode, const char *level, const char *fmt, ...);
 #define fscrypt_err(inode, fmt, ...)		\
 	fscrypt_msg((inode), KERN_ERR, fmt, ##__VA_ARGS__)
 
-#define FSCRYPT_MAX_IV_SIZE	32
-
 union fscrypt_iv {
 	struct {
 		/* logical block number within the file */
@@ -326,6 +324,7 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 #define HKDF_CONTEXT_DIRHASH_KEY	5 /* info=file_nonce		*/
 #define HKDF_CONTEXT_IV_INO_LBLK_32_KEY	6 /* info=mode_num||fs_uuid	*/
 #define HKDF_CONTEXT_INODE_HASH_KEY	7 /* info=<empty>		*/
+#define HKDF_CONTEXT_IV_FROM_FS_KEY	8 /* info=mode_num	*/
 
 int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 			const u8 *info, unsigned int infolen,
@@ -498,6 +497,7 @@ struct fscrypt_master_key {
 	struct fscrypt_prepared_key mk_direct_keys[FSCRYPT_MODE_MAX + 1];
 	struct fscrypt_prepared_key mk_iv_ino_lblk_64_keys[FSCRYPT_MODE_MAX + 1];
 	struct fscrypt_prepared_key mk_iv_ino_lblk_32_keys[FSCRYPT_MODE_MAX + 1];
+	struct fscrypt_prepared_key mk_iv_from_fs_keys[FSCRYPT_MODE_MAX + 1];
 
 	/* Hash key for inode numbers.  Initialized only when needed. */
 	siphash_key_t		mk_ino_hash_key;
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 90f3e68f166e..8a8330caadfa 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -476,14 +476,22 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 		return nr_blocks;
 
 	ci = inode->i_crypt_info;
-	if (!(fscrypt_policy_flags(&ci->ci_policy) &
-	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
-		return nr_blocks;
 
-	/* With IV_INO_LBLK_32, the DUN can wrap around from U32_MAX to 0. */
+	if (fscrypt_policy_flags(&ci->ci_policy) &
+	    FSCRYPT_POLICY_FLAG_IV_FROM_FS) {
+		return 1;
+	}
 
-	dun = ci->ci_hashed_ino + lblk;
+	if ((fscrypt_policy_flags(&ci->ci_policy) &
+	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
+		/*
+		 * With IV_INO_LBLK_32, the DUN can wrap around from U32_MAX to
+		 * 0.
+		 */
+		dun = ci->ci_hashed_ino + lblk;
+		return min_t(u64, nr_blocks, (u64)U32_MAX + 1 - dun);
+	}
 
-	return min_t(u64, nr_blocks, (u64)U32_MAX + 1 - dun);
+	return nr_blocks;
 }
 EXPORT_SYMBOL_GPL(fscrypt_limit_io_blocks);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index c35711896bd4..62b30b567c0d 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -323,6 +323,11 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 		 */
 		err = setup_per_mode_enc_key(ci, mk, mk->mk_direct_keys,
 					     HKDF_CONTEXT_DIRECT_KEY, false);
+	} else if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_IV_FROM_FS) {
+		err = setup_per_mode_enc_key(ci, mk,
+					     mk->mk_iv_from_fs_keys,
+					     HKDF_CONTEXT_IV_FROM_FS_KEY,
+					     false);
 	} else if (ci->ci_policy.v2.flags &
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
 		/*
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 5763462af9e8..878650b8e3e7 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -199,7 +199,8 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 	if (policy->flags & ~(FSCRYPT_POLICY_FLAGS_PAD_MASK |
 			      FSCRYPT_POLICY_FLAG_DIRECT_KEY |
 			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
-			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
+			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 |
+			      FSCRYPT_POLICY_FLAG_IV_FROM_FS)) {
 		fscrypt_warn(inode, "Unsupported encryption flags (0x%02x)",
 			     policy->flags);
 		return false;
@@ -208,6 +209,7 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 	count += !!(policy->flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY);
 	count += !!(policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64);
 	count += !!(policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32);
+	count += !!(policy->flags & FSCRYPT_POLICY_FLAG_IV_FROM_FS);
 	if (count > 1) {
 		fscrypt_warn(inode, "Mutually exclusive encryption flags (0x%02x)",
 			     policy->flags);
@@ -235,6 +237,18 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 					  32, 32))
 		return false;
 
+	if ((policy->flags & FSCRYPT_POLICY_FLAG_IV_FROM_FS) &&
+	    !inode->i_sb->s_cop->get_fs_defined_iv)
+		return false;
+
+	/*
+	 * If the filesystem defines its own IVs, presumably it does so because
+	 * no existing policy works, so disallow other policies.
+	 */
+	if (inode->i_sb->s_cop->get_fs_defined_iv &&
+	    !(policy->flags & FSCRYPT_POLICY_FLAG_IV_FROM_FS))
+		return false;
+
 	if (memchr_inv(policy->__reserved, 0, sizeof(policy->__reserved))) {
 		fscrypt_warn(inode, "Reserved bits set in encryption policy");
 		return false;
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 1686b25f6d9c..3ebca02c4ba0 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -94,6 +94,12 @@ struct fscrypt_nokey_name {
 /* Maximum value for the third parameter of fscrypt_operations.set_context(). */
 #define FSCRYPT_SET_CONTEXT_MAX_SIZE	40
 
+/*
+ * Maximum size needed for an IV. Defines the size of the buffer passed to a
+ * get_fs_defined_iv() function.
+ */
+#define FSCRYPT_MAX_IV_SIZE	32
+
 #ifdef CONFIG_FS_ENCRYPTION
 
 /*
@@ -198,7 +204,13 @@ struct fscrypt_operations {
 	 */
 	void (*get_ino_and_lblk_bits)(struct super_block *sb,
 				      int *ino_bits_ret, int *lblk_bits_ret);
-
+	/*
+	 * Generate an IV for a given inode and lblk number, for filesystems
+	 * where additional filesystem-internal information is necessary to
+	 * keep the IV stable.
+	 */
+	void (*get_fs_defined_iv)(u8 *iv, int ivsize, struct inode *inode,
+				  u64 lblk_num);
 	/*
 	 * Return the number of block devices to which the filesystem may write
 	 * encrypted file contents.
@@ -317,6 +329,8 @@ static inline struct page *fscrypt_pagecache_page(struct page *bounce_page)
 
 void fscrypt_free_bounce_page(struct page *bounce_page);
 
+int fscrypt_mode_ivsize(struct inode *inode);
+
 /* policy.c */
 int fscrypt_have_same_policy(struct inode *inode1, struct inode *inode2);
 int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg);
@@ -492,6 +506,11 @@ static inline void fscrypt_free_bounce_page(struct page *bounce_page)
 {
 }
 
+static inline int fscrypt_mode_ivsize(struct inode *inode)
+{
+	return 0;
+}
+
 /* policy.c */
 static inline int fscrypt_ioctl_set_policy(struct file *filp,
 					   const void __user *arg)
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 9f4428be3e36..3fbde7668b07 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -20,6 +20,7 @@
 #define FSCRYPT_POLICY_FLAG_DIRECT_KEY		0x04
 #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64	0x08
 #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32	0x10
+#define FSCRYPT_POLICY_FLAG_IV_FROM_FS		0x20
 
 /* Encryption algorithms */
 #define FSCRYPT_MODE_AES_256_XTS		1
-- 
2.35.1

