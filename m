Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF72D527612
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 May 2022 08:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbiEOGiE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 May 2022 02:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbiEOGiB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 May 2022 02:38:01 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BDA18E37;
        Sat, 14 May 2022 23:38:00 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h24so5969783pgh.12;
        Sat, 14 May 2022 23:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ct6F/dfWJeudSBuTPTnxPoMb/5nXxCK1YzRP7KmUU6k=;
        b=Xtf2tMNyKm0JaKFzDoYnpGoNFDTEp5GGYTTtOjmu5htNAUXLV2rVZU8ytA3Hm3JqDO
         7SQPjqlk+53Y6tzeAAtXbD/M7lp3TBBG2vGj/vtn66zAxj4NUDSE2Ad2gdKqjxNfJ0iN
         L+pXY19EHH4vosTWidsOWsnVyI+YB/AgNkGaPTolBBA/yiP+n1Vnx2BiJU5zQE7iZHeK
         IVTnPeAILEHjWD0xaV/r5nTotUasoRO6G+1kKPyRnhazfCeZ0nSRm8SYhQExBfiH7NIq
         KHKCEpmON1EqZlmTb/eJXzsPWmC3QVmVWx1rat5D0uefRtjnSx27N58tY0m4jFGNl6u7
         UxFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ct6F/dfWJeudSBuTPTnxPoMb/5nXxCK1YzRP7KmUU6k=;
        b=peXL50O6WFUW7alZdAH1BKdEniFMms556ocdBtWcBlh25Yy78WjEQlvfYGYAnXik9F
         GGc0po3UQIEXYGRbIGchBcrLsL3UngWPQkhDHn/D5Dz29B6fgu2JAABMGGyEkpEX3XKu
         xWZF8T//v47sWJV9IQTvJaVzah2g/SBICX6md5Kyb8/VHFKww2qtY10IB43sRz4BEFo3
         NBpmIqJjgmX/qSxqrbqKTakqUTMBRuoz6wTQAMnxR7J3VcHwvjxD9kFDxbBVdee2W1SZ
         ik2W9c9MUYfwhYvIIuBRLCP+uZjv+KKyaYJLYy5EbjxGZ2owCjNMHbXRPDewf7SJuC8/
         4K/A==
X-Gm-Message-State: AOAM530qaMeuZ1Ah64qWM6XM5KQvyVjIIvC/6JYsa3VXz+xccMD+chZ/
        Kjhd9O5KMhtit2Xv3aLDkU0Uc1Nuzi8=
X-Google-Smtp-Source: ABdhPJzJDI5uTwmhNk4u5sovhhva4gw4i89GDUo17+JzParOcvC3v0a6wztQRtNA6/arF+/ANIMn9A==
X-Received: by 2002:aa7:88d1:0:b0:510:3ee2:3f25 with SMTP id k17-20020aa788d1000000b005103ee23f25mr12037356pff.41.1652596680019;
        Sat, 14 May 2022 23:38:00 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id q17-20020a656851000000b003e4580cf645sm2632579pgt.17.2022.05.14.23.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 23:37:59 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCHv3 1/3] ext4: Move ext4 crypto code to its own file crypto.c
Date:   Sun, 15 May 2022 12:07:46 +0530
Message-Id: <7d637e093cbc34d727397e8d41a53a1b9ca7d7a4.1652595565.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1652595565.git.ritesh.list@gmail.com>
References: <cover.1652595565.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is to cleanup super.c file which has grown quite large.
So, start moving ext4 crypto related code to where it should
be in the first place i.e. fs/ext4/crypto.c

Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ritesh Harjani <ritesh.list@gmail.com>
---
 fs/ext4/Makefile |   1 +
 fs/ext4/crypto.c | 127 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   |   3 ++
 fs/ext4/super.c  | 122 ---------------------------------------------
 4 files changed, 131 insertions(+), 122 deletions(-)
 create mode 100644 fs/ext4/crypto.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 7d89142e1421..72206a292676 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -17,3 +17,4 @@ ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
 ext4-inode-test-objs			+= inode-test.o
 obj-$(CONFIG_EXT4_KUNIT_TESTS)		+= ext4-inode-test.o
 ext4-$(CONFIG_FS_VERITY)		+= verity.o
