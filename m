Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F143817CB17
	for <lists+linux-fscrypt@lfdr.de>; Sat,  7 Mar 2020 03:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgCGCgt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 6 Mar 2020 21:36:49 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:33178 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgCGCgp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 6 Mar 2020 21:36:45 -0500
Received: by mail-pl1-f201.google.com with SMTP id b10so2529186pls.0
        for <linux-fscrypt@vger.kernel.org>; Fri, 06 Mar 2020 18:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NzaUhXJKxblqI5Gh8t6DIY356EoyrOvF1fo+IUJGt18=;
        b=EccoWQS9AXS5hpeGqbDeRB4+lk5VSQiPuG6A9As+3Sz27I8WtlXC7LFsnBTkqyqscy
         fc8A0NXyynB4xbNC92kgeeMp1g9fvxDOIW9r/O/0XTtY4PAL6UrY6270d/juGsMo3wzS
         Id48ssVCGbe6Ql7ff0nq/tLqCaLFaeV/b+53mZWcesKKQlDvzCIKelbXLc0qz27vVeHD
         JTRdBGExEw1G+NoooIhNmw6AVYyOveSXsv5WLCTTBdXp2/epPotL5URlrY/UCT2V3HlI
         EKcpp6bpVGwX6D4lnw7C82WpWKpIAVs0ZviTE/X4oxpqJ2qOmlKTjoZZXeFRYseEvdm7
         a35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NzaUhXJKxblqI5Gh8t6DIY356EoyrOvF1fo+IUJGt18=;
        b=TbD1J5ldyzs65jRA2/Qexo/ddMet0OdrduURr1RE4JQzfut5n+mIAGVLjfWE/MAaO+
         gIaRAxzKeFvvZh+JnaPwm4HXkHS29g6Awc6FrVHjyjnooc9yOoqqwzLUQwF9eYsM33md
         rsEzwbfb70Ex56F9dyNd3ynlAPgqLxlAyZVz9HmjsxHPWNbNOuOZ0zaI7ZkawgHMW+K0
         CGL3Mw6qp7Xqvded5vKnzgkvCanMFFrpe2T+IBnL1wYJ3jdoNPzYOiAYvby5mmF6fApk
         XZLGnNi0MeK+2bvEgdTkwDeP+enhBS/QD9jHb80fOJV2EZDcCq4nt8Mn8fRTU83TqKSC
         HRmA==
X-Gm-Message-State: ANhLgQ1SNNkxcup/M7EWncv6Pq/1mV30SamKnVTBOwPYa7br6sX3dXmz
        QOzcatya/1izr2bJkX1s+yMX7gdozjg=
X-Google-Smtp-Source: ADFU+vupxVhCcnBRX+LRsi80i60l66Dbf4Wv4LxKEgsP+bQwFjA57ttf6c1Wy8uq3io7+mJZmPsncegbrKY=
X-Received: by 2002:a17:90a:8509:: with SMTP id l9mr6698441pjn.43.1583548603121;
 Fri, 06 Mar 2020 18:36:43 -0800 (PST)
Date:   Fri,  6 Mar 2020 18:36:07 -0800
In-Reply-To: <20200307023611.204708-1-drosen@google.com>
Message-Id: <20200307023611.204708-5-drosen@google.com>
Mime-Version: 1.0
References: <20200307023611.204708-1-drosen@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v8 4/8] ext4: Use generic casefolding support
From:   Daniel Rosenberg <drosen@google.com>
To:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>
Cc:     linux-mtd@lists.infradead.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This switches ext4 over to the generic casefolding support provided by
the previous patch.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 fs/ext4/dir.c   | 48 ++----------------------------------------------
 fs/ext4/ext4.h  | 12 ------------
 fs/ext4/hash.c  |  2 +-
 fs/ext4/namei.c | 20 ++++++++------------
 fs/ext4/super.c | 12 ++++++------
 5 files changed, 17 insertions(+), 77 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 9aa1f75409b02..04fd68c4adc5f 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -669,52 +669,8 @@ const struct file_operations ext4_dir_operations = {
 };
 
 #ifdef CONFIG_UNICODE
