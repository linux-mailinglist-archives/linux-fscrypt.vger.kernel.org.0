Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E2C5349A0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 May 2022 06:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbiEZEFD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 26 May 2022 00:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344644AbiEZEFB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 26 May 2022 00:05:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0288C0397;
        Wed, 25 May 2022 21:04:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C18AB81F3B;
        Thu, 26 May 2022 04:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1937C385B8;
        Thu, 26 May 2022 04:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653537897;
        bh=wKDEGt+5Ot1O94WMY1k8OTrln4I2jliCqQ29bqoAWv8=;
        h=From:To:Cc:Subject:Date:From;
        b=M1vInzyoEYrQET/xWbLJGjHTIOCPO8XMiSM/8TNOPAuvp9nmxcmY5Yt8gEHMED+r9
         0jedzeBkUQO7rIo32unMtPjUseqiiPRZkNOHNpsvoF0bCqC2DCmtzF0Uq0jZ+PEq6F
         PQojtauZ87nkN9U8B1WtnFlVU7bJjM9/8MTZzIvkD8ifJIftCEtwtWSqjbq3IhohVy
         j+TWhJok8YZo0W5GG/L5sg5QZZyofuXr003DNGzLgJj5nNXyK+vyhnNnKN2Zf0Xdq+
         /0D5M8nnR5ycDa0aan69cUMr8cVQVFK02cwEA9bTeOp40/QPPyrVr4zuZClIt9NPWo
         I+4IaWEdrqAQQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc:     linux-fscrypt@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCH v4] ext4: fix up test_dummy_encryption handling for new mount API
Date:   Wed, 25 May 2022 21:04:12 -0700
Message-Id: <20220526040412.173025-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since ext4 was converted to the new mount API, the test_dummy_encryption
mount option isn't being handled entirely correctly, because the needed
fscrypt_set_test_dummy_encryption() helper function combines
parsing/checking/applying into one function.  That doesn't work well
with the new mount API, which split these into separate steps.

This was sort of okay anyway, due to the parsing logic that was copied
from fscrypt_set_test_dummy_encryption() into ext4_parse_param(),
combined with an additional check in ext4_check_test_dummy_encryption().
However, these overlooked the case of changing the value of
test_dummy_encryption on remount, which isn't allowed but ext4 wasn't
detecting until ext4_apply_options() when it's too late to fail.
Another bug is that if test_dummy_encryption was specified multiple
times with an argument, memory was leaked.

Fix this up properly by using the new helper functions that allow
splitting up the parse/check/apply steps for test_dummy_encryption.

Fixes: cebe85d570cf ("ext4: switch to the new mount api")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v4: rebased onto upstream.
v3: fixed a couple bugs.

 fs/ext4/super.c | 134 +++++++++++++++++++++++++-----------------------
 1 file changed, 71 insertions(+), 63 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 450c918d68fcf..f4ba3eed42a6f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -87,7 +87,7 @@ static struct inode *ext4_get_journal_inode(struct super_block *sb,
 static int ext4_validate_options(struct fs_context *fc);
 static int ext4_check_opt_consistency(struct fs_context *fc,
 				      struct super_block *sb);
-static int ext4_apply_options(struct fs_context *fc, struct super_block *sb);
+static void ext4_apply_options(struct fs_context *fc, struct super_block *sb);
 static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param);
 static int ext4_get_tree(struct fs_context *fc);
 static int ext4_reconfigure(struct fs_context *fc);
@@ -1870,31 +1870,12 @@ ext4_sb_read_encoding(const struct ext4_super_block *es)
 }
 #endif
 
-static int ext4_set_test_dummy_encryption(struct super_block *sb, char *arg)
-{
-#ifdef CONFIG_FS_ENCRYPTION
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	int err;
-
-	err = fscrypt_set_test_dummy_encryption(sb, arg,
-						&sbi->s_dummy_enc_policy);
-	if (err) {
-		ext4_msg(sb, KERN_WARNING,
-			 "Error while setting test dummy encryption [%d]", err);
-		return err;
-	}
-	ext4_msg(sb, KERN_WARNING, "Test dummy encryption mode enabled");
-#endif
-	return 0;
-}
-
 #define EXT4_SPEC_JQUOTA			(1 <<  0)
 #define EXT4_SPEC_JQFMT				(1 <<  1)
 #define EXT4_SPEC_DATAJ				(1 <<  2)
 #define EXT4_SPEC_SB_BLOCK			(1 <<  3)
 #define EXT4_SPEC_JOURNAL_DEV			(1 <<  4)
 #define EXT4_SPEC_JOURNAL_IOPRIO		(1 <<  5)
