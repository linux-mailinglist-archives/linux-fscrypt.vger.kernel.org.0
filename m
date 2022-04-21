Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C375A5096A6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 07:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381649AbiDUF0b (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Apr 2022 01:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiDUF0b (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Apr 2022 01:26:31 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E567DFAB;
        Wed, 20 Apr 2022 22:23:42 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z16so3975440pfh.3;
        Wed, 20 Apr 2022 22:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ukkzC5rglV7fdpwJa+4gSQZ0vM4mRRWo6ddpHTdRkc0=;
        b=RN8RtVLcLlPGScmT/nyoxbzYpl76nbzCWM1Wz3Y8QzQHXYEVF1chq75mVodyGttCNX
         ML/L5XSboU+7+9q/lveSqX+bbsRikHkdqvnlVd8NBVPmoKaqje1KSruz5VLfkREd38kq
         cPHyfIxEDSQ0hM9EDKZQufCqVRMdeiaqTmlITOFVgAWXZaQVdrtsFjV0qOIP4KQzlV9n
         8MYA/iNhKvV1LzsMAcbfyUBEtmN2lYFXtqmvFx1+xFtebdfkmk3E80psRKcY0UfHMoya
         TU9DLXTDqoPLERl+wfrZYRyihjcWmlR7XPoDrNmCi1Vczxw0GnbLjWQip+dthUMx80r3
         I/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ukkzC5rglV7fdpwJa+4gSQZ0vM4mRRWo6ddpHTdRkc0=;
        b=dftghBQ42/yjw/mQuZiUBldTByLIsoFC4/gQSiY9QaBn1MDWTr7ZZcRsqvzZbsj0/z
         Crq4EQLseVw/uj+N7JaavyFFKvWZTfz0j7zpGaRcLS0HDPHze4Mrw7ZkkElvZtTeJ00D
         zZB+BVySgQ/hgjAVAmvSZ+VtJPKBx7lqg8FblapaSYCtXtc4Zx3VUaFVPcI1Nsfg4PHc
         UyYtfs5Mrx51CB67tAsvBFfu932A5UB0lMpjfxGTAwvNELyDeQ84nhShJFJe+R2a6+YA
         UZHpLpEd91+th1qkmpdKkm9MB0pwXqLZOZqOH9w5HJAFixhTKVREv8B64g+rOGaxdzjA
         tW1g==
X-Gm-Message-State: AOAM532bxM9DRvkQZ9ibfl3MdkqLGnEfAHFB/oNualgm5sEt1WDo3SKr
        4JF5KwAFxV2K6lT9WiAM883xWYLpGCs=
X-Google-Smtp-Source: ABdhPJwnDwxPR0lWKfmyrjf/V/ZExjpsu6V0tmvNcU7H2pagf5LXLGkloXnDX6aOmwA68vv2CJ9pFQ==
X-Received: by 2002:a05:6a00:3497:b0:50a:d54c:7de1 with SMTP id cp23-20020a056a00349700b0050ad54c7de1mr2716707pfb.52.1650518621676;
        Wed, 20 Apr 2022 22:23:41 -0700 (PDT)
Received: from localhost ([2406:7400:63:fca5:5639:1911:2ab6:cfe6])
        by smtp.gmail.com with ESMTPSA id w7-20020aa79547000000b0050ad0e82e6dsm2465805pfq.215.2022.04.20.22.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 22:23:41 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Ritesh Harjani <ritesh.list@gmail.com>
Subject: [RFC 2/6] ext4: Move ext4 crypto code to its own file ext4_crypto.c
Date:   Thu, 21 Apr 2022 10:53:18 +0530
Message-Id: <165505b3603b7e957acfa9a90f38455d5da530ae.1650517532.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1650517532.git.ritesh.list@gmail.com>
References: <cover.1650517532.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is to cleanup super.c file which has grown quite large.
So, start moving ext4 crypto related code to where it should be in the first
place i.e. fs/ext4/ext4_crypto.c

Signed-off-by: Ritesh Harjani <ritesh.list@gmail.com>
---
 fs/ext4/Makefile      |   1 +
 fs/ext4/ext4.h        |   3 +
 fs/ext4/ext4_crypto.c | 127 ++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c       | 122 ----------------------------------------
 4 files changed, 131 insertions(+), 122 deletions(-)
 create mode 100644 fs/ext4/ext4_crypto.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 7d89142e1421..b340fe5f849c 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -17,3 +17,4 @@ ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
 ext4-inode-test-objs			+= inode-test.o
 obj-$(CONFIG_EXT4_KUNIT_TESTS)		+= ext4-inode-test.o
 ext4-$(CONFIG_FS_VERITY)		+= verity.o
+ext4-$(CONFIG_FS_ENCRYPTION)		+= ext4_crypto.o
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1d79012c5a5b..8bac8af25ed8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2727,6 +2727,9 @@ extern int ext4_fname_setup_ci_filename(struct inode *dir,
 					 struct ext4_filename *fname);
 #endif
 
+/* ext4 encryption related stuff goes here ext4_crypto.c */
+extern const struct fscrypt_operations ext4_cryptops;
+
 #ifdef CONFIG_FS_ENCRYPTION
 static inline void ext4_fname_from_fscrypt_name(struct ext4_filename *dst,
 						const struct fscrypt_name *src)
diff --git a/fs/ext4/ext4_crypto.c b/fs/ext4/ext4_crypto.c
new file mode 100644
index 000000000000..e5413c0970ee
--- /dev/null
+++ b/fs/ext4/ext4_crypto.c
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
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ae98b07285d2..8bb5fa15a013 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1488,128 +1488,6 @@ static int ext4_nfs_commit_metadata(struct inode *inode)
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

