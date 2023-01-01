Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1185765A8FB
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjAAFNu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjAAFNr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:47 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B6763FE
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:45 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 458918263D;
        Sun,  1 Jan 2023 00:06:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549601; bh=g4930koxwcaUYiQSLl2wE+AjGCHIuIimXlcUqzwAigE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIkX44IO6MorEtvfv+mGLpDBwN8hknZG8e0TxdHdH7VRBIPKcJKPMEBX1IhXYvBY2
         xFvVDQ7/DZxzbKmOzRAiMVYU8lcVhA49JWwO10S51V9I5fgEMb8TIW91Zdn3OIvyFp
         ZoZ2JlTppz+rvzet39QImw1DI5s6PAWuHmwGS7IdhwgyMV240cnhZOE/inXDjsUfte
         ZRtiuvQeRQ8ZzVnR/fwudaXO5FAcQddgEGGghUwHCE/fCNqG2AUrXkem93gaWrGDtU
         yg1cZP5dBSx6KRCb+JqXmlu2UXbxyaqw1zY7Cy+KYibAkycqJHPua36kHpDF45DkkB
         3A5cLNe22IuPA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 06/17] fscrypt: add a super_block pointer to fscrypt_info
Date:   Sun,  1 Jan 2023 00:06:10 -0500
Message-Id: <623191aef09dc226a77d59230b5363f674910915.1672547582.git.sweettea-kernel@dorminy.me>
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

When fscrypt_infos are attached to extents instead of inodes, we can't
go through the inode to get at the filesystems's superblock. Therefore,
add a dedicated superblock pointer to fscrypt_info to keep track of it.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 3 +++
 fs/crypto/inline_crypt.c    | 6 +++---
 fs/crypto/keysetup.c        | 9 ++++-----
 fs/crypto/keysetup_v1.c     | 6 +++---
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index e4c9c483114f..da4df8642456 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -220,6 +220,9 @@ struct fscrypt_info {
 	/* Back-pointer to the inode */
 	struct inode *ci_inode;
 
+	/* The superblock of the filesystem to which this fscrypt_info pertains */
+	struct super_block *ci_sb;
+
 	/*
 	 * The master key with which this inode was unlocked (decrypted).  This
 	 * will be NULL if the master key was found in a process-subscribed
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 0ae220c8afa3..7e85167d9f37 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -41,7 +41,7 @@ static struct block_device **fscrypt_get_devices(struct super_block *sb,
 
 static unsigned int fscrypt_get_dun_bytes(const struct fscrypt_info *ci)
 {
-	struct super_block *sb = ci->ci_inode->i_sb;
+	struct super_block *sb = ci->ci_sb;
 	unsigned int flags = fscrypt_policy_flags(&ci->ci_policy);
 	int ino_bits = 64, lblk_bits = 64;
 
@@ -95,7 +95,7 @@ static void fscrypt_log_blk_crypto_impl(struct fscrypt_mode *mode,
 int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 {
 	const struct inode *inode = ci->ci_inode;
-	struct super_block *sb = inode->i_sb;
+	struct super_block *sb = ci->ci_sb;
 	struct blk_crypto_config crypto_cfg;
 	struct block_device **devs;
 	unsigned int num_devs;
@@ -158,7 +158,7 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 				     const struct fscrypt_info *ci)
 {
 	const struct inode *inode = ci->ci_inode;
-	struct super_block *sb = inode->i_sb;
+	struct super_block *sb = ci->ci_sb;
 	enum blk_crypto_mode_num crypto_mode = ci->ci_mode->blk_crypto_mode;
 	struct blk_crypto_key *blk_key;
 	struct block_device **devs;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 52244e0dd1e4..dacf3c47a24a 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -174,8 +174,7 @@ static int setup_per_mode_enc_key(struct fscrypt_info *ci,
 				  struct fscrypt_prepared_key *keys,
 				  u8 hkdf_context, bool include_fs_uuid)
 {
-	const struct inode *inode = ci->ci_inode;
-	const struct super_block *sb = inode->i_sb;
+	const struct super_block *sb = ci->ci_sb;
 	struct fscrypt_mode *mode = ci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
 	struct fscrypt_prepared_key *prep_key;
@@ -435,7 +434,7 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 	if (err)
 		return err;
 
-	mk = fscrypt_find_master_key(ci->ci_inode->i_sb, &mk_spec);
+	mk = fscrypt_find_master_key(ci->ci_sb, &mk_spec);
 	if (!mk) {
 		if (ci->ci_policy.version != FSCRYPT_POLICY_V1)
 			return -ENOKEY;
@@ -495,8 +494,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 	if (ci->ci_direct_key)
 		fscrypt_put_direct_key(ci->ci_direct_key);
 	else if (ci->ci_owns_key)
-		fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
-					     &ci->ci_enc_key);
+		fscrypt_destroy_prepared_key(ci->ci_sb, &ci->ci_enc_key);
 
 	mk = ci->ci_master_key;
 	if (mk) {
@@ -568,6 +566,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 		return -ENOMEM;
 
 	crypt_info->ci_inode = inode;
+	crypt_info->ci_sb = inode->i_sb;
 	crypt_info->ci_policy = *policy;
 	memcpy(crypt_info->ci_nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
 
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 75dabd9b27f9..3cbf1480c457 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -232,7 +232,7 @@ fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
 	dk = kzalloc(sizeof(*dk), GFP_KERNEL);
 	if (!dk)
 		return ERR_PTR(-ENOMEM);
-	dk->dk_sb = ci->ci_inode->i_sb;
+	dk->dk_sb = ci->ci_sb;
 	refcount_set(&dk->dk_refcount, 1);
 	dk->dk_mode = ci->ci_mode;
 	err = fscrypt_prepare_key(&dk->dk_key, raw_key, ci);
@@ -306,8 +306,8 @@ int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci)
 	key = find_and_lock_process_key(FSCRYPT_KEY_DESC_PREFIX,
 					ci->ci_policy.v1.master_key_descriptor,
 					ci->ci_mode->keysize, &payload);
-	if (key == ERR_PTR(-ENOKEY) && ci->ci_inode->i_sb->s_cop->key_prefix) {
-		key = find_and_lock_process_key(ci->ci_inode->i_sb->s_cop->key_prefix,
+	if (key == ERR_PTR(-ENOKEY) && ci->ci_sb->s_cop->key_prefix) {
+		key = find_and_lock_process_key(ci->ci_sb->s_cop->key_prefix,
 						ci->ci_policy.v1.master_key_descriptor,
 						ci->ci_mode->keysize, &payload);
 	}
-- 
2.38.1

