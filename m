Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6CE52734C
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 May 2022 19:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiENRXF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 14 May 2022 13:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiENRXE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 14 May 2022 13:23:04 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBB8B47;
        Sat, 14 May 2022 10:23:03 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c14so10419882pfn.2;
        Sat, 14 May 2022 10:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZtorijWtGeqsjcvr/gQHDZ+uw73+I7h2d4Z+6J5lltE=;
        b=EaRmZdEz1a3iBXZ0qItXLXRb5yNBcR20hNtRphT/SnDYr6IpSXEJq6tGAu9/mCzFo0
         fpVBnU/LO4+TrtMxCPLwzik1kaiEQJS/DO/5w0J6kns8CnDBgzsC9mR5ZWeEYSDnOUU/
         EGREgakMV1xq8bucDMBz/t5Av765fvTdHA99M7xrlliSf08W6f+JypCmnJ2Bi7G4tvLU
         eT5lHe4v7syX31K12m9ybFy/bTWJT3TUWsqNVawrD3fJ9TuJreQP3Xd9cW2ofmq4AZjG
         XymlQN/V2lqesaptq2ybpNwXP/80O2c5MWrWyUee5jf0bFPlDS9+HZgUu+b3y/CpTxbs
         BFwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZtorijWtGeqsjcvr/gQHDZ+uw73+I7h2d4Z+6J5lltE=;
        b=2i6idzAELRnTCh9ZU5FogDx4QccX8F79d0q8xxLTeMUhP/NcxkfE6NZpQXBv9twr7j
         s7UMDN5/XG/wIH8WK92rkAwLsXdhddlcaC5nbdT5Enr7rijEsAstuslfb6IF0w60K4ww
         LMHkP3KLS9W4EHuL2NOeGxYclmmaefSHK0E0Xl+PkZlgdKAn0AMSv4KGj6Ktu7Yndps0
         r55IcWC0lTT+cRQuV0rqb7YIL7Tg7JbSqi3UbFyIaN+gePIR3u3sCyH0Du/VrHkRlzgE
         TeL04waQsR28sRHX+bXjAYHyvh+T/kyc1lDy6BJ0apZiqPhvTx5gWgVjAyHQ3q3lJxf9
         uArw==
X-Gm-Message-State: AOAM531b2vkQ8QB26dHzWQZDhzjKDblYivtUx0/Acwh32Z4Fyt3d2jEC
        nU0LOXIoPafsBfgJdsXE4iIR30/noS0=
X-Google-Smtp-Source: ABdhPJxiES+c1XmUcgTcard16jYTHrZT2FLjQ6ozl/SAM7vIGFP6zCF3g/LJqTd/ulBQRbFTp8wJYg==
X-Received: by 2002:a63:4e62:0:b0:398:cb40:19b0 with SMTP id o34-20020a634e62000000b00398cb4019b0mr8650058pgl.445.1652548983117;
        Sat, 14 May 2022 10:23:03 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id a30-20020a62d41e000000b0050dc7628130sm3949814pfh.10.2022.05.14.10.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 10:23:02 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCHv2 1/3] ext4: Move ext4 crypto code to its own file crypto.c
Date:   Sat, 14 May 2022 22:52:46 +0530
Message-Id: <4f6b9ff4411ced6591f858119feb025300ecf918.1652539361.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1652539361.git.ritesh.list@gmail.com>
References: <cover.1652539361.git.ritesh.list@gmail.com>
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
index a743b1e3b89e..9100f0ba4a52 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2731,6 +2731,9 @@ extern int ext4_fname_setup_ci_filename(struct inode *dir,
 					 struct ext4_filename *fname);
 #endif
 
+/* ext4 encryption related stuff goes here crypto.c */
+extern const struct fscrypt_operations ext4_cryptops;
+
 #ifdef CONFIG_FS_ENCRYPTION
 static inline void ext4_fname_from_fscrypt_name(struct ext4_filename *dst,
 						const struct fscrypt_name *src)
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

