Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E27C1C8423
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 May 2020 10:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgEGICH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 May 2020 04:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgEGICG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 May 2020 04:02:06 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C73F820870;
        Thu,  7 May 2020 08:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588838525;
        bh=ztW4C2b6T2EFInxjRwHnDi0WLo+7XrsN3yd2t+lAdAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVN/U1fKwqbnkjNigCQV+W1CpB/UN45jcHJkfWHEjDvBsAMKDRgAYPL+kKki1MCTm
         CP3/KRZaA7FxagZAlIwjyTVrhskgP5W6quvOKrfxTqzRdhansIl6ZVxF25uqfqQuQD
         g07K453HTrcl/Kk+PydPJoz75sqsDjPo52vhmPWc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH 2/4] f2fs: split f2fs_d_compare() from f2fs_match_name()
Date:   Thu,  7 May 2020 00:59:03 -0700
Message-Id: <20200507075905.953777-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507075905.953777-1-ebiggers@kernel.org>
References: <20200507075905.953777-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Sharing f2fs_ci_compare() between comparing cached dentries
(f2fs_d_compare()) and comparing on-disk dentries (f2fs_match_name())
doesn't work as well as intended, as these actions fundamentally differ
in several ways (e.g. whether the task may sleep, whether the directory
is stable, whether the casefolded name was precomputed, whether the
dentry will need to be decrypted once we allow casefold+encrypt, etc.)

Just make f2fs_d_compare() implement what it needs directly, and rework
f2fs_ci_compare() to be specialized for f2fs_match_name().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/dir.c  | 70 +++++++++++++++++++++++++-------------------------
 fs/f2fs/f2fs.h |  5 ----
 2 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 44bfc464df7872..44eb12a00cd0ed 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -107,36 +107,28 @@ static struct f2fs_dir_entry *find_in_block(struct inode *dir,
 /*
  * Test whether a case-insensitive directory entry matches the filename
  * being searched for.
- *
- * Returns: 0 if the directory entry matches, more than 0 if it
- * doesn't match or less than zero on error.
  */
-int f2fs_ci_compare(const struct inode *parent, const struct qstr *name,
-				const struct qstr *entry, bool quick)
+static bool f2fs_match_ci_name(const struct inode *dir, const struct qstr *name,
+			       const struct qstr *entry, bool quick)
 {
-	const struct f2fs_sb_info *sbi = F2FS_SB(parent->i_sb);
+	const struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
 	const struct unicode_map *um = sbi->s_encoding;
-	int ret;
+	int res;
 
 	if (quick)
-		ret = utf8_strncasecmp_folded(um, name, entry);
+		res = utf8_strncasecmp_folded(um, name, entry);
 	else
-		ret = utf8_strncasecmp(um, name, entry);
-
-	if (ret < 0) {
-		/* Handle invalid character sequence as either an error
-		 * or as an opaque byte sequence.
+		res = utf8_strncasecmp(um, name, entry);
+	if (res < 0) {
+		/*
+		 * In strict mode, ignore invalid names.  In non-strict mode,
+		 * fall back to treating them as opaque byte sequences.
 		 */
-		if (f2fs_has_strict_mode(sbi))
-			return -EINVAL;
-
-		if (name->len != entry->len)
-			return 1;
-
-		return !!memcmp(name->name, entry->name, name->len);
+		if (f2fs_has_strict_mode(sbi) || name->len != entry->len)
+			return false;
+		return !memcmp(name->name, entry->name, name->len);
 	}
-
-	return ret;
+	return res == 0;
 }
 
 static void f2fs_fname_setup_ci_filename(struct inode *dir,
@@ -188,10 +180,10 @@ static inline bool f2fs_match_name(struct f2fs_dentry_ptr *d,
 		if (cf_str->name) {
 			struct qstr cf = {.name = cf_str->name,
 					  .len = cf_str->len};
-			return !f2fs_ci_compare(parent, &cf, &entry, true);
+			return f2fs_match_ci_name(parent, &cf, &entry, true);
 		}
-		return !f2fs_ci_compare(parent, fname->usr_fname, &entry,
-					false);
+		return f2fs_match_ci_name(parent, fname->usr_fname, &entry,
+					  false);
 	}
 #endif
 	if (fscrypt_match_name(fname, d->filename[bit_pos],
@@ -1080,17 +1072,25 @@ const struct file_operations f2fs_dir_operations = {
 static int f2fs_d_compare(const struct dentry *dentry, unsigned int len,
 			  const char *str, const struct qstr *name)
 {
-	struct qstr qstr = {.name = str, .len = len };
 	const struct dentry *parent = READ_ONCE(dentry->d_parent);
-	const struct inode *inode = READ_ONCE(parent->d_inode);
-
-	if (!inode || !IS_CASEFOLDED(inode)) {
-		if (len != name->len)
-			return -1;
-		return memcmp(str, name->name, len);
-	}
-
-	return f2fs_ci_compare(inode, name, &qstr, false);
+	const struct inode *dir = READ_ONCE(parent->d_inode);
+	const struct f2fs_sb_info *sbi = F2FS_SB(dentry->d_sb);
+	struct qstr entry = QSTR_INIT(str, len);
+	int res;
+
+	if (!dir || !IS_CASEFOLDED(dir))
+		goto fallback;
+
+	res = utf8_strncasecmp(sbi->s_encoding, name, &entry);
+	if (res >= 0)
+		return res;
+
+	if (f2fs_has_strict_mode(sbi))
+		return -EINVAL;
+fallback:
+	if (len != name->len)
+		return 1;
+	return !!memcmp(str, name->name, len);
 }
 
 static int f2fs_d_hash(const struct dentry *dentry, struct qstr *str)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 5ef9711ccb4967..a953a622f260e3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3134,11 +3134,6 @@ int f2fs_update_extension_list(struct f2fs_sb_info *sbi, const char *name,
 							bool hot, bool set);
 struct dentry *f2fs_get_parent(struct dentry *child);
 
-extern int f2fs_ci_compare(const struct inode *parent,
-			   const struct qstr *name,
-			   const struct qstr *entry,
-			   bool quick);
-
 /*
  * dir.c
  */
-- 
2.26.2

