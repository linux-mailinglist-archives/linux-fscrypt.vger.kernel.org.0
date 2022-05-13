Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C065526D7A
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 May 2022 01:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiEMXX1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 May 2022 19:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiEMXX0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 May 2022 19:23:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DF02FDA06;
        Fri, 13 May 2022 16:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A543661898;
        Fri, 13 May 2022 23:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE84C3411A;
        Fri, 13 May 2022 23:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652484056;
        bh=EyKf7j3uVG38CtsPiz6Z+ffuEuCxBF8XO/5PoI3A4wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCPSywhblhgVP6TmsJZp1U4aRoeTYn1inyFmM03kvIOUL1+oia5WIehjVD7w+17G7
         7N/CaV9RdU77hxa3zxAjE57nFmSamo1D++PyK/q6wcCUzTqjP8FzyJOf8z8HGsP6OJ
         dRqSgyvi0oG7gbazaWUhBX+lPEq+IUtI31SdULjzMFY9JASqYSSsW0A+1QYv0rggxY
         Edpcvjx7i8T1iijOjnJ9EQjYx9ImcaqYrqcIyaxIlg9GN7cvM4IUKtErYLNcWVRK4u
         7xMVGo1PgDSd/VsZZLNohHfNfoN015UHofCBfnlauxGnib0Qhnajj8wZFsVgmhSuWy
         IoS49W75XC4EA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jeff Layton <jlayton@kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH v3 4/5] f2fs: use the updated test_dummy_encryption helper functions
Date:   Fri, 13 May 2022 16:16:04 -0700
Message-Id: <20220513231605.175121-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513231605.175121-1-ebiggers@kernel.org>
References: <20220513231605.175121-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/super.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 6f69491aa5731..c08cbe0dfcd85 100644
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
-- 
2.36.1