-#define EXT4_SPEC_DUMMY_ENCRYPTION		(1 <<  6)
 #define EXT4_SPEC_s_want_extra_isize		(1 <<  7)
 #define EXT4_SPEC_s_max_batch_time		(1 <<  8)
 #define EXT4_SPEC_s_min_batch_time		(1 <<  9)
@@ -1911,7 +1892,7 @@ static int ext4_set_test_dummy_encryption(struct super_block *sb, char *arg)
 
 struct ext4_fs_context {
 	char		*s_qf_names[EXT4_MAXQUOTAS];
-	char		*test_dummy_enc_arg;
+	struct fscrypt_dummy_policy dummy_enc_policy;
 	int		s_jquota_fmt;	/* Format of quota to use */
 #ifdef CONFIG_EXT4_DEBUG
 	int s_fc_debug_max_replay;
@@ -1953,7 +1934,7 @@ static void ext4_fc_free(struct fs_context *fc)
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
 		kfree(ctx->s_qf_names[i]);
 
-	kfree(ctx->test_dummy_enc_arg);
+	fscrypt_free_dummy_policy(&ctx->dummy_enc_policy);
 	kfree(ctx);
 }
 
@@ -2029,6 +2010,29 @@ static int unnote_qf_name(struct fs_context *fc, int qtype)
 }
 #endif
 
+static int ext4_parse_test_dummy_encryption(const struct fs_parameter *param,
+					    struct ext4_fs_context *ctx)
+{
+	int err;
+
+	if (!IS_ENABLED(CONFIG_FS_ENCRYPTION)) {
+		ext4_msg(NULL, KERN_WARNING,
+			 "test_dummy_encryption option not supported");
+		return -EINVAL;
+	}
+	err = fscrypt_parse_test_dummy_encryption(param,
+						  &ctx->dummy_enc_policy);
+	if (err == -EINVAL) {
+		ext4_msg(NULL, KERN_WARNING,
+			 "Value of option \"%s\" is unrecognized", param->key);
+	} else if (err == -EEXIST) {
+		ext4_msg(NULL, KERN_WARNING,
+			 "Conflicting test_dummy_encryption options");
+		return -EINVAL;
+	}
+	return err;
+}
+
 #define EXT4_SET_CTX(name)						\
 static inline void ctx_set_##name(struct ext4_fs_context *ctx,		\
 				  unsigned long flag)			\
@@ -2291,29 +2295,7 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		ctx->spec |= EXT4_SPEC_JOURNAL_IOPRIO;
 		return 0;
 	case Opt_test_dummy_encryption:
-#ifdef CONFIG_FS_ENCRYPTION
-		if (param->type == fs_value_is_flag) {
-			ctx->spec |= EXT4_SPEC_DUMMY_ENCRYPTION;
-			ctx->test_dummy_enc_arg = NULL;
-			return 0;
-		}
-		if (*param->string &&
-		    !(!strcmp(param->string, "v1") ||
-		      !strcmp(param->string, "v2"))) {
-			ext4_msg(NULL, KERN_WARNING,
-				 "Value of option \"%s\" is unrecognized",
-				 param->key);
-			return -EINVAL;
-		}
-		ctx->spec |= EXT4_SPEC_DUMMY_ENCRYPTION;
-		ctx->test_dummy_enc_arg = kmemdup_nul(param->string, param->size,
-						      GFP_KERNEL);
-		return 0;
-#else
-		ext4_msg(NULL, KERN_WARNING,
-			 "test_dummy_encryption option not supported");
-		return -EINVAL;
-#endif
+		return ext4_parse_test_dummy_encryption(param, ctx);
 	case Opt_dax:
 	case Opt_dax_type:
 #ifdef CONFIG_FS_DAX
