Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBF1527352
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 May 2022 19:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiENRXQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 14 May 2022 13:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbiENRXO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 14 May 2022 13:23:14 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747A0101EA;
        Sat, 14 May 2022 10:23:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso10580888pjg.0;
        Sat, 14 May 2022 10:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s44YCbNakB8bQK/snGTGfzRHdvt2dIcw1qE5dHnQ1es=;
        b=KCP5QTPq/b8iEYZKB6C1/wrxlm5IJ1DMcze64xkVI90k0d+dT/WcW3LZijibTNpk8s
         BHlUBjJaq7sSZuxmDpVdapvAtTxUE38/V8LBeV1iKhd/BSvUmfgOIm1WIYqyMV0vFo3P
         wvoZjbiStAe71lDZKZC+gTCTg6mGRhwc9UNnpsGmJ+hUARVfiz/KEamtjtuHQ2djfpH0
         4RLxLHRs0l/xCElZVneFJmULtLmVrQCcmYn2qszHB9Sg/GJrE0v1r4O3cwyMWfdhH69k
         WAau5X2YiTCRtPPOWdQUPIOi49KB90t+R/qgz3J42B1fkfmFD2GCRyZ4PN0UEJDJaxXe
         0ruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s44YCbNakB8bQK/snGTGfzRHdvt2dIcw1qE5dHnQ1es=;
        b=Qm6StK9euTt8TAFhDaRpGKrAG+1MnA7tumM5dGMSdZfccP44oQFSkxlxsaZZNa09sQ
         sXMIy/s7HeJJsG8XgdktFbpl/8Onr69GPTXYGSSMf0RnJ+pCLgs46a944kxqhoVKgPK7
         7NvFXYtYP4njESKi1n7rSN1KOgXWp82EdaevUyXgqA5Lc72pjurBZelXfO8GZ78k5VJy
         eRP9MY1THHB8mUf9GQ5aWvdXdMar3ExAjIPQ1h8L0OVDhNFc1kuljFtIo7K9P0jA7eyM
         92HYD+H7I4+N55voJ2S8hVBBAhinQYlMgkd/BlFlBkHldq8GAfmrEpwUinUg2jSXK6KJ
         xOFg==
X-Gm-Message-State: AOAM532R1cbScoU+/ZGKzQhRGemq+ChDobnFZ/vdQWNHHDJb97qHuiNj
        LyZk8J/SEMV5+KRAWpH695Ly2dVcGyA=
X-Google-Smtp-Source: ABdhPJxMOKEbcOBQuh6llD1+SNoXhu+eOYCaQMVJM/DcAF8cTWqxp3RsCfwq4wv1NbNpFzmWWIGbyA==
X-Received: by 2002:a17:902:ba85:b0:161:53e9:c798 with SMTP id k5-20020a170902ba8500b0016153e9c798mr2925945pls.81.1652548992944;
        Sat, 14 May 2022 10:23:12 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id d134-20020a621d8c000000b0050dc762819dsm3801872pfd.119.2022.05.14.10.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 10:23:12 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCHv2 3/3] ext4: Refactor and move ext4_ioc_get_encryption_pwsalt()
Date:   Sat, 14 May 2022 22:52:48 +0530
Message-Id: <3256b969d6e858414f08e0ca2f5117e76fdc2057.1652539361.git.ritesh.list@gmail.com>
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

This patch move code for FS_IOC_GET_ENCRYPTION_PWSALT case into
ext4's crypto.c file, i.e. ext4_ioc_get_encryption_pwsalt()
and uuid_is_zero(). This is mostly refactoring logic and should
not affect any functionality change.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ritesh Harjani <ritesh.list@gmail.com>
---
 fs/ext4/crypto.c | 53 +++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   |  8 +++++++
 fs/ext4/ioctl.c  | 58 ++----------------------------------------------
 3 files changed, 63 insertions(+), 56 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index f8333927f0f6..36bcfeecdb00 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -71,6 +71,59 @@ void ext4_fname_free_filename(struct ext4_filename *fname)
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
+int ext4_ioc_get_encryption_pwsalt(struct file *filp, void __user *arg)
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
index 11bb0d2ee2eb..b61115fe7ffb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2744,6 +2744,8 @@ int ext4_fname_prepare_lookup(struct inode *dir, struct dentry *dentry,
 
 void ext4_fname_free_filename(struct ext4_filename *fname);
 
+int ext4_ioc_get_encryption_pwsalt(struct file *filp, void __user *arg);
+
 #else /* !CONFIG_FS_ENCRYPTION */
 static inline int ext4_fname_setup_filename(struct inode *dir,
 					    const struct qstr *iname,
@@ -2776,6 +2778,12 @@ static inline void ext4_fname_free_filename(struct ext4_filename *fname)
 	fname->cf_name.name = NULL;
 #endif
 }
+
+static inline int ext4_ioc_get_encryption_pwsalt(struct file *filp,
+						 void __user *arg)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* !CONFIG_FS_ENCRYPTION */
 
 /* dir.c */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index ba44fa1be70a..044e65d44054 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -504,18 +504,6 @@ static long swap_inode_boot_loader(struct super_block *sb,
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
@@ -1432,51 +1420,9 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return -EOPNOTSUPP;
 		return fscrypt_ioctl_set_policy(filp, (const void __user *)arg);
 
-	case FS_IOC_GET_ENCRYPTION_PWSALT: {
-#ifdef CONFIG_FS_ENCRYPTION
-		int err, err2;
-		struct ext4_sb_info *sbi = EXT4_SB(sb);
-		handle_t *handle;
+	case FS_IOC_GET_ENCRYPTION_PWSALT:
+		return ext4_ioc_get_encryption_pwsalt(filp, (void __user *)arg);
 
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

