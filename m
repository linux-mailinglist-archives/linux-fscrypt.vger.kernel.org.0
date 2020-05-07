Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E5C1C8425
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 May 2020 10:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgEGICI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 May 2020 04:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgEGICH (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 May 2020 04:02:07 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 776A020CC7;
        Thu,  7 May 2020 08:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588838526;
        bh=ECBaJRi5wL+/VNR4JVpwpbiwgLN0+oYdlYN4lsNSMRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BuyNqU2JUMR3TimGPvAd/7ggdQY10QYciqxESl5/yNJLWD0W3mQp8CN9qWt0AORwA
         FMhtmC4ii/lcLHWFshI9TL4p4qXwyIHF5hVLV1cUbHiaKI01wg9uwnt0kOf3Na9H0H
         1D8qQFy6B5AztJmHX9twlspiinRfNd9jLMULJTHI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [RFC PATCH 4/4] f2fs: Handle casefolding with Encryption (INCOMPLETE)
Date:   Thu,  7 May 2020 00:59:05 -0700
Message-Id: <20200507075905.953777-5-ebiggers@kernel.org>
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

Expand f2fs's casefolding support to include encrypted directories.  To
index casefolded+encrypted directories, we use the SipHash of the
casefolded name, keyed by a key derived from the directory's fscrypt
master key.  This ensures that the dirhash doesn't leak information
about the plaintext filenames.

Encryption keys are unavailable during roll-forward recovery, so we
can't compute the dirhash when recovering a new dentry in an encrypted +
casefolded directory.  To avoid having to force a checkpoint when a new
file is fsync'ed, store the dirhash on-disk appended to i_name.

[Based on patches from Daniel Rosenberg <drosen@google.com>
 and Jaegeuk Kim <jaegeuk@kernel.org>.   This patch is incomplete as it
 doesn't include the generic_set_encrypted_ci_d_ops().  This patch just
 shows the other changes based on top of the f2fs_filename rework.]

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/dir.c      | 63 ++++++++++++++++++++++++++++++++++++++--------
 fs/f2fs/f2fs.h     |  8 +++---
 fs/f2fs/hash.c     | 11 +++++++-
 fs/f2fs/recovery.c | 12 ++++++++-
 4 files changed, 79 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 29f70f2295cce8..eea9458a37b384 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2012 Samsung Electronics Co., Ltd.
  *             http://www.samsung.com/
  */
+#include <asm/unaligned.h>
 #include <linux/fs.h>
 #include <linux/f2fs_fs.h>
 #include <linux/sched/signal.h>
@@ -217,9 +218,28 @@ static bool f2fs_match_ci_name(const struct inode *dir, const struct qstr *name,
 {
 	const struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
 	const struct unicode_map *um = sbi->s_encoding;
+	struct fscrypt_str decrypted_name = FSTR_INIT(NULL, de_name_len);
 	struct qstr entry = QSTR_INIT(de_name, de_name_len);
 	int res;
 
+	if (IS_ENCRYPTED(dir)) {
+		const struct fscrypt_str encrypted_name =
+			FSTR_INIT((u8 *)de_name, de_name_len);
+
+		if (WARN_ON_ONCE(!fscrypt_has_encryption_key(dir)))
+			return false;
+
+		decrypted_name.name = kmalloc(de_name_len, GFP_KERNEL);
+		if (!decrypted_name.name)
+			return false;
+		res = fscrypt_fname_disk_to_usr(dir, 0, 0, &encrypted_name,
+						&decrypted_name);
+		if (res < 0)
+			goto out;
+		entry.name = decrypted_name.name;
+		entry.len = decrypted_name.len;
+	}
+
 	res = utf8_strncasecmp_folded(um, name, &entry);
 	if (res < 0) {
 		/*
@@ -227,9 +247,12 @@ static bool f2fs_match_ci_name(const struct inode *dir, const struct qstr *name,
 		 * fall back to treating them as opaque byte sequences.
 		 */
 		if (f2fs_has_strict_mode(sbi) || name->len != entry.len)
-			return false;
-		return !memcmp(name->name, entry.name, name->len);
+			res = 1;
+		else
+			res = memcmp(name->name, entry.name, name->len);
 	}
+out:
+	kfree(decrypted_name.name);
 	return res == 0;
 }
 #endif /* CONFIG_UNICODE */
@@ -454,17 +477,39 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
 	f2fs_put_page(page, 1);
 }
 
-static void init_dent_inode(const struct f2fs_filename *fname,
+static void init_dent_inode(struct inode *dir, struct inode *inode,
+			    const struct f2fs_filename *fname,
 			    struct page *ipage)
 {
 	struct f2fs_inode *ri;
 
+	if (!fname) /* tmpfile case? */
+		return;
+
 	f2fs_wait_on_page_writeback(ipage, NODE, true, true);
 
 	/* copy name info. to this inode page */
 	ri = F2FS_INODE(ipage);
 	ri->i_namelen = cpu_to_le32(fname->disk_name.len);
 	memcpy(ri->i_name, fname->disk_name.name, fname->disk_name.len);
+	if (IS_ENCRYPTED(dir)) {
+		file_set_enc_name(inode);
+		/*
+		 * Roll-forward recovery doesn't have encryption keys available,
+		 * so it can't compute the dirhash for encrypted+casefolded
+		 * filenames.  Append it to i_name if possible.  Else, disable
+		 * roll-forward recovery of the dentry (i.e., make fsync'ing the
+		 * file force a checkpoint) by setting LOST_PINO.
+		 */
+		if (IS_CASEFOLDED(dir)) {
+			if (fname->disk_name.len + sizeof(f2fs_hash_t) <=
+			    F2FS_NAME_LEN)
+				put_unaligned(fname->hash,
+					&ri->i_name[fname->disk_name.len]);
+			else
+				file_lost_pino(inode);
+		}
+	}
 	set_page_dirty(ipage);
 }
 
@@ -547,11 +592,7 @@ struct page *f2fs_init_inode_metadata(struct inode *inode, struct inode *dir,
 			return page;
 	}
 
-	if (fname) {
-		init_dent_inode(fname, page);
-		if (IS_ENCRYPTED(dir))
-			file_set_enc_name(inode);
-	}
+	init_dent_inode(dir, inode, fname, page);
 
 	/*
 	 * This file should be checkpointed during fsync.
@@ -1116,7 +1157,8 @@ static int f2fs_d_compare(const struct dentry *dentry, unsigned int len,
 	struct qstr entry = QSTR_INIT(str, len);
 	int res;
 
-	if (!dir || !IS_CASEFOLDED(dir))
+	if (!dir || !IS_CASEFOLDED(dir) ||
+	    (IS_ENCRYPTED(dir) && !fscrypt_has_encryption_key(dir)))
 		goto fallback;
 
 	res = utf8_strncasecmp(sbi->s_encoding, name, &entry);
@@ -1139,7 +1181,8 @@ static int f2fs_d_hash(const struct dentry *dentry, struct qstr *str)
 	unsigned char *norm;
 	int len, ret = 0;
 
-	if (!inode || !IS_CASEFOLDED(inode))
+	if (!inode || !IS_CASEFOLDED(inode) ||
+	    (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode)))
 		return 0;
 
 	norm = f2fs_kmalloc(sbi, PATH_MAX, GFP_ATOMIC);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1df50d9224bb71..1c01d6b87e936f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -534,9 +534,11 @@ struct f2fs_filename {
 #ifdef CONFIG_UNICODE
 	/*
 	 * For casefolded directories: the casefolded name, but it's left NULL
-	 * if the original name is not valid Unicode or if the filesystem is
-	 * doing an internal operation where usr_fname is also NULL.  In these
-	 * cases we fall back to treating the name as an opaque byte sequence.
+	 * if the original name is not valid Unicode, if the directory is both
+	 * casefolded and encrypted and its encryption key is unavailable, or if
+	 * the filesystem is doing an internal operation where usr_fname is also
+	 * NULL.  In all these cases we fall back to treating the name as an
+	 * opaque byte sequence.
 	 */
 	struct fscrypt_str cf_name;
 #endif
diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
index e5997919472d4f..f9b706495d1d62 100644
--- a/fs/f2fs/hash.c
+++ b/fs/f2fs/hash.c
@@ -112,7 +112,9 @@ void f2fs_hash_filename(const struct inode *dir, struct f2fs_filename *fname)
 		 * If the casefolded name is provided, hash it instead of the
 		 * on-disk name.  If the casefolded name is *not* provided, that
 		 * should only be because the name wasn't valid Unicode, so fall
-		 * back to treating the name as an opaque byte sequence.
+		 * back to treating the name as an opaque byte sequence.  Note
+		 * that to handle encrypted directories, the fallback must use
+		 * usr_fname (plaintext) rather than disk_name (ciphertext).
 		 */
 		WARN_ON_ONCE(!fname->usr_fname->name);
 		if (fname->cf_name.name) {
@@ -122,6 +124,13 @@ void f2fs_hash_filename(const struct inode *dir, struct f2fs_filename *fname)
 			name = fname->usr_fname->name;
 			len = fname->usr_fname->len;
 		}
+		if (IS_ENCRYPTED(dir)) {
+			struct qstr tmp = QSTR_INIT(name, len);
+
+			fname->hash =
+				cpu_to_le32(fscrypt_fname_siphash(dir, &tmp));
+			return;
+		}
 	}
 #endif
 	fname->hash = cpu_to_le32(TEA_hash_name(name, len));
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index ae5310f02e7ff1..c762a9e4300620 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2012 Samsung Electronics Co., Ltd.
  *             http://www.samsung.com/
  */
+#include <asm/unaligned.h>
 #include <linux/fs.h>
 #include <linux/f2fs_fs.h>
 #include "f2fs.h"
@@ -128,7 +129,16 @@ static int init_recovered_filename(const struct inode *dir,
 	}
 
 	/* Compute the hash of the filename */
-	if (IS_CASEFOLDED(dir)) {
+	if (IS_ENCRYPTED(dir) && IS_CASEFOLDED(dir)) {
+		/*
+		 * In this case the hash isn't computable without the key, so it
+		 * was saved on-disk.
+		 */
+		if (fname->disk_name.len + sizeof(f2fs_hash_t) > F2FS_NAME_LEN)
+			return -EINVAL;
+		fname->hash = get_unaligned((f2fs_hash_t *)
+				&raw_inode->i_name[fname->disk_name.len]);
+	} else if (IS_CASEFOLDED(dir)) {
 		err = f2fs_init_casefolded_name(dir, fname);
 		if (err)
 			return err;
-- 
2.26.2