+ext4-$(CONFIG_FS_ENCRYPTION)		+= crypto.o
diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
new file mode 100644
index 000000000000..e5413c0970ee
--- /dev/null
+++ b/fs/ext4/crypto.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/quotaops.h>
+
+#include "ext4.h"
+#include "xattr.h"
+#include "ext4_jbd2.h"
+
+static int ext4_get_context(struct inode *inode, void *ctx, size_t len)
+{
+	return ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
+				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT, ctx, len);
+}
+
+static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
+							void *fs_data)
+{
+	handle_t *handle = fs_data;
+	int res, res2, credits, retries = 0;
+
+	/*
+	 * Encrypting the root directory is not allowed because e2fsck expects
+	 * lost+found to exist and be unencrypted, and encrypting the root
+	 * directory would imply encrypting the lost+found directory as well as
+	 * the filename "lost+found" itself.
+	 */
+	if (inode->i_ino == EXT4_ROOT_INO)
+		return -EPERM;
+
+	if (WARN_ON_ONCE(IS_DAX(inode) && i_size_read(inode)))
+		return -EINVAL;
+
+	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
+		return -EOPNOTSUPP;
+
+	res = ext4_convert_inline_data(inode);
+	if (res)
+		return res;
+
+	/*
+	 * If a journal handle was specified, then the encryption context is
+	 * being set on a new inode via inheritance and is part of a larger
+	 * transaction to create the inode.  Otherwise the encryption context is
+	 * being set on an existing inode in its own transaction.  Only in the
+	 * latter case should the "retry on ENOSPC" logic be used.
+	 */
+
+	if (handle) {
+		res = ext4_xattr_set_handle(handle, inode,
+					    EXT4_XATTR_INDEX_ENCRYPTION,
+					    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
+					    ctx, len, 0);
+		if (!res) {
+			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
+			ext4_clear_inode_state(inode,
+					EXT4_STATE_MAY_INLINE_DATA);
+			/*
+			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
+			 * S_DAX may be disabled
+			 */
+			ext4_set_inode_flags(inode, false);
+		}
+		return res;
+	}
+
+	res = dquot_initialize(inode);
+	if (res)
+		return res;
+retry:
+	res = ext4_xattr_set_credits(inode, len, false /* is_create */,
+				     &credits);
+	if (res)
+		return res;
+
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, credits);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	res = ext4_xattr_set_handle(handle, inode, EXT4_XATTR_INDEX_ENCRYPTION,
+				    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
+				    ctx, len, 0);
+	if (!res) {
+		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
+		/*
+		 * Update inode->i_flags - S_ENCRYPTED will be enabled,
+		 * S_DAX may be disabled
+		 */
+		ext4_set_inode_flags(inode, false);
+		res = ext4_mark_inode_dirty(handle, inode);
+		if (res)
+			EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
+	}
+	res2 = ext4_journal_stop(handle);
+
+	if (res == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
+	if (!res)
+		res = res2;
+	return res;
+}
+
+static const union fscrypt_policy *ext4_get_dummy_policy(struct super_block *sb)
+{
+	return EXT4_SB(sb)->s_dummy_enc_policy.policy;
+}
+
+static bool ext4_has_stable_inodes(struct super_block *sb)
+{
+	return ext4_has_feature_stable_inodes(sb);
+}
+
+static void ext4_get_ino_and_lblk_bits(struct super_block *sb,
+				       int *ino_bits_ret, int *lblk_bits_ret)
+{
+	*ino_bits_ret = 8 * sizeof(EXT4_SB(sb)->s_es->s_inodes_count);
+	*lblk_bits_ret = 8 * sizeof(ext4_lblk_t);
+}
+
+const struct fscrypt_operations ext4_cryptops = {
+	.key_prefix		= "ext4:",
+	.get_context		= ext4_get_context,
+	.set_context		= ext4_set_context,
+	.get_dummy_policy	= ext4_get_dummy_policy,
+	.empty_dir		= ext4_empty_dir,
+	.has_stable_inodes	= ext4_has_stable_inodes,
+	.get_ino_and_lblk_bits	= ext4_get_ino_and_lblk_bits,
+};
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a743b1e3b89e..95d87641ad87 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2731,7 +2731,10 @@ extern int ext4_fname_setup_ci_filename(struct inode *dir,
 					 struct ext4_filename *fname);
 #endif
 
+/* ext4 encryption related stuff goes here crypto.c */
 #ifdef CONFIG_FS_ENCRYPTION
