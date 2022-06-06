Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D7753F22A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Jun 2022 00:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiFFWdj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Jun 2022 18:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbiFFWdi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Jun 2022 18:33:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBF7403C9
        for <linux-fscrypt@vger.kernel.org>; Mon,  6 Jun 2022 15:33:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48F84B81C1E
        for <linux-fscrypt@vger.kernel.org>; Mon,  6 Jun 2022 22:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9314C385A9;
        Mon,  6 Jun 2022 22:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654554815;
        bh=WcJjpRc7XzfSJON+fPuBoWVagfFjcoKPqQP19/5+bv8=;
        h=From:To:Cc:Subject:Date:From;
        b=NNiodLz/m6Zi8KxGG3tTKJSrlfBGdMozhDOIBYGnihFrBGavCwheeMQFPWfuih+dw
         mc77Rjl5Lgevb/VXycaaQk8srrnmnFl3PxcLiMJHCK02BoM+tbZvodVclp09RR9Yba
         leJ3Fx1JirygvSNsXJBMLBQuhBZrFq4/6N2QecdJ8PPL4ZQG4tWQstc8UCdh/aYJ5Q
         MXTN8LMzN9YOSKtOfYqXsCuz6WB6CJD47DW5FV5rEFSWKw74+bdrQWFaxP+DsXp2NL
         96HvspR+g3f/wQmr9ntQRWV3d9s/fEgkEgthf53MdAZQvzklmvYCNHGoSmjRTDVcKD
         SQGPK/Ch7FJBA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org, Chao Yu <chao@kernel.org>
Subject: [PATCH RESEND v3] f2fs: use the updated test_dummy_encryption helper functions
Date:   Mon,  6 Jun 2022 15:32:41 -0700
Message-Id: <20220606223241.12497-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Switch f2fs over to the functions that are replacing
fscrypt_set_test_dummy_encryption().  Since f2fs hasn't been converted
to the new mount API yet, this doesn't really provide a benefit for
f2fs.  But it allows fscrypt_set_test_dummy_encryption() to be removed.

Also take the opportunity to eliminate an #ifdef.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Resending this since its prerequisites are upstream now.

 fs/f2fs/super.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 37221e94e5eff..3112fe92f9342 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/fs_context.h>
 #include <linux/sched/mm.h>
 #include <linux/statfs.h>
 #include <linux/buffer_head.h>
@@ -492,9 +493,19 @@ static int f2fs_set_test_dummy_encryption(struct super_block *sb,
 					  bool is_remount)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
-#ifdef CONFIG_FS_ENCRYPTION
+	struct fs_parameter param = {
+		.type = fs_value_is_string,
+		.string = arg->from ? arg->from : "",
+	};
+	struct fscrypt_dummy_policy *policy =
+		&F2FS_OPTION(sbi).dummy_enc_policy;
 	int err;
 
+	if (!IS_ENABLED(CONFIG_FS_ENCRYPTION)) {
+		f2fs_warn(sbi, "test_dummy_encryption option not supported");
+		return -EINVAL;
+	}
+
 	if (!f2fs_sb_has_encrypt(sbi)) {
 		f2fs_err(sbi, "Encrypt feature is off");
 		return -EINVAL;
@@ -506,12 +517,12 @@ static int f2fs_set_test_dummy_encryption(struct super_block *sb,
 	 * needed to allow it to be set or changed during remount.  We do allow
 	 * it to be specified during remount, but only if there is no change.
 	 */
-	if (is_remount && !F2FS_OPTION(sbi).dummy_enc_policy.policy) {
+	if (is_remount && !fscrypt_is_dummy_policy_set(policy)) {
 		f2fs_warn(sbi, "Can't set test_dummy_encryption on remount");
 		return -EINVAL;
 	}
-	err = fscrypt_set_test_dummy_encryption(
-		sb, arg->from, &F2FS_OPTION(sbi).dummy_enc_policy);
+
+	err = fscrypt_parse_test_dummy_encryption(&param, policy);
 	if (err) {
 		if (err == -EEXIST)
 			f2fs_warn(sbi,
@@ -524,12 +535,14 @@ static int f2fs_set_test_dummy_encryption(struct super_block *sb,
 				  opt, err);
 		return -EINVAL;
 	}
+	err = fscrypt_add_test_dummy_key(sb, policy);
+	if (err) {
+		f2fs_warn(sbi, "Error adding test dummy encryption key [%d]",
+			  err);
+		return err;
+	}
 	f2fs_warn(sbi, "Test dummy encryption mode enabled");
 	return 0;
-#else
-	f2fs_warn(sbi, "test_dummy_encryption option not supported");
-	return -EINVAL;
-#endif
 }
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
2.36.1

