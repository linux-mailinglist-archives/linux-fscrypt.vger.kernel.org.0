Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751305161E4
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 07:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240316AbiEAFQQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 01:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbiEAFQP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 01:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF655506F0;
        Sat, 30 Apr 2022 22:12:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BF06611AA;
        Sun,  1 May 2022 05:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A219EC385B2;
        Sun,  1 May 2022 05:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651381966;
        bh=nAmBt61GKAfsWjQfkolSXWscTvEpi56hFaS0lvkymzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHuEseytMNqKSviC9FuPd+k1bTCjEacx1KTn/1Fv2Q4hZs3WnN7urP3xit4Z7h+lQ
         QoTFJpdXGS1WWry4Qk6n/vofkicHjG6nR7QkIo3xnzVoNC99XjC9lo7QhGr7Ig+eWf
         Fi//JrXYD5+IBWhohGOfFwLIqwI55jFpUPFGNo2VZ5HGIaDEWH5DPCVXcf5KN+J3j8
         0Dx2J03UOgaewhIeRwNaXvpTxEn3s3e/qkzayiAfTDs4bSC7N9832/VTZfVsMX05O5
         XjFe7bnIypIenkmzZc48g5/6kHgszEe/srrmCj1M64ZXkR6f0NJmdlNyB08kFx/0u8
         gURKokmoAG1rg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Lukas Czerner <lczerner@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 1/7] ext4: only allow test_dummy_encryption when supported
Date:   Sat, 30 Apr 2022 22:08:51 -0700
Message-Id: <20220501050857.538984-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220501050857.538984-1-ebiggers@kernel.org>
References: <20220501050857.538984-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 fs/ext4/super.c | 59 +++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1466fbdbc8e34..64ce17714e193 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2427,11 +2427,12 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
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
@@ -2786,12 +2787,43 @@ static int ext4_check_quota_consistency(struct fs_context *fc,
 #endif
 }
 
+static int ext4_check_test_dummy_encryption(const struct fs_context *fc,
+					    struct super_block *sb)
+{
+	const struct ext4_fs_context *ctx = fc->fs_private;
+	const struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (!IS_ENABLED(CONFIG_FS_ENCRYPTION) ||
+	    !(ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION))
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
+	    !DUMMY_ENCRYPTION_ENABLED(sbi)) {
+		ext4_msg(NULL, KERN_WARNING,
+			 "Can't set test_dummy_encryption on remount");
+		return -EINVAL;
+	}
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
@@ -2821,20 +2853,9 @@ static int ext4_check_opt_consistency(struct fs_context *fc,
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
@@ -5279,12 +5300,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
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
2.36.0

