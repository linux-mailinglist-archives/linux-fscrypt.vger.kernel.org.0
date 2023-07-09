Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C122474C79C
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjGISyF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjGISyE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:54:04 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7813D124;
        Sun,  9 Jul 2023 11:54:03 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id BC89380AE0;
        Sun,  9 Jul 2023 14:54:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928843; bh=Bc0Ykt0qYEJfRIkG+fty++J6AyeiIf8Gvf+5Drnz2Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anKLG3RgB4vr3KIAjbjFCMzO+RY+TDtbWTDv0r+ArAedgWpWqO0t5t4QX+/uO/k2/
         l3lX9KD0cvovvL2zJLR/AZ4YRrEuobdUX3PBhk0yORFJBvXpevSv9WyWd6/O+62xLu
         aHT5WKgy42fYI5GKfxkI4e5ofndDJSrjU6F0/ulVHgzt7U6xIh0Vuc+cgmG5tf/ABz
         w07DQ9/UPl5PgM70pqa9n7IJ5kwBhzK5qIh0NNgJ95IeVlEN+m02NVXC4AlSo2TTWr
         vsNC0Lj2gM6VDQPK+p+6/42uZL9j/tnvxJWssDo7HzXeHH9hvXhA0YBc9VcQl8k+Qe
         AI91yqZVuOk2g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 08/14] fscrypt: use an optional ino equivalent for per-extent infos
Date:   Sun,  9 Jul 2023 14:53:41 -0400
Message-Id: <6830afa74507c24d61510f54c34a3bee560c3b3c.1688927487.git.sweettea-kernel@dorminy.me>
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

Since per-extent infos are not tied to inodes, an ino-based policy
cannot access the inode's i_ino to get the necessary information.
Instead, this adds an optional fscrypt_operation pointer to get the ino
equivalent for an extent, adds a wrapper to get the ino for an info, and
uses this wrapper everywhere where the ci's inode's i_ino is currently
accessed.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 18 ++++++++++++++++++
 fs/crypto/keyring.c         |  8 ++++----
 fs/crypto/keysetup.c        |  6 +++---
 include/linux/fscrypt.h     |  9 +++++++++
 4 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 1674e66e72e3..8bf27ceeecd1 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -332,6 +332,24 @@ static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
 	return false;
 }
 
+/**
+ * fscrypt_get_info_ino() - get the ino or ino equivalent for an info
+ *
+ * @ci: the fscrypt_info in question
+ *
+ * Return: For inode-based encryption, this will return the info's inode's ino.
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
 int fscrypt_initialize(struct super_block *sb);
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 0aad825087c1..bfcd2ecbe481 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -923,12 +923,12 @@ static int check_for_busy_inodes(struct super_block *sb,
 	}
 
 	{
-		/* select an example file to show for debugging purposes */
-		struct inode *inode =
+		/* select an example info to show for debugging purposes */
+		struct fscrypt_info *ci =
 			list_first_entry(&mk->mk_decrypted_inodes,
 					 struct fscrypt_info,
-					 ci_master_key_link)->ci_inode;
-		ino = inode->i_ino;
+					 ci_master_key_link);
+		ino = fscrypt_get_info_ino(ci);
 	}
 	spin_unlock(&mk->mk_decrypted_inodes_lock);
 
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 29565338d9c0..d20cee61e24f 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -380,10 +380,10 @@ int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
 void fscrypt_hash_inode_number(struct fscrypt_info *ci,
 			       const struct fscrypt_master_key *mk)
 {
-	WARN_ON_ONCE(ci->ci_inode->i_ino == 0);
+	WARN_ON_ONCE(fscrypt_get_info_ino(ci) == 0);
 	WARN_ON_ONCE(!mk->mk_ino_hash_key_initialized);
 
-	ci->ci_hashed_ino = (u32)siphash_1u64(ci->ci_inode->i_ino,
+	ci->ci_hashed_ino = (u32)siphash_1u64(fscrypt_get_info_ino(ci),
 					      &mk->mk_ino_hash_key);
 }
 
@@ -706,7 +706,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 		if (res)
 			goto out;
 
-		if (inode->i_ino)
+		if (fscrypt_get_info_ino(crypt_info))
 			fscrypt_hash_inode_number(crypt_info, mk);
 	}
 
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 378a1f41c62f..22affbb15706 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -169,6 +169,15 @@ struct fscrypt_operations {
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
2.40.1