-static int ext4_d_compare(const struct dentry *dentry, unsigned int len,
-			  const char *str, const struct qstr *name)
-{
-	struct qstr qstr = {.name = str, .len = len };
-	const struct dentry *parent = READ_ONCE(dentry->d_parent);
-	const struct inode *inode = READ_ONCE(parent->d_inode);
-
-	if (!inode || !IS_CASEFOLDED(inode) ||
-	    !EXT4_SB(inode->i_sb)->s_encoding) {
-		if (len != name->len)
-			return -1;
-		return memcmp(str, name->name, len);
-	}
-
-	return ext4_ci_compare(inode, name, &qstr, false);
-}
-
-static int ext4_d_hash(const struct dentry *dentry, struct qstr *str)
-{
-	const struct ext4_sb_info *sbi = EXT4_SB(dentry->d_sb);
-	const struct unicode_map *um = sbi->s_encoding;
-	const struct inode *inode = READ_ONCE(dentry->d_inode);
-	unsigned char *norm;
-	int len, ret = 0;
-
-	if (!inode || !IS_CASEFOLDED(inode) || !um)
-		return 0;
-
-	norm = kmalloc(PATH_MAX, GFP_ATOMIC);
-	if (!norm)
-		return -ENOMEM;
-
-	len = utf8_casefold(um, str, norm, PATH_MAX);
-	if (len < 0) {
-		if (ext4_has_strict_mode(sbi))
-			ret = -EINVAL;
-		goto out;
-	}
-	str->hash = full_name_hash(dentry, norm, len);
-out:
-	kfree(norm);
-	return ret;
-}
-
 const struct dentry_operations ext4_dentry_ops = {
-	.d_hash = ext4_d_hash,
-	.d_compare = ext4_d_compare,
+	.d_hash = generic_ci_d_hash,
+	.d_compare = generic_ci_d_compare,
 };
 #endif
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 61b37a052052b..b912c5611ddad 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1372,14 +1372,6 @@ struct ext4_super_block {
 
 #define EXT4_ENC_UTF8_12_1	1
 
-/*
- * Flags for ext4_sb_info.s_encoding_flags.
- */
-#define EXT4_ENC_STRICT_MODE_FL	(1 << 0)
-
-#define ext4_has_strict_mode(sbi) \
-	(sbi->s_encoding_flags & EXT4_ENC_STRICT_MODE_FL)
-
 /*
  * fourth extended-fs super-block data in memory
  */
@@ -1429,10 +1421,6 @@ struct ext4_sb_info {
 	struct kobject s_kobj;
 	struct completion s_kobj_unregister;
 	struct super_block *s_sb;
-#ifdef CONFIG_UNICODE
-	struct unicode_map *s_encoding;
-	__u16 s_encoding_flags;
-#endif
 
 	/* Journaling */
 	struct journal_s *s_journal;
diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index 3e133793a5a34..143b0073b3f46 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -275,7 +275,7 @@ int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 		   struct dx_hash_info *hinfo)
 {
 #ifdef CONFIG_UNICODE
-	const struct unicode_map *um = EXT4_SB(dir->i_sb)->s_encoding;
+	const struct unicode_map *um = dir->i_sb->s_encoding;
 	int r, dlen;
 	unsigned char *buff;
 	struct qstr qstr = {.name = name, .len = len };
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b05ea72f38fd1..1a1c4fdcfd3ee 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1286,8 +1286,8 @@ static void dx_insert_block(struct dx_frame *frame, u32 hash, ext4_lblk_t block)
 int ext4_ci_compare(const struct inode *parent, const struct qstr *name,
 		    const struct qstr *entry, bool quick)
 {
-	const struct ext4_sb_info *sbi = EXT4_SB(parent->i_sb);
-	const struct unicode_map *um = sbi->s_encoding;
+	const struct super_block *sb = parent->i_sb;
+	const struct unicode_map *um = sb->s_encoding;
 	int ret;
 
 	if (quick)
@@ -1299,7 +1299,7 @@ int ext4_ci_compare(const struct inode *parent, const struct qstr *name,
 		/* Handle invalid character sequence as either an error
 		 * or as an opaque byte sequence.
 		 */
-		if (ext4_has_strict_mode(sbi))
+		if (sb_has_enc_strict_mode(sb))
 			return -EINVAL;
 
 		if (name->len != entry->len)
@@ -1316,7 +1316,7 @@ void ext4_fname_setup_ci_filename(struct inode *dir, const struct qstr *iname,
 {
 	int len;
 
-	if (!IS_CASEFOLDED(dir) || !EXT4_SB(dir->i_sb)->s_encoding) {
+	if (!needs_casefold(dir)) {
 		cf_name->name = NULL;
 		return;
 	}
@@ -1325,7 +1325,7 @@ void ext4_fname_setup_ci_filename(struct inode *dir, const struct qstr *iname,
 	if (!cf_name->name)
 		return;
 
-	len = utf8_casefold(EXT4_SB(dir->i_sb)->s_encoding,
+	len = utf8_casefold(dir->i_sb->s_encoding,
 			    iname, cf_name->name,
 			    EXT4_NAME_LEN);
 	if (len <= 0) {
@@ -1362,7 +1362,7 @@ static inline bool ext4_match(const struct inode *parent,
 #endif
 
 #ifdef CONFIG_UNICODE
-	if (EXT4_SB(parent->i_sb)->s_encoding && IS_CASEFOLDED(parent)) {
+	if (needs_casefold(parent)) {
 		if (fname->cf_name.name) {
 			struct qstr cf = {.name = fname->cf_name.name,
 					  .len = fname->cf_name.len};
@@ -2171,9 +2171,6 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	struct buffer_head *bh = NULL;
 	struct ext4_dir_entry_2 *de;
 	struct super_block *sb;
-#ifdef CONFIG_UNICODE
-	struct ext4_sb_info *sbi;
-#endif
 	struct ext4_filename fname;
 	int	retval;
 	int	dx_fallback=0;
@@ -2190,9 +2187,8 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 		return -EINVAL;
 
 #ifdef CONFIG_UNICODE
-	sbi = EXT4_SB(sb);
-	if (ext4_has_strict_mode(sbi) && IS_CASEFOLDED(dir) &&
-	    sbi->s_encoding && utf8_validate(sbi->s_encoding, &dentry->d_name))
+	if (sb_has_enc_strict_mode(sb) && IS_CASEFOLDED(dir) &&
+	    sb->s_encoding && utf8_validate(sb->s_encoding, &dentry->d_name))
 		return -EINVAL;
 #endif
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0c7c4adb664ec..11a7af11d8aee 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1112,7 +1112,7 @@ static void ext4_put_super(struct super_block *sb)
 	kfree(sbi->s_blockgroup_lock);
 	fs_put_dax(sbi->s_daxdev);
 #ifdef CONFIG_UNICODE
-	utf8_unload(sbi->s_encoding);
+	utf8_unload(sb->s_encoding);
 #endif
 	kfree(sbi);
 }
@@ -3926,7 +3926,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 
 #ifdef CONFIG_UNICODE
-	if (ext4_has_feature_casefold(sb) && !sbi->s_encoding) {
+	if (ext4_has_feature_casefold(sb) && !sb->s_encoding) {
 		const struct ext4_sb_encodings *encoding_info;
 		struct unicode_map *encoding;
 		__u16 encoding_flags;
@@ -3957,8 +3957,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			 "%s-%s with flags 0x%hx", encoding_info->name,
 			 encoding_info->version?:"\b", encoding_flags);
 
-		sbi->s_encoding = encoding;
-		sbi->s_encoding_flags = encoding_flags;
+		sb->s_encoding = encoding;
+		sb->s_encoding_flags = encoding_flags;
 	}
 #endif
 
@@ -4571,7 +4571,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 #ifdef CONFIG_UNICODE
-	if (sbi->s_encoding)
+	if (sb->s_encoding)
 		sb->s_d_op = &ext4_dentry_ops;
 #endif
 
@@ -4766,7 +4766,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		crypto_free_shash(sbi->s_chksum_driver);
 
 #ifdef CONFIG_UNICODE
-	utf8_unload(sbi->s_encoding);
+	utf8_unload(sb->s_encoding);
 #endif
 
 #ifdef CONFIG_QUOTA
-- 
2.25.1.481.gfbce0eb801-goog

