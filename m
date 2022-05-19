Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AE652DE92
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 22:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiESUpW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 May 2022 16:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243646AbiESUpV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 May 2022 16:45:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9E798597;
        Thu, 19 May 2022 13:45:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C35B4B82876;
        Thu, 19 May 2022 20:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C239C385B8;
        Thu, 19 May 2022 20:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652993117;
        bh=wEfZSj0RbI4Y9fCs1ylaMxzsYq2qlkESIR/ISPdqffU=;
        h=From:To:Cc:Subject:Date:From;
        b=Z1Wm7WrGtDadmYn1ek03D9lbhagJzYTun8vDNekAfZgw9m+OnbNlTUk09OLfNmiFe
         2kKEGqwnoL1ORJcsQE3DXDw8qskqzy2ucyQoW8cnYVKZ77xsOKcLGCZusUw8YGs2l7
         m3flJIOFMvWyD8z7IuXwqkPK4jK1sfnQCcPqLE6HDpuNlBpohpe1MiaiGvyCqnXE8M
         qPPtttO3/8Jq7uUz1BX0s2TPoQrOyZQ42ozMq6M+6TLU4CSrfdt31BVb8rFdmiF7Ro
         xzfsrdXKWQaipeBcU7Wh2c4flHbH4HMETB0ui3NqMrFmaByTSg5gI6xbnnG3fPJqLH
         g+y8bwfbOy/fw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v4] ext4: only allow test_dummy_encryption when supported
Date:   Thu, 19 May 2022 13:44:37 -0700
Message-Id: <20220519204437.61645-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make the test_dummy_encryption mount option require that the encrypt
feature flag be already enabled on the filesystem, rather than
automatically enabling it.  Practically, this means that "-O encrypt"
will need to be included in MKFS_OPTIONS when running xfstests with the
test_dummy_encryption mount option.  (ext4/053 also needs an update.)

Moreover, as long as the preconditions for test_dummy_encryption are
being tightened anyway, take the opportunity to start rejecting it when
!CONFIG_FS_ENCRYPTION rather than ignoring it.

The motivation for requiring the encrypt feature flag is that:

- Having the filesystem auto-enable feature flags is problematic, as it
  bypasses the usual sanity checks.  The specific issue which came up
  recently is that in kernel versions where ext4 supports casefold but
  not encrypt+casefold (v5.1 through v5.10), the kernel will happily add
  the encrypt flag to a filesystem that has the casefold flag, making it
  unmountable -- but only for subsequent mounts, not the initial one.
  This confused the casefold support detection in xfstests, causing
  generic/556 to fail rather than be skipped.

- The xfstests-bld test runners (kvm-xfstests et al.) already use the
  required mkfs flag, so they will not be affected by this change.  Only
  users of test_dummy_encryption alone will be affected.  But, this
  option has always been for testing only, so it should be fine to
  require that the few users of this option update their test scripts.

- f2fs already requires it (for its equivalent feature flag).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v4: Fixed an unused variable warning when !CONFIG_FS_ENCRYPTION, and
    removed DUMMY_ENCRYPTION_ENABLED() which is no longer used.

 fs/ext4/ext4.h  |  6 -----
 fs/ext4/super.c | 60 +++++++++++++++++++++++++++++++------------------
 2 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 797bc572d6fb3..e608c06980087 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1442,12 +1442,6 @@ struct ext4_super_block {
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_FS_ENCRYPTION
-#define DUMMY_ENCRYPTION_ENABLED(sbi) ((sbi)->s_dummy_enc_policy.policy != NULL)
-#else
-#define DUMMY_ENCRYPTION_ENABLED(sbi) (0)
-#endif
-
 /* Number of quota types we support */
 #define EXT4_MAXQUOTAS 3
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea8255a03305a..1ef85a3a2be9f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2430,11 +2430,12 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		ctx->spec |= EXT4_SPEC_DUMMY_ENCRYPTION;
 		ctx->test_dummy_enc_arg = kmemdup_nul(param->string, param->size,
 						      GFP_KERNEL);
+		return 0;
 #else
 		ext4_msg(NULL, KERN_WARNING,
-			 "Test dummy encryption mount option ignored");
+			 "test_dummy_encryption option not supported");
+		return -EINVAL;
 #endif
-		return 0;
 	case Opt_dax:
 	case Opt_dax_type:
 #ifdef CONFIG_FS_DAX
@@ -2791,12 +2792,44 @@ static int ext4_check_quota_consistency(struct fs_context *fc,
 #endif
 }
 
+static int ext4_check_test_dummy_encryption(const struct fs_context *fc,
+					    struct super_block *sb)
+{
+#ifdef CONFIG_FS_ENCRYPTION
+	const struct ext4_fs_context *ctx = fc->fs_private;
+	const struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (!(ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION))
+		return 0;
+
+	if (!ext4_has_feature_encrypt(sb)) {
+		ext4_msg(NULL, KERN_WARNING,
+			 "test_dummy_encryption requires encrypt feature");
+		return -EINVAL;
+	}
+	/*
+	 * This mount option is just for testing, and it's not worthwhile to
+	 * implement the extra complexity (e.g. RCU protection) that would be
+	 * needed to allow it to be set or changed during remount.  We do allow
+	 * it to be specified during remount, but only if there is no change.
+	 */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE &&
+	    !sbi->s_dummy_enc_policy.policy) {
+		ext4_msg(NULL, KERN_WARNING,
+			 "Can't set test_dummy_encryption on remount");
+		return -EINVAL;
+	}
+#endif /* CONFIG_FS_ENCRYPTION */
+	return 0;
+}
+
 static int ext4_check_opt_consistency(struct fs_context *fc,
 				      struct super_block *sb)
 {
 	struct ext4_fs_context *ctx = fc->fs_private;
 	struct ext4_sb_info *sbi = fc->s_fs_info;
 	int is_remount = fc->purpose == FS_CONTEXT_FOR_RECONFIGURE;
+	int err;
 
 	if ((ctx->opt_flags & MOPT_NO_EXT2) && IS_EXT2_SB(sb)) {
 		ext4_msg(NULL, KERN_ERR,
@@ -2826,20 +2859,9 @@ static int ext4_check_opt_consistency(struct fs_context *fc,
 				 "for blocksize < PAGE_SIZE");
 	}
 
-#ifdef CONFIG_FS_ENCRYPTION
-	/*
-	 * This mount option is just for testing, and it's not worthwhile to
-	 * implement the extra complexity (e.g. RCU protection) that would be
-	 * needed to allow it to be set or changed during remount.  We do allow
-	 * it to be specified during remount, but only if there is no change.
-	 */
-	if ((ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION) &&
-	    is_remount && !sbi->s_dummy_enc_policy.policy) {
-		ext4_msg(NULL, KERN_WARNING,
-			 "Can't set test_dummy_encryption on remount");
-		return -1;
-	}
-#endif
+	err = ext4_check_test_dummy_encryption(fc, sb);
+	if (err)
+		return err;
 
 	if ((ctx->spec & EXT4_SPEC_DATAJ) && is_remount) {
 		if (!sbi->s_journal) {
@@ -5285,12 +5307,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		goto failed_mount_wq;
 	}
 
-	if (DUMMY_ENCRYPTION_ENABLED(sbi) && !sb_rdonly(sb) &&
-	    !ext4_has_feature_encrypt(sb)) {
-		ext4_set_feature_encrypt(sb);
-		ext4_commit_super(sb);
-	}
-
 	/*
 	 * Get the # of file system overhead blocks from the
 	 * superblock if present.
-- 
2.36.1