+extern const struct fscrypt_operations ext4_cryptops;
+
 static inline void ext4_fname_from_fscrypt_name(struct ext4_filename *dst,
 						const struct fscrypt_name *src)
 {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1847b46af808..e6cfd338712c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1492,128 +1492,6 @@ static int ext4_nfs_commit_metadata(struct inode *inode)
 	return ext4_write_inode(inode, &wbc);
 }
 
-#ifdef CONFIG_FS_ENCRYPTION
-static int ext4_get_context(struct inode *inode, void *ctx, size_t len)
-{
-	return ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
-				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT, ctx, len);
-}
-
-static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
-							void *fs_data)
-{
-	handle_t *handle = fs_data;
-	int res, res2, credits, retries = 0;
-
-	/*
-	 * Encrypting the root directory is not allowed because e2fsck expects
-	 * lost+found to exist and be unencrypted, and encrypting the root
-	 * directory would imply encrypting the lost+found directory as well as
-	 * the filename "lost+found" itself.
-	 */
-	if (inode->i_ino == EXT4_ROOT_INO)
-		return -EPERM;
-
-	if (WARN_ON_ONCE(IS_DAX(inode) && i_size_read(inode)))
-		return -EINVAL;
-
-	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
-		return -EOPNOTSUPP;
-
-	res = ext4_convert_inline_data(inode);
-	if (res)
-		return res;
-
-	/*
-	 * If a journal handle was specified, then the encryption context is
-	 * being set on a new inode via inheritance and is part of a larger
-	 * transaction to create the inode.  Otherwise the encryption context is
-	 * being set on an existing inode in its own transaction.  Only in the
-	 * latter case should the "retry on ENOSPC" logic be used.
-	 */
-
-	if (handle) {
-		res = ext4_xattr_set_handle(handle, inode,
-					    EXT4_XATTR_INDEX_ENCRYPTION,
-					    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
-					    ctx, len, 0);
-		if (!res) {
-			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
-			ext4_clear_inode_state(inode,
-					EXT4_STATE_MAY_INLINE_DATA);
-			/*
-			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
-			 * S_DAX may be disabled
-			 */
-			ext4_set_inode_flags(inode, false);
-		}
-		return res;
-	}
-
-	res = dquot_initialize(inode);
-	if (res)
-		return res;
-retry:
-	res = ext4_xattr_set_credits(inode, len, false /* is_create */,
-				     &credits);
-	if (res)
-		return res;
-
-	handle = ext4_journal_start(inode, EXT4_HT_MISC, credits);
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
-
-	res = ext4_xattr_set_handle(handle, inode, EXT4_XATTR_INDEX_ENCRYPTION,
-				    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
-				    ctx, len, 0);
-	if (!res) {
-		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
-		/*
-		 * Update inode->i_flags - S_ENCRYPTED will be enabled,
-		 * S_DAX may be disabled
-		 */
-		ext4_set_inode_flags(inode, false);
-		res = ext4_mark_inode_dirty(handle, inode);
-		if (res)
-			EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
-	}
-	res2 = ext4_journal_stop(handle);
-
-	if (res == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-		goto retry;
-	if (!res)
-		res = res2;
-	return res;
-}
-
-static const union fscrypt_policy *ext4_get_dummy_policy(struct super_block *sb)
-{
-	return EXT4_SB(sb)->s_dummy_enc_policy.policy;
-}
-
-static bool ext4_has_stable_inodes(struct super_block *sb)
-{
-	return ext4_has_feature_stable_inodes(sb);
-}
-
-static void ext4_get_ino_and_lblk_bits(struct super_block *sb,
-				       int *ino_bits_ret, int *lblk_bits_ret)
-{
-	*ino_bits_ret = 8 * sizeof(EXT4_SB(sb)->s_es->s_inodes_count);
-	*lblk_bits_ret = 8 * sizeof(ext4_lblk_t);
-}
-
-static const struct fscrypt_operations ext4_cryptops = {
-	.key_prefix		= "ext4:",
-	.get_context		= ext4_get_context,
-	.set_context		= ext4_set_context,
-	.get_dummy_policy	= ext4_get_dummy_policy,
-	.empty_dir		= ext4_empty_dir,
-	.has_stable_inodes	= ext4_has_stable_inodes,
-	.get_ino_and_lblk_bits	= ext4_get_ino_and_lblk_bits,
-};
-#endif
-
 #ifdef CONFIG_QUOTA
 static const char * const quotatypes[] = INITQFNAMES;
 #define QTYPE2NAME(t) (quotatypes[t])
-- 
2.31.1

