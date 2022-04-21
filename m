Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811F750A83E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 20:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391446AbiDUSno (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Apr 2022 14:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391466AbiDUSnn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Apr 2022 14:43:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587C34BBA0;
        Thu, 21 Apr 2022 11:40:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 50B2FCE21D6;
        Thu, 21 Apr 2022 18:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8031EC385A1;
        Thu, 21 Apr 2022 18:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650566448;
        bh=bqfDAlB2qWMQr4K+hYhzd46IuJygLM7kUryMw0OsNF4=;
        h=From:To:Cc:Subject:Date:From;
        b=JcwxVzuKlIMXJXc3b42/7vdTY67+dX/MbBPEMtOWLBoyGEdZIOA4nHPonq23TUlKK
         rXND0jqNAwxqWsBZtwOdWFN5cwx5+qK+vmPHRcfVh2XQ6nOZ9RkoiecKgAYAHlDjBL
         4vlgSWML8feu7wvhGoik/g4/Td3MFYpDgOHdbQFm94v4VU0UyqmBr/H2f12xeZidQG
         6TnUdp1Dvl0ewrJHJHx6regX2sbMeo5IgWPb+xR/V+xPun6y9TQkw5AU4C64bLJ1Q0
         M6B+kXB/eikU+p3bD8XBxe2ezwhbZiuIU2HGodr45zTZx1EzDCSFDJ+cVkaPvlo6Ad
         wHL7JaE9TTXNQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] ext4: make test_dummy_encryption require the encrypt feature
Date:   Thu, 21 Apr 2022 11:40:40 -0700
Message-Id: <20220421184040.173802-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.2
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
test_dummy_encryption mount option.

The motivation for this is that:

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

- f2fs already requires this.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/super.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 81749eaddf4c1..420eb29183eb4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2817,17 +2817,24 @@ static int ext4_check_opt_consistency(struct fs_context *fc,
 	}
 
 #ifdef CONFIG_FS_ENCRYPTION
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
+	if (ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION) {
+		if (!ext4_has_feature_encrypt(sb)) {
+			ext4_msg(NULL, KERN_WARNING,
+				 "test_dummy_encryption requires encrypt feature");
+			return -EINVAL;
+		}
+		/*
+		 * This mount option is just for testing, and it's not
+		 * worthwhile to implement the extra complexity (e.g. RCU
+		 * protection) that would be needed to allow it to be set or
+		 * changed during remount.  We do allow it to be specified
+		 * during remount, but only if there is no change.
+		 */
+		if (is_remount && !sbi->s_dummy_enc_policy.policy) {
+			ext4_msg(NULL, KERN_WARNING,
+				 "Can't set test_dummy_encryption on remount");
+			return -1;
+		}
 	}
 #endif
 
@@ -5272,12 +5279,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
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

base-commit: b2d229d4ddb17db541098b83524d901257e93845
-- 
2.35.2

