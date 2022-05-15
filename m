Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3BA527614
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 May 2022 08:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiEOGiM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 May 2022 02:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbiEOGiL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 May 2022 02:38:11 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AA218E37;
        Sat, 14 May 2022 23:38:10 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id pt3-20020a17090b3d0300b001df448c8d79so330123pjb.5;
        Sat, 14 May 2022 23:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LwYuF5xIH53xMVZydLNJzfYcgCPRV/iJZtHYFDn0/eE=;
        b=S4KvdvVHGltI+dF9SV3qEFGN39uTF/Qcvxbrr0ZO2KExIYLts3iuPKbdO2XBrRoIlG
         O45g+hMi6RM4ffvn9HKYWlGgK6bd8D2ouhDu0Zoz8rUt3bdv6oZINyNEjqrpN34q4wqP
         9qcDWEK1T5y3QnTl66WFNONw6+m9kw0PgyrB4JVtwt18PVi+qXKcXAXrqAeqL1Zhw1kR
         FP1xTuoNwYtbjBW6q1XjzUqR4fsYi+fjIRPDAaFKhCtpHiyFaUyriHzFD31G/Pha8Ubb
         FmE1L3XhYBAXhGT8Uk+xPXAlPDzbdRJePxhWful7YDDq/6FWOK70sAb8nVWqcfnRhk10
         LWDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LwYuF5xIH53xMVZydLNJzfYcgCPRV/iJZtHYFDn0/eE=;
        b=3MRdOYIRA17CLOmLbH3+FU1e505P9GLrBi8Sm577by1RxWMfTYo/EuAo/Al1AnmUcj
         wOIW4i3gFuT+X4NJKrdwUMVit9PHSgXJ/dyl0FtywdSJc/23nJig92wboRFXrzVrCKQa
         wl1xGqo+Yoxim/Np6klXHNayNNVOOtV4QZBtSidqBPh4DDpoYdP6VdNPWCQjv4LqNCBj
         3Pg3AfkvW7dVSu+IzPzQVSpLTqkIXSGzDGBf2SGMsIZf/afi65ei3CiR6fs8XmV7kyu+
         AWZDbnckxMV/s99rR3YNR6jHZdzHe5lFGGkdsxGhv5HoR4RXM2rQ0075TXcQHRr7UpEX
         Bm7g==
X-Gm-Message-State: AOAM530SiC0fzfiPxfA9/7ExkiUwV1EHgAQoj4dY82SnYVivyAVMGKI/
        lGxdsXzRjjuQ2Ny8bMVDJlgbc8ovhyI=
X-Google-Smtp-Source: ABdhPJzMMGuOgG1LyAvsj2OXWLJWekiaS1E0cCV6o+DN9n+gbkcC80DSQEflAC3cK+Odl4cqmA5JgA==
X-Received: by 2002:a17:902:ed82:b0:158:fef8:b501 with SMTP id e2-20020a170902ed8200b00158fef8b501mr11830702plj.47.1652596689735;
        Sat, 14 May 2022 23:38:09 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id n10-20020aa7984a000000b0050dc76281d1sm4636246pfq.171.2022.05.14.23.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 23:38:09 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCHv3 3/3] ext4: Refactor and move ext4_ioctl_get_encryption_pwsalt()
Date:   Sun, 15 May 2022 12:07:48 +0530
Message-Id: <5af98b17152a96b245b4f7d2dfb8607fc93e36aa.1652595565.git.ritesh.list@gmail.com>
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

This patch move code for FS_IOC_GET_ENCRYPTION_PWSALT case into
ext4's crypto.c file, i.e. ext4_ioctl_get_encryption_pwsalt()
and uuid_is_zero(). This is mostly refactoring logic and should
not affect any functionality change.

Suggested-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ritesh Harjani <ritesh.list@gmail.com>
---
 fs/ext4/crypto.c | 54 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   |  8 +++++++
 fs/ext4/ioctl.c  | 59 ++----------------------------------------------
 3 files changed, 64 insertions(+), 57 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index f8333927f0f6..e20ac0654b3f 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0

 #include <linux/quotaops.h>
+#include <linux/uuid.h>

 #include "ext4.h"
 #include "xattr.h"
@@ -71,6 +72,59 @@ void ext4_fname_free_filename(struct ext4_filename *fname)
 #endif
 }