@@ -2504,7 +2486,8 @@ static int parse_apply_sb_mount_options(struct super_block *sb,
 	if (s_ctx->spec & EXT4_SPEC_JOURNAL_IOPRIO)
 		m_ctx->journal_ioprio = s_ctx->journal_ioprio;
 
-	ret = ext4_apply_options(fc, sb);
+	ext4_apply_options(fc, sb);
+	ret = 0;
 
 out_free:
 	if (fc) {
@@ -2673,11 +2656,11 @@ static int ext4_check_quota_consistency(struct fs_context *fc,
 static int ext4_check_test_dummy_encryption(const struct fs_context *fc,
 					    struct super_block *sb)
 {
-#ifdef CONFIG_FS_ENCRYPTION
 	const struct ext4_fs_context *ctx = fc->fs_private;
 	const struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int err;
 
-	if (!(ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION))
+	if (!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy))
 		return 0;
 
 	if (!ext4_has_feature_encrypt(sb)) {
@@ -2691,14 +2674,46 @@ static int ext4_check_test_dummy_encryption(const struct fs_context *fc,
 	 * needed to allow it to be set or changed during remount.  We do allow
 	 * it to be specified during remount, but only if there is no change.
 	 */
-	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE &&
-	    !sbi->s_dummy_enc_policy.policy) {
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
+		if (fscrypt_dummy_policies_equal(&sbi->s_dummy_enc_policy,
+						 &ctx->dummy_enc_policy))
+			return 0;
 		ext4_msg(NULL, KERN_WARNING,
-			 "Can't set test_dummy_encryption on remount");
+			 "Can't set or change test_dummy_encryption on remount");
 		return -EINVAL;
 	}
-#endif /* CONFIG_FS_ENCRYPTION */
-	return 0;
+	/* Also make sure s_mount_opts didn't contain a conflicting value. */
+	if (fscrypt_is_dummy_policy_set(&sbi->s_dummy_enc_policy)) {
+		if (fscrypt_dummy_policies_equal(&sbi->s_dummy_enc_policy,
+						 &ctx->dummy_enc_policy))
+			return 0;
+		ext4_msg(NULL, KERN_WARNING,
+			 "Conflicting test_dummy_encryption options");
+		return -EINVAL;
+	}
+	/*
+	 * fscrypt_add_test_dummy_key() technically changes the super_block, so
+	 * technically it should be delayed until ext4_apply_options() like the
+	 * other changes.  But since we never get here for remounts (see above),
+	 * and this is the last chance to report errors, we do it here.
+	 */
+	err = fscrypt_add_test_dummy_key(sb, &ctx->dummy_enc_policy);
+	if (err)
+		ext4_msg(NULL, KERN_WARNING,
+			 "Error adding test dummy encryption key [%d]", err);
+	return err;
+}
+
+static void ext4_apply_test_dummy_encryption(struct ext4_fs_context *ctx,
+					     struct super_block *sb)
+{
+	if (!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy) ||
+	    /* if already set, it was already verified to be the same */
+	    fscrypt_is_dummy_policy_set(&EXT4_SB(sb)->s_dummy_enc_policy))
+		return;
+	EXT4_SB(sb)->s_dummy_enc_policy = ctx->dummy_enc_policy;
+	memset(&ctx->dummy_enc_policy, 0, sizeof(ctx->dummy_enc_policy));
+	ext4_msg(sb, KERN_WARNING, "Test dummy encryption mode enabled");
 }
 
 static int ext4_check_opt_consistency(struct fs_context *fc,
@@ -2785,11 +2800,10 @@ static int ext4_check_opt_consistency(struct fs_context *fc,
 	return ext4_check_quota_consistency(fc, sb);
 }
 
-static int ext4_apply_options(struct fs_context *fc, struct super_block *sb)
+static void ext4_apply_options(struct fs_context *fc, struct super_block *sb)
 {
 	struct ext4_fs_context *ctx = fc->fs_private;
 	struct ext4_sb_info *sbi = fc->s_fs_info;
-	int ret = 0;
 
 	sbi->s_mount_opt &= ~ctx->mask_s_mount_opt;
 	sbi->s_mount_opt |= ctx->vals_s_mount_opt;
@@ -2825,11 +2839,7 @@ static int ext4_apply_options(struct fs_context *fc, struct super_block *sb)
 #endif
 
 	ext4_apply_quota_options(fc, sb);
-
-	if (ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION)
-		ret = ext4_set_test_dummy_encryption(sb, ctx->test_dummy_enc_arg);
-
-	return ret;
+	ext4_apply_test_dummy_encryption(ctx, sb);
 }
 
 
@@ -4552,9 +4562,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	if (err < 0)
 		goto failed_mount;
 
-	err = ext4_apply_options(fc, sb);
-	if (err < 0)
-		goto failed_mount;
+	ext4_apply_options(fc, sb);
 
 #if IS_ENABLED(CONFIG_UNICODE)
 	if (ext4_has_feature_casefold(sb) && !sb->s_encoding) {

base-commit: babf0bb978e3c9fce6c4eba6b744c8754fd43d8e
-- 
2.36.1

