Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C5874C794
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjGISx6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjGISx5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:53:57 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE56110C;
        Sun,  9 Jul 2023 11:53:56 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 4D12D80B04;
        Sun,  9 Jul 2023 14:53:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928836; bh=ZVvk66n0GpPurZZwk9pk3KLX/tBcHMTKzIUY6RO8BAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVwvXDr8S50I4jZmz0+W6ZIMPQAvJZT6902QGY4aGFRb+m/T3VEMIETLjoxRl//Yb
         IL6RGsxjxDDT+zuW7zljd3VeB1PkZA3dgXWoTGVQPG6yjySCl4s0mNRGDeFdplAKOb
         MgUwqQtCD/EdF0em1GQoXMryaOHv+WA+Px1Gq+UzaDWvDY5BptIvTJEsGhvVa+o+zZ
         VuwU3pX7cuRZhT3WzZcavSAuP6Bg6vCnO8GD0ckpmvbilNHD5RsyGcQ+rKYLq63fzR
         zQ5LkrbW/kWD4qwoLDxlBSkbvi/0q73WI8unO1rDMH3INCApyJw6SZVOEmrVZCnu91
         n6d3Btdy29JFw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 04/14] fscrypt: add a super_block pointer to fscrypt_info
Date:   Sun,  9 Jul 2023 14:53:37 -0400
Message-Id: <2be0ba2f42473b3a32f2bf6e43b0c5700a602708.1688927487.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688927487.git.sweettea-kernel@dorminy.me>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
 fs/crypto/fscrypt_private.h |  3 +++
 fs/crypto/inline_crypt.c    |  4 ++--
 fs/crypto/keysetup.c        | 10 +++++-----
 fs/crypto/keysetup_v1.c     |  6 +++---
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 4d1e67bc1e62..c04454c289fd 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -241,6 +241,9 @@ struct fscrypt_info {
 	/* Back-pointer to the inode */
 	struct inode *ci_inode;
 
+	/* The superblock of the filesystem to which this info pertains */
+	struct super_block *ci_sb;
+
 	/*
 	 * The master key with which this inode was unlocked (decrypted).  This
 	 * will be NULL if the master key was found in a process-subscribed
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index b3e7a5291d22..b8b4e59000d7 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -41,7 +41,7 @@ static struct block_device **fscrypt_get_devices(struct super_block *sb,
 
 static unsigned int fscrypt_get_dun_bytes(const struct fscrypt_info *ci)
 {
-	struct super_block *sb = ci->ci_inode->i_sb;
+	struct super_block *sb = ci->ci_sb;
 	unsigned int flags = fscrypt_policy_flags(&ci->ci_policy);
 	int ino_bits = 64, lblk_bits = 64;
 
@@ -155,7 +155,7 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 				     const struct fscrypt_info *ci)
 {
 	const struct inode *inode = ci->ci_inode;
-	struct super_block *sb = inode->i_sb;
+	struct super_block *sb = ci->ci_sb;
 	enum blk_crypto_mode_num crypto_mode = ci->ci_mode->blk_crypto_mode;
 	struct blk_crypto_key *blk_key;
 	struct block_device **devs;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index c3d3da5da449..c5f68cf65a6f 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -250,8 +250,7 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 				       struct fscrypt_prepared_key *prep_key,
 				       const struct fscrypt_info *ci)
 {
-	const struct inode *inode = ci->ci_inode;
-	const struct super_block *sb = inode->i_sb;
+	const struct super_block *sb = ci->ci_sb;
 	unsigned int policy_flags = fscrypt_policy_flags(&ci->ci_policy);
 	struct fscrypt_mode *mode = ci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
@@ -525,7 +524,7 @@ static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
 static int find_and_lock_master_key(const struct fscrypt_info *ci,
 				    struct fscrypt_master_key **mk_ret)
 {
-	struct super_block *sb = ci->ci_inode->i_sb;
+	struct super_block *sb = ci->ci_sb;
 	struct fscrypt_key_specifier mk_spec;
 	struct fscrypt_master_key *mk;
 	int err;
@@ -599,7 +598,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		if (type == FSCRYPT_KEY_DIRECT_V1)
 			fscrypt_put_direct_key(ci->ci_enc_key);
 		if (type == FSCRYPT_KEY_PER_INFO) {
-			fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
+			fscrypt_destroy_prepared_key(ci->ci_sb,
 						     ci->ci_enc_key);
 			kfree_sensitive(ci->ci_enc_key);
 		}
@@ -616,7 +615,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		spin_lock(&mk->mk_decrypted_inodes_lock);
 		list_del(&ci->ci_master_key_link);
 		spin_unlock(&mk->mk_decrypted_inodes_lock);
-		fscrypt_put_master_key_activeref(ci->ci_inode->i_sb, mk);
+		fscrypt_put_master_key_activeref(ci->ci_sb, mk);
 	}
 	memzero_explicit(ci, sizeof(*ci));
 	kmem_cache_free(fscrypt_info_cachep, ci);
@@ -642,6 +641,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 		return -ENOMEM;
 
 	crypt_info->ci_inode = inode;
+	crypt_info->ci_sb = inode->i_sb;
 	crypt_info->ci_policy = *policy;
 	memcpy(crypt_info->ci_nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
 
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 1e785cedead0..41d317f08aeb 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -235,7 +235,7 @@ fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
 	dk = kzalloc(sizeof(*dk), GFP_KERNEL);
 	if (!dk)
 		return ERR_PTR(-ENOMEM);
-	dk->dk_sb = ci->ci_inode->i_sb;
+	dk->dk_sb = ci->ci_sb;
 	refcount_set(&dk->dk_refcount, 1);
 	dk->dk_mode = ci->ci_mode;
 	dk->dk_key.type = FSCRYPT_KEY_DIRECT_V1;
@@ -309,8 +309,8 @@ int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci)
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
2.40.1