+static bool uuid_is_zero(__u8 u[16])
+{
+	int i;
+
+	for (i = 0; i < 16; i++)
+		if (u[i])
+			return false;
+	return true;
+}
+
+int ext4_ioctl_get_encryption_pwsalt(struct file *filp, void __user *arg)
+{
+	struct super_block *sb = file_inode(filp)->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int err, err2;
+	handle_t *handle;
+
+	if (!ext4_has_feature_encrypt(sb))
+		return -EOPNOTSUPP;
+
+	if (uuid_is_zero(sbi->s_es->s_encrypt_pw_salt)) {
+		err = mnt_want_write_file(filp);
+		if (err)
+			return err;
+		handle = ext4_journal_start_sb(sb, EXT4_HT_MISC, 1);
+		if (IS_ERR(handle)) {
+			err = PTR_ERR(handle);
+			goto pwsalt_err_exit;
+		}
+		err = ext4_journal_get_write_access(handle, sb, sbi->s_sbh,
+						    EXT4_JTR_NONE);
+		if (err)
+			goto pwsalt_err_journal;
+		lock_buffer(sbi->s_sbh);
+		generate_random_uuid(sbi->s_es->s_encrypt_pw_salt);
+		ext4_superblock_csum_set(sb);
+		unlock_buffer(sbi->s_sbh);
+		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
+pwsalt_err_journal:
+		err2 = ext4_journal_stop(handle);
+		if (err2 && !err)
+			err = err2;
+pwsalt_err_exit:
+		mnt_drop_write_file(filp);
+		if (err)
+			return err;
+	}
+
+	if (copy_to_user(arg, sbi->s_es->s_encrypt_pw_salt, 16))
+		return -EFAULT;
+	return 0;
+}
+
 static int ext4_get_context(struct inode *inode, void *ctx, size_t len)
 {
 	return ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3c474c9623af..ec859b42dafd 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2743,6 +2743,8 @@ int ext4_fname_prepare_lookup(struct inode *dir, struct dentry *dentry,

 void ext4_fname_free_filename(struct ext4_filename *fname);

+int ext4_ioctl_get_encryption_pwsalt(struct file *filp, void __user *arg);
+
 #else /* !CONFIG_FS_ENCRYPTION */
 static inline int ext4_fname_setup_filename(struct inode *dir,
 					    const struct qstr *iname,
@@ -2775,6 +2777,12 @@ static inline void ext4_fname_free_filename(struct ext4_filename *fname)
 	fname->cf_name.name = NULL;
 #endif
 }
+
+static inline int ext4_ioctl_get_encryption_pwsalt(struct file *filp,
+						   void __user *arg)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* !CONFIG_FS_ENCRYPTION */

 /* dir.c */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index ba44fa1be70a..d8639aaed3f6 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -16,7 +16,6 @@
 #include <linux/file.h>
 #include <linux/quotaops.h>
 #include <linux/random.h>
-#include <linux/uuid.h>
 #include <linux/uaccess.h>
 #include <linux/delay.h>
 #include <linux/iversion.h>
@@ -504,18 +503,6 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	return err;
 }

-#ifdef CONFIG_FS_ENCRYPTION
-static int uuid_is_zero(__u8 u[16])
-{
-	int	i;
-
-	for (i = 0; i < 16; i++)
-		if (u[i])
-			return 0;
-	return 1;
-}
-#endif
-
 /*
  * If immutable is set and we are not clearing it, we're not allowed to change
  * anything else in the inode.  Don't error out if we're only trying to set
@@ -1432,51 +1419,9 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return -EOPNOTSUPP;
 		return fscrypt_ioctl_set_policy(filp, (const void __user *)arg);

-	case FS_IOC_GET_ENCRYPTION_PWSALT: {
-#ifdef CONFIG_FS_ENCRYPTION
-		int err, err2;
-		struct ext4_sb_info *sbi = EXT4_SB(sb);
-		handle_t *handle;
+	case FS_IOC_GET_ENCRYPTION_PWSALT:
+		return ext4_ioctl_get_encryption_pwsalt(filp, (void __user *)arg);

-		if (!ext4_has_feature_encrypt(sb))
-			return -EOPNOTSUPP;
-		if (uuid_is_zero(sbi->s_es->s_encrypt_pw_salt)) {
-			err = mnt_want_write_file(filp);
-			if (err)
-				return err;
-			handle = ext4_journal_start_sb(sb, EXT4_HT_MISC, 1);
-			if (IS_ERR(handle)) {
-				err = PTR_ERR(handle);
-				goto pwsalt_err_exit;
-			}
-			err = ext4_journal_get_write_access(handle, sb,
-							    sbi->s_sbh,
-							    EXT4_JTR_NONE);
-			if (err)
-				goto pwsalt_err_journal;
-			lock_buffer(sbi->s_sbh);
-			generate_random_uuid(sbi->s_es->s_encrypt_pw_salt);
-			ext4_superblock_csum_set(sb);
-			unlock_buffer(sbi->s_sbh);
-			err = ext4_handle_dirty_metadata(handle, NULL,
-							 sbi->s_sbh);
-		pwsalt_err_journal:
-			err2 = ext4_journal_stop(handle);
-			if (err2 && !err)
-				err = err2;
-		pwsalt_err_exit:
-			mnt_drop_write_file(filp);
-			if (err)
-				return err;
-		}
-		if (copy_to_user((void __user *) arg,
-				 sbi->s_es->s_encrypt_pw_salt, 16))
-			return -EFAULT;
-		return 0;
-#else
-		return -EOPNOTSUPP;
-#endif
-	}
 	case FS_IOC_GET_ENCRYPTION_POLICY:
 		if (!ext4_has_feature_encrypt(sb))
 			return -EOPNOTSUPP;
--
2.31.1

