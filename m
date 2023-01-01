Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313C965A908
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjAAFN7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbjAAFNt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:49 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E935E6403
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:47 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 977B682666;
        Sun,  1 Jan 2023 00:06:54 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549615; bh=Zek6tJgMgpf4jZZbZ1RTIGxYIEyVbndBB6tiZz5U+Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cy7dhjJZufvJ8Jd9URDZVffFHYdnNbyHNr1XwkS5gMgsTUtUKWCJl6sn32QPUpLey
         S8JPBplt1Xia1zW5Qtn4G8nwzSnIoA6IKgWhz/TijRJRQSOlI8YFHnyx1/XVKfHKar
         RpaFaL1JYV/WYdnPvui6uJGsw2qYBnvd3OhvmW9aABl+QxX+gxVKg0uefvxyT8nqme
         Ieg2ujWqTM8qsgYKEWH8+C+Xc0hLVLxDm098vqfn+hSuArYv4N/qT+618k1YE1Ap2T
         oDiO+tZMyz7doTp4ssg8HYqmnDOuk7b9m38BCEX47Bg4BK/qE6DDkeyuhVFECNu0TV
         meXRyGkUG9aRQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 13/17] fscrypt: use an optional ino equivalent for per-extent infos
Date:   Sun,  1 Jan 2023 00:06:17 -0500
Message-Id: <f2b7d9f5412a2e8d2bb2c88d41a76495c6c1bc89.1672547582.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1672547582.git.sweettea-kernel@dorminy.me>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Since per-extent infos are not tied to inodes, an ino-based policy
cannot access the inode's i_ino to get the necessary information.
Instead, this adds an optional fscrypt_operation pointer to get the ino
equivalent for an extent, adds a wrapper to get the ino for an info, and
uses this wrapper everywhere where the ci's inode's i_ino is currently
accessed.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c          |  5 +++--
 fs/crypto/fscrypt_private.h | 18 ++++++++++++++++++
 fs/crypto/keyring.c         |  6 +++---
 fs/crypto/keysetup.c        |  8 ++++----
 include/linux/fscrypt.h     | 18 ++++++++++++++++++
 5 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 93b83dbe82ee..4760adc1158f 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -85,9 +85,10 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 	memset(iv, 0, ci->ci_mode->ivsize);
 
 	if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
+		u64 ino = fscrypt_get_info_ino(ci);
 		WARN_ON_ONCE(lblk_num > U32_MAX);
-		WARN_ON_ONCE(ci->ci_inode->i_ino > U32_MAX);
-		lblk_num |= (u64)ci->ci_inode->i_ino << 32;
+		WARN_ON_ONCE(ino > U32_MAX);
+		lblk_num |= (u64)ino << 32;
 	} else if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
 		WARN_ON_ONCE(lblk_num > U32_MAX);
 		lblk_num = (u32)(ci->ci_hashed_ino + lblk_num);
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index a34d2e525ddf..d937a320361e 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -344,6 +344,24 @@ fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
 	return fscrypt_get_info(inode);
 }
 
+/**
+ * fscrypt_get_info_ino() - get the ino or ino equivalent for an info
+ *
+ * @ci: the fscrypt_info in question
+ *
+ * For inode-based encryption, this will return the info's inode's ino.
+ * For extent-based encryption, this will return the extent's ino equivalent
+ * or 0 if it is not implemented.
+ */
+static inline u64 fscrypt_get_info_ino(const struct fscrypt_info *ci)
+{
+	if (ci->ci_inode)
+		return ci->ci_inode->i_ino;
+	if (!ci->ci_sb->s_cop->get_extent_ino_equivalent)
+		return 0;
+	return ci->ci_sb->s_cop->get_extent_ino_equivalent(ci->ci_info_ptr);
+}
+
 /* crypto.c */
 extern struct kmem_cache *fscrypt_info_cachep;
 int fscrypt_initialize(unsigned int cop_flags);
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 0c4e917a5281..48e732628d43 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -933,11 +933,11 @@ static int check_for_busy_inodes(struct super_block *sb,
 
 	{
 		/* select an example file to show for debugging purposes */
-		struct inode *inode =
+		struct fscrypt_info *ci =
 			list_first_entry(&mk->mk_active_infos,
 					 struct fscrypt_info,
-					 ci_master_key_link)->ci_inode;
-		ino = inode->i_ino;
+					 ci_master_key_link);
+		ino = fscrypt_get_info_ino(ci);
 	}
 	spin_unlock(&mk->mk_active_infos_lock);
 
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 1751e3ed9956..f32b6f0a8336 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -266,11 +266,11 @@ int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
 void fscrypt_hash_inode_number(struct fscrypt_info *ci,
 			       const struct fscrypt_master_key *mk)
 {
-	WARN_ON(ci->ci_inode->i_ino == 0);
+	u64 ino = fscrypt_get_info_ino(ci);
+	WARN_ON(ino == 0);
 	WARN_ON(!mk->mk_ino_hash_key_initialized);
 
-	ci->ci_hashed_ino = (u32)siphash_1u64(ci->ci_inode->i_ino,
-					      &mk->mk_ino_hash_key);
+	ci->ci_hashed_ino = (u32)siphash_1u64(ino, &mk->mk_ino_hash_key);
 }
 
 static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
@@ -308,7 +308,7 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
 	 * New inodes may not have an inode number assigned yet.
 	 * Hashing their inode number is delayed until later.
 	 */
-	if (ci->ci_inode->i_ino)
+	if (fscrypt_get_info_ino(ci))
 		fscrypt_hash_inode_number(ci, mk);
 	return 0;
 }
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 4f5f8a651213..c05e6ad3e729 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -129,6 +129,15 @@ struct fscrypt_operations {
 	 */
 	bool (*empty_dir)(struct inode *inode);
 
+	/*
+	 * Inform the filesystem that a particular extent must forget its
+	 * fscrypt_info (for instance, for a key removal).
+	 *
+	 * @info_ptr: a pointer to the location storing the fscrypt_info pointer
+	 *            within the opaque extent whose info is to be freed
+	 */
+	void (*forget_extent_info)(struct fscrypt_info **info_ptr);
+
 	/*
 	 * Check whether the filesystem's inode numbers and UUID are stable,
 	 * meaning that they will never be changed even by offline operations
@@ -160,6 +169,15 @@ struct fscrypt_operations {
 	void (*get_ino_and_lblk_bits)(struct super_block *sb,
 				      int *ino_bits_ret, int *lblk_bits_ret);
 
+	/*
+	 * Get the inode number equivalent for filesystems using per-extent
+	 * encryption keys.
+	 *
+	 * This function only needs to be implemented if support for one of the
+	 * FSCRYPT_POLICY_FLAG_IV_INO_* flags is needed.
+	 */
+	u64 (*get_extent_ino_equivalent)(struct fscrypt_info **info_ptr);
+
 	/*
 	 * Return an array of pointers to the block devices to which the
 	 * filesystem may write encrypted file contents, NULL if the filesystem
-- 
2.38.1

